import 'package:flutter/material.dart';
import '../../../data/models/vendor_model.dart';
import '../../../data/models/review_model.dart';

class VendorViewModel extends ChangeNotifier {
  final List<VendorModel> _allVendors = [
    VendorModel(
      id: '1',
      name: 'Salão Estrela',
      category: 'Local',
      status: VendorStatus.hired,
      phone: '(11) 91111-1111',
      email: 'contato@estrela.com',
      rating: 4.8,
      reviews: [
        ReviewModel(id: 'r1', userName: 'Ana Clara', userImage: '', date: '1 semana atrás', rating: 5.0, comment: 'O lugar é simplesmente mágico!'),
        ReviewModel(id: 'r2', userName: 'Roberto M.', userImage: '', date: '3 semanas atrás', rating: 5.0, comment: 'Equipe super atenciosa.'),
      ],
    ),
    VendorModel(
      id: '2',
      name: 'Chácara Bela Vista',
      category: 'Local',
      status: VendorStatus.budgeting,
      phone: '(11) 92222-2222',
      email: 'contato@belavista.com',
      rating: 3.2,
      reviews: [
        ReviewModel(id: 'r4', userName: 'Marcos P.', userImage: '', date: '2 semanas atrás', rating: 5.0, comment: 'A vista é linda!'),
        ReviewModel(id: 'r5', userName: 'Carla T.', userImage: '', date: '1 mês atrás', rating: 3.0, comment: 'Acesso difícil.'),
        ReviewModel(id: 'r6', userName: 'Felipe D.', userImage: '', date: '2 meses atrás', rating: 1.0, comment: 'Problemas com água.'),
      ],
    ),
    VendorModel(
      id: '3',
      name: 'Galpão Central',
      category: 'Local',
      status: VendorStatus.pending,
      phone: '(11) 93333-3333',
      email: 'contato@galpaocentral.com',
      rating: 1.3,
      reviews: [
        ReviewModel(id: 'r7', userName: 'Lucas G.', userImage: '', date: '1 semana atrás', rating: 1.0, comment: 'Ar condicionado quebrado.'),
        ReviewModel(id: 'r8', userName: 'Mariana L.', userImage: '', date: '3 semanas atrás', rating: 1.0, comment: 'Sujo e mal conservado.'),
      ],
    ),
    VendorModel(
      id: '4',
      name: 'Gourmet Real',
      category: 'Buffet',
      status: VendorStatus.budgeting,
      phone: '(21) 94444-4444',
      email: 'contato@gourmetreal.com',
      rating: 5.0,
      reviews: [
        ReviewModel(id: 'r10', userName: 'Sofia B.', userImage: '', date: '3 dias atrás', rating: 5.0, comment: 'Comida divina!'),
        ReviewModel(id: 'r11', userName: 'Carlos E.', userImage: '', date: '2 semanas atrás', rating: 5.0, comment: 'Serviço impecável.'),
      ],
    ),
    VendorModel(
      id: '5',
      name: 'Sabor da Festa',
      category: 'Buffet',
      status: VendorStatus.pending,
      phone: '(21) 95555-5555',
      email: 'contato@sabordafesta.com',
      rating: 2.8,
      reviews: [
        ReviewModel(id: 'r13', userName: 'Gustavo R.', userImage: '', date: '1 semana atrás', rating: 1.0, comment: 'Comida fria.'),
        ReviewModel(id: 'r14', userName: 'Larissa M.', userImage: '', date: '3 semanas atrás', rating: 2.5, comment: 'Salgados deixaram a desejar.'),
      ],
    ),
    VendorModel(
      id: '6',
      name: 'Festa Rápida',
      category: 'Buffet',
      status: VendorStatus.pending,
      phone: '(21) 96666-6666',
      email: 'contato@festarapida.com',
      rating: 1.0,
      reviews: [
        ReviewModel(id: 'r16', userName: 'Joana D.', userImage: '', date: '2 dias atrás', rating: 1.0, comment: 'Horrível. Cancelaram.'),
      ],
    ),
    VendorModel(
      id: '7',
      name: 'Eterno Momento',
      category: 'Fotografia',
      status: VendorStatus.hired,
      phone: '(31) 97777-7777',
      email: 'contato@eternomomento.com',
      rating: 4.9,
      reviews: [
        ReviewModel(id: 'r19', userName: 'Camila P.', userImage: '', date: '1 mês atrás', rating: 5.0, comment: 'Fotos de revista!'),
        ReviewModel(id: 'r20', userName: 'Renato L.', userImage: '', date: '2 meses atrás', rating: 5.0, comment: 'Fotógrafo discreto.'),
      ],
    ),
    VendorModel(
      id: '8',
      name: 'Click & Cia',
      category: 'Fotografia',
      status: VendorStatus.budgeting,
      phone: '(31) 98888-8888',
      email: 'contato@clickcia.com',
      rating: 3.5,
      reviews: [
        ReviewModel(id: 'r22', userName: 'Aline B.', userImage: '', date: '2 semanas atrás', rating: 5.0, comment: 'Ensaio lindo!'),
        ReviewModel(id: 'r23', userName: 'Diego M.', userImage: '', date: '1 mês atrás', rating: 3.5, comment: 'Demoraram para entregar.'),
      ],
    ),
    VendorModel(
      id: '9',
      name: 'Foto Amadora',
      category: 'Fotografia',
      status: VendorStatus.pending,
      phone: '(31) 99999-9999',
      email: 'contato@fotoamadora.com',
      rating: 1.8,
      reviews: [
        ReviewModel(id: 'r25', userName: 'Igor T.', userImage: '', date: '1 semana atrás', rating: 2.0, comment: 'Fotos desfocadas.'),
      ],
    ),

    VendorModel(
      id: '10',
      name: 'Flores & Sonhos',
      category: 'Decoração',
      status: VendorStatus.hired,
      phone: '(41) 91234-5678',
      email: 'contato@floresesonhos.com',
      rating: 5.0,
      reviews: [
        ReviewModel(id: 'r28', userName: 'Patrícia L.', userImage: '', date: '1 semana atrás', rating: 5.0, comment: 'O arranjo ficou exatamente como no Pinterest!'),
        ReviewModel(id: 'r29', userName: 'Silvia M.', userImage: '', date: '1 mês atrás', rating: 5.0, comment: 'Flores frescas e cheirosas. Perfeito.'),
      ],
    ),
    VendorModel(
      id: '11',
      name: 'Decora Mais',
      category: 'Decoração',
      status: VendorStatus.budgeting,
      phone: '(41) 98765-4321',
      email: 'orcamento@decoramais.com',
      rating: 3.0,
      reviews: [
        ReviewModel(id: 'r30', userName: 'Fernanda K.', userImage: '', date: '2 semanas atrás', rating: 4.0, comment: 'Ficou bonito, mas esqueceram o tapete vermelho.'),
        ReviewModel(id: 'r31', userName: 'Ricardo J.', userImage: '', date: '1 mês atrás', rating: 2.0, comment: 'Móveis um pouco gastos.'),
      ],
    ),
    VendorModel(
      id: '12',
      name: 'Festa Simples',
      category: 'Decoração',
      status: VendorStatus.pending,
      phone: '(41) 99988-7766',
      email: 'contato@festasimples.com',
      rating: 1.5,
      reviews: [
        ReviewModel(id: 'r32', userName: 'Cláudia R.', userImage: '', date: '3 dias atrás', rating: 1.0, comment: 'As flores eram de plástico e pareciam velhas.'),
        ReviewModel(id: 'r33', userName: 'Mauro S.', userImage: '', date: '1 semana atrás', rating: 2.0, comment: 'Montagem atrasou 2 horas.'),
      ],
    ),
  ];

  List<VendorModel> get allVendors => _allVendors;

  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Todos';

  VendorViewModel() {
    searchController.addListener(() {
      _searchQuery = searchController.text;
      notifyListeners();
    });
  }

  List<VendorModel> get filteredVendors {
    return _allVendors.where((vendor) {
      final matchesSearch = vendor.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Todos' || vendor.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  String get selectedCategory => _selectedCategory;

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateVendor(VendorModel updatedVendor) {
    final index = _allVendors.indexWhere((v) => v.id == updatedVendor.id);
    if (index != -1) {
      _allVendors[index] = updatedVendor;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}