import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_viewmodel.dart';
import '../guests/guest_view.dart'; // Tela de Convidados
import '../budget/budget_view.dart'; // Tela de Orçamento
import '../tasks/task_view.dart';    // <--- IMPORT NOVO: Tela de Tarefas
import '../vendors/vendor_view.dart'; // Tela de Fornecedores

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // Índice da navegação inferior
  int _selectedIndex = 0;

  // Cores do Design
  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF140e1b);

  // Lista de Telas para o BottomNav
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardContent(), // 0: Home (Dashboard)
      const TaskView(),         // 1: <--- AGORA SIM: A TELA DE TAREFAS APARECE AQUI
      const Center(child: Text("Agenda (Em breve)")), // 2: Agenda
      const GuestView(),        // 3: Convidados (Perfil)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: _pages[_selectedIndex], // Troca o corpo conforme o ícone clicado
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: BottomNavigationBar(
          backgroundColor: bgLight.withOpacity(0.9),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tarefas'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Convidados'),
          ],
        ),
      ),
    );
  }
}

// --- CONTEÚDO DO DASHBOARD (Widgets internos da Home) ---

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF140e1b);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.favorite, color: textDark),
                  Text(
                    "Maria & João",
                    style: TextStyle(
                        color: textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // COUNTDOWN TIMER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _buildCountdownItem(vm.timeRemaining.inDays.toString(), "Dias", false),
                  const SizedBox(width: 8),
                  _buildCountdownItem((vm.timeRemaining.inHours % 24).toString(), "Horas", false),
                  const SizedBox(width: 8),
                  _buildCountdownItem((vm.timeRemaining.inMinutes % 60).toString(), "Minutos", false),
                  const SizedBox(width: 8),
                  _buildCountdownItem((vm.timeRemaining.inSeconds % 60).toString().padLeft(2, '0'), "Segundos", true),
                ],
              ),
            ),

            // PROGRESS BAR
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Progresso Geral", style: TextStyle(color: textDark, fontWeight: FontWeight.w500)),
                      Text("${(vm.overallProgress * 100).toInt()}%", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: vm.overallProgress,
                    backgroundColor: Colors.grey[200],
                    color: primaryColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),

            // STATS CARDS (Clicáveis)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildInfoCard(context, "Orçamento", "R\$${vm.budgetSpent} / R\$${vm.budgetTotal}"),
                  _buildInfoCard(context, "Convidados", "${vm.guestConfirmed} / ${vm.guestTotal}"),
                  _buildInfoCard(context, "Fornecedores", "${vm.vendorsHired} / ${vm.vendorsTotal} Contratados", fullWidth: true),
                ],
              ),
            ),

            // UPCOMING TASKS SECTION (Resumo na Home)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Próximos Passos",
                style: TextStyle(color: textDark, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildTaskItem(Icons.mail, "Enviar Convites", "Prazo: 15 de Outubro"),
                  const SizedBox(height: 12),
                  _buildTaskItem(Icons.restaurant, "Degustação do Buffet", "Agendado para amanhã"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildCountdownItem(String value, String label, bool isPrimary) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: isPrimary ? primaryColor.withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isPrimary ? primaryColor : textDark,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Card Clicável com Navegação
  Widget _buildInfoCard(BuildContext context, String title, String value, {bool fullWidth = false}) {
    return GestureDetector(
      onTap: () {
        if (title == "Orçamento") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetView()));
        } else if (title == "Fornecedores") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorView()));
        } else if (title == "Convidados") {
          // Opcional: Ir para a tab de convidados ou abrir tela cheia
          Navigator.push(context, MaterialPageRoute(builder: (_) => const GuestView()));
        }
      },
      child: Container(
        width: fullWidth ? double.infinity : null,
        constraints: fullWidth ? null : const BoxConstraints(minWidth: 150, maxWidth: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textDark, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            height: 40, width: 40,
            decoration: BoxDecoration(color: primaryColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textDark, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}