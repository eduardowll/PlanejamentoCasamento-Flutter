import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/guest_model.dart';
import '../services/guest_service.dart';

class GuestRepository {
  final GuestService _service;

  GuestRepository(this._service);

  // Transforma Stream<QuerySnapshot> (bruto) em Stream<List<GuestModel>> (limpo)
  Stream<List<GuestModel>> getGuests() {
    return _service.getGuestsStream().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GuestModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addNewGuest(String name) async {
    final newGuest = GuestModel(id: '', name: name); // ID é gerado pelo Fire
    await _service.addGuest(newGuest.toMap());
  }

  Future<void> toggleGuestStatus(GuestModel guest) async {
    await _service.toggleConfirmation(guest.id, guest.isConfirmed);
  }

  Future<void> removeGuest(String id) async {
    await _service.deleteGuest(id);
  }
}