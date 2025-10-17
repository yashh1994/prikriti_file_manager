/**
 * File Management Types and Interfaces
 */

export interface FileMetadata {
  name: string;
  originalName: string;
  extension: string;
  size: number;
  path: string;
  mimetype?: string;
  createdAt: Date;
  modifiedAt: Date;
}

export interface FileWithRename extends FileMetadata {
  newName?: string;
  id: string;
}

export enum UploadStatus {
  PENDING = 'pending',
  DONE = 'done',
  FAILED = 'failed',
  DUPLICATE = 'duplicate',
}

export interface UploadResult {
  id: string;
  originalName: string;
  newName: string;
  status: UploadStatus;
  finalPath?: string;
  error?: string;
  size?: number;
  extension?: string;
}

export interface BatchUploadResponse {
  success: boolean;
  message: string;
  results: UploadResult[];
  summary: {
    total: number;
    done: number;
    failed: number;
    duplicate: number;
    pending: number;
  };
}

export interface FolderListResponse {
  success: boolean;
  message: string;
  files: FileWithRename[];
  totalFiles: number;
  totalSize: number;
}

export interface RenameRequest {
  fileId: string;
  newName: string;
}

export interface ErrorResponse {
  success: false;
  message: string;
  error?: string;
}
