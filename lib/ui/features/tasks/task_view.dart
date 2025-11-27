import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_viewmodel.dart';
import '../../../data/models/task_model.dart';

class TaskView extends StatelessWidget {
  const TaskView({super.key});

  // Paleta de Cores do Design
  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF140e1b);
  final Color greenColor = const Color(0xFF22c55e); // Verde para concluído
  final Color redColor = const Color(0xFFef4444);   // Vermelho para atrasado
  final Color orangeColor = const Color(0xFFf97316); // Laranja para urgente

  @override
  Widget build(BuildContext context) {
    // Injetando o ViewModel exclusivo desta tela
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel(),
      child: Scaffold(
        backgroundColor: bgLight,
        // --- HEADER / APP BAR ---
        appBar: AppBar(
          backgroundColor: bgLight,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            child: IconButton(
              // Ícone estilizado igual ao HTML
              icon: Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
              onPressed: () {
                // Tenta voltar se possível (caso tenha vindo de outra tela)
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          title: Text("Lista de Tarefas", style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle, color: textDark),
              onPressed: () {
                // Futuramente abre modal de adicionar tarefa
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey[300], height: 1),
          ),
        ),

        // --- BODY (LISTA AGRUPADA) ---
        body: Consumer<TaskViewModel>(
          builder: (context, vm, child) {
            final groups = vm.groupedTasks;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: groups.keys.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final periodName = groups.keys.elementAt(index);
                final tasks = groups[periodName]!;

                // Contadores para o cabeçalho (Ex: 2/4)
                final completedCount = tasks.where((t) => t.isCompleted).length;
                final totalCount = tasks.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TÍTULO DA SEÇÃO (Ex: 12-9 Meses Antes)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          periodName,
                          style: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        // Badge contador (ícone check + 2/4)
                        Row(
                          children: [
                            Icon(Icons.task_alt, color: greenColor, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              "$completedCount/$totalCount",
                              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 12),

                    // LISTA DE TAREFAS DENTRO DESTA SEÇÃO
                    ListView.separated(
                      shrinkWrap: true, // Necessário para funcionar dentro de outro ListView
                      physics: const NeverScrollableScrollPhysics(), // Scroll controlado pelo pai
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, taskIndex) {
                        final task = tasks[taskIndex];
                        return _buildTaskCard(task, vm);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // --- CARD DA TAREFA COM LÓGICA DE PRAZO ---
  Widget _buildTaskCard(TaskModel task, TaskViewModel vm) {
    // 1. Determina a cor e o texto baseados no prazo
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

    // 2. Constrói o visual do Card
    return GestureDetector(
      onTap: () => vm.toggleTask(task.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          // Sombra suave para destacar se for urgente (opcional)
          boxShadow: !task.isCompleted && days <= 0
              ? [BoxShadow(color: redColor.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          children: [
            // Ícone Checkbox
            Icon(
              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: task.isCompleted ? greenColor : Colors.grey[300],
              size: 28,
            ),
            const SizedBox(width: 12),

            // Textos (Título + Prazo)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: task.isCompleted ? Colors.grey : textDark,
                      // Risca o texto se completou
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Badge do Prazo
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: deadlineColor),
                      const SizedBox(width: 4),
                      Text(
                        deadlineText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: deadlineColor,
                        ),
                      ),
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