import 'package:flutter/material.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';
import 'package:planejamento_casamento/ui/common/widgets/custom_text_field.dart';
import 'package:planejamento_casamento/ui/common/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import 'guest_viewmodel.dart';

class AddGuestView extends StatefulWidget {
  const AddGuestView({super.key});

  @override
  State<AddGuestView> createState() => _AddGuestViewState();
}

class _AddGuestViewState extends State<AddGuestView> {
  final _nameController = TextEditingController();
  String _status = 'Pendente';
  int _companions = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveGuest() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite o nome do convidado!")),
      );
      return;
    }
    final isConfirmed = _status == 'Confirmado';
    context.read<GuestViewModel>().addGuest(name, _companions, isConfirmed);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Adicionar Novo Convidado",
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _nameController,
              label: "Nome do convidado",
              hint: "Ex: Maria Silva",
            ),
            const SizedBox(height: 24),

            const Center(
              child: Text("Status da Confirmação",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildToggleOption("Confirmado"),
                  _buildToggleOption("Pendente"),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.group, color: AppColors.textDark),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Acompanhantes (Opcional)",
                            style: TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w500)),
                        Text("Quantas pessoas virão junto?",
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildCounterButton(Icons.remove, () {
                      if (_companions > 0) setState(() => _companions--);
                    }),
                    SizedBox(
                      width: 40,
                      child: Text(
                        _companions.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ),
                    _buildCounterButton(Icons.add, () {
                      setState(() => _companions++);
                    }, isPrimary: true),
                  ],
                )
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          label: "Salvar Convidado",
          onPressed: _saveGuest,
        ),
      ),
    );
  }

  Widget _buildToggleOption(String label) {
    final isSelected = _status == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _status = label),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.background : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)] : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.textDark : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: isPrimary ? AppColors.primary : AppColors.textSecondary),
      ),
    );
  }
}
