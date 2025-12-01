import 'package:flutter/material.dart';
import '../app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? prefixText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.label,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.prefixText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty) ...[
          Text(
            label!,
            style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixText: prefixText,
            prefixStyle: const TextStyle(color: AppColors.textDark, fontSize: 16),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.guestIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
