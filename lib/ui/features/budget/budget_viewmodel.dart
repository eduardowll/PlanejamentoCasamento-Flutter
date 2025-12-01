import 'package:flutter/material.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/repositories/budget_repository.dart';

class BudgetViewModel extends ChangeNotifier {
  final BudgetRepository _repository;

  List<ExpenseModel> _allExpenses = [];

  String _currentFilter = 'Todos';
  String get currentFilter => _currentFilter;

  List<ExpenseModel> get expenses {
    if (_currentFilter == 'Todos') {
      return _allExpenses;
    } else if (_currentFilter == 'Pagos') {
      return _allExpenses.where((e) => e.isPaid).toList();
    } else {
      return _allExpenses.where((e) => !e.isPaid).toList();
    }
  }

  final double HARD_BUDGET_LIMIT = 50000;

  BudgetViewModel(this._repository) {
    _listenToExpenses();
  }

  void _listenToExpenses() {
    _repository.getExpenses().listen((data) {
      _allExpenses = data;
      notifyListeners();
    });
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  double get totalBudget => HARD_BUDGET_LIMIT;
  double get totalSpent => _allExpenses.fold(0, (sum, item) => sum + item.spent);
  double get remaining => totalBudget - totalSpent;
  double get overallProgress => totalBudget == 0 ? 0 : (totalSpent / totalBudget);

  Future<void> addExpense(String title, String category, double amount, bool isPaid) async {
    await _repository.addExpense(title, category, amount, isPaid);
  }

  Future<void> deleteExpense(String id) async {
    await _repository.deleteExpense(id);
  }

  Future<void> toggleStatus(ExpenseModel expense) async {
    await _repository.toggleExpenseStatus(expense.id, !expense.isPaid);
  }
}