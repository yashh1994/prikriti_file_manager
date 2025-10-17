import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import { config } from './config/config';
import { createFileRoutes } from './routes/file.routes';
import { createSimpleFileMetadataRoutes } from './routes/simple-file-metadata.routes';
import { errorHandler, notFoundHandler } from './middleware/error.middleware';
import { requestLogger } from './middleware/logger.middleware';

// Create Express application
const app: Application = express();

// Middleware
app.use(helmet()); // Security headers
app.use(cors(config.cors)); // CORS
app.use(compression()); // Response compression
app.use(express.json({ limit: '50mb' })); // Parse JSON bodies
app.use(express.urlencoded({ extended: true, limit: '50mb' })); // Parse URL-encoded bodies
app.use(requestLogger); // Request logging

// API Routes
app.use('/api/files', createFileRoutes(config.upload.path));
app.use('/api/file-metadata', createSimpleFileMetadataRoutes(config.upload.path));

// Health check endpoint
app.get('/health', (_req, res) => {
  res.status(200).json({
    success: true,
    message: 'Prikriti File Manager API is running',
    timestamp: new Date().toISOString(),
    environment: config.server.env,
  });
});

// Root endpoint
app.get('/', (_req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Prikriti File Manager API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      files: {
        listFolder: 'POST /api/files/list-folder',
        rename: 'PUT /api/files/rename',
        upload: 'POST /api/files/upload',
        uploadWeb: 'POST /api/files/upload-web',
        stats: 'GET /api/files/stats',
      },
      fileMetadata: {
        list: 'GET /api/file-metadata/list',
        download: 'GET /api/file-metadata/download/:filename',
        stream: 'GET /api/file-metadata/stream/:filename',
      },
    },
  });
});

// Error Handlers
app.use(notFoundHandler);
app.use(errorHandler);

// Start server
const PORT = config.server.port;

app.listen(PORT, () => {
  console.log('=================================');
  console.log(`🚀 Prikriti File Manager API`);
  console.log(`📡 Server running on port ${PORT}`);
  console.log(`🌍 Environment: ${config.server.env}`);
  console.log(`📁 Upload path: ${config.upload.path}`);
  console.log('=================================');
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (err: Error) => {
  console.error('❌ UNHANDLED REJECTION! Shutting down...');
  console.error(err.name, err.message);
  process.exit(1);
});

// Handle uncaught exceptions
process.on('uncaughtException', (err: Error) => {
  console.error('❌ UNCAUGHT EXCEPTION! Shutting down...');
  console.error(err.name, err.message);
  process.exit(1);
});

export default app;
