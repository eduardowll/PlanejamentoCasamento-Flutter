import 'package:flutter/material.dart';
import '../../../data/models/vendor_model.dart';

class VendorViewModel extends ChangeNotifier {
  // Lista Mockada (Dados "fake" iniciais)
  final List<VendorModel> _allVendors = [
    VendorModel(
        id: '1',
        name: 'Espaço Garden',
        category: 'Local',
        status: VendorStatus.hired,
        phone: '(11) 98765-4321',
        email: 'contato@espacogarden.com'
    ),
    VendorModel(
        id: '2',
        name: 'Sabor & Arte Buffet',
        category: 'Buffet',
        status: VendorStatus.budgeting,
        phone: '(21) 91234-5678',
        email: 'orcamento@saborearte.com'
    ),
    VendorModel(
        id: '3',
        name: 'Sweet Memories',
        category: 'Fotografia',
        status: VendorStatus.pending,
        phone: '(31) 99999-8888',
        email: 'sweet@memories.foto'
    ),
  ];

  // Estado dos Filtros
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  // Getter inteligente: Retorna apenas os fornecedores que batem com a busca e filtro
  List<VendorModel> get filteredVendors {
    return _allVendors.where((vendor) {
      final matchesSearch = vendor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vendor.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'Todos' || vendor.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  String get selectedCategory => _selectedCategory;

  // Ações
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); // Atualiza a tela
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners(); // Atualiza a tela
  }

  // Placeholder para adicionar (futuro)
  void addVendorMock() {
    // Lógica para adicionar...
  }
}