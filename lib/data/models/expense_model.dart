import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String category;
  final double spent;
  final double totalBudget;
  final bool isPaid;
  final String title;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.spent,
    this.totalBudget = 0,
    this.isPaid = false,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      title: data['title'] ?? 'Despesa',
      category: data['category'] ?? 'Outros',
      spent: (data['amount'] ?? 0).toDouble(),
      isPaid: data['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'amount': spent,
      'isPaid': isPaid,
      'date': FieldValue.serverTimestamp(),
    };
  }

  // Ícone baseado na categoria
  String get iconName {
    switch (category.toLowerCase()) {
      case 'buffet': return 'restaurant';
      case 'música': return 'music_note';
      case 'fotografia': return 'photo_camera';
      case 'decoração': return 'celebration';
      case 'vestuário': return 'checkroom';
      default: return 'attach_money';
    }
  }
}