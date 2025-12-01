import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';
import 'package:planejamento_casamento/ui/common/widgets/custom_text_field.dart';
import 'package:planejamento_casamento/ui/common/widgets/primary_button.dart';
import 'task_viewmodel.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});
  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  final List<String> _categories = [
    '12-9 Meses Antes', '8-6 Meses Antes', '5-4 Meses Antes', '3-1 Meses Antes', 'Semana do Casamento', 'Dia do Casamento'
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary, onPrimary: AppColors.surface, onSurface: AppColors.textDark)), child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _saveTask() {
    if (_titleController.text.isEmpty || _selectedDate == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preencha todos os campos!")));
      return;
    }
    context.read<TaskViewModel>().addTask(_titleController.text, _selectedDate!, _selectedCategory!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: () => Navigator.pop(context)),
        title: const Text("Adicionar Nova Tarefa", style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(controller: _titleController, label: "Título da Tarefa", hint: "Ex: Contratar fotógrafo"),
            const SizedBox(height: 24),
            CustomTextField(controller: _dateController, label: "Data Limite", hint: "DD/MM/AAAA", readOnly: true, onTap: _pickDate, suffixIcon: Icons.calendar_today),
            const SizedBox(height: 24),
            const Text("Categoria", style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                hintText: "Selecione", filled: true, fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightGrey)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              ),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: PrimaryButton(label: "Salvar Tarefa", onPressed: _saveTask),
      ),
    );
  }
}
