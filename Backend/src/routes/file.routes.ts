/**
 * File Management Routes
 */

import { Router } from 'express';
import multer from 'multer';
import { FileController } from '../controllers/file.controller';

const upload = multer({ storage: multer.memoryStorage() });

export const createFileRoutes = (uploadPath: string): Router => {
  const router = Router();
  const fileController = new FileController(uploadPath);

  // List files from selected folder
  router.post('/list-folder', fileController.listFilesFromFolder);

  // Rename files (update names before upload)
  router.put('/rename', fileController.renameFiles);

  // Upload files to uploads folder with duplicate handling (desktop)
  router.post('/upload', fileController.uploadFiles);

  // Upload files from web with multipart form data
  router.post('/upload-web', upload.array('files'), fileController.uploadFilesWeb);

  // Get upload statistics
  router.get('/stats', fileController.getUploadStats);

  // Health check
  router.get('/health', fileController.healthCheck);

  return router;
};
