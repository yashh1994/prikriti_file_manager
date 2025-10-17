/**
 * Simple File Metadata Controller
 */

import { Request, Response } from 'express';
import { SimpleFileMetadataService } from '../services/simple-file-metadata.service';
import * as path from 'path';

export class SimpleFileMetadataController {
  private service: SimpleFileMetadataService;

  constructor(uploadsPath: string) {
    this.service = new SimpleFileMetadataService(uploadsPath);
  }

  /**
   * Get all files metadata
   */
  getFiles = async (_req: Request, res: Response): Promise<void> => {
    try {
      const files = await this.service.getAllFiles();
      res.status(200).json({
        success: true,
        message: `Found ${files.length} files`,
        files,
        totalFiles: files.length,
        totalSize: files.reduce((sum, file) => sum + file.size, 0),
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to get files',
        files: [],
        totalFiles: 0,
        totalSize: 0,
      });
    }
  };

  /**
   * Download file by name
   */
  downloadFile = async (req: Request, res: Response): Promise<void> => {
    try {
      const { filename } = req.params;
      
      if (!filename) {
        res.status(400).json({
          success: false,
          message: 'Filename is required',
        });
        return;
      }

      const fileBuffer = await this.service.getFileByName(filename);
      
      if (!fileBuffer) {
        res.status(404).json({
          success: false,
          message: 'File not found',
        });
        return;
      }

      const ext = path.extname(filename).replace('.', '');
      const mimeType = this.getMimeType(ext);

      res.setHeader('Content-Type', mimeType);
      res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
      res.setHeader('Content-Length', fileBuffer.length);
      res.send(fileBuffer);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to download file',
      });
    }
  };

  /**
   * Stream file by name
   */
  streamFile = async (req: Request, res: Response): Promise<void> => {
    try {
      const { filename } = req.params;
      
      if (!filename) {
        res.status(400).json({
          success: false,
          message: 'Filename is required',
        });
        return;
      }

      const fileBuffer = await this.service.getFileByName(filename);
      
      if (!fileBuffer) {
        res.status(404).json({
          success: false,
          message: 'File not found',
        });
        return;
      }

      const ext = path.extname(filename).replace('.', '');
      const mimeType = this.getMimeType(ext);

      res.setHeader('Content-Type', mimeType);
      res.setHeader('Content-Length', fileBuffer.length);
      res.send(fileBuffer);
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to stream file',
      });
    }
  };

  /**
   * Delete file by name
   */
  deleteFile = async (req: Request, res: Response): Promise<void> => {
    try {
      const { filename } = req.params;
      
      if (!filename) {
        res.status(400).json({
          success: false,
          message: 'Filename is required',
        });
        return;
      }

      // Check if file exists first
      const exists = await this.service.fileExists(filename);
      if (!exists) {
        res.status(404).json({
          success: false,
          message: 'File not found',
        });
        return;
      }

      // Delete the file
      const deleted = await this.service.deleteFileByName(filename);
      
      if (deleted) {
        res.status(200).json({
          success: true,
          message: `File '${filename}' deleted successfully`,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Failed to delete file',
        });
      }
    } catch (error) {
      console.error('Error deleting file:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to delete file',
      });
    }
  };

  private getMimeType(ext: string): string {
    const mimeTypes: { [key: string]: string } = {
      'pdf': 'application/pdf',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'txt': 'text/plain',
      'json': 'application/json',
      'mp4': 'video/mp4',
      'zip': 'application/zip',
    };

    return mimeTypes[ext.toLowerCase()] || 'application/octet-stream';
  }
}