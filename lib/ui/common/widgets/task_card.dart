import 'package:flutter/material.dart';
import 'package:planejamento_casamento/data/models/task_model.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;

  const TaskCard({required this.task, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color deadlineColor;
    String deadlineText;
    final days = task.daysRemaining;

    if (task.isCompleted) {
      deadlineColor = AppColors.green;
      deadlineText = "Concluído";
    } else if (days < 0) {
      deadlineColor = AppColors.red;
      deadlineText = "Atrasado ${days.abs()} dias";
    } else if (days == 0) {
      deadlineColor = AppColors.orange;
      deadlineText = "Vence Hoje!";
    } else if (days <= 7) {
      deadlineColor = AppColors.orange;
      deadlineText = "$days dias restantes";
    } else {
      deadlineColor = AppColors.textGrey;
      deadlineText = "Prazo: $days dias";
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(
              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted ? AppColors.green : AppColors.lightGrey,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted ? AppColors.textGrey : AppColors.textDark,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: deadlineColor),
                      const SizedBox(width: 4),
                      Text(
                        deadlineText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: deadlineColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
