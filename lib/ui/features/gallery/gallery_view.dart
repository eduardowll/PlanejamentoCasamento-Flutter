import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'gallery_viewmodel.dart';
import '../../../data/models/gallery_item_model.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF140e1b);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GalleryViewModel(),
      child: Scaffold(
        backgroundColor: bgLight,
        // --- HEADER ---
        appBar: AppBar(
          backgroundColor: bgLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textDark),
            // Volta se possível, senão não faz nada (pois está na home)
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
          title: Text("Galeria de Inspiração",
              style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.search, color: textDark), onPressed: () {}),
          ],
        ),

        body: Consumer<GalleryViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                // --- FILTROS (Chips) ---
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    children: [
                      _buildCategoryChip(vm, "Todos"),
                      _buildCategoryChip(vm, "Vestidos"),
                      _buildCategoryChip(vm, "Decoração"),
                      _buildCategoryChip(vm, "Bolos"),
                      _buildCategoryChip(vm, "Buquês"),
                    ],
                  ),
                ),

                // --- MASONRY GRID ---
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MasonryGridView.count(
                    padding: const EdgeInsets.all(16),
                    crossAxisCount: 2, // 2 Colunas
                    mainAxisSpacing: 12, // Espaço Vertical
                    crossAxisSpacing: 12, // Espaço Horizontal
                    itemCount: vm.items.length,
                    itemBuilder: (context, index) {
                      return _buildGalleryItem(context, vm.items[index], vm);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildCategoryChip(GalleryViewModel vm, String label) {
    final isSelected = vm.selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) vm.setCategory(label);
        },
        backgroundColor: Colors.white,
        selectedColor: primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? primaryColor : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, GalleryItemModel item, GalleryViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Imagem com Cache (Não pisca ao scrolar)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image, color: Colors.grey))
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),

            // Botão Favoritar
            Positioned(
              top: 8, right: 8,
              child: GestureDetector(
                onTap: () => vm.toggleFavorite(item.id),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: item.isFavorite
                        ? primaryColor.withOpacity(0.9)
                        : Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            item.title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textDark
            ),
          ),
        ),
      ],
    );
  }
}