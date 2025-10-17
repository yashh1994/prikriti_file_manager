import axios from 'axios';

// API base URL - will use Vite proxy to backend
const API_BASE_URL = '/api';

// File metadata interface matching backend response
export interface FileInfo {
  id: string;
  name: string;
  size: number;
  extension: string;
  mimetype: string;
  createdAt: string;
  modifiedAt: string;
}

export interface FilesResponse {
  success: boolean;
  message: string;
  files: FileInfo[];
  totalFiles: number;
  totalSize: number;
}

class FileService {
  /**
   * Get all files metadata from backend
   */
  async getFiles(): Promise<FilesResponse> {
    try {
      const response = await axios.get(`${API_BASE_URL}/file-metadata/list`);
      return response.data;
    } catch (error) {
      console.error('Error fetching files:', error);
      throw new Error('Failed to fetch files');
    }
  }

  /**
   * Download file by name
   */
  downloadFile(filename: string): void {
    const url = `${API_BASE_URL}/file-metadata/download/${encodeURIComponent(filename)}`;
    window.open(url, '_blank');
  }

  /**
   * Get file URL for streaming/viewing
   */
  getFileStreamUrl(filename: string): string {
    return `${API_BASE_URL}/file-metadata/stream/${encodeURIComponent(filename)}`;
  }

  /**
   * Delete file by name
   */
  async deleteFile(filename: string): Promise<{ success: boolean; message: string }> {
    try {
      const response = await axios.delete(`${API_BASE_URL}/file-metadata/delete/${encodeURIComponent(filename)}`);
      return response.data;
    } catch (error) {
      console.error('Error deleting file:', error);
      throw new Error('Failed to delete file');
    }
  }

  /**
   * Format file size for display
   */
  formatFileSize(bytes: number): string {
    if (bytes === 0) return '0 Bytes';

    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  }

  /**
   * Format date for display
   */
  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { 
      hour: '2-digit', 
      minute: '2-digit' 
    });
  }

  /**
   * Get file icon based on extension
   */
  getFileIcon(extension: string): string {
    const ext = extension.toLowerCase();
    
    // Image files
    if (['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'bmp'].includes(ext)) {
      return '🖼️';
    }
    
    // Document files
    if (['pdf'].includes(ext)) {
      return '📄';
    }
    
    if (['doc', 'docx'].includes(ext)) {
      return '📝';
    }
    
    if (['xls', 'xlsx'].includes(ext)) {
      return '📊';
    }
    
    if (['ppt', 'pptx'].includes(ext)) {
      return '📋';
    }
    
    // Video files
    if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].includes(ext)) {
      return '🎥';
    }
    
    // Audio files
    if (['mp3', 'wav', 'flac', 'aac', 'ogg'].includes(ext)) {
      return '🎵';
    }
    
    // Archive files
    if (['zip', 'rar', '7z', 'tar', 'gz'].includes(ext)) {
      return '📦';
    }
    
    // Code files
    if (['js', 'ts', 'jsx', 'tsx', 'html', 'css', 'py', 'java', 'cpp', 'c'].includes(ext)) {
      return '💻';
    }
    
    // Text files
    if (['txt', 'md', 'json', 'xml', 'csv'].includes(ext)) {
      return '📃';
    }
    
    // Default file icon
    return '📁';
  }

  /**
   * Check if file can be previewed in browser
   */
  canPreviewFile(extension: string): boolean {
    const ext = extension.toLowerCase();
    const previewable = [
      'jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'bmp', // Images
      'pdf', // PDF
      'txt', 'json', 'xml', 'csv', 'md', // Text files
      'mp4', 'webm', // Videos
      'mp3', 'wav', 'ogg', // Audio
      'xls', 'xlsx' // Excel files
    ];
    
    return previewable.includes(ext);
  }

  /**
   * Check if file is an Excel file
   */
  isExcelFile(extension: string): boolean {
    const ext = extension.toLowerCase();
    return ['xls', 'xlsx'].includes(ext);
  }
}

export const fileService = new FileService();