import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Atenção: Use um ID fixo para testes ou o ID do usuário logado (FirebaseAuth)
  // Como é MVP sem login complexo, vamos usar um ID fixo "user_default"
  CollectionReference get _tasksRef =>
      _db.collection('users').doc('user_default').collection('tasks');

  // Ler Tarefas (Stream em tempo real)
  Stream<QuerySnapshot> getTasksStream() {
    // Ordena pela data de prazo
    return _tasksRef.orderBy('deadline').snapshots();
  }

  // Adicionar Tarefa
  Future<void> addTask(Map<String, dynamic> taskData) async {
    await _tasksRef.add(taskData);
  }

  // Atualizar Status (Check/Uncheck)
  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await _tasksRef.doc(id).update({'isCompleted': isCompleted});
  }

  // Deletar
  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }
}