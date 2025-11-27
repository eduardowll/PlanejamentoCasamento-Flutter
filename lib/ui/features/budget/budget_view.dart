import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'budget_viewmodel.dart';

class BudgetView extends StatelessWidget {
  const BudgetView({super.key});

  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF140e1b);
  final Color surfaceLight = const Color(0xFFede7f3); // Cor roxinha bem clara do fundo dos cards

  @override
  Widget build(BuildContext context) {
    // Injetando o ViewModel direto aqui (para simplificar o main.dart neste momento)
    return ChangeNotifierProvider(
      create: (_) => BudgetViewModel(),
      child: Scaffold(
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
              onPressed: () {},
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
                      color: surfaceLight, // Fundo roxinho claro
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
                        // Barra de Progresso Customizada
                        Stack(
                          children: [
                            Container(height: 8, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
                            FractionallySizedBox(
                              widthFactor: vm.overallProgress,
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
                  ListView.separated(
                    shrinkWrap: true, // Importante dentro de SingleScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vm.expenses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = vm.expenses[index];
                      return Row(
                        children: [
                          // Ícone
                          Container(
                            height: 48, width: 48,
                            decoration: BoxDecoration(color: surfaceLight, borderRadius: BorderRadius.circular(12)),
                            child: Icon(_getIconData(item.iconName), color: textDark),
                          ),
                          const SizedBox(width: 16),
                          // Textos
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.category, style: TextStyle(color: textDark, fontWeight: FontWeight.w600, fontSize: 16)),
                                Text("R\$ ${_formatMoney(item.spent)} / R\$ ${_formatMoney(item.totalBudget)}",
                                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
                              ],
                            ),
                          ),
                          // Mini Barra lateral com porcentagem
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                height: 6,
                                child: LinearProgressIndicator(
                                  value: item.progress,
                                  backgroundColor: Colors.grey[300],
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 35,
                                child: Text(item.percentageString,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }

  // --- Helpers ---

  String _formatMoney(double value) {
    // Formatação simples (em app real use o pacote 'intl')
    return value.toStringAsFixed(0).replaceAll('.', ',');
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

  // Mapeia string do banco para IconData do Flutter
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