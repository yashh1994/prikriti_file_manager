/**
 * Request Logger Middleware
 */

import { Request, Response } from 'express';
import morgan from 'morgan';

// Custom morgan token for response body size
morgan.token('body-size', (_req: Request, res: Response) => {
  return res.get('content-length') || '0';
});

// Custom format for development
export const developmentLogger = morgan(
  ':method :url :status :response-time ms - :res[content-length] bytes'
);

// Custom format for production
export const productionLogger = morgan('combined');

// Request logger based on environment
export const requestLogger =
  process.env.NODE_ENV === 'production' ? productionLogger : developmentLogger;
