import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String period;
  final DateTime deadline;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.period,
    required this.deadline,
    this.isCompleted = false,
  });


  int get daysRemaining {
    final now = DateTime.now();
    final dateNow = DateTime(now.year, now.month, now.day);
    final dateDeadline = DateTime(deadline.year, deadline.month, deadline.day);
    return dateDeadline.difference(dateNow).inDays;
  }

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      period: data['period'] ?? 'Outros',
      deadline: (data['deadline'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'period': period,
      'deadline': Timestamp.fromDate(deadline),
      'isCompleted': isCompleted,
    };
  }

}