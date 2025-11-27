import 'package:flutter/material.dart';
import 'package:planejamento_casamento/ui/features/vendors/vendor_details_view.dart';
import 'package:provider/provider.dart';
import 'vendor_viewmodel.dart';
import '../../../data/models/vendor_model.dart';

class VendorView extends StatelessWidget {
  const VendorView({super.key});

  // Cores extraídas do HTML
  final Color primaryColor = const Color(0xFFd8a7b1); // Rosa
  final Color accentColor = const Color(0xFFc9a959); // Dourado/Mostarda (FAB)
  final Color bgLight = const Color(0xFFfdfafb);
  final Color textLight = const Color(0xFF333333);
  final Color textNeutral = const Color(0xFF888888);

  // Cores de Status
  final Color statusGreen = const Color(0xFF50b86a);
  final Color statusYellow = const Color(0xFFf5b745);
  final Color statusGray = const Color(0xFFa0a0a0);

  @override
  Widget build(BuildContext context) {
    // Injetando o ViewModel
    return ChangeNotifierProvider(
      create: (_) => VendorViewModel(),
      child: Scaffold(
        backgroundColor: bgLight,
        // --- APP BAR ---
        appBar: AppBar(
          backgroundColor: bgLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textLight),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Fornecedores", style: TextStyle(color: textLight, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.more_vert, color: textLight), onPressed: () {}),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: const Color(0xFFf3e9dd), height: 1), // Borda sutil
          ),
        ),

        body: Consumer<VendorViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                // --- SEARCH BAR ---
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf3e9dd), // subtle-light
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      onChanged: (val) => vm.setSearchQuery(val),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: textNeutral),
                        hintText: "Pesquisar por nome ou serviço...",
                        hintStyle: TextStyle(color: textNeutral),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),

                // --- FILTER CHIPS ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterChip(vm, "Todos"),
                      const SizedBox(width: 8),
                      _buildFilterChip(vm, "Local"),
                      const SizedBox(width: 8),
                      _buildFilterChip(vm, "Buffet"),
                      const SizedBox(width: 8),
                      _buildFilterChip(vm, "Fotografia"),
                      const SizedBox(width: 8),
                      _buildFilterChip(vm, "Decoração"),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --- VENDOR LIST ---
                Expanded(
                  child: vm.filteredVendors.isEmpty
                      ? _buildEmptyState() // Mostra se não achar nada
                      : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: vm.filteredVendors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final vendor = vm.filteredVendors[index];
                      return _buildVendorCard(context, vendor);
                    },
                  ),
                ),
              ],
            );
          },
        ),

        // --- FAB (Accent Color) ---
        floatingActionButton: FloatingActionButton(
          backgroundColor: accentColor,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
          onPressed: () {},
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildFilterChip(VendorViewModel vm, String label) {
    final bool isSelected = vm.selectedCategory == label;
    return GestureDetector(
      onTap: () => vm.setCategoryFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Se selecionado, usa Primary com opacidade, senão usa subtle-light
          color: isSelected ? primaryColor.withOpacity(0.2) : const Color(0xFFf3e9dd),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : textNeutral,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildVendorCard(BuildContext context, VendorModel vendor) {
    // Definir cores baseadas no status
    Color badgeColor;
    String badgeText;

    switch (vendor.status) {
      case VendorStatus.hired:
        badgeColor = statusGreen;
        badgeText = "Contratado";
        break;
      case VendorStatus.budgeting:
        badgeColor = statusYellow;
        badgeText = "Orçamento";
        break;
      case VendorStatus.pending:
        badgeColor = statusGray;
        badgeText = "Pendente";
        break;
    }

    // --- ALTERAÇÃO AQUI: GestureDetector para o clique ---
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VendorDetailsView(vendor: vendor),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            // Topo do Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vendor.name,
                        style: TextStyle(
                            color: textLight,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(vendor.category,
                        style: TextStyle(color: textNeutral, fontSize: 14)),
                  ],
                ),
                // Badge de Status
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: badgeColor, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(badgeText,
                          style: TextStyle(
                              color: badgeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            // Botões de Contato
            Row(
              children: [
                _buildContactItem(Icons.call, vendor.phone),
                const SizedBox(width: 16),
                _buildContactItem(Icons.mail, vendor.email),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: textNeutral),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: textNeutral, fontSize: 14)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: primaryColor.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text("Nenhum fornecedor encontrado", style: TextStyle(color: textLight, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Adicione um novo fornecedor ou ajuste seus filtros de busca.",
              textAlign: TextAlign.center,
              style: TextStyle(color: textNeutral),
            ),
          ),
        ],
      ),
    );
  }
}