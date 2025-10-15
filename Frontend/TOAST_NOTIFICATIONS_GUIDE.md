# Enhanced Toast Notifications Guide

## Overview
The Prikriti File Manager now features modern, attractive toast notifications with improved typography, status-dependent styling, and strategic positioning.

---

## 🎨 Design Features

### **1. Visual Enhancements**
- **Lightweight backgrounds** - Soft, pastel colors for better readability
- **Status-dependent borders** - Colored borders (1.5px) matching the notification type
- **Elegant shadows** - Dual-layer shadows for depth
- **Modern typography** - 14px font with 0.2 letter-spacing and 1.4 line-height
- **Refined icons** - Clean, simple symbols for each notification type

### **2. Position & Behavior**
- **Bottom-Right placement** - All toasts appear in the bottom-right corner
- **Auto-dismiss** - Toasts automatically close after specified duration
- **Close button** (Web) - Manual dismiss option with close icon
- **Non-intrusive** - Doesn't block main content

---

## 📋 Notification Types

### **Success** ✓
```dart
ToastHelper.showSuccess('File uploaded successfully');
```
- **Icon**: ✓ (Checkmark)
- **Background**: Light Green (#E8F5E9)
- **Text**: Dark Green (#1B5E20)
- **Border**: Green (#4CAF50)
- **Use**: Successful operations, confirmations

### **Error** ✕
```dart
ToastHelper.showError('Upload failed');
```
- **Icon**: ✕ (Cross)
- **Background**: Light Red (#FFEBEE)
- **Text**: Dark Red (#C62828)
- **Border**: Red (#EF5350)
- **Use**: Failed operations, critical errors

### **Warning** ⚠
```dart
ToastHelper.showWarning('Large file detected');
```
- **Icon**: ⚠ (Warning triangle)
- **Background**: Light Orange (#FFF3E0)
- **Text**: Dark Orange (#E65100)
- **Border**: Orange (#FF9800)
- **Use**: Warnings, alerts, cautions

### **Info** ⓘ
```dart
ToastHelper.showInfo('Processing files...');
```
- **Icon**: ⓘ (Info circle)
- **Background**: Light Blue (#E3F2FD)
- **Text**: Dark Blue (#0D47A1)
- **Border**: Blue (#2196F3)
- **Use**: Informational messages, tips

### **Duplicate** ◉
```dart
ToastHelper.showDuplicate('Duplicate file detected');
```
- **Icon**: ◉ (Filled circle)
- **Background**: Light Yellow (#FFFDE7)
- **Text**: Dark Yellow (#F57F17)
- **Border**: Amber (#FFC107)
- **Use**: Duplicate detection, conflicts

---

## 🔧 Specialized Notifications

### **Upload Success**
```dart
ToastHelper.showUploadSuccess(5); // 5 files
```
**Message**: "✓  5 files uploaded successfully"
- Uses success theme
- Automatic pluralization

### **File Removed**
```dart
ToastHelper.showFileRemoved('document.pdf');
```
**Message**: "✓  Removed: document.pdf"
- **Background**: Light Purple (#F3E5F5)
- **Text**: Dark Purple (#4A148C)
- **Border**: Purple
- **Duration**: 2 seconds

### **File Renamed**
```dart
ToastHelper.showFileRenamed('old.pdf', 'new.pdf');
```
**Message**: "✓  Renamed to: new.pdf"
- **Background**: Light Cyan (#E1F5FE)
- **Text**: Dark Cyan (#01579B)
- **Border**: Cyan
- **Duration**: 2 seconds

### **Upload Summary**
```dart
ToastHelper.showUploadSummary(
  done: 3,
  failed: 1,
  duplicate: 1,
);
```
**Message**: "✓ 3 uploaded  •  ✕ 1 failed  •  ◉ 1 duplicates"
- **Smart theming**: 
  - Green if all successful
  - Yellow if duplicates but no failures
  - Red if any failures
- **Duration**: 5 seconds

---

## 🎯 Custom Toast

Create custom notifications with specific styling:

```dart
ToastHelper.showCustom(
  message: 'Custom notification',
  backgroundColor: const Color(0xFFE8EAF6),
  textColor: const Color(0xFF3F51B5),
  icon: '🎉',
  durationSeconds: 4,
);
```

**Parameters**:
- `message` - The notification text
- `backgroundColor` - Lightweight background color
- `textColor` - Text color (should contrast with background)
- `icon` - Optional emoji or symbol prefix
- `durationSeconds` - Display duration (default: 3)

---

## 💅 Custom Toast Widget (Advanced)

For more control, use the `CustomToast` widget:

```dart
import '../widgets/custom_toast.dart';

// Success toast
CustomToast.success(
  'Operation completed',
  onClose: () => print('Toast closed'),
);

// Error toast
CustomToast.error('Something went wrong');

// Warning toast
CustomToast.warning('Proceed with caution');

// Info toast
CustomToast.info('Did you know?');

// Duplicate toast
CustomToast.duplicate('File already exists');
```

**Widget Features**:
- ✓ Rounded borders (8px radius)
- ✓ Dual-layer box shadows
- ✓ Icon in colored circle badge
- ✓ Close button (optional)
- ✓ Flexible width (300-400px)
- ✓ Responsive text wrapping

---

## 🎨 Color Palette Reference

| Type | Background | Text | Border |
|------|-----------|------|--------|
| Success | #E8F5E9 | #1B5E20 | #4CAF50 |
| Error | #FFEBEE | #C62828 | #EF5350 |
| Warning | #FFF3E0 | #E65100 | #FF9800 |
| Info | #E3F2FD | #0D47A1 | #2196F3 |
| Duplicate | #FFFDE7 | #F57F17 | #FFC107 |
| File Removed | #F3E5F5 | #4A148C | Purple |
| File Renamed | #E1F5FE | #01579B | Cyan |

---

## 📐 Typography Specifications

- **Font Size**: 14px
- **Font Weight**: 500 (Medium)
- **Letter Spacing**: 0.2px
- **Line Height**: 1.4
- **Icon Size**: 14px (in circle badge)
- **Circle Badge**: 24px diameter

---

## 🌐 Web-Specific Features

On web platform, toasts include:
- ✓ Close button (X icon)
- ✓ Enhanced shadows for better depth
- ✓ Smooth animations
- ✓ Bottom-right positioning
- ✓ Non-blocking overlay

---

## 📱 Mobile-Specific Features

On mobile platforms:
- ✓ Bottom-right gravity
- ✓ Automatic dismiss
- ✓ Appropriate duration timing
- ✓ Optimized touch targets

---

## ⚙️ Duration Guidelines

| Duration | Use Case |
|----------|----------|
| 2 seconds | Quick actions (remove, rename) |
| 3 seconds | Standard notifications (success, info, warning) |
| 4 seconds | Important messages (errors, duplicates) |
| 5 seconds | Summary/detailed information |

---

## 🚀 Usage Examples

### File Upload Flow
```dart
// Start upload
ToastHelper.showInfo('Starting upload...');

// Success
ToastHelper.showUploadSuccess(5);

// Or with details
ToastHelper.showUploadSummary(
  done: 4,
  failed: 1,
  duplicate: 0,
);
```

### File Management
```dart
// Rename
ToastHelper.showFileRenamed('old.pdf', 'new.pdf');

// Remove
ToastHelper.showFileRemoved('document.pdf');

// Duplicate detected
ToastHelper.showDuplicate('File already exists');
```

### Error Handling
```dart
try {
  await uploadFile();
  ToastHelper.showSuccess('File uploaded');
} catch (e) {
  ToastHelper.showError('Upload failed: ${e.message}');
}
```

---

## 🎯 Best Practices

1. **Be Concise**: Keep messages short and clear (< 60 characters)
2. **Use Appropriate Type**: Match notification type to action result
3. **Avoid Spam**: Don't show multiple toasts rapidly
4. **Provide Context**: Include relevant details (file names, counts)
5. **Test Readability**: Ensure text contrasts well with background
6. **Consider Timing**: Use appropriate duration for message importance

---

## 🔄 Migration from Old Toasts

### Old (Pre-Enhancement)
```dart
Fluttertoast.showToast(
  msg: "Success",
  backgroundColor: Colors.green,
  textColor: Colors.white,
);
```

### New (Enhanced)
```dart
ToastHelper.showSuccess('Success');
```

**Benefits**:
- ✓ Consistent styling across app
- ✓ Better typography and spacing
- ✓ Status-dependent borders
- ✓ Lightweight backgrounds
- ✓ Bottom-right positioning
- ✓ Reduced code duplication

---

## 🐛 Troubleshooting

### Toast Not Appearing
- Ensure `fluttertoast` package is installed
- Check that context is mounted when calling
- Verify no other overlays are blocking

### Wrong Position on Web
- Confirmed `webPosition: "right"` in all methods
- Check browser console for errors

### Colors Not Matching
- Use exact hex codes from color palette
- Ensure Material theme is not overriding

---

## 📦 Dependencies

```yaml
dependencies:
  fluttertoast: ^8.2.4
```

---

**Version**: 2.0  
**Last Updated**: October 2025  
**Design System**: Material Design 3 with Custom Enhancement
