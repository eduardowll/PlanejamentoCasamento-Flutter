import 'package:flutter/material.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/repositories/budget_repository.dart';

class BudgetViewModel extends ChangeNotifier {
  final BudgetRepository _repository;

  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> get expenses => _expenses;

  final double HARD_BUDGET_LIMIT = 50000; // Meta fixa para MVP

  // Construtor recebe o Repositório (Injeção)
  BudgetViewModel(this._repository) {
    _listenToExpenses();
  }

  void _listenToExpenses() {
    _repository.getExpenses().listen((data) {
      _expenses = data;
      notifyListeners();
    });
  }

  // Cálculos
  double get totalBudget => HARD_BUDGET_LIMIT;
  double get totalSpent => _expenses.fold(0, (sum, item) => sum + item.spent);
  double get remaining => totalBudget - totalSpent;
  double get overallProgress => totalBudget == 0 ? 0 : (totalSpent / totalBudget);

  // Ações
  Future<void> addExpense(String title, String category, double amount, bool isPaid) async {
    await _repository.addExpense(title, category, amount, isPaid);
  }

  Future<void> deleteExpense(String id) async {
    await _repository.deleteExpense(id);
  }
}