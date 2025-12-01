import 'package:flutter/material.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';
import 'package:planejamento_casamento/ui/common/widgets/custom_text_field.dart';
import 'package:planejamento_casamento/ui/common/widgets/primary_button.dart';
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
  bool _isPaid = true;

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
    final amountStr = _amountController.text.replaceAll(',', '.');
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLighter,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Adicionar Nova Despesa",
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _titleController,
              label: "Título da Despesa",
              hint: "Ex: Bolo do casamento",
            ),
            const SizedBox(height: 24),

            CustomTextField(
              controller: _amountController,
              label: "Valor (R\$)",
              hint: "0,00",
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixText: "R\$ ",
            ),
            const SizedBox(height: 24),

            _buildLabel("Categoria"),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _inputDecoration("Selecione uma categoria"),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 24),

            _buildLabel("Status do Pagamento"),
            Row(
              children: [
                Expanded(child: _buildStatusButton("Pendente", false, AppColors.orange, Icons.hourglass_top)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatusButton("Pago", true, AppColors.green, Icons.check_circle)),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surfaceLighter,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: PrimaryButton(
          label: "Salvar Despesa",
          onPressed: _saveExpense,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textHint),
      filled: true,
      fillColor: AppColors.surfaceLighter,
      contentPadding: const EdgeInsets.all(16),
      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: AppColors.border)),
      enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: AppColors.border)),
      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: AppColors.primary, width: 2)),
    );
  }

  Widget _buildStatusButton(String label, bool value, Color color, IconData icon) {
    final isSelected = _isPaid == value;
    return GestureDetector(
      onTap: () => setState(() => _isPaid = value),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.surfaceLighter,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 2 : 1
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : AppColors.textGrey),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                  color: isSelected ? color : AppColors.textDark,
                  fontWeight: FontWeight.w600,
                )
            ),
          ],
        ),
      ),
    );
  }
}