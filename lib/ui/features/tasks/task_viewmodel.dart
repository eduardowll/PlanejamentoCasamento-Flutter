import 'package:flutter/material.dart';
import '../../../data/models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  // Dados Mockados com datas dinâmicas para teste
  final List<TaskModel> _tasks = [
    // --- 12-9 Meses (Prazos longos) ---
    TaskModel(
      id: '1',
      period: '12-9 Meses Antes',
      title: 'Definir orçamento',
      isCompleted: true,
      deadline: DateTime.now().add(const Duration(days: 200)), // Faltam 200 dias
    ),
    TaskModel(
      id: '2',
      period: '12-9 Meses Antes',
      title: 'Montar lista de convidados',
      isCompleted: false,
      deadline: DateTime.now().add(const Duration(days: 5)), // URGENTE: Faltam 5 dias
    ),

    // --- 8-6 Meses ---
    TaskModel(
      id: '5',
      period: '8-6 Meses Antes',
      title: 'Contratar fotógrafo',
      isCompleted: false,
      deadline: DateTime.now().subtract(const Duration(days: 2)), // ATRASADO: -2 dias
    ),
    TaskModel(
      id: '6',
      period: '8-6 Meses Antes',
      title: 'Contratar buffet',
      isCompleted: true,
      deadline: DateTime.now().add(const Duration(days: 45)),
    ),

    // --- 5-4 Meses ---
    TaskModel(
      id: '8',
      period: '5-4 Meses Antes',
      title: 'Enviar Save the Date',
      isCompleted: false,
      deadline: DateTime.now().add(const Duration(days: 15)), // Atenção: 15 dias
    ),
  ];

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

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }
}