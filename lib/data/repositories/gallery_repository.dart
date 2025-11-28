import '../models/gallery_item_model.dart';

class GalleryRepository {
  // Simula uma chamada de API (delay de 1s para parecer real)
  Future<List<GalleryItemModel>> getInspirations() async {
    await Future.delayed(const Duration(seconds: 1));

    // Lista Curada de Imagens Reais do Unsplash (Temática Casamento)
    return [
      GalleryItemModel(
        id: '1',
        title: 'Cerimônia na Praia',
        category: 'Cerimônias',
        imageUrl: 'https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=500&q=80',
      ),
      GalleryItemModel(
        id: '2',
        title: 'Vestido Minimalista',
        category: 'Vestidos',
        imageUrl: 'https://images.unsplash.com/photo-1594539659103-6272338cb464?w=500&q=80',
      ),
      GalleryItemModel(
        id: '3',
        title: 'Bolo Floral',
        category: 'Bolos',
        imageUrl: 'https://images.unsplash.com/photo-1535295972055-1c762f4483e5?w=500&q=80',
      ),
      GalleryItemModel(
        id: '4',
        title: 'Decoração Rústica',
        category: 'Decoração',
        imageUrl: 'https://images.unsplash.com/photo-1470219556762-1771e7f9427d?w=500&q=80',
      ),
      GalleryItemModel(
        id: '5',
        title: 'Buquê Clássico',
        category: 'Buquês',
        imageUrl: 'https://images.unsplash.com/photo-1552689536-117537b98a32?w=500&q=80',
      ),
      GalleryItemModel(
        id: '6',
        title: 'Alianças',
        category: 'Detalhes',
        imageUrl: 'https://images.unsplash.com/photo-1516961642265-531546e84af2?w=500&q=80',
      ),
      GalleryItemModel(
        id: '7',
        title: 'Mesa de Jantar',
        category: 'Decoração',
        imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0202128?w=500&q=80',
      ),
      GalleryItemModel(
        id: '8',
        title: 'Vestido de Renda',
        category: 'Vestidos',
        imageUrl: 'https://images.unsplash.com/photo-1596838132731-3301c3fd4317?w=500&q=80',
      ),
      GalleryItemModel(
        id: '9',
        title: 'Convite Elegante',
        category: 'Detalhes',
        imageUrl: 'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?w=500&q=80',
      ),
      GalleryItemModel(
        id: '10',
        title: 'Votos',
        category: 'Cerimônias',
        imageUrl: 'https://images.unsplash.com/photo-1511285560982-1351cdeb9821?w=500&q=80',
      ),
    ];
  }
}