/**
 * File Utility Service
 * Handles file operations, hash calculation, and duplicate detection
 */

import * as fs from 'fs-extra';
import * as path from 'path';
import * as crypto from 'crypto';
import * as mime from 'mime-types';
import { FileWithRename } from '../types/file.types';

export class FileUtilsService {
  /**
   * Read all files from a directory and return metadata
   */
  static async listFilesFromFolder(folderPath: string): Promise<FileWithRename[]> {
    try {
      // Verify folder exists
      const exists = await fs.pathExists(folderPath);
      if (!exists) {
        throw new Error(`Folder does not exist: ${folderPath}`);
      }

      // Check if it's a directory
      const stats = await fs.promises.stat(folderPath);
      if (!stats.isDirectory()) {
        throw new Error(`Path is not a directory: ${folderPath}`);
      }

      // Read all files (not directories)
      const items = await fs.promises.readdir(folderPath);
      const files: FileWithRename[] = [];

      for (const item of items) {
        const itemPath = path.join(folderPath, item);
        const itemStats = await fs.promises.stat(itemPath);

        if (itemStats.isFile()) {
          const extension = path.extname(item);
          const mimetype = mime.lookup(item) || 'application/octet-stream';

          files.push({
            id: crypto.randomUUID(),
            name: item,
            originalName: item,
            extension: extension.replace('.', ''),
            size: itemStats.size,
            path: itemPath,
            mimetype,
            createdAt: itemStats.birthtime,
            modifiedAt: itemStats.mtime,
          });
        }
      }

      return files;
    } catch (error) {
      throw new Error(`Failed to list files: ${(error as Error).message}`);
    }
  }

  /**
   * Calculate file hash (MD5) for duplicate detection
   */
  static async calculateFileHash(filePath: string): Promise<string> {
    return new Promise((resolve, reject) => {
      const hash = crypto.createHash('md5');
      const stream = fs.createReadStream(filePath);

      stream.on('data', (data) => hash.update(data));
      stream.on('end', () => resolve(hash.digest('hex')));
      stream.on('error', (error) => reject(error));
    });
  }

  /**
   * Calculate hash from buffer (for web uploads)
   */
  static calculateHashFromBuffer(buffer: Buffer): string {
    const hash = crypto.createHash('md5');
    hash.update(buffer);
    return hash.digest('hex');
  }

  /**
   * Check if file with same hash exists in destination
   */
  static async findDuplicateByHash(
    sourceFilePath: string,
    destinationFolder: string
  ): Promise<string | null> {
    try {
      const sourceHash = await this.calculateFileHash(sourceFilePath);
      const destFiles = await fs.promises.readdir(destinationFolder);

      for (const file of destFiles) {
        const destFilePath = path.join(destinationFolder, file);
        const destStats = await fs.promises.stat(destFilePath);

        if (destStats.isFile()) {
          const destHash = await this.calculateFileHash(destFilePath);
          if (sourceHash === destHash) {
            return file; // Found duplicate
          }
        }
      }

      return null; // No duplicate found
    } catch (error) {
      return null;
    }
  }

  /**
   * Check if file with same hash exists in destination (from buffer for web uploads)
   */
  static async findDuplicateByHashFromBuffer(
    buffer: Buffer,
    destinationFolder: string
  ): Promise<string | null> {
    try {
      const sourceHash = this.calculateHashFromBuffer(buffer);
      const destFiles = await fs.promises.readdir(destinationFolder);

      for (const file of destFiles) {
        const destFilePath = path.join(destinationFolder, file);
        const destStats = await fs.promises.stat(destFilePath);

        if (destStats.isFile()) {
          const destHash = await this.calculateFileHash(destFilePath);
          if (sourceHash === destHash) {
            return file; // Found duplicate
          }
        }
      }

      return null; // No duplicate found
    } catch (error) {
      return null;
    }
  }

  /**
   * Generate unique filename with timestamp if duplicate exists
   */
  static async generateUniqueFilename(
    fileName: string,
    destinationFolder: string
  ): Promise<string> {
    const ext = path.extname(fileName);
    const baseName = path.basename(fileName, ext);
    let uniqueName = fileName;
    let counter = 1;

    // Check if file exists
    while (await fs.pathExists(path.join(destinationFolder, uniqueName))) {
      const timestamp = new Date().getTime();
      uniqueName = `${baseName}_${timestamp}${ext}`;
      
      // Fallback with counter if timestamp still conflicts
      if (await fs.pathExists(path.join(destinationFolder, uniqueName))) {
        uniqueName = `${baseName}_${timestamp}_${counter}${ext}`;
        counter++;
      } else {
        break;
      }
    }

    return uniqueName;
  }

  /**
   * Format file size to human-readable format
   */
  static formatFileSize(bytes: number): string {
    if (bytes === 0) return '0 Bytes';

    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
  }

  /**
   * Validate file name (no special characters that could cause issues)
   */
  static validateFileName(fileName: string): boolean {
    // Disallow special characters that could cause file system issues
    const invalidChars = /[<>:"|?*\x00-\x1f]/g;
    return !invalidChars.test(fileName);
  }

  /**
   * Sanitize file name
   */
  static sanitizeFileName(fileName: string): string {
    // Remove invalid characters
    return fileName.replace(/[<>:"|?*\x00-\x1f]/g, '_');
  }

  /**
   * Ensure uploads directory exists
   */
  static async ensureUploadsDirectory(uploadPath: string): Promise<void> {
    await fs.ensureDir(uploadPath);
  }
}
