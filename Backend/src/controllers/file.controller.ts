/**
 * File Management Controller
 * Handles HTTP requests for file operations
 */

import { Request, Response } from 'express';
import { FileUtilsService } from '../services/file-utils.service';
import { UploadService } from '../services/upload.service';
import { FileWithRename, FolderListResponse, ErrorResponse } from '../types/file.types';
import * as path from 'path';

export class FileController {
  private uploadService: UploadService;

  constructor(uploadPath: string) {
    this.uploadService = new UploadService(uploadPath);
  }

  /**
   * List all files from a selected folder
   * POST /api/files/list-folder
   * Body: { folderPath: string }
   */
  listFilesFromFolder = async (
    req: Request,
    res: Response<FolderListResponse | ErrorResponse>
  ): Promise<void> => {
    try {
      const { folderPath } = req.body;

      if (!folderPath) {
        res.status(400).json({
          success: false,
          message: 'Folder path is required',
        });
        return;
      }

      // List files
      const files = await FileUtilsService.listFilesFromFolder(folderPath);

      // Calculate total size
      const totalSize = files.reduce((sum, file) => sum + file.size, 0);

      res.status(200).json({
        success: true,
        message: `Found ${files.length} files`,
        files,
        totalFiles: files.length,
        totalSize,
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to list files from folder',
        error: (error as Error).message,
      });
    }
  };

  /**
   * Rename files in the temporary list (before upload)
   * PUT /api/files/rename
   * Body: { files: FileWithRename[] }
   */
  renameFiles = async (
    req: Request,
    res: Response
  ): Promise<void> => {
    try {
      const { files } = req.body as { files: FileWithRename[] };

      if (!files || !Array.isArray(files)) {
        res.status(400).json({
          success: false,
          message: 'Files array is required',
        });
        return;
      }

      // Validate and sanitize new names
      const updatedFiles = files.map((file) => {
        if (file.newName) {
          // Validate filename
          if (!FileUtilsService.validateFileName(file.newName)) {
            file.newName = FileUtilsService.sanitizeFileName(file.newName);
          }
          
          // Preserve extension if not included
          const hasExtension = path.extname(file.newName);
          if (!hasExtension && file.extension) {
            file.newName = `${file.newName}.${file.extension}`;
          }
        }
        return file;
      });

      res.status(200).json({
        success: true,
        message: 'Files renamed successfully',
        files: updatedFiles,
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to rename files',
        error: (error as Error).message,
      });
    }
  };

  /**
   * Upload files with modifications to uploads folder
   * POST /api/files/upload
   * Body: { files: FileWithRename[] }
   */
  uploadFiles = async (
    req: Request,
    res: Response
  ): Promise<void> => {
    try {
      const { files } = req.body as { files: FileWithRename[] };

      if (!files || !Array.isArray(files) || files.length === 0) {
        res.status(400).json({
          success: false,
          message: 'Files array is required and cannot be empty',
        });
        return;
      }

      // Process batch upload
      const result = await this.uploadService.processBatchUpload(files);

      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to upload files',
        error: (error as Error).message,
      });
    }
  };

  /**
   * Upload files from web with multipart form data
   * POST /api/files/upload-web
   * Form Data: files (multipart), metadata
   */
  uploadFilesWeb = async (
    req: Request,
    res: Response
  ): Promise<void> => {
    try {
      const uploadedFiles = req.files as Express.Multer.File[];

      if (!uploadedFiles || uploadedFiles.length === 0) {
        res.status(400).json({
          success: false,
          message: 'No files uploaded',
        });
        return;
      }

      // Process web upload
      const result = await this.uploadService.processWebUpload(uploadedFiles, req.body);

      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to upload files from web',
        error: (error as Error).message,
      });
    }
  };

  /**
   * Get upload statistics
   * GET /api/files/stats
   */
  getUploadStats = async (
    _req: Request,
    res: Response
  ): Promise<void> => {
    try {
      const stats = await this.uploadService.getUploadStats();

      res.status(200).json({
        success: true,
        message: 'Upload statistics retrieved successfully',
        data: stats,
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to get upload statistics',
        error: (error as Error).message,
      });
    }
  };

  /**
   * Health check endpoint
   * GET /api/files/health
   */
  healthCheck = async (
    _req: Request,
    res: Response
  ): Promise<void> => {
    res.status(200).json({
      success: true,
      message: 'File Manager API is running',
      timestamp: new Date().toISOString(),
    });
  };
}
