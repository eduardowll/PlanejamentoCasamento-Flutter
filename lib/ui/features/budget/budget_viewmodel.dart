import 'package:flutter/material.dart';
import '../../../data/models/expense_model.dart';

class BudgetViewModel extends ChangeNotifier {
  // Lista Mockada (Simulando o Banco de Dados)
  final List<ExpenseModel> _expenses = [
    ExpenseModel(id: '1', category: 'Buffet', spent: 18500, totalBudget: 20000, iconName: 'restaurant'),
    ExpenseModel(id: '2', category: 'Decoração & Flores', spent: 7000, totalBudget: 8000, iconName: 'celebration'),
    ExpenseModel(id: '3', category: 'Música & Entretenimento', spent: 5000, totalBudget: 5000, iconName: 'music_note'),
    ExpenseModel(id: '4', category: 'Fotografia & Vídeo', spent: 2000, totalBudget: 4000, iconName: 'photo_camera'),
    ExpenseModel(id: '5', category: 'Vestuário', spent: 0, totalBudget: 3000, iconName: 'checkroom'),
  ];

  List<ExpenseModel> get expenses => _expenses;

  // Cálculos Gerais
  double get totalBudget => _expenses.fold(0, (sum, item) => sum + item.totalBudget);
  double get totalSpent => _expenses.fold(0, (sum, item) => sum + item.spent);
  double get remaining => totalBudget - totalSpent;
  double get overallProgress => totalBudget == 0 ? 0 : (totalSpent / totalBudget);

  // Função para adicionar gasto (Mock)
  void addExpenseMock(String category, double amount) {
    // Aqui no futuro chamaremos o Repository
    notifyListeners();
  }
}