import 'package:flutter/material.dart';
import '../../../data/models/gallery_item_model.dart';
import '../../../data/repositories/gallery_repository.dart';

class GalleryViewModel extends ChangeNotifier {
  final GalleryRepository _repository = GalleryRepository();

  List<GalleryItemModel> _allItems = [];
  List<GalleryItemModel> _filteredItems = [];

  bool isLoading = true;
  String _selectedCategory = "Todos";

  List<GalleryItemModel> get items => _filteredItems;
  String get selectedCategory => _selectedCategory;

  GalleryViewModel() {
    _loadImages();
  }

  Future<void> _loadImages() async {
    _allItems = await _repository.getInspirations();
    _filterItems();
    isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _filterItems();
    notifyListeners();
  }

  void _filterItems() {
    if (_selectedCategory == "Todos") {
      _filteredItems = List.from(_allItems);
    } else {
      _filteredItems = _allItems.where((i) => i.category == _selectedCategory).toList();
    }
  }

  void toggleFavorite(String id) {
    final index = _allItems.indexWhere((i) => i.id == id);
    if (index != -1) {
      _allItems[index].isFavorite = !_allItems[index].isFavorite;
      _filterItems(); // Re-aplica filtro para atualizar a lista exibida
      notifyListeners();
    }
  }
}