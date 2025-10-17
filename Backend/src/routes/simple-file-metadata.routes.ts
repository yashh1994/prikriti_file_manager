/**
 * Simple File Metadata Routes
 */

import { Router } from 'express';
import { SimpleFileMetadataController } from '../controllers/simple-file-metadata.controller';

export function createSimpleFileMetadataRoutes(uploadsPath: string): Router {
  const router = Router();
  const controller = new SimpleFileMetadataController(uploadsPath);

  // Get all files metadata
  router.get('/list', controller.getFiles);

  // Download file by name
  router.get('/download/:filename', controller.downloadFile);

  // Stream file by name (for browser viewing)
  router.get('/stream/:filename', controller.streamFile);

  // Delete file by name
  router.delete('/delete/:filename', controller.deleteFile);

  return router;
}