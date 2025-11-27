enum VendorStatus { hired, budgeting, pending }

class VendorModel {
  final String id;
  final String name;
  final String category; // Ex: Local, Buffet, Fotografia
  final VendorStatus status;
  final String phone;
  final String email;

  VendorModel({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.phone,
    required this.email,
  });
}