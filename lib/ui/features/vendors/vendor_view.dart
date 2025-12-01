import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vendor_viewmodel.dart';
import 'vendor_details_view.dart';
import '../../common/app_colors.dart';
import '../../common/widgets/filter_chip_widget.dart';
import '../../common/widgets/vendor_card.dart';

class VendorView extends StatelessWidget {
  const VendorView({super.key});

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
        title: const Text("Fornecedores", style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: AppColors.textDark), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
      ),

      body: Consumer<VendorViewModel>(
        builder: (context, vm, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChipWidget(label: "Todos", isSelected: vm.selectedCategory == "Todos", onTap: () => vm.setCategoryFilter("Todos")),
                    const SizedBox(width: 8),
                    FilterChipWidget(label: "Local", isSelected: vm.selectedCategory == "Local", onTap: () => vm.setCategoryFilter("Local")),
                    const SizedBox(width: 8),
                    FilterChipWidget(label: "Buffet", isSelected: vm.selectedCategory == "Buffet", onTap: () => vm.setCategoryFilter("Buffet")),
                    const SizedBox(width: 8),
                    FilterChipWidget(label: "Fotografia", isSelected: vm.selectedCategory == "Fotografia", onTap: () => vm.setCategoryFilter("Fotografia")),
                    const SizedBox(width: 8),
                    FilterChipWidget(label: "Decoração", isSelected: vm.selectedCategory == "Decoração", onTap: () => vm.setCategoryFilter("Decoração")),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: vm.filteredVendors.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: vm.filteredVendors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final vendor = vm.filteredVendors[index];
                    return VendorCard(
                      vendor: vendor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VendorDetailsView(vendor: vendor),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {},
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: AppColors.primary.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text("Nenhum fornecedor encontrado", style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Tente outro termo ou limpe os filtros.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
        ],
      ),
    );
  }
}