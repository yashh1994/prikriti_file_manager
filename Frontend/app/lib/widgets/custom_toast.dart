import 'package:flutter/material.dart';

/// Custom Toast Widget with Enhanced Styling
/// Provides modern toast notifications with borders and shadows
class CustomToast extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final IconData? icon;
  final VoidCallback? onClose;

  const CustomToast({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.icon,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: borderColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: borderColor),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                height: 1.4,
              ),
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 12),
            InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: textColor.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Success toast configuration
  static Widget success(String message, {VoidCallback? onClose}) {
    return CustomToast(
      message: message,
      backgroundColor: const Color(0xFFE8F5E9),
      textColor: const Color(0xFF1B5E20),
      borderColor: const Color(0xFF4CAF50),
      icon: Icons.check_circle_rounded,
      onClose: onClose,
    );
  }

  /// Error toast configuration
  static Widget error(String message, {VoidCallback? onClose}) {
    return CustomToast(
      message: message,
      backgroundColor: const Color(0xFFFFEBEE),
      textColor: const Color(0xFFC62828),
      borderColor: const Color(0xFFEF5350),
      icon: Icons.error_rounded,
      onClose: onClose,
    );
  }

  /// Warning toast configuration
  static Widget warning(String message, {VoidCallback? onClose}) {
    return CustomToast(
      message: message,
      backgroundColor: const Color(0xFFFFF3E0),
      textColor: const Color(0xFFE65100),
      borderColor: const Color(0xFFFF9800),
      icon: Icons.warning_rounded,
      onClose: onClose,
    );
  }

  /// Info toast configuration
  static Widget info(String message, {VoidCallback? onClose}) {
    return CustomToast(
      message: message,
      backgroundColor: const Color(0xFFE3F2FD),
      textColor: const Color(0xFF0D47A1),
      borderColor: const Color(0xFF2196F3),
      icon: Icons.info_rounded,
      onClose: onClose,
    );
  }

  /// Duplicate toast configuration
  static Widget duplicate(String message, {VoidCallback? onClose}) {
    return CustomToast(
      message: message,
      backgroundColor: const Color(0xFFFFFDE7),
      textColor: const Color(0xFFF57F17),
      borderColor: const Color(0xFFFFC107),
      icon: Icons.content_copy_rounded,
      onClose: onClose,
    );
  }
}
