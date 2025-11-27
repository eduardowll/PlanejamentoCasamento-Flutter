class ExpenseModel {
  final String id;
  final String category;
  final double spent; // Quanto já gastou
  final double totalBudget; // Quanto planejou gastar
  final String iconName; // 'restaurant', 'music_note', etc.

  ExpenseModel({
    required this.id,
    required this.category,
    required this.spent,
    required this.totalBudget,
    required this.iconName,
  });

  // Getter para calcular progresso (0.0 a 1.0)
  double get progress => totalBudget == 0 ? 0 : (spent / totalBudget);

  // Getter para porcentagem em String (ex: "92%")
  String get percentageString => "${(progress * 100).toInt()}%";
}