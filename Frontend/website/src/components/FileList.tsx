import React, { useState } from 'react';
import { Download, Eye, FileText, Trash2 } from 'lucide-react';
import { FileInfo, fileService } from '../services/fileService';

interface FileListProps {
  files: FileInfo[];
  loading: boolean;
  onFileClick: (file: FileInfo) => void;
  onFileDelete: (filename: string) => void;
}

const FileList: React.FC<FileListProps> = ({ files, loading, onFileClick, onFileDelete }) => {
  const [deletingFile, setDeletingFile] = useState<string | null>(null);

  const handleDeleteFile = async (filename: string) => {
    if (window.confirm(`Are you sure you want to delete "${filename}"? This action cannot be undone.`)) {
      setDeletingFile(filename);
      try {
        onFileDelete(filename);
      } finally {
        setDeletingFile(null);
      }
    }
  };
  if (loading) {
    return (
      <div className="material-card">
        <div className="flex items-center justify-center py-16">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
          <span className="ml-4 text-gray-600 font-medium">Loading files...</span>
        </div>
      </div>
    );
  }

  if (files.length === 0) {
    return (
      <div className="material-card">
        <div className="text-center py-16">
          <FileText className="mx-auto h-16 w-16 text-gray-300 mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">No files found</h3>
          <p className="text-gray-500">
            No files match your search criteria.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="material-card border-primary-100">
      <div className="px-6 py-4 border-b border-primary-100 bg-gradient-to-r from-primary-50 to-accent-50">
        <h3 className="text-lg font-semibold text-primary-800">
          Files ({files.length})
        </h3>
      </div>
      
      <div className="divide-y divide-gray-200">
        {files.map((file) => (
            <div
            key={file.id}
            className="file-item px-6 py-4 flex items-center justify-between cursor-pointer"
            onClick={() => onFileClick(file)}
          >
            <div className="flex items-center space-x-3 flex-1 min-w-0">
              <div className="text-2xl">
                {fileService.getFileIcon(file.extension)}
              </div>
              
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-gray-900 truncate">
                  {file.name}
                </p>
                <div className="flex items-center space-x-4 text-xs text-gray-500 mt-1">
                  <span>{file.extension.toUpperCase()}</span>
                  <span>{fileService.formatFileSize(file.size)}</span>
                  <span>{fileService.formatDate(file.modifiedAt)}</span>
                </div>
              </div>
            </div>
            
            <div className="flex items-center space-x-2">
              {fileService.canPreviewFile(file.extension) && (
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    // Use the main click handler for consistent preview behavior
                    onFileClick(file);
                  }}
                  className="p-2 rounded-full text-gray-500 hover:text-primary-600 hover:bg-primary-100 transition-all duration-200"
                  title="Preview file"
                >
                  <Eye className="h-4 w-4" />
                </button>
              )}
              
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  fileService.downloadFile(file.name);
                }}
                className="p-2 rounded-full text-gray-500 hover:text-accent-600 hover:bg-accent-100 transition-all duration-200"
                title="Download file"
              >
                <Download className="h-4 w-4" />
              </button>

              <button
                onClick={(e) => {
                  e.stopPropagation();
                  handleDeleteFile(file.name);
                }}
                disabled={deletingFile === file.name}
                className={`p-2 rounded-full transition-all duration-200 ${
                  deletingFile === file.name
                    ? 'text-gray-400 cursor-not-allowed'
                    : 'text-gray-500 hover:text-error-600 hover:bg-error-100'
                }`}
                title="Delete file"
              >
                <Trash2 className="h-4 w-4" />
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default FileList;