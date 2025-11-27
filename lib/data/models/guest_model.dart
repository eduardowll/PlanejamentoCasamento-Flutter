class GuestModel {
  final String id;
  final String name;
  final bool isConfirmed;

  GuestModel({required this.id, required this.name, this.isConfirmed = false});

  // Converte do Firebase (Map) para o nosso Objeto
  factory GuestModel.fromMap(String id, Map<String, dynamic> map) {
    return GuestModel(
      id: id,
      name: map['name'] ?? '',
      isConfirmed: map['isConfirmed'] ?? false,
    );
  }

  // Converte do Objeto para o Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isConfirmed': isConfirmed,
    };
  }
}