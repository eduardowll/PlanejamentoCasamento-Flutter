import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String period; // Ex: "12-9 Meses Antes"
  final DateTime deadline; // <--- NOVO CAMPO
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.period,
    required this.deadline, // <--- Obrigatório agora
    this.isCompleted = false,
  });

  // Helper para saber dias restantes
  int get daysRemaining {
    final now = DateTime.now();
    // Zera as horas para comparar apenas dias
    final dateNow = DateTime(now.year, now.month, now.day);
    final dateDeadline = DateTime(deadline.year, deadline.month, deadline.day);
    return dateDeadline.difference(dateNow).inDays;
  }

  // 1. Converter do Firebase (Map) para o App (Objeto)
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      period: data['period'] ?? 'Outros',
      // Firebase guarda data como Timestamp, precisamos converter
      deadline: (data['deadline'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  // 2. Converter do App (Objeto) para o Firebase (Map)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'period': period,
      'deadline': Timestamp.fromDate(deadline),
      'isCompleted': isCompleted,
    };
  }

}