// ... imports ...

import '../models/guest_model.dart';
import '../services/guest_service.dart';

class GuestRepository {
  final GuestService _service;

  GuestRepository(this._service);

  Stream<List<GuestModel>> getGuests() {
    return _service.getGuestsStream().map((snapshot) {
      return snapshot.docs.map((doc) {
        return GuestModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // --- ATUALIZADO: Recebe mais dados ---
  Future<void> addNewGuest(String name, int companions, bool isConfirmed) async {
    final newGuest = GuestModel(
        id: '',
        name: name,
        companions: companions,
        isConfirmed: isConfirmed
    );
    await _service.addGuest(newGuest.toMap());
  }

  Future<void> toggleGuestStatus(GuestModel guest) async {
    await _service.toggleConfirmation(guest.id, guest.isConfirmed);
  }

  Future<void> removeGuest(String id) async {
    await _service.deleteGuest(id);
  }
}