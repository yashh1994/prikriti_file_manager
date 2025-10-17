/**
 * File Metadata Service
 * Handles file metadata operations and file retrieval from uploads directory
 */

import * as fs from 'fs-extra';
import * as path from 'path';
import * as mime from 'mime-types';

export interface FileMetadataInfo {
  id: string;
  name: string;
  originalName: string;
  extension: string;
  size: number;
  mimetype: string;
  createdAt: Date;
  modifiedAt: Date;
  relativePath: string;
}

export interface FileListResponse {
  success: boolean;
  message: string;
  files: FileMetadataInfo[];
  totalFiles: number;
  totalSize: number;
}

export interface FileRetrievalResponse {
  success: boolean;
  message: string;
  file?: {
    buffer: Buffer;
    filename: string;
    mimetype: string;
    size: number;
  };
}

export class FileMetadataService {
  private uploadsPath: string;

  constructor(uploadsPath: string) {
    this.uploadsPath = uploadsPath;
  }

  /**
   * Get metadata of all files in uploads directory
   * Returns only metadata, not file contents
   */
  async getAllFilesMetadata(): Promise<FileListResponse> {
    try {
      // Ensure uploads directory exists
      const exists = await fs.pathExists(this.uploadsPath);
      if (!exists) {
        return {
          success: true,
          message: 'No uploads directory found',
          files: [],
          totalFiles: 0,
          totalSize: 0,
        };
      }

      const files: FileMetadataInfo[] = [];
      await this.scanDirectory(this.uploadsPath, files, '');

      // Calculate total size
      const totalSize = files.reduce((sum, file) => sum + file.size, 0);

      return {
        success: true,
        message: `Found ${files.length} uploaded files`,
        files,
        totalFiles: files.length,
        totalSize,
      };
    } catch (error) {
      throw new Error(`Failed to scan uploads directory: ${error}`);
    }
  }

  /**
   * Recursively scan directory for files
   */
  private async scanDirectory(
    dirPath: string,
    files: FileMetadataInfo[],
    relativePath: string
  ): Promise<void> {
    const items = await fs.promises.readdir(dirPath);

    for (const item of items) {
      const itemPath = path.join(dirPath, item);
      const itemStats = await fs.promises.stat(itemPath);
      const itemRelativePath = path.join(relativePath, item).replace(/\\/g, '/');

      if (itemStats.isDirectory()) {
        // Recursively scan subdirectories
        await this.scanDirectory(itemPath, files, itemRelativePath);
      } else if (itemStats.isFile()) {
        const extension = path.extname(item);
        const mimetype = mime.lookup(item) || 'application/octet-stream';

        files.push({
          id: Buffer.from(itemPath).toString('base64'), // Use base64 encoded path as ID
          name: item,
          originalName: item,
          extension: extension.replace('.', ''),
          size: itemStats.size,
          mimetype,
          createdAt: itemStats.birthtime,
          modifiedAt: itemStats.mtime,
          relativePath: itemRelativePath,
        });
      }
    }
  }

  /**
   * Get file by filename (exact match)
   * Returns the actual file buffer
   */
  async getFileByName(filename: string): Promise<FileRetrievalResponse> {
    try {
      // Find the file in uploads directory
      const fileInfo = await this.findFileByName(this.uploadsPath, filename);

      if (!fileInfo) {
        return {
          success: false,
          message: `File not found: ${filename}`,
        };
      }

      // Read file content
      const buffer = await fs.promises.readFile(fileInfo.fullPath);
      const mimetype = mime.lookup(filename) || 'application/octet-stream';

      return {
        success: true,
        message: `File retrieved successfully: ${filename}`,
        file: {
          buffer,
          filename: fileInfo.name,
          mimetype,
          size: buffer.length,
        },
      };
    } catch (error) {
      throw new Error(`Failed to retrieve file: ${error}`);
    }
  }

  /**
   * Search for files by name (case-insensitive)
   * Returns multiple matches if found
   */
  async searchFilesByName(searchTerm: string): Promise<FileListResponse> {
    try {
      const allFiles = await this.getAllFilesMetadata();
      
      if (!allFiles.success) {
        return allFiles;
      }

      // Filter files by search term (case-insensitive)
      const filteredFiles = allFiles.files.filter(file =>
        file.name.toLowerCase().includes(searchTerm.toLowerCase())
      );

      const totalSize = filteredFiles.reduce((sum, file) => sum + file.size, 0);

      return {
        success: true,
        message: `Found ${filteredFiles.length} files matching "${searchTerm}"`,
        files: filteredFiles,
        totalFiles: filteredFiles.length,
        totalSize,
      };
    } catch (error) {
      throw new Error(`Failed to search files: ${error}`);
    }
  }

  /**
   * Find file by exact filename (recursive search)
   */
  private async findFileByName(
    dirPath: string,
    filename: string
  ): Promise<{ fullPath: string; name: string } | null> {
    const exists = await fs.pathExists(dirPath);
    if (!exists) {
      return null;
    }

    const items = await fs.promises.readdir(dirPath);

    for (const item of items) {
      const itemPath = path.join(dirPath, item);
      const itemStats = await fs.promises.stat(itemPath);

      if (itemStats.isDirectory()) {
        // Recursively search in subdirectories
        const found = await this.findFileByName(itemPath, filename);
        if (found) {
          return found;
        }
      } else if (itemStats.isFile() && item === filename) {
        return {
          fullPath: itemPath,
          name: item,
        };
      }
    }

    return null;
  }

  /**
   * Get file by ID (base64 encoded path)
   */
  async getFileById(fileId: string): Promise<FileRetrievalResponse> {
    try {
      // Decode base64 ID to get original path
      const decodedPath = Buffer.from(fileId, 'base64').toString('utf-8');
      
      // Verify file exists and is within uploads directory
      const exists = await fs.pathExists(decodedPath);
      if (!exists) {
        return {
          success: false,
          message: `File not found with ID: ${fileId}`,
        };
      }

      // Security check: ensure file is within uploads directory
      const relativePath = path.relative(this.uploadsPath, decodedPath);
      if (relativePath.startsWith('..') || path.isAbsolute(relativePath)) {
        return {
          success: false,
          message: 'Invalid file path - security violation',
        };
      }

      // Read file content
      const buffer = await fs.promises.readFile(decodedPath);
      const filename = path.basename(decodedPath);
      const mimetype = mime.lookup(filename) || 'application/octet-stream';

      return {
        success: true,
        message: `File retrieved successfully: ${filename}`,
        file: {
          buffer,
          filename,
          mimetype,
          size: buffer.length,
        },
      };
    } catch (error) {
      throw new Error(`Failed to retrieve file by ID: ${error}`);
    }
  }
}