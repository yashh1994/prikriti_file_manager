import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Enhanced Toast Helper Utility
/// Provides modern, attractive toast notifications with status-dependent styling
class ToastHelper {
  // Private constructor to prevent instantiation
  ToastHelper._();

  /// Show success toast (green theme)
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: "✓  $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFE8F5E9), // Light green
      textColor: const Color(0xFF1B5E20), // Dark green text
      fontSize: 14.0,
      webBgColor: "#E8F5E9",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show error toast (red theme)
  static void showError(String message) {
    Fluttertoast.showToast(
      msg: "✕  $message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 4,
      backgroundColor: const Color(0xFFFFEBEE), // Light red
      textColor: const Color(0xFFC62828), // Dark red text
      fontSize: 14.0,
      webBgColor: "#FFEBEE",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show warning toast (orange/amber theme)
  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: "⚠  $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFFFF3E0), // Light orange
      textColor: const Color(0xFFE65100), // Dark orange text
      fontSize: 14.0,
      webBgColor: "#FFF3E0",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show info toast (blue theme)
  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: "ⓘ  $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFE3F2FD), // Light blue
      textColor: const Color(0xFF0D47A1), // Dark blue text
      fontSize: 14.0,
      webBgColor: "#E3F2FD",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show duplicate toast (yellow theme)
  static void showDuplicate(String message) {
    Fluttertoast.showToast(
      msg: "◉  $message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 4,
      backgroundColor: const Color(0xFFFFFDE7), // Light yellow
      textColor: const Color(0xFFF57F17), // Dark yellow text
      fontSize: 14.0,
      webBgColor: "#FFFDE7",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show upload success with count
  static void showUploadSuccess(int count) {
    Fluttertoast.showToast(
      msg: "✓  ${count > 1 ? '$count files' : '1 file'} uploaded successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFE8F5E9), // Light green
      textColor: const Color(0xFF1B5E20), // Dark green text
      fontSize: 14.0,
      webBgColor: "#E8F5E9",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show file removed notification
  static void showFileRemoved(String fileName) {
    Fluttertoast.showToast(
      msg: "✓  Removed: $fileName",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFFF3E5F5), // Light purple
      textColor: const Color(0xFF4A148C), // Dark purple text
      fontSize: 14.0,
      webBgColor: "#F3E5F5",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show file renamed notification
  static void showFileRenamed(String oldName, String newName) {
    Fluttertoast.showToast(
      msg: "✓  Renamed to: $newName",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFFE1F5FE), // Light cyan
      textColor: const Color(0xFF01579B), // Dark cyan text
      fontSize: 14.0,
      webBgColor: "#E1F5FE",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show upload summary with detailed breakdown
  static void showUploadSummary({
    required int done,
    required int failed,
    required int duplicate,
  }) {
    String message = "";
    Color bgColor;
    Color textColor;

    // Build message with emoji indicators
    if (done > 0) message += "✓ $done uploaded";
    if (failed > 0) {
      if (message.isNotEmpty) message += "  •  ";
      message += "✕ $failed failed";
    }
    if (duplicate > 0) {
      if (message.isNotEmpty) message += "  •  ";
      message += "◉ $duplicate duplicates";
    }

    // Determine color based on results
    if (failed > 0) {
      // Red theme if any failures
      bgColor = const Color(0xFFFFEBEE);
      textColor = const Color(0xFFC62828);
    } else if (duplicate > 0) {
      // Yellow theme if duplicates but no failures
      bgColor = const Color(0xFFFFFDE7);
      textColor = const Color(0xFFF57F17);
    } else {
      // Green theme if all successful
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF1B5E20);
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 5,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 14.0,
      webBgColor: "#${bgColor.value.toRadixString(16).substring(2)}",
      webPosition: "right",
      webShowClose: true,
    );
  }

  /// Show custom toast with specific styling
  static void showCustom({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    String? icon,
    int durationSeconds = 3,
  }) {
    Fluttertoast.showToast(
      msg: icon != null ? "$icon  $message" : message,
      toastLength: durationSeconds > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: durationSeconds,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 14.0,
      webBgColor: "#${backgroundColor.value.toRadixString(16).substring(2)}",
      webPosition: "right",
      webShowClose: true,
    );
  }
}
