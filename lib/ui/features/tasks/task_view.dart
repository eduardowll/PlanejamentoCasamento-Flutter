import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_viewmodel.dart';
import '../../../data/models/task_model.dart';
import 'add_task_view.dart'; // Importa a tela de adicionar

class TaskView extends StatelessWidget {
  const TaskView({super.key});

  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF140e1b);
  final Color greenColor = const Color(0xFF22c55e);
  final Color redColor = const Color(0xFFef4444);
  final Color orangeColor = const Color(0xFFf97316);

  @override
  Widget build(BuildContext context) {
    // Scaffold direto, pois o ViewModel é injetado no main.dart
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
        title: Text("Lista de Tarefas", style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: textDark),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskView()));
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
      ),

      body: Consumer<TaskViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          final groups = vm.groupedTasks;
          if (groups.isEmpty) {
            return Center(child: Text("Nenhuma tarefa encontrada.", style: TextStyle(color: textDark)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: groups.keys.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final periodName = groups.keys.elementAt(index);
              final tasks = groups[periodName]!;
              final completedCount = tasks.where((t) => t.isCompleted).length;
              final totalCount = tasks.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(periodName, style: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.task_alt, color: greenColor, size: 20),
                          const SizedBox(width: 4),
                          Text("$completedCount/$totalCount", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, taskIndex) => _buildTaskCard(tasks[taskIndex], vm),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, TaskViewModel vm) {
    Color deadlineColor;
    String deadlineText;
    final days = task.daysRemaining;

    if (task.isCompleted) {
      deadlineColor = greenColor;
      deadlineText = "Concluído";
    } else if (days < 0) {
      deadlineColor = redColor;
      deadlineText = "Atrasado ${days.abs()} dias";
    } else if (days == 0) {
      deadlineColor = orangeColor;
      deadlineText = "Vence Hoje!";
    } else if (days <= 7) {
      deadlineColor = orangeColor;
      deadlineText = "$days dias restantes";
    } else {
      deadlineColor = Colors.grey;
      deadlineText = "Prazo: $days dias";
    }

    return GestureDetector(
      onTap: () => vm.toggleTask(task.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: task.isCompleted ? greenColor : Colors.grey[300], size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: task.isCompleted ? Colors.grey : textDark, decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: deadlineColor),
                      const SizedBox(width: 4),
                      Text(deadlineText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: deadlineColor)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}