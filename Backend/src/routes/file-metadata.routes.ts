/**
 * File Metadata Routes
 * Routes for file metadata operations and file retrieval
 */

import { Router } from 'express';
import { FileMetadataController } from '../controllers/file-metadata.controller';

export const createFileMetadataRoutes = (uploadsPath: string): Router => {
  const router = Router();
  const fileMetadataController = new FileMetadataController(uploadsPath);

  // Get metadata of all uploaded files (no file content, just metadata)
  router.get('/list', fileMetadataController.getAllFilesMetadata);

  // Download file by exact filename
  router.get('/download/:filename', fileMetadataController.downloadFileByName);

  // Stream file by exact filename (for viewing in browser)
  router.get('/stream/:filename', fileMetadataController.streamFileByName);

  // Get file by ID (base64 encoded path)
  router.get('/file/:fileId', fileMetadataController.getFileById);

  // Search files by name (partial match)
  router.get('/search', fileMetadataController.searchFilesByName);

  // Delete file by filename
  router.delete('/delete/:filename', fileMetadataController.deleteFileByName);

  // Get uploads directory statistics
  router.get('/stats', fileMetadataController.getUploadsStats);

  // Health check for file metadata service
  router.get('/health', fileMetadataController.healthCheck);

  return router;
};