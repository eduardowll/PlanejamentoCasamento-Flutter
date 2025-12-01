import 'package:planejamento_casamento/data/models/review_model.dart';

enum VendorStatus { hired, budgeting, pending }

class VendorModel {
  final String id;
  final String name;
  final String category; // Ex: Local, Buffet, Fotografia
  final VendorStatus status;
  final String phone;
  final String email;
final double rating;
  final List<ReviewModel> reviews;
  final bool isHired;

  VendorModel({
    required this.id,
    required this.name,
    required this.category,
    this.status = VendorStatus.budgeting,
    required this.phone,
    required this.email,
    this.rating = 0.0,
    this.reviews = const [],
    this.isHired = false,
  });

  VendorModel copyWith({
    String? id,
    String? name,
    String? category,
    VendorStatus? status,
    String? phone,
    String? email,
    double? rating,
    List<ReviewModel>? reviews,
    bool? isHired,
  }) {
    return VendorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      isHired: isHired ?? this.isHired,
    );
  }
}