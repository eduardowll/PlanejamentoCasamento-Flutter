import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _budgetRef =>
      _db.collection('users').doc('user_default').collection('budget');

  Stream<QuerySnapshot> getBudgetStream() {
    return _budgetRef.orderBy('date', descending: true).snapshots();
  }

  Future<void> addExpense(Map<String, dynamic> expenseData) async {
    await _budgetRef.add(expenseData);
  }

  Future<void> deleteExpense(String id) async {
    await _budgetRef.doc(id).delete();
  }

  Future<void> updateExpenseStatus(String id, bool isPaid) async {
    await _budgetRef.doc(id).update({'isPaid': isPaid});
  }
}