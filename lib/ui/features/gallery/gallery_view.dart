import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'gallery_viewmodel.dart';
import '../../../data/models/gallery_item_model.dart';
import '../../common/app_colors.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GalleryViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
          title: const Text("Galeria de Inspiração",
              style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(icon: const Icon(Icons.search, color: AppColors.textDark), onPressed: () {}),
          ],
        ),

        body: Consumer<GalleryViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    children: [
                      _buildCategoryChip(vm, "Todos"),
                      _buildCategoryChip(vm, "Vestidos"),
                      _buildCategoryChip(vm, "Ternos"),
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
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
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
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, GalleryItemModel item, GalleryViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image, color: Colors.grey))
                ),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: Colors.grey[100],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 8, right: 8,
              child: GestureDetector(
                onTap: () => vm.toggleFavorite(item.id),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: item.isFavorite
                        ? AppColors.primary.withOpacity(0.9)
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
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark
            ),
          ),
        ),
      ],
    );
  }
}