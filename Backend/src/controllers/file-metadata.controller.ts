/**
 * File Metadata Controller
 * Handles HTTP requests for file metadata operations and file retrieval
 */

import { Request, Response } from 'express';
import { FileMetadataService, FileListResponse } from '../services/file-metadata.service';

export class FileMetadataController {
  private fileMetadataService: FileMetadataService;

  constructor(uploadsPath: string) {
    this.fileMetadataService = new FileMetadataService(uploadsPath);
  }

  /**
   * Get metadata of all uploaded files
   * GET /api/file-metadata/list
   */
  getAllFilesMetadata = async (
    _req: Request,
    res: Response<FileListResponse>
  ): Promise<void> => {
    try {
      const result = await this.fileMetadataService.getAllFilesMetadata();
      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error instanceof Error ? error.message : 'Failed to get files metadata',
        files: [],
        totalFiles: 0,
        totalSize: 0,
      });
    }
  };

  /**
   * Get file by exact filename
   * GET /api/file-metadata/download/:filename
   */
  downloadFileByName = async (req: Request, res: Response): Promise<void> => {
    try {
      const { filename } = req.params;

      if (!filename) {
        res.status(400).json({
          success: false,
          message: 'Filename is required',
        });
        return;
      }

      const result = await this.fileMetadataService.getFileByName(filename);

      if (!result.success || !result.file) {
        res.status(404).json({
          success: false,
          message: result.message,
        });
        return;
      }

      // Set headers for file download
      res.setHeader('Content-Type', result.file.mimetype);
      res.setHeader('Content-Disposition', `attachment; filename="${result.file.filename}"`);
      res.setHeader('Content-Length', result.file.size);

      // Send file buffer
      res.end(result.file.buffer);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error instanceof Error ? error.message : 'Failed to download file',
      });
    }
  };

  /**
   * Stream file by exact filename (for viewing in browser)
   * GET /api/file-metadata/stream/:filename
   */
  streamFileByName = async (req: Request, res: Response): Promise<void> => {
    try {
      const { filename } = req.params;

      if (!filename) {
        res.status(400).json({
          success: false,
          message: 'Filename is required',
        });
        return;
      }

      const result = await this.fileMetadataService.getFileByName(filename);

      if (!result.success || !result.file) {
        res.status(404).json({
          success: false,
          message: result.message,
        });
        return;
      }

      // Set headers for inline viewing
      res.setHeader('Content-Type', result.file.mimetype);
      res.setHeader('Content-Length', result.file.size);

      // Send file buffer for inline viewing
      res.end(result.file.buffer);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error instanceof Error ? error.message : 'Failed to stream file',
      });
    }
  };

  /**
   * Get file by ID
   * GET /api/file-metadata/file/:fileId
   */
  getFileById = async (req: Request, res: Response): Promise<void> => {
    try {
      const { fileId } = req.params;

      if (!fileId) {
        res.status(400).json({
          success: false,
          message: 'File ID is required',
        });
        return;
      }

      const result = await this.fileMetadataService.getFileById(fileId);

      if (!result.success || !result.file) {
        res.status(404).json({
          success: false,
          message: result.message,
        });
        return;
      }

      // Set headers for file download
      res.setHeader('Content-Type', result.file.mimetype);
      res.setHeader('Content-Disposition', `attachment; filename="${result.file.filename}"`);
      res.setHeader('Content-Length', result.file.size);

      // Send file buffer
      res.end(result.file.buffer);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error instanceof Error ? error.message : 'Failed to get file by ID',
      });
    }
  };

  /**
   * Search files by name (partial match)
   * GET /api/file-metadata/search?q=searchTerm
   */
  searchFilesByName = async (
    req: Request,
    res: Response<FileListResponse>
  ): Promise<void> => {
    try {
      const { q: searchTerm } = req.query;

      if (!searchTerm || typeof searchTerm !== 'string') {
        res.status(400).json({
          success: false,
          message: 'Search term (q) is required',
          files: [],
          totalFiles: 0,
          totalSize: 0,
        });
        return;
      }

      const result = await this.fileMetadataService.searchFilesByName(searchTerm);
      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error instanceof Error ? error.message : 'Failed to search files',
        files: [],
        totalFiles: 0,
        totalSize: 0,
      });
    }
  };

  /**
   * Delete file by filename
   * DELETE /api/file-metadata/delete/:filename
   */
  deleteFileByName = async (req: Request, res: Response): Promise<void> => {
    try {
      const { filename } = req.params;

      if (!filename) {
        res.status(400).json({
          success: false,
          message: 'Filename is required',
        });
        return;
      }

      const result = await this.fileMetadataService.deleteFileByName(filename);

      if (!result.success) {
        res.status(404).json(result);
        return;
      }

      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error instanceof Error ? error.message : 'Failed to delete file',
      });
    }
  };

  /**
   * Get uploads directory statistics
   * GET /api/file-metadata/stats
   */
  getUploadsStats = async (_req: Request, res: Response): Promise<void> => {
    try {
      const result = await this.fileMetadataService.getUploadsStats();
      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error instanceof Error ? error.message : 'Failed to get uploads stats',
        stats: {
          totalFiles: 0,
          totalSize: 0,
          totalDirectories: 0,
          lastModified: null,
        },
      });
    }
  };

  /**
   * Health check for file metadata service
   * GET /api/file-metadata/health
   */
  healthCheck = async (_req: Request, res: Response): Promise<void> => {
    try {
      const stats = await this.fileMetadataService.getUploadsStats();
      
      res.status(200).json({
        success: true,
        message: 'File Metadata Service is healthy',
        service: 'file-metadata-service',
        timestamp: new Date().toISOString(),
        uploadsAvailable: stats.success,
        version: '1.0.0',
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'File Metadata Service is unhealthy',
        service: 'file-metadata-service',
        timestamp: new Date().toISOString(),
        error: error instanceof Error ? error.message : 'Unknown error',
        version: '1.0.0',
      });
    }
  };
}