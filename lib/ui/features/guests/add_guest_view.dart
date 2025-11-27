import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'guest_viewmodel.dart';

class AddGuestView extends StatefulWidget {
  const AddGuestView({super.key});

  @override
  State<AddGuestView> createState() => _AddGuestViewState();
}

class _AddGuestViewState extends State<AddGuestView> {
  // Controladores e Variáveis de Estado
  final _nameController = TextEditingController();
  String _status = 'Pendente'; // Valor padrão
  int _companions = 0; // Valor padrão

  // Cores do Design (Extraídas do seu HTML)
  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFfaf8fc);
  final Color textDark = const Color(0xFF140e1b);
  final Color surfaceLight = const Color(0xFFede7f3);
  final Color textSecondary = const Color(0xFF734e97);
  final Color borderLight = const Color(0xFFdbd0e7);

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

    // Converte o status String para bool
    final isConfirmed = _status == 'Confirmado';

    // Chama o ViewModel para salvar no Firebase
    context.read<GuestViewModel>().addGuest(
        name,
        _companions,
        isConfirmed
    );

    Navigator.pop(context); // Fecha a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Adicionar Novo Convidado",
            style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. NOME DO CONVIDADO
            Text("Nome do convidado",
                style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Ex: Maria Silva",
                hintStyle: TextStyle(color: textSecondary.withOpacity(0.7)),
                filled: true,
                fillColor: bgLight,
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. STATUS DA CONFIRMAÇÃO (Toggle)
            Center(
              child: Text("Status da Confirmação",
                  style: TextStyle(color: textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: surfaceLight,
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

            // 3. ACOMPANHANTES (Contador)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: surfaceLight, borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.group, color: textDark),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Acompanhantes (Opcional)",
                            style: TextStyle(color: textDark, fontSize: 16, fontWeight: FontWeight.w500)),
                        Text("Quantas pessoas virão junto?",
                            style: TextStyle(color: textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                // Botões + e -
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
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

      // --- BOTÃO SALVAR ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _saveGuest,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: primaryColor.withOpacity(0.4),
            ),
            child: const Text("Salvar Convidado",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildToggleOption(String label) {
    final isSelected = _status == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _status = label),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? bgLight : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)] : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? textDark : textSecondary,
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
        decoration: BoxDecoration(
          color: surfaceLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: isPrimary ? primaryColor : textSecondary),
      ),
    );
  }
}