import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskRepository {
  final TaskService _service;

  TaskRepository(this._service);

  Stream<List<TaskModel>> getTasks() {
    return _service.getTasksStream().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> addNewTask(String title, DateTime date, String period) async {
    final newTaskMap = {
      'title': title,
      'deadline': date,
      'period': period,
      'isCompleted': false,
    };
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