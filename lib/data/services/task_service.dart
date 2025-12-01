import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _tasksRef =>
      _db.collection('users').doc('user_default').collection('tasks');

  Stream<QuerySnapshot> getTasksStream() {
    return _tasksRef.orderBy('deadline').snapshots();
  }

  Future<void> addTask(Map<String, dynamic> taskData) async {
    await _tasksRef.add(taskData);
  }

  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await _tasksRef.doc(id).update({'isCompleted': isCompleted});
  }

  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }
}