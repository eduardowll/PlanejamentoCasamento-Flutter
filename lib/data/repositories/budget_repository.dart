import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/budget_service.dart';
import '../models/expense_model.dart';

class BudgetRepository {
  final BudgetService _service;

  BudgetRepository(this._service);

  Stream<List<ExpenseModel>> getExpenses() {
    return _service.getBudgetStream().map((snapshot) {
      return snapshot.docs.map((doc) => ExpenseModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> addExpense(String title, String category, double amount, bool isPaid) async {
    final expense = ExpenseModel(
      id: '',
      title: title,
      category: category,
      spent: amount,
      isPaid: isPaid,
    );

    await _service.addExpense(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _service.deleteExpense(id);
  }

  Future<void> toggleExpenseStatus(String id, bool isPaid) async {
    await _service.updateExpenseStatus(id, isPaid);
  }
}