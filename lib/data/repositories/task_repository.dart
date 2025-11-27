import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskRepository {
  final TaskService _service;

  TaskRepository(this._service);

  // Retorna lista limpa de Tarefas para o ViewModel
  Stream<List<TaskModel>> getTasks() {
    return _service.getTasksStream().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> addNewTask(String title, DateTime date, String period) async {
    final newTaskMap = {
      'title': title,
      'deadline': date, // O Service converte pra Timestamp no toMap se usarmos o model, ou direto aqui
      'period': period,
      'isCompleted': false,
    };
    // No Service ajustamos pra receber map, mas podemos instanciar model aqui
    // Simplificando:
    final model = TaskModel(
        id: '',
        title: title,
        period: period,
        deadline: date
    );
    await _service.addTask(model.toMap());
  }

  Future<void> toggleTask(String id, bool currentStatus) async {
    await _service.updateTaskStatus(id, !currentStatus);
  }
}