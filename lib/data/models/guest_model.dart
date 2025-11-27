class GuestModel {
  final String id;
  final String name;
  final bool isConfirmed;
  final int companions; // <--- NOVO CAMPO

  GuestModel({
    required this.id,
    required this.name,
    this.isConfirmed = false,
    this.companions = 0, // Padrão é 0 acompanhantes
  });

  factory GuestModel.fromMap(String id, Map<String, dynamic> map) {
    return GuestModel(
      id: id,
      name: map['name'] ?? '',
      isConfirmed: map['isConfirmed'] ?? false,
      companions: map['companions'] ?? 0, // <--- Lendo do Firebase
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isConfirmed': isConfirmed,
      'companions': companions, // <--- Salvando no Firebase
    };
  }
}