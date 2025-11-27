import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final Color primaryColor = const Color(0xFF8c30e8);
  final Color textDark = const Color(0xFF140e1b);

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
        return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: primaryColor, onPrimary: Colors.white, onSurface: textDark)), child: child!);
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
      backgroundColor: const Color(0xFFf7f6f8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf7f6f8), elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: textDark), onPressed: () => Navigator.pop(context)),
        title: Text("Adicionar Nova Tarefa", style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Título da Tarefa", style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(controller: _titleController, decoration: _inputDec("Ex: Contratar fotógrafo")),
            const SizedBox(height: 24),
            Text("Data Limite", style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(controller: _dateController, readOnly: true, onTap: _pickDate, decoration: _inputDec("DD/MM/AAAA").copyWith(suffixIcon: Icon(Icons.calendar_today, color: primaryColor))),
            const SizedBox(height: 24),
            Text("Categoria", style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _inputDec("Selecione"),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(height: 56, child: ElevatedButton(onPressed: _saveTask, style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Salvar Tarefa", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
      ),
    );
  }

  InputDecoration _inputDec(String hint) {
    return InputDecoration(
      hintText: hint, filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: const Color(0xFF8c30e8), width: 2)),
    );
  }
}