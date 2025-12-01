import '../models/gallery_item_model.dart';

class GalleryRepository {
  Future<List<GalleryItemModel>> getInspirations() async {
    // Simula delay de rede rápido para parecer real
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      // --- VESTIDOS ---
      GalleryItemModel(id: 'v1', category: 'Vestidos', title: 'Vestido Premium', imageUrl: 'https://plus.unsplash.com/premium_photo-1671576642314-11a11284ea36?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v2', category: 'Vestidos', title: 'Detalhes em Renda', imageUrl: 'https://images.unsplash.com/photo-1502955422409-06e43fd3eff3?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v3', category: 'Vestidos', title: 'Elegância Pura', imageUrl: 'https://images.unsplash.com/photo-1593575620619-602b4ddf6e96?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v4', category: 'Vestidos', title: 'Vestido no Cabide', imageUrl: 'https://media.istockphoto.com/id/1096951942/pt/foto/wedding-dress-hanging-on-clothing.webp?a=1&b=1&s=612x612&w=0&k=20&c=U0Q3ht513EHejneC4lVRrPCSazVhjxDz2kRdIArV8Ck='),
      GalleryItemModel(id: 'v5', category: 'Vestidos', title: 'Costas Abertas', imageUrl: 'https://images.unsplash.com/photo-1549417229-7686ac5595fd?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v6', category: 'Vestidos', title: 'Caimento Fluido', imageUrl: 'https://images.unsplash.com/photo-1549416878-b9ca95e26903?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v7', category: 'Vestidos', title: 'Noiva Radiante', imageUrl: 'https://plus.unsplash.com/premium_photo-1676234842565-bc1df0bfd45a?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v8', category: 'Vestidos', title: 'Clássico Branco', imageUrl: 'https://images.unsplash.com/photo-1594552072238-b8a33785b261?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v9', category: 'Vestidos', title: 'Véu Longo', imageUrl: 'https://images.unsplash.com/photo-1604531825858-a8e24ed6b43d?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v10', category: 'Vestidos', title: 'Minimalista', imageUrl: 'https://images.unsplash.com/photo-1591997297702-d43f7f008486?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v11', category: 'Vestidos', title: 'Renda Floral', imageUrl: 'https://images.unsplash.com/photo-1596181243306-e02a1897afb1?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'v12', category: 'Vestidos', title: 'Estilo Princesa', imageUrl: 'https://images.unsplash.com/photo-1524048269000-9949b9a70cb0?w=500&auto=format&fit=crop&q=60'),

      // --- TERNOS ---
      GalleryItemModel(id: 't1', category: 'Ternos', title: 'Homem de Negócios', imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 't2', category: 'Ternos', title: 'Azul Marinho Real', imageUrl: 'https://images.unsplash.com/photo-1600091166971-7f9faad6c1e2?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 't3', category: 'Ternos', title: 'Black Tie', imageUrl: 'https://images.unsplash.com/photo-1598915850252-fb07ad1e6768?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 't4', category: 'Ternos', title: 'Gravata Borboleta', imageUrl: 'https://images.unsplash.com/photo-1590426987415-5366b3feb642?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 't5', category: 'Ternos', title: 'Estilo Moderno', imageUrl: 'https://images.unsplash.com/photo-1598808503746-f34c53b9323e?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 't6', category: 'Ternos', title: 'Cinza Clássico', imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 't7', category: 'Ternos', title: 'Bege e Tons Terra', imageUrl: 'https://images.unsplash.com/photo-1617332518605-22c3063112cb?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 't8', category: 'Ternos', title: 'Noivo Despojado', imageUrl: 'https://images.unsplash.com/photo-1593030103066-0093718efeb9?w=500&auto=format&fit=crop&q=60'),

      // --- DECORAÇÃO ---
      GalleryItemModel(id: 'd1', category: 'Decoração', title: 'Mesa de Doces Floral', imageUrl: 'https://images.unsplash.com/photo-1625038032515-308ab14d10b9?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'd2', category: 'Decoração', title: 'Arranjo de Centro', imageUrl: 'https://images.unsplash.com/photo-1641996250159-9d2bbfb483fa?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'd3', category: 'Decoração', title: 'Altar ao Ar Livre', imageUrl: 'https://images.unsplash.com/photo-1712068534065-f56c36e21759?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'd4', category: 'Decoração', title: 'Mesa de Jantar', imageUrl: 'https://images.unsplash.com/photo-1665607437981-973dcd6a22bb?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'd5', category: 'Decoração', title: 'Iluminação e Velas', imageUrl: 'https://images.unsplash.com/photo-1629744418692-345355518e78?w=500&auto=format&fit=crop&q=60'),

      // --- BOLOS ---
      GalleryItemModel(id: 'k1', category: 'Bolos', title: 'Bolo Floral Premium', imageUrl: 'https://plus.unsplash.com/premium_photo-1673896654037-5aed7a409cae?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'k2', category: 'Bolos', title: 'Rústico com Flores', imageUrl: 'https://images.unsplash.com/photo-1623428454614-abaf00244e52?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'k3', category: 'Bolos', title: 'Naked Cake', imageUrl: 'https://images.unsplash.com/photo-1503525642560-ecca5e2e49e9?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'k4', category: 'Bolos', title: 'Clássico Branco', imageUrl: 'https://images.unsplash.com/photo-1519654793190-2e8a4806f1f2?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'k5', category: 'Bolos', title: 'Moderno Texturizado', imageUrl: 'https://images.unsplash.com/photo-1535254973040-607b474cb50d?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'k6', category: 'Bolos', title: 'Topo de Flores', imageUrl: 'https://images.unsplash.com/photo-1574538860416-baadc5d4ec57?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'k7', category: 'Bolos', title: 'Estilo Romântico', imageUrl: 'https://images.unsplash.com/photo-1565987164841-7132b384293b?w=500&auto=format&fit=crop&q=60'),
      GalleryItemModel(id: 'k8', category: 'Bolos', title: 'Bolo Minimalista', imageUrl: 'https://plus.unsplash.com/premium_photo-1671672208868-dd62a3218bb0?w=500&auto=format&fit=crop&q=60'),

      // --- BUQUÊS (Seus Novos Links) ---
      GalleryItemModel(
          id: 'b1',
          category: 'Buquês',
          title: 'Buquê da Noiva',
          imageUrl: 'https://plus.unsplash.com/premium_photo-1675107360191-5b87521acc1b?w=500&auto=format&fit=crop&q=60'
      ),
      GalleryItemModel(
          id: 'b2',
          category: 'Buquês',
          title: 'Rosas Brancas',
          imageUrl: 'https://images.unsplash.com/photo-1604531826103-7c626b90a5f4?w=500&auto=format&fit=crop&q=60'
      ),
      GalleryItemModel(
          id: 'b3',
          category: 'Buquês',
          title: 'Flores do Campo',
          imageUrl: 'https://plus.unsplash.com/premium_photo-1664790560116-0325ad12b5e0?w=500&auto=format&fit=crop&q=60'
      ),
      GalleryItemModel(
          id: 'b4',
          category: 'Buquês',
          title: 'Arranjo Colorido',
          imageUrl: 'https://images.unsplash.com/photo-1692167900605-e02666cadb6d?w=500&auto=format&fit=crop&q=60'
      ),
      GalleryItemModel(
          id: 'b5',
          category: 'Buquês',
          title: 'Buquê Rústico',
          imageUrl: 'https://images.unsplash.com/photo-1700142611715-8a023c5eb8c5?w=500&auto=format&fit=crop&q=60'
      ),
      GalleryItemModel(
          id: 'b6',
          category: 'Buquês',
          title: 'Flores Silvestres',
          imageUrl: 'https://images.unsplash.com/photo-1700062351272-3609358b554a?w=500&auto=format&fit=crop&q=60'
      ),
    ];
  }
}