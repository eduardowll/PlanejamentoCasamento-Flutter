import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  List<TaskModel> _tasks = [];
  bool isLoading = true;

  TaskViewModel(this._repository) {
    _init();
  }

  void _init() {
    _repository.getTasks().listen((data) {
      _tasks = data;
      isLoading = false;
      notifyListeners();
    });
  }

  Map<String, List<TaskModel>> get groupedTasks {
    Map<String, List<TaskModel>> groups = {};
    for (var task in _tasks) {
      if (!groups.containsKey(task.period)) {
        groups[task.period] = [];
      }
      groups[task.period]!.add(task);
    }
    return groups;
  }

  Future<void> toggleTask(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    await _repository.toggleTask(id, task.isCompleted);
  }

  Future<void> addTask(String title, DateTime date, String period) async {
    await _repository.addNewTask(title, date, period);
  }
}