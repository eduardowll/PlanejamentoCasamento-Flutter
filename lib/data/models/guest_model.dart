class GuestModel {
  final String id;
  final String name;
  final bool isConfirmed;
  final int companions;

  GuestModel({
    required this.id,
    required this.name,
    this.isConfirmed = false,
    this.companions = 0,
  });

  factory GuestModel.fromMap(String id, Map<String, dynamic> map) {
    return GuestModel(
      id: id,
      name: map['name'] ?? '',
      isConfirmed: map['isConfirmed'] ?? false,
      companions: map['companions'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isConfirmed': isConfirmed,
      'companions': companions,
    };
  }
}