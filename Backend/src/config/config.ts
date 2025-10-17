/**
 * Configuration Module
 * Centralized application configuration
 */

import * as dotenv from 'dotenv';
import * as path from 'path';

// Load environment variables
dotenv.config();

export const config = {
  // Server Configuration
  server: {
    port: parseInt(process.env.PORT || '3000', 10),
    env: process.env.NODE_ENV || 'development',
  },

  // CORS Configuration
  cors: {
    origin: process.env.CORS_ORIGIN || '*',
    credentials: true,
  },

  // File Upload Configuration
  upload: {
    path: path.join(process.cwd(), process.env.UPLOAD_PATH || 'uploads'),
    maxFileSize: parseInt(process.env.MAX_FILE_SIZE || '104857600', 10), // 100MB default
    allowedExtensions: (process.env.ALLOWED_EXTENSIONS || 'jpg,jpeg,png,gif,pdf,doc,docx,txt,zip,rar,7z,csv,xlsx,xls,ppt,pptx,mp4,avi,mov,mp3,wav').split(','),
  },

  // Rate Limiting
  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW || '900000', 10), // 15 minutes
    max: parseInt(process.env.RATE_LIMIT_MAX || '100', 10),
  },

  // Logging
  logging: {
    level: process.env.LOG_LEVEL || 'info',
  },
};
