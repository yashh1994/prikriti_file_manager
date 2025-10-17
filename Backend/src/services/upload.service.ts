/**
 * Upload Service
 * Handles batch file uploads with status tracking and duplicate detection
 */

import * as fs from 'fs-extra';
import * as path from 'path';
import { FileWithRename, UploadResult, UploadStatus, BatchUploadResponse } from '../types/file.types';
import { FileUtilsService } from './file-utils.service';

export class UploadService {
  private uploadPath: string;

  constructor(uploadPath: string) {
    this.uploadPath = uploadPath;
  }

  /**
   * Process batch upload with status tracking
   */
  async processBatchUpload(files: FileWithRename[]): Promise<BatchUploadResponse> {
    // Ensure uploads directory exists
    await FileUtilsService.ensureUploadsDirectory(this.uploadPath);

    const results: UploadResult[] = [];

    for (const file of files) {
      const result = await this.uploadSingleFile(file);
      results.push(result);
    }

    // Calculate summary
    const summary = {
      total: results.length,
      done: results.filter((r) => r.status === UploadStatus.DONE).length,
      failed: results.filter((r) => r.status === UploadStatus.FAILED).length,
      duplicate: results.filter((r) => r.status === UploadStatus.DUPLICATE).length,
      pending: results.filter((r) => r.status === UploadStatus.PENDING).length,
    };

    return {
      success: true,
      message: `Batch upload completed. ${summary.done} files uploaded successfully.`,
      results,
      summary,
    };
  }

  /**
   * Process web upload from multipart form data
   */
  async processWebUpload(files: Express.Multer.File[], metadata: any): Promise<BatchUploadResponse> {
    // Ensure uploads directory exists
    await FileUtilsService.ensureUploadsDirectory(this.uploadPath);

    const results: UploadResult[] = [];

    // Parse metadata if provided
    const fileMetadata = metadata.files ? JSON.parse(metadata.files) : [];

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      const meta = fileMetadata[i] || {};
      const result = await this.uploadWebFile(file, meta);
      results.push(result);
    }

    // Calculate summary
    const summary = {
      total: results.length,
      done: results.filter((r) => r.status === UploadStatus.DONE).length,
      failed: results.filter((r) => r.status === UploadStatus.FAILED).length,
      duplicate: results.filter((r) => r.status === UploadStatus.DUPLICATE).length,
      pending: results.filter((r) => r.status === UploadStatus.PENDING).length,
    };

    return {
      success: true,
      message: `Web upload completed. ${summary.done} files uploaded successfully.`,
      results,
      summary,
    };
  }

  /**
   * Upload single file with duplicate detection and name conflict handling
   */
  private async uploadSingleFile(file: FileWithRename): Promise<UploadResult> {
    const result: UploadResult = {
      id: file.id,
      originalName: file.originalName,
      newName: file.newName || file.name,
      status: UploadStatus.PENDING,
    };

    try {
      // Validate source file exists
      const sourceExists = await fs.pathExists(file.path);
      if (!sourceExists) {
        result.status = UploadStatus.FAILED;
        result.error = 'Source file not found';
        return result;
      }

      // Use new name if provided, otherwise use original name
      let targetFileName = file.newName || file.name;

      // Sanitize filename
      if (!FileUtilsService.validateFileName(targetFileName)) {
        targetFileName = FileUtilsService.sanitizeFileName(targetFileName);
      }

      // Check for duplicate file (same content)
      const duplicateFile = await FileUtilsService.findDuplicateByHash(
        file.path,
        this.uploadPath
      );

      if (duplicateFile) {
        result.status = UploadStatus.DUPLICATE;
        result.error = `Duplicate of "${targetFileName}" already exists as: ${duplicateFile}`;
        result.finalPath = path.join(this.uploadPath, duplicateFile);
        return result;
      }

      // Check for name conflict and generate unique name if needed
      const uniqueFileName = await FileUtilsService.generateUniqueFilename(
        targetFileName,
        this.uploadPath
      );

      const destinationPath = path.join(this.uploadPath, uniqueFileName);

      // Copy file to uploads folder
      await fs.copy(file.path, destinationPath);

      // Verify file was copied successfully
      const copiedExists = await fs.pathExists(destinationPath);
      if (!copiedExists) {
        result.status = UploadStatus.FAILED;
        result.error = 'File copy verification failed';
        return result;
      }

      // Get final file stats
      const stats = await fs.promises.stat(destinationPath);

      result.status = UploadStatus.DONE;
      result.finalPath = destinationPath;
      result.newName = uniqueFileName;
      result.size = stats.size;
      result.extension = file.extension;

      return result;
    } catch (error) {
      result.status = UploadStatus.FAILED;
      result.error = (error as Error).message;
      return result;
    }
  }

  /**
   * Upload single file from web (multipart upload)
   */
  private async uploadWebFile(file: Express.Multer.File, metadata: any): Promise<UploadResult> {
    const result: UploadResult = {
      id: metadata.id || file.originalname,
      originalName: file.originalname,
      newName: metadata.newName || file.originalname,
      status: UploadStatus.PENDING,
    };

    try {
      // Use new name if provided, otherwise use original name
      let targetFileName = metadata.newName || file.originalname;

      // Sanitize filename
      if (!FileUtilsService.validateFileName(targetFileName)) {
        targetFileName = FileUtilsService.sanitizeFileName(targetFileName);
      }

      // Check for duplicate file by calculating hash from buffer
      const duplicateFile = await FileUtilsService.findDuplicateByHashFromBuffer(
        file.buffer,
        this.uploadPath
      );

      if (duplicateFile) {
        result.status = UploadStatus.DUPLICATE;
        result.error = `Duplicate of "${targetFileName}" already exists as: ${duplicateFile}`;
        result.finalPath = path.join(this.uploadPath, duplicateFile);
        return result;
      }

      // Check for name conflict and generate unique name if needed
      const uniqueFileName = await FileUtilsService.generateUniqueFilename(
        targetFileName,
        this.uploadPath
      );

      const destinationPath = path.join(this.uploadPath, uniqueFileName);

      // Write buffer to file
      await fs.promises.writeFile(destinationPath, file.buffer);

      // Verify file was written successfully
      const writtenExists = await fs.pathExists(destinationPath);
      if (!writtenExists) {
        result.status = UploadStatus.FAILED;
        result.error = 'File write verification failed';
        return result;
      }

      // Get final file stats
      const stats = await fs.promises.stat(destinationPath);

      result.status = UploadStatus.DONE;
      result.finalPath = destinationPath;
      result.newName = uniqueFileName;
      result.size = stats.size;
      result.extension = metadata.extension || path.extname(file.originalname);

      return result;
    } catch (error) {
      result.status = UploadStatus.FAILED;
      result.error = (error as Error).message;
      return result;
    }
  }

  /**
   * Get upload statistics
   */
  async getUploadStats(): Promise<{
    totalFiles: number;
    totalSize: number;
    files: Array<{ name: string; size: number; uploadedAt: Date }>;
  }> {
    try {
      const files = await fs.promises.readdir(this.uploadPath);
      let totalSize = 0;
      const fileDetails = [];

      for (const file of files) {
        const filePath = path.join(this.uploadPath, file);
        const stats = await fs.promises.stat(filePath);

        if (stats.isFile()) {
          totalSize += stats.size;
          fileDetails.push({
            name: file,
            size: stats.size,
            uploadedAt: stats.mtime,
          });
        }
      }

      return {
        totalFiles: fileDetails.length,
        totalSize,
        files: fileDetails,
      };
    } catch (error) {
      throw new Error(`Failed to get upload stats: ${(error as Error).message}`);
    }
  }
}
