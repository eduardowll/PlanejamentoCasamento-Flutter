import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'budget_viewmodel.dart';

class AddExpenseView extends StatefulWidget {
  const AddExpenseView({super.key});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String? _selectedCategory;
  bool _isPaid = true; // Padrão: Pago (como no HTML)

  // Cores do Design
  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color surfaceLight = const Color(0xFFfaf8fc);
  final Color textDark = const Color(0xFF140e1b);
  final Color borderLight = const Color(0xFFdbd0e7);
  final Color greenColor = const Color(0xFF22c55e);
  final Color orangeColor = const Color(0xFFf97316);

  final List<String> _categories = [
    'Buffet', 'Música', 'Decoração', 'Fotografia', 'Vestuário', 'Outros'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final title = _titleController.text.trim();
    final amountStr = _amountController.text.replaceAll(',', '.'); // Aceita vírgula
    final amount = double.tryParse(amountStr);

    if (title.isEmpty || amount == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente!")),
      );
      return;
    }

    context.read<BudgetViewModel>().addExpense(
        title,
        _selectedCategory!,
        amount,
        _isPaid
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: surfaceLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Adicionar Nova Despesa",
            style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderLight, height: 1),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. TÍTULO
            _buildLabel("Título da Despesa"),
            TextField(
              controller: _titleController,
              decoration: _inputDecoration("Ex: Bolo do casamento"),
            ),
            const SizedBox(height: 24),

            // 2. VALOR
            _buildLabel("Valor (R\$)"),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration("0,00").copyWith(
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Text("R\$", style: TextStyle(fontSize: 16, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. CATEGORIA
            _buildLabel("Categoria"),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _inputDecoration("Selecione uma categoria"),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 24),

            // 4. STATUS PAGAMENTO
            _buildLabel("Status do Pagamento"),
            Row(
              children: [
                Expanded(child: _buildStatusButton("Pendente", false, orangeColor, Icons.hourglass_top)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatusButton("Pago", true, greenColor, Icons.check_circle)),
              ],
            ),
          ],
        ),
      ),

      // --- FOOTER ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceLight,
          border: Border(top: BorderSide(color: borderLight)),
        ),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _saveExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text("Salvar Despesa",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: surfaceLight,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderLight)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderLight)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
    );
  }

  Widget _buildStatusButton(String label, bool value, Color color, IconData icon) {
    final isSelected = _isPaid == value;
    return GestureDetector(
      onTap: () => setState(() => _isPaid = value),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected ? color : borderLight,
              width: isSelected ? 2 : 1
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                  color: isSelected ? color : textDark,
                  fontWeight: FontWeight.w600,
                )
            ),
          ],
        ),
      ),
    );
  }
}