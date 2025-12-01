import 'package:flutter/material.dart';
import '../app_colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isFullWidth;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? labelColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.isFullWidth = false,
    this.backgroundColor,
    this.textColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),

        border: backgroundColor == null
            ? Border.all(color: Colors.grey[200]!)
            : null,

        boxShadow: backgroundColor == null
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor ?? AppColors.textDark,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textColor ?? AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );


    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: content);
    }

    return content;
  }
}