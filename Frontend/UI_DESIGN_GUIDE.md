# UI Design Guide - Prikriti File Manager

## Design Philosophy
Modern, clean Google Drive / React web inspired interface with emphasis on:
- **Clarity**: Clear hierarchy and information structure
- **Efficiency**: Quick access to essential actions
- **Visual Appeal**: Polished, professional appearance
- **Consistency**: Unified design language across all components

---

## Color Palette

### Primary Colors (Google Material)
- **Blue (Primary)**: `#1A73E8` - Main actions, links
- **Green (Success)**: `#34A853` - Upload success, confirmations
- **Yellow (Warning)**: `#FBBC04` - Duplicates, warnings
- **Red (Error)**: `#EA4335` - Errors, failures

### Neutral Colors
- **Background**: `#F8F9FA` - Main app background
- **Surface**: `#FFFFFF` - Card/container backgrounds
- **Text Primary**: `#202124` - Main text
- **Text Secondary**: `#5F6368` - Supporting text
- **Border**: `#E8EAED` - Dividers and borders
- **Border Dark**: `#DADCE0` - Button borders
- **Hover**: `#F1F3F4` - Interactive element hover states

---

## Typography

### Font Weights
- **Regular**: 400
- **Medium**: 500
- **SemiBold**: 600
- **Bold**: 700

### Text Styles
- **App Title**: 18px, SemiBold (600), #202124
- **Subtitle**: 11px, Regular (400), #5F6368, letter-spacing: 0.3
- **Section Title**: 14px, SemiBold (600), #202124, letter-spacing: 0.3
- **Body Text**: 14px, Regular (400), #5F6368, letter-spacing: 0.3
- **Card Title**: 13px, Medium (500), #5F6368, letter-spacing: 0.3
- **Card Value**: 32px, Bold (700), #202124, letter-spacing: -0.5
- **Button Text**: 14px, SemiBold (600), letter-spacing: 0.5

---

## Component Specifications

### 1. Summary Cards
**Location**: Dashboard horizontal scroll section

**Design**:
- White background (#FFFFFF)
- 16px border radius
- 1px border (#E8EAED)
- Subtle shadow: `rgba(0,0,0,0.04)` with 8px blur and 2px offset
- 20px padding
- 160px width × 140px height

**Layout**:
```
┌────────────────────┐
│ [Icon in colored   │
│  rounded box]      │
│                    │
│ 32                 │ (Large value)
│ Total Files        │ (Small label)
└────────────────────┘
```

**Icon Container**:
- 48×48px size
- 12px border radius
- Color with 10% opacity background
- 24px icon size

---

### 2. File List Item
**Location**: Main file list

**Design**:
- White background (default)
- Hover: `#F1F3F4` background
- 150ms transition animation
- 16px vertical padding, 20px horizontal padding

**Layout**:
```
┌──────────────────────────────────────────────────────────┐
│ [Icon] File Name.ext    1.2 MB    [Status] [✏️] [🗑️]    │
│                        2024-01-15                        │
│        Error: Duplicate detected (if applicable)         │
└──────────────────────────────────────────────────────────┘
```

**File Type Icons**:
- Images (jpg, png, gif, svg): Red (#EA4335)
- PDFs: Red (#EA4335)
- Documents (doc, docx, txt): Blue (#1A73E8)
- Spreadsheets (xls, xlsx, csv): Green (#34A853)
- Presentations (ppt, pptx): Yellow (#FBBC04)
- Archives (zip, rar, 7z): Purple (#9334E6)
- Audio/Video (mp3, mp4, avi): Pink (#D81B60)
- Default: Gray (#5F6368)

**Icon Container**: 40×40px with 8px border radius, color with 10% opacity

**Status Badges**:
- Pill shape (12px border radius)
- Color with 10% opacity background
- 8px horizontal, 4px vertical padding
- Icon + text combination

**Error Messages**:
- Duplicates: Yellow background (#FEF7E0)
- Failed: Red background (#FCE8E6)
- 12px padding, 8px border radius

---

### 3. App Bar
**Design**:
- White background
- No elevation (flat)
- Logo icon in colored container (40×40px, 8px radius)
- Title + subtitle layout

---

### 4. Folder Selection Card
**Design**:
- Light gray background (#F8F9FA)
- 1px border (#E8EAED)
- 12px border radius
- 20px padding

**Layout**:
```
┌────────────────────────────────────────────────────┐
│ [Icon] Selected Folder             [Browse Button] │
│        /path/to/folder                             │
└────────────────────────────────────────────────────┘
```

---

### 5. Buttons

#### Primary Button (Upload)
- Background: `#34A853` (Green)
- Foreground: White
- No elevation
- 8px border radius
- 32px horizontal, 16px vertical padding
- Icon + Text
- Hover: Slightly darker shade

#### Secondary Button (Clear All)
- Border: 1px `#DADCE0`
- Foreground: `#5F6368`
- Background: Transparent
- 8px border radius
- 24px horizontal, 16px vertical padding
- Icon + Text

#### Icon Button
- Foreground: `#5F6368`
- No background
- Hover: Light gray circular background

---

### 6. Dialogs

#### Confirmation Dialog
```
┌──────────────────────────────┐
│ [Icon] Confirm Upload        │
│                              │
│ Upload 5 file(s) to server?  │
│ This action will process...  │
│                              │
│          [Cancel] [Upload]   │
└──────────────────────────────┘
```

#### Results Dialog
```
┌──────────────────────────────┐
│ [✓] Upload Complete          │
│                              │
│ Files processed successfully │
│                              │
│ ┌──────────────────────────┐ │
│ │ [Icon] Total      5      │ │
│ │ [Icon] Uploaded   3      │ │
│ │ [Icon] Failed     1      │ │
│ │ [Icon] Duplicates 1      │ │
│ │ [Icon] Pending    0      │ │
│ └──────────────────────────┘ │
│                              │
│                   [Got it]   │
└──────────────────────────────┘
```

**Summary Row**:
- Colored background (8% opacity)
- Colored border (20% opacity)
- 12px padding
- 8px border radius
- Icon in small colored container (32×32px)

---

### 7. Empty State
**Design**:
- Large circular icon container (120×120px)
- Light gray background (#F1F3F4)
- Icon: 64px, color: #BDC1C6
- Title: 18px, SemiBold (600), #202124
- Description: 13px, Regular (400), #5F6368

---

### 8. Loading State
**Design**:
- Centered spinner (48×48px)
- Blue color (#1A73E8)
- 3px stroke width
- "Loading files..." text below

---

### 9. Error Banner
**Design**:
- Background: `#FCE8E6` (light red)
- Border: 1px `#EA4335`
- 16px padding
- 8px border radius
- Icon (20px) + text layout

---

## Spacing System

- **Extra Small**: 4px
- **Small**: 8px
- **Medium**: 12px
- **Base**: 16px
- **Large**: 20px
- **Extra Large**: 24px
- **XXL**: 32px

---

## Elevation & Shadows

### Card Shadow
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.04),
  blurRadius: 8,
  offset: Offset(0, 2),
)
```

### Dialog Shadow
Built-in Material dialog elevation

---

## Animations

### Hover Transitions
- Duration: 150ms
- Properties: background color, opacity
- Curve: Default (ease)

### Button Press
- Material ripple effect (default)

---

## Responsive Behavior

### Summary Cards
- Horizontal scrollable list
- Fixed width (160px per card)
- 12px spacing between cards

### File List
- Full width container with max constraints
- Responsive padding (24px on desktop)
- Scrollable when content exceeds viewport

### Bottom Action Bar
- Sticks to bottom
- Full width with internal padding
- Buttons scale based on content

---

## Icon Usage

### Rounded Icons (Material Rounded)
All icons use the rounded variant for a softer, modern appearance:
- `Icons.folder_open_rounded`
- `Icons.cloud_upload_rounded`
- `Icons.check_circle_rounded`
- `Icons.error_rounded`
- `Icons.content_copy_rounded`
- `Icons.schedule_rounded`
- `Icons.clear_all_rounded`

### Icon Sizes
- App bar icon: 24px
- Summary card icon: 24px
- File type icon: 24px
- Action button icon: 20px
- Dialog title icon: 24px
- Summary row icon: 18px

---

## Accessibility

- All interactive elements have minimum 44×44px touch target
- Color contrast ratios meet WCAG AA standards
- Icons accompanied by text labels
- Error messages clearly visible and readable
- Loading states announced to screen readers

---

## Best Practices

1. **Consistency**: Use defined color palette and spacing system
2. **Clarity**: Maintain clear visual hierarchy
3. **Feedback**: Provide immediate visual feedback for user actions
4. **Performance**: Use const constructors and avoid unnecessary rebuilds
5. **Accessibility**: Ensure all UI elements are accessible

---

## Implementation Notes

### Material 3
The app uses Material Design 3 with custom theming:
```dart
useMaterial3: true
```

### Theme Configuration
All colors and text styles defined in `main.dart` theme configuration.

### Component Structure
- Widgets are modular and reusable
- State management via Provider
- Clean separation of concerns

---

**Version**: 1.0  
**Last Updated**: January 2025  
**Design System**: Google Material Design 3
