import 'package:flutter/material.dart';
import 'package:planejamento_casamento/data/models/review_model.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';

class ReviewListItem extends StatelessWidget {
  final ReviewModel review;

  const ReviewListItem({required this.review, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.border,
                  radius: 20,
                  child: Text(
                    review.userName.isNotEmpty ? review.userName[0] : 'U',
                    style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600)),
                    Text(review.date, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ],
            ),
            _buildStarRow(review.rating, size: 16),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          review.comment,
          style: TextStyle(color: AppColors.textDark.withOpacity(0.9), height: 1.5, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildStarRow(double rating, {double size = 20}) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      IconData icon;
      if (rating >= i) {
        icon = Icons.star;
      } else if (rating >= i - 0.5) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }
      stars.add(Icon(icon, color: AppColors.orange, size: size));
    }
    return Row(children: stars);
  }
}
