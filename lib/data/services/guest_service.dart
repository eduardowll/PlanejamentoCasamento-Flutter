import 'package:cloud_firestore/cloud_firestore.dart';

class GuestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _guestsRef =>
      _db.collection('users').doc('userId_fixo').collection('guests');

  Stream<QuerySnapshot> getGuestsStream() {
    return _guestsRef.snapshots();
  }

  Future<void> addGuest(Map<String, dynamic> guestData) async {
    await _guestsRef.add(guestData);
  }

  Future<void> toggleConfirmation(String id, bool currentStatus) async {
    await _guestsRef.doc(id).update({'isConfirmed': !currentStatus});
  }

  Future<void> deleteGuest(String id) async {
    await _guestsRef.doc(id).delete();
  }
}