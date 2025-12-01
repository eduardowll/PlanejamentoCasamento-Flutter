import 'package:flutter/material.dart';
import 'package:planejamento_casamento/data/models/vendor_model.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';
import 'package:planejamento_casamento/ui/common/widgets/vendor_status_badge.dart';

class VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback onTap;

  const VendorCard({required this.vendor, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
            border: Border.all(color: AppColors.border)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendor.name, style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(vendor.category, style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                VendorStatusBadge(status: vendor.status),
              ],
            ),

            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _buildContactItem(Icons.call, vendor.phone),
                _buildContactItem(Icons.mail, vendor.email),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
      ],
    );
  }
}