import React, { useState, useEffect } from 'react';
import { RefreshCw, FileText } from 'lucide-react';
import SearchBar from './components/SearchBar';
import FileList from './components/FileList';
import Pagination from './components/Pagination';
import ExcelPreview from './components/ExcelPreview';
import { fileService, FileInfo } from './services/fileService';

const ITEMS_PER_PAGE = 10;

const App: React.FC = () => {
  const [files, setFiles] = useState<FileInfo[]>([]);
  const [filteredFiles, setFilteredFiles] = useState<FileInfo[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [error, setError] = useState<string | null>(null);
  const [excelPreview, setExcelPreview] = useState<{ file: FileInfo; url: string } | null>(null);

  useEffect(() => {
    loadFiles();
  }, []);

  useEffect(() => {
    // Filter files based on search term
    const filtered = files.filter(file => 
      file.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      file.extension.toLowerCase().includes(searchTerm.toLowerCase())
    );
    setFilteredFiles(filtered);
    setCurrentPage(1); // Reset to first page when filtering
  }, [files, searchTerm]);

  const loadFiles = async () => {
    try {
      setLoading(true);
      setError(null);
      const filesResponse = await fileService.getFiles();
      setFiles(filesResponse.files);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to load files');
      console.error('Error loading files:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleFileClick = (file: FileInfo) => {
    // Handle Excel files with custom preview
    if (fileService.isExcelFile(file.extension)) {
      setExcelPreview({
        file: file,
        url: fileService.getFileStreamUrl(file.name)
      });
    } else if (fileService.canPreviewFile(file.extension)) {
      // Other previewable files - open in new tab
      window.open(fileService.getFileStreamUrl(file.name), '_blank');
    } else {
      // If can't preview, download the file
      fileService.downloadFile(file.name);
    }
  };

  const handleSearchChange = (term: string) => {
    setSearchTerm(term);
  };

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
  };

  const handleFileDelete = async (filename: string) => {
    try {
      setError(null);
      const result = await fileService.deleteFile(filename);
      
      if (result.success) {
        // Remove the file from local state
        setFiles(prevFiles => prevFiles.filter(file => file.name !== filename));
        
        // Show success message (optional - you can add a toast notification here)
        console.log(`File "${filename}" deleted successfully`);
      } else {
        setError(result.message || 'Failed to delete file');
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to delete file');
      console.error('Error deleting file:', err);
    }
  };

  // Calculate pagination
  const totalPages = Math.ceil(filteredFiles.length / ITEMS_PER_PAGE);
  const startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
  const endIndex = startIndex + ITEMS_PER_PAGE;
  const currentFiles = filteredFiles.slice(startIndex, endIndex);

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        {/* Material Design Header */}
        <div className="material-card p-6 mb-6 bg-gradient-to-r from-primary-50 to-accent-50 border-primary-200">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-primary-800 mb-2">Prikriti File Manager</h1>
              <p className="text-primary-600 text-base">
                Browse and manage your uploaded files
              </p>
            </div>
            <button
              onClick={loadFiles}
              disabled={loading}
              className={`p-3 rounded-full bg-primary-100 hover:bg-primary-200 text-primary-600 hover:text-primary-700 transition-all duration-200 ${loading ? 'animate-spin' : ''}`}
              title="Refresh files"
            >
              <RefreshCw className="h-5 w-5" />
            </button>
          </div>
        </div>

        {/* Search Bar */}
        <div className="material-card p-4 mb-6 border-primary-100">
          <SearchBar
            searchTerm={searchTerm}
            onSearchChange={handleSearchChange}
            placeholder="Search files by name or type..."
          />
        </div>

        {/* Error Message */}
        {error && (
          <div className="material-card mb-6 bg-error-50 border-error-200 p-6">
            <div className="flex items-start">
              <div className="flex-shrink-0">
                <svg className="h-5 w-5 text-error-600" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="ml-3 flex-1">
                <h3 className="text-sm font-medium text-error-800">
                  Error loading files
                </h3>
                <div className="mt-2 text-sm text-error-700">
                  {error}
                </div>
                <div className="mt-4">
                  <button
                    onClick={loadFiles}
                    className="material-button-secondary text-error-700 hover:bg-error-100"
                  >
                    Try again
                  </button>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Stats */}
        {!loading && !error && (
          <div className="material-card p-4 mb-6 bg-primary-50 border-primary-200">
            <div className="flex items-center justify-between">
              <div className="text-sm text-gray-700">
                Showing <span className="font-medium text-primary-800">{currentFiles.length}</span> of <span className="font-medium text-primary-800">{filteredFiles.length}</span> files
                {searchTerm && (
                  <span className="ml-2 text-primary-600 font-medium">
                    (filtered by "{searchTerm}")
                  </span>
                )}
              </div>
              
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm('')}
                  className="px-3 py-1 bg-primary-100 hover:bg-primary-200 text-primary-700 text-xs rounded-button font-medium transition-colors"
                >
                  Clear search
                </button>
              )}
            </div>
          </div>
        )}

        {/* File List */}
        <div className="mb-6">
          <FileList
            files={currentFiles}
            loading={loading}
            onFileClick={handleFileClick}
            onFileDelete={handleFileDelete}
          />
        </div>

        {/* Pagination */}
        {!loading && !error && totalPages > 1 && (
          <div className="material-card p-4 flex justify-center bg-primary-50 border-primary-200">
            <Pagination
              currentPage={currentPage}
              totalPages={totalPages}
              onPageChange={handlePageChange}
            />
          </div>
        )}

        {/* Empty State */}
        {!loading && !error && files.length === 0 && (
          <div className="material-card text-center py-16">
            <div className="text-gray-400 mb-6">
              <FileText className="mx-auto h-16 w-16" />
            </div>
            <h3 className="text-xl font-medium text-gray-900 mb-2">No files uploaded yet</h3>
            <p className="text-gray-500 mb-6 max-w-sm mx-auto">
              Upload some files to get started with file management.
            </p>
            <button
              onClick={loadFiles}
              className="px-6 py-3 bg-primary-600 hover:bg-primary-700 text-white rounded-button font-medium shadow-button hover:shadow-lg transition-all duration-200"
            >
              Refresh Files
            </button>
          </div>
        )}
      </div>

      {/* Excel Preview Modal */}
      {excelPreview && (
        <ExcelPreview
          fileUrl={excelPreview.url}
          fileName={excelPreview.file.name}
          onClose={() => setExcelPreview(null)}
        />
      )}
    </div>
  );
};

export default App;