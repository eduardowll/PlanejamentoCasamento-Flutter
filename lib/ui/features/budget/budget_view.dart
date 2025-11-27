import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'budget_viewmodel.dart';
import 'add_expense_view.dart'; // <--- Importe a tela de adicionar (vamos criar jaja)

class BudgetView extends StatelessWidget {
  const BudgetView({super.key});

  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF140e1b);
  final Color surfaceLight = const Color(0xFFede7f3);

  @override
  Widget build(BuildContext context) {
    // REMOVIDO: ChangeNotifierProvider. Usamos a instância global do main.dart.
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Meu Orçamento", style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Navega para a tela de adicionar
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseView()));
            },
            child: Text("+ Adicionar Gasto", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          )
        ],
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
                // --- BUDGET SUMMARY CARD ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Orçamento Total: R\$ ${_formatMoney(vm.totalBudget)}",
                              style: TextStyle(color: textDark, fontWeight: FontWeight.w500)),
                          Text("R\$ ${_formatMoney(vm.totalSpent)}",
                              style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Barra de Progresso
                      Stack(
                        children: [
                          Container(height: 8, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
                          FractionallySizedBox(
                            widthFactor: vm.overallProgress > 1.0 ? 1.0 : vm.overallProgress, // Evita erro se passar de 100%
                            child: Container(height: 8, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(4))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text("Saldo Restante: R\$ ${_formatMoney(vm.remaining)}",
                          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- SEARCH BAR ---
                Container(
                  height: 48,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: "Pesquisar despesas",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --- FILTERS ---
                Row(
                  children: [
                    _buildFilterChip("Todos", true),
                    const SizedBox(width: 8),
                    _buildFilterChip("Pagos", false),
                    const SizedBox(width: 8),
                    _buildFilterChip("Pendentes", false),
                  ],
                ),

                const SizedBox(height: 24),

                // --- EXPENSE LIST ---
                if (vm.expenses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text("Nenhuma despesa lançada.", style: TextStyle(color: Colors.grey[500])),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.expenses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = vm.expenses[index];
                      return Row(
                        children: [
                          Container(
                            height: 48, width: 48,
                            decoration: BoxDecoration(color: surfaceLight, borderRadius: BorderRadius.circular(12)),
                            child: Icon(_getIconData(item.iconName), color: textDark),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: TextStyle(color: textDark, fontWeight: FontWeight.w600, fontSize: 16)),
                                Text("${item.category} • ${item.isPaid ? 'Pago' : 'Pendente'}",
                                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                              ],
                            ),
                          ),
                          Text("R\$ ${_formatMoney(item.spent)}",
                              style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),

      // Botão Flutuante também navega
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseView()));
        },
      ),
    );
  }

  String _formatMoney(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : textDark, fontWeight: FontWeight.w500)),
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