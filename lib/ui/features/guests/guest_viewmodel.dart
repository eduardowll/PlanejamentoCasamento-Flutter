import 'package:flutter/material.dart';
import '../../../data/models/guest_model.dart';
import '../../../data/repositories/guest_repository.dart';

class GuestViewModel extends ChangeNotifier {
  final GuestRepository _repository;

  List<GuestModel> _guests = [];
  List<GuestModel> get guests => _guests;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Getters para os Cards do Topo
  int get totalGuests => _guests.fold(0, (sum, g) => sum + 1 + g.companions);
  int get confirmedGuests => _guests.where((g) => g.isConfirmed).fold(0, (sum, g) => sum + 1 + g.companions);
  int get pendingGuests => _guests.where((g) => !g.isConfirmed).fold(0, (sum, g) => sum + 1 + g.companions);

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

  // A função que recebe os 3 parâmetros
  Future<void> addGuest(String name, int companions, bool isConfirmed) async {
    if (name.isNotEmpty) {
      await _repository.addNewGuest(name, companions, isConfirmed);
    }
  }

  Future<void> toggleConfirmation(GuestModel guest) async {
    await _repository.toggleGuestStatus(guest);
  }

  Future<void> deleteGuest(String id) async {
    await _repository.removeGuest(id);
  }
}