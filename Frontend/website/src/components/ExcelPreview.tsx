import React, { useState, useEffect } from 'react';
import { X, Download, Table, AlertCircle } from 'lucide-react';

interface ExcelPreviewProps {
  fileUrl: string;
  fileName: string;
  onClose: () => void;
}

interface WorksheetData {
  name: string;
  data: any[][];
}

const ExcelPreview: React.FC<ExcelPreviewProps> = ({ fileUrl, fileName, onClose }) => {
  const [worksheets, setWorksheets] = useState<WorksheetData[]>([]);
  const [activeSheet, setActiveSheet] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadExcelFile();
  }, [fileUrl]);

  const loadExcelFile = async () => {
    try {
      setLoading(true);
      setError(null);

      // Dynamically import xlsx to avoid build issues
      const XLSX = await import('xlsx');
      
      // Fetch the file
      const response = await fetch(fileUrl);
      if (!response.ok) {
        throw new Error('Failed to fetch file');
      }

      const arrayBuffer = await response.arrayBuffer();
      const workbook = XLSX.read(arrayBuffer, { type: 'array' });

      const sheets: WorksheetData[] = [];
      
      workbook.SheetNames.forEach((sheetName) => {
        const worksheet = workbook.Sheets[sheetName];
        const jsonData = XLSX.utils.sheet_to_json(worksheet, { 
          header: 1,
          defval: '' // Default value for empty cells
        });
        
        sheets.push({
          name: sheetName,
          data: jsonData as any[][]
        });
      });

      setWorksheets(sheets);
      setActiveSheet(0);
    } catch (err) {
      console.error('Error loading Excel file:', err);
      setError(err instanceof Error ? err.message : 'Failed to load Excel file');
    } finally {
      setLoading(false);
    }
  };

  const downloadFile = () => {
    window.open(fileUrl, '_blank');
  };

  const renderTable = (data: any[][]) => {
    if (!data || data.length === 0) {
      return (
        <div className="flex items-center justify-center py-8 text-gray-500">
          <Table className="h-8 w-8 mr-2" />
          <span>No data in this sheet</span>
        </div>
      );
    }

    // Limit display to first 100 rows and 20 columns for performance
    const maxRows = Math.min(data.length, 100);
    const maxCols = Math.min(Math.max(...data.map(row => row.length)), 20);

    return (
      <div className="overflow-auto max-h-96">
        <table className="min-w-full divide-y divide-gray-200 text-sm">
          <tbody className="bg-white divide-y divide-gray-200">
            {data.slice(0, maxRows).map((row, rowIndex) => (
              <tr key={rowIndex} className={rowIndex === 0 ? 'bg-gray-50 font-medium' : ''}>
                {Array.from({ length: maxCols }, (_, colIndex) => (
                  <td 
                    key={colIndex} 
                    className="px-3 py-2 whitespace-nowrap border-r border-gray-200 text-gray-900 max-w-xs truncate"
                    title={String(row[colIndex] || '')}
                  >
                    {String(row[colIndex] || '')}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
        {data.length > 100 && (
          <div className="text-center py-2 text-gray-500 text-xs bg-gray-50">
            Showing first 100 rows of {data.length} total rows
          </div>
        )}
      </div>
    );
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-2xl max-w-6xl w-full max-h-[90vh] flex flex-col">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-gray-200">
          <div className="flex items-center space-x-3">
            <div className="text-2xl">📊</div>
            <div>
              <h3 className="text-lg font-semibold text-gray-900">{fileName}</h3>
              <p className="text-sm text-gray-500">Excel Spreadsheet Preview</p>
            </div>
          </div>
          
          <div className="flex items-center space-x-2">
            <button
              onClick={downloadFile}
              className="p-2 rounded-full text-gray-500 hover:text-accent-600 hover:bg-accent-100 transition-all duration-200"
              title="Download file"
            >
              <Download className="h-5 w-5" />
            </button>
            
            <button
              onClick={onClose}
              className="p-2 rounded-full text-gray-500 hover:text-gray-700 hover:bg-gray-100 transition-all duration-200"
              title="Close preview"
            >
              <X className="h-5 w-5" />
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-hidden">
          {loading && (
            <div className="flex items-center justify-center py-16">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
              <span className="ml-4 text-gray-600 font-medium">Loading Excel file...</span>
            </div>
          )}

          {error && (
            <div className="flex items-center justify-center py-16">
              <div className="text-center">
                <AlertCircle className="h-12 w-12 text-red-500 mx-auto mb-4" />
                <h4 className="text-lg font-medium text-gray-900 mb-2">Failed to load Excel file</h4>
                <p className="text-gray-500 mb-4">{error}</p>
                <button
                  onClick={downloadFile}
                  className="px-4 py-2 bg-primary-600 text-white rounded-md hover:bg-primary-700 transition-colors"
                >
                  Download File Instead
                </button>
              </div>
            </div>
          )}

          {!loading && !error && worksheets.length > 0 && (
            <>
              {/* Sheet Tabs */}
              {worksheets.length > 1 && (
                <div className="border-b border-gray-200 px-4">
                  <div className="flex space-x-1 overflow-x-auto">
                    {worksheets.map((sheet, index) => (
                      <button
                        key={index}
                        onClick={() => setActiveSheet(index)}
                        className={`px-4 py-2 text-sm font-medium whitespace-nowrap border-b-2 ${
                          activeSheet === index
                            ? 'border-primary-600 text-primary-600'
                            : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                        }`}
                      >
                        {sheet.name}
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {/* Sheet Content */}
              <div className="flex-1 p-4">
                {worksheets[activeSheet] && renderTable(worksheets[activeSheet].data)}
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default ExcelPreview;