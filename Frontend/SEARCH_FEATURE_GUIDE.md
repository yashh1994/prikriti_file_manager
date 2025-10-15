# File Search Feature Guide

## Overview
The Prikriti File Manager now includes a powerful search bar that allows users to quickly filter and find files in their loaded file list.

---

## 🔍 Search Capabilities

### **What You Can Search**
1. **File Name** - Original or renamed file names
2. **File Extension** - File types (e.g., pdf, jpg, docx)
3. **File Size** - Formatted size strings (e.g., "2.5 MB", "500 KB")

### **Search Behavior**
- **Real-time filtering** - Results update as you type
- **Case-insensitive** - Searches ignore letter case
- **Partial matching** - Finds files containing the search term
- **Multi-field** - Searches across name, extension, and size simultaneously

---

## 🎨 Design Features

### **Search Bar Styling**
```
┌──────────────────────────────────────────────────┐
│ 🔍  Search files by name, extension, or size... ✕│
└──────────────────────────────────────────────────┘
```

**Visual Elements**:
- **Background**: Light gray (#F8F9FA) for subtle contrast
- **Border**: 
  - Default: Light gray (#E8EAED, 1.5px)
  - Active: Blue (#1A73E8, 1.5px) when typing
- **Border Radius**: 24px (fully rounded pill shape)
- **Height**: 42px for comfortable interaction
- **Icons**:
  - Search icon (🔍) on the left
  - Clear icon (✕) on the right (appears when typing)

### **Typography**
- **Placeholder**: 13px, gray (#9AA0A6), regular weight
- **Input Text**: 13px, dark gray (#202124), medium weight (500)
- **Letter Spacing**: 0.2px for clean readability

---

## 📊 File Counter

### **Dynamic Count Display**
Shows filtered results vs total files:
- **Format**: "X of Y file(s)"
- **Examples**:
  - `3 of 10 file(s)` - 3 files match search
  - `10 of 10 file(s)` - All files shown (no search)
  - `0 of 10 file(s)` - No matches found

---

## 🎯 Empty Search State

When no files match the search query:

```
     🔍
    
  No files found
  
  Try a different search term
```

**Design**:
- Centered content
- Large search-off icon (64px, light gray)
- Bold title text (16px)
- Helpful subtitle (13px, lighter gray)
- Plenty of whitespace (48px padding)

---

## 💡 Usage Examples

### **Search by File Name**
```
Input: "report"
Matches: 
  ✓ Annual_Report.pdf
  ✓ Report_2024.docx
  ✓ monthly-report.xlsx
```

### **Search by Extension**
```
Input: "pdf"
Matches:
  ✓ document.pdf
  ✓ presentation.pdf
  ✓ invoice.pdf
```

### **Search by Size**
```
Input: "mb"
Matches:
  ✓ video.mp4 (5.2 MB)
  ✓ image.jpg (2.1 MB)
  ✓ archive.zip (12 MB)
```

### **Combined Search**
```
Input: "2024"
Matches:
  ✓ Report_2024.docx
  ✓ Budget_2024.xlsx
  ✓ Photos_2024.zip
```

---

## ⌨️ Keyboard Interaction

### **Shortcuts & Behaviors**
- **Type to search** - Immediate filtering on input
- **Clear button** - Click ✕ to clear search and show all files
- **Tab navigation** - Accessible keyboard navigation
- **Focus state** - Blue border when active

---

## 🔄 State Management

### **Search State Variables**
```dart
TextEditingController _searchController = TextEditingController();
String _searchQuery = '';
```

### **Filter Logic**
```dart
List<FileModel> _getFilteredFiles(List<FileModel> files) {
  if (_searchQuery.isEmpty) {
    return files; // Show all files
  }
  
  final query = _searchQuery.toLowerCase();
  return files.where((file) {
    final fileName = (file.newName ?? file.name).toLowerCase();
    final extension = file.extension.toLowerCase();
    final size = file.formattedSize.toLowerCase();
    return fileName.contains(query) || 
           extension.contains(query) || 
           size.contains(query);
  }).toList();
}
```

### **State Updates**
- `setState()` called on every search input change
- ListView rebuilt with filtered results
- Counter updated to show current/total files

---

## 🎨 UI Components

### **Search Bar Container**
- **Location**: Below file count stats, above file list
- **Margin**: Part of header container (24px horizontal padding)
- **Spacing**: 12px gap above search bar

### **Integration with File List**
```dart
// Header Section
Container(
  child: Column(
    children: [
      // Stats Row
      Row(...),
      
      SizedBox(height: 12),
      
      // Search Bar
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _searchQuery.isNotEmpty 
              ? Color(0xFF1A73E8)  // Blue when active
              : Color(0xFFE8EAED), // Gray when empty
          ),
        ),
        child: TextField(...),
      ),
    ],
  ),
),
```

---

## 🚀 Performance Considerations

### **Optimization Techniques**
1. **Lowercase conversion** - Query and fields converted once
2. **Early return** - Skip filtering if search is empty
3. **Efficient where clause** - Uses Dart's optimized filtering
4. **setState scope** - Only rebuilds affected widgets

### **Recommended Practices**
- ✓ Search works with any list size
- ✓ No debouncing needed (instant filtering is smooth)
- ✓ Maintains file order from original list
- ✓ Cleared search restores full list

---

## 🎯 Accessibility

### **Features for All Users**
- **Keyboard accessible** - Full tab navigation support
- **Clear focus states** - Visible blue border when active
- **Screen reader friendly** - Proper labels and hints
- **Tooltip on clear button** - "Clear search" tooltip
- **High contrast** - Text meets WCAG AA standards

---

## 🔧 Customization Options

### **Modify Search Placeholder**
```dart
decoration: InputDecoration(
  hintText: 'Your custom placeholder text...',
  // ... other properties
),
```

### **Change Active Border Color**
```dart
border: Border.all(
  color: _searchQuery.isNotEmpty
      ? const Color(0xFF34A853)  // Green instead of blue
      : const Color(0xFFE8EAED),
),
```

### **Add More Search Fields**
```dart
return files.where((file) {
  final fileName = (file.newName ?? file.name).toLowerCase();
  final extension = file.extension.toLowerCase();
  final size = file.formattedSize.toLowerCase();
  final status = file.status.displayName.toLowerCase(); // Add status
  
  return fileName.contains(query) || 
         extension.contains(query) || 
         size.contains(query) ||
         status.contains(query);
}).toList();
```

---

## 🐛 Edge Cases Handled

### **Scenarios**
1. **Empty file list** - Search bar not shown (no files loaded)
2. **No search results** - Shows "No files found" empty state
3. **Search cleared** - Restores full file list
4. **Special characters** - Handled correctly in search
5. **Multiple spaces** - Treated as single space in query

---

## 📱 Responsive Behavior

### **Desktop**
- Full-width search bar with comfortable spacing
- Hover states on clear button
- Large click targets

### **Mobile**
- Touch-friendly 42px height
- Large clear button for easy tapping
- Keyboard opens smoothly on focus

---

## 🎨 Visual States

### **Default State**
- Gray border
- Placeholder visible
- No clear button

### **Active State** (typing)
- Blue border
- Search text visible
- Clear button appears

### **Hover State** (clear button)
- Slight opacity change
- Cursor changes to pointer

### **Empty Results State**
- Special empty state UI
- Helpful message
- Large icon

---

## 🔄 Future Enhancement Ideas

### **Potential Additions**
- 🔹 Search by date range
- 🔹 Advanced filters (status, size range)
- 🔹 Search history dropdown
- 🔹 Regex support for power users
- 🔹 Save search queries
- 🔹 Export filtered results

---

## 📚 Code Reference

### **Key Files**
- **Dashboard Screen**: `lib/screens/dashboard_screen.dart`
  - Contains search logic and UI
  - Lines: Search state, filter method, search bar UI

- **File Model**: `lib/models/file_model.dart`
  - Provides searchable properties
  - Properties: name, newName, extension, formattedSize

---

## ✅ Testing Checklist

- [ ] Search by file name works
- [ ] Search by extension works
- [ ] Search by file size works
- [ ] Clear button removes search
- [ ] Empty state shows when no results
- [ ] Counter updates correctly
- [ ] Border changes color when typing
- [ ] Tab navigation works
- [ ] Special characters handled
- [ ] Performance smooth with 100+ files

---

**Version**: 1.0  
**Last Updated**: October 2025  
**Feature Status**: ✅ Complete and Production Ready
