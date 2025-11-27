import 'package:flutter/material.dart';
import '../../../data/models/review_model.dart';
import '../../../data/models/vendor_model.dart';

class VendorDetailsViewModel extends ChangeNotifier {
  // Dados Mockados de Reviews (Copiados do seu HTML)
  final List<ReviewModel> _reviews = [
    ReviewModel(
      id: '1',
      userName: 'Ana L.',
      userImage: '', // Placeholder no UI
      date: '2 semanas atrás',
      rating: 5.0,
      comment: '"O lugar é incrível, superou todas as nossas expectativas! A equipe foi maravilhosa do início ao fim. Recomendo de olhos fechados!"',
    ),
    ReviewModel(
      id: '2',
      userName: 'Marcos P.',
      userImage: '',
      date: '1 mês atrás',
      rating: 4.5, // Star half
      comment: '"Atendimento impecável e o espaço é lindo. Tivemos um pequeno problema com a iluminação externa, mas foi resolvido rapidamente."',
    ),
    ReviewModel(
      id: '3',
      userName: 'Julia F.',
      userImage: '',
      date: '3 meses atrás',
      rating: 5.0,
      comment: '"Perfeito! O jardim é deslumbrante para cerimônias ao ar livre e o salão é muito elegante. Todos os convidados elogiaram muito a escolha do local."',
    ),
  ];

  List<ReviewModel> get reviews => _reviews;

  // Cálculo da nota média
  double get averageRating => 4.8;
  int get totalReviews => 128;
}