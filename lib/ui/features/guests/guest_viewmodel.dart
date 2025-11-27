import 'package:flutter/material.dart';
import '../../../data/models/guest_model.dart';
import '../../../data/repositories/guest_repository.dart';

class GuestViewModel extends ChangeNotifier {
  final GuestRepository _repository;

  List<GuestModel> _guests = [];
  List<GuestModel> get guests => _guests;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // --- NOVOS GETTERS PARA OS CARDS DE ESTATÍSTICA ---
  int get totalGuests => _guests.length;
  int get confirmedGuests => _guests.where((g) => g.isConfirmed).length;
  int get pendingGuests => _guests.where((g) => !g.isConfirmed).length;
  // --------------------------------------------------

  GuestViewModel(this._repository) {
    _startListening();
  }

  void _startListening() {
    _repository.getGuests().listen((guestList) {
      _guests = guestList;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addGuest(String name) async {
    if (name.isNotEmpty) await _repository.addNewGuest(name);
  }

  Future<void> toggleConfirmation(GuestModel guest) async {
    await _repository.toggleGuestStatus(guest);
  }

  Future<void> deleteGuest(String id) async {
    await _repository.removeGuest(id);
  }
}