import 'package:flutter/material.dart';
import '../../../data/models/vendor_model.dart';
import '../app_colors.dart';

class VendorStatusBadge extends StatelessWidget {
  final VendorStatus status;

  const VendorStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    if (status == VendorStatus.hired) {
      color = AppColors.green;
      text = "Contratado";
    } else {
      color = AppColors.textGrey;
      text = "Pendente";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)
          ),
          const SizedBox(width: 6),
          Text(
              text,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
              )
          ),
        ],
      ),
    );
  }
}