import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String category; // "Buffet", "Música", etc.
  final double spent; // Valor gasto
  final double totalBudget; // Meta (Opcional, por enquanto vamos repetir o spent ou fixar)
  final bool isPaid; // Novo campo: Pago ou não
  final String title; // Novo campo: Nome da despesa (ex: "Sinal do DJ")

  ExpenseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.spent,
    this.totalBudget = 0, // Simplificação para o MVP
    this.isPaid = false,
  });

  // Do Firebase para o App
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

  // Do App para o Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'amount': spent,
      'isPaid': isPaid,
      'date': FieldValue.serverTimestamp(), // Salva a data de criação
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