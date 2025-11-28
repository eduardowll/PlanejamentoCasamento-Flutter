class GalleryItemModel {
  final String id;
  final String imageUrl;
  final String title;
  final String category;
  bool isFavorite;

  GalleryItemModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.category,
    this.isFavorite = false,
  });
}