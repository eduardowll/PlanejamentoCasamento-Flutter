import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/app_colors.dart';
import 'budget_viewmodel.dart';
import 'add_expense_view.dart';

class BudgetView extends StatelessWidget {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Meu Orçamento",
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
      ),

      body: Consumer<BudgetViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Orçamento Total: R\$ ${_formatMoney(vm.totalBudget)}",
                              style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500)),
                          Text("R\$ ${_formatMoney(vm.totalSpent)}",
                              style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        children: [
                          Container(height: 8, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
                          FractionallySizedBox(
                            widthFactor: vm.overallProgress.clamp(0.0, 1.0),
                            child: Container(height: 8, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text("Saldo Restante: R\$ ${_formatMoney(vm.remaining)}",
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _buildFilterChip("Todos", vm.currentFilter == "Todos", () => vm.setFilter("Todos")),
                    const SizedBox(width: 8),
                    _buildFilterChip("Pagos", vm.currentFilter == "Pagos", () => vm.setFilter("Pagos")),
                    const SizedBox(width: 8),
                    _buildFilterChip("Pendentes", vm.currentFilter == "Pendentes", () => vm.setFilter("Pendentes")),
                  ],
                ),

                const SizedBox(height: 24),

                if (vm.expenses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text("Nenhuma despesa encontrada.", style: TextStyle(color: Colors.grey[500])),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.expenses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = vm.expenses[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.red, // Usa AppColors
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          vm.deleteExpense(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${item.title} removido"),
                              backgroundColor: AppColors.red,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 48, width: 48,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Icon(_getIconData(item.iconName), color: AppColors.textDark),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 16)),
                                    Row(
                                      children: [
                                        Text(item.category, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                                        const SizedBox(width: 8),

                                        // --- BOTÃO DE CLICAR ---
                                        GestureDetector(
                                          onTap: () => vm.toggleStatus(item),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                                color: item.isPaid ? AppColors.green.withOpacity(0.1) : AppColors.orange.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: item.isPaid ? AppColors.green : AppColors.orange,
                                                    width: 1
                                                )
                                            ),
                                            child: Text(
                                              item.isPaid ? 'Pago' : 'Pendente',
                                              style: TextStyle(
                                                  color: item.isPaid ? AppColors.green : AppColors.orange,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                        // -----------------------
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text("R\$ ${_formatMoney(item.spent)}",
                                  style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseView()));
        },
      ),
    );
  }

  // Helpers
  String _formatMoney(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w500)),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'restaurant': return Icons.restaurant;
      case 'celebration': return Icons.celebration;
      case 'music_note': return Icons.music_note;
      case 'photo_camera': return Icons.camera_alt;
      case 'checkroom': return Icons.checkroom;
      default: return Icons.attach_money;
    }
  }
}