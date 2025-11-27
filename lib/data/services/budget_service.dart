import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Referência da coleção
  CollectionReference get _budgetRef =>
      _db.collection('users').doc('user_default').collection('budget');

  // Retorna o Stream cru do Firebase (QuerySnapshot)
  Stream<QuerySnapshot> getBudgetStream() {
    return _budgetRef.orderBy('date', descending: true).snapshots();
  }

  // Adiciona um mapa de dados (JSON)
  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    await _budgetRef.add(expenseData);
  }

  // Deleta um documento pelo ID
  Future<void> deleteExpense(String id) async {
    await _budgetRef.doc(id).delete();
  }
}