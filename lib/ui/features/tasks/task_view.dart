import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';
import 'package:planejamento_casamento/ui/common/widgets/task_card.dart';
import 'task_viewmodel.dart';
import '../../../data/models/task_model.dart';
import 'add_task_view.dart';

class TaskView extends StatelessWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
        title: const Text("Lista de Tarefas", style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppColors.textDark),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskView()));
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.lightGrey, height: 1),
        ),
      ),

      body: Consumer<TaskViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          final groups = vm.groupedTasks;
          if (groups.isEmpty) {
            return const Center(child: Text("Nenhuma tarefa encontrada.", style: TextStyle(color: AppColors.textDark)));
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
                      Text(periodName, style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.task_alt, color: AppColors.green, size: 20),
                          const SizedBox(width: 4),
                          Text("$completedCount/$totalCount", style: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600)),
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
                    itemBuilder: (context, taskIndex) => TaskCard(task: tasks[taskIndex], onTap: () => vm.toggleTask(tasks[taskIndex].id)),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
