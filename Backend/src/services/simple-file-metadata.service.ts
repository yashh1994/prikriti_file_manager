/**
 * Simple File Metadata Service
 * Handles file metadata operations and file retrieval from uploads directory
 */

import * as fs from 'fs';
import * as path from 'path';

export interface FileInfo {
  id: string;
  name: string;
  size: number;
  extension: string;
  mimetype: string;
  createdAt: Date;
  modifiedAt: Date;
}

export class SimpleFileMetadataService {
  private uploadsPath: string;

  constructor(uploadsPath: string) {
    this.uploadsPath = uploadsPath;
  }

  /**
   * Get all files metadata
   */
  async getAllFiles(): Promise<FileInfo[]> {
    try {
      if (!fs.existsSync(this.uploadsPath)) {
        return [];
      }

      const files = fs.readdirSync(this.uploadsPath, { withFileTypes: true });
      const fileInfos: FileInfo[] = [];

      for (const file of files) {
        if (file.isFile()) {
          const filePath = path.join(this.uploadsPath, file.name);
          const stats = fs.statSync(filePath);
          const ext = path.extname(file.name).replace('.', '');
          
          fileInfos.push({
            id: Buffer.from(filePath).toString('base64'),
            name: file.name,
            size: stats.size,
            extension: ext,
            mimetype: this.getMimeType(ext),
            createdAt: stats.birthtime,
            modifiedAt: stats.mtime,
          });
        }
      }

      return fileInfos;
    } catch (error) {
      console.error('Error getting files:', error);
      return [];
    }
  }

  /**
   * Get file by name
   */
  async getFileByName(filename: string): Promise<Buffer | null> {
    try {
      const filePath = path.join(this.uploadsPath, filename);
      
      if (!fs.existsSync(filePath)) {
        return null;
      }

      return fs.readFileSync(filePath);
    } catch (error) {
      console.error('Error reading file:', error);
      return null;
    }
  }

  /**
   * Delete file by name
   */
  async deleteFileByName(filename: string): Promise<boolean> {
    try {
      const filePath = path.join(this.uploadsPath, filename);
      
      if (!fs.existsSync(filePath)) {
        return false;
      }

      fs.unlinkSync(filePath);
      return true;
    } catch (error) {
      console.error('Error deleting file:', error);
      return false;
    }
  }

  /**
   * Check if file exists
   */
  async fileExists(filename: string): Promise<boolean> {
    try {
      const filePath = path.join(this.uploadsPath, filename);
      return fs.existsSync(filePath);
    } catch (error) {
      return false;
    }
  }

  /**
   * Get basic mime type
   */
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