# File Manager - React Frontend

A modern React web application for browsing, searching, and managing uploaded files with pagination and file preview capabilities.

## Features

- **📋 File Listing**: Display all files with metadata in a clean, organized format
- **🔍 Search**: Real-time search by filename or file extension
- **📄 Pagination**: Navigate through files with 10 items per page
- **👁️ Preview**: Preview supported files (images, PDFs, text) in browser
- **📥 Download**: Direct download for any file
- **📊 File Info**: Show file size, type, and modification date
- **🎨 Modern UI**: Built with Tailwind CSS for responsive design

## Tech Stack

- **React 18.2.0** - Modern React with hooks
- **TypeScript** - Type-safe development
- **Vite** - Fast build tool and dev server
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client for API calls
- **Lucide React** - Beautiful icons

## Prerequisites

- Node.js 16+ and npm
- Backend server running on `http://localhost:3001`

## Installation

1. Navigate to the website directory:
```bash
cd "Frontend/website"
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

4. Open your browser to `http://localhost:5173`

## Project Structure

```
src/
├── components/          # React components
│   ├── SearchBar.tsx   # Search input component
│   ├── FileList.tsx    # File display component
│   └── Pagination.tsx  # Page navigation component
├── services/           # API integration
│   └── fileService.ts  # File operations service
├── App.tsx            # Main application component
├── main.tsx           # React entry point
└── index.css          # Global styles and Tailwind imports
```

## API Integration

The frontend connects to the backend API with these endpoints:

- `GET /api/file-metadata/list` - Get all files metadata
- `GET /api/file-metadata/download/:filename` - Download file
- `GET /api/file-metadata/stream/:filename` - Stream/preview file

## Component Overview

### SearchBar
- Real-time search functionality
- Filters by filename and extension
- Uses Lucide Search icon

### FileList
- Displays files in a clean table format
- Shows file icons, names, sizes, dates
- Preview and download buttons for each file
- Loading and empty states

### Pagination
- Shows page numbers with Previous/Next buttons
- Smart page number display (shows ... for large page counts)
- Responsive design for mobile devices

### App (Main Component)
- Manages application state
- Handles API calls and error states
- Coordinates all child components
- Implements search filtering and pagination logic

## Features in Detail

### File Preview
Supported file types for in-browser preview:
- Images: jpg, jpeg, png, gif, webp, svg
- Documents: pdf, txt, md
- Code: js, ts, css, html, json, xml

### Search Functionality
- Case-insensitive search
- Searches both filename and file extension
- Instant results with automatic page reset
- Clear search button for easy reset

### Responsive Design
- Mobile-first design approach
- Touch-friendly buttons and interactions
- Responsive file list layout
- Optimized for tablets and desktops

## Development Scripts

```bash
npm run dev      # Start development server
npm run build    # Build for production
npm run preview  # Preview production build
npm run lint     # Run ESLint
```

## Configuration

### Vite Configuration
- Proxy setup for backend API calls
- Development server on port 5173
- Hot module replacement enabled

### Tailwind Configuration
- Custom color scheme with primary colors
- Responsive breakpoints
- Custom component utilities

## Browser Support

- Modern browsers (Chrome 90+, Firefox 88+, Safari 14+)
- Mobile browsers (iOS Safari, Chrome Mobile)
- Progressive enhancement for older browsers

## Performance Optimizations

- Lazy loading of file icons
- Efficient pagination with slicing
- Debounced search (can be added)
- Optimized bundle size with Vite

## Troubleshooting

### Common Issues

1. **Backend connection fails**
   - Ensure backend is running on port 3001
   - Check CORS configuration
   - Verify API endpoints are accessible

2. **Files not displaying**
   - Check backend file upload directory
   - Verify API response format
   - Check browser console for errors

3. **Styling issues**
   - Ensure Tailwind CSS is properly configured
   - Check if PostCSS is processing styles
   - Verify all CSS classes are valid

### Development Tips

- Use React Developer Tools for debugging
- Check Network tab for API call issues
- Use TypeScript errors to catch issues early
- Test responsive design with browser dev tools

## Future Enhancements

- File upload functionality
- Bulk file operations
- File organization with folders
- Advanced search filters
- File sharing capabilities
- Dark mode support
- Keyboard shortcuts
- Drag and drop interface

## License

Part of the Prikriti File Manager system.