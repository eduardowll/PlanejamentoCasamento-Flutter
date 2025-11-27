import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/budget_service.dart';
import '../models/expense_model.dart';

class BudgetRepository {
  final BudgetService _service;

  // Injeção de dependência do Service
  BudgetRepository(this._service);

  // Transforma QuerySnapshot (Firebase) em List<ExpenseModel> (App)
  Stream<List<ExpenseModel>> getExpenses() {
    return _service.getBudgetStream().map((snapshot) {
      return snapshot.docs.map((doc) => ExpenseModel.fromFirestore(doc)).toList();
    });
  }

  // Prepara o objeto para ser salvo
  Future<void> addExpense(String title, String category, double amount, bool isPaid) async {
    final expense = ExpenseModel(
      id: '', // ID será gerado pelo Firebase
      title: title,
      category: category,
      spent: amount,
      isPaid: isPaid,
    );

    // Converte Model -> Map e chama o Service
    await _service.addExpense(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _service.deleteExpense(id);
  }
}