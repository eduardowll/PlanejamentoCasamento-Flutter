import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../gallery/gallery_view.dart';
import 'dashboard_viewmodel.dart';
import '../guests/guest_view.dart';
import '../budget/budget_view.dart';
import '../tasks/task_view.dart';
import '../vendors/vendor_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF140e1b);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardContent(), // Home
      const TaskView(),         // Tarefas
      const GalleryView(), // Galeria
      const GuestView(),        // Convidados
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[200]!))),
        child: BottomNavigationBar(
          backgroundColor: bgLight.withOpacity(0.9), elevation: 0, type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex, selectedItemColor: primaryColor, unselectedItemColor: Colors.grey, showUnselectedLabels: true,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tarefas'),
            BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: 'Galeria'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Convidados'),
          ],
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  final Color primaryColor = const Color(0xFF8c30e8);
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.favorite, color: textDark),
                  Text("Maria & João", style: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                _count(vm.timeRemaining.inDays.toString(), "Dias", false), const SizedBox(width: 8),
                _count((vm.timeRemaining.inHours % 24).toString(), "Horas", false), const SizedBox(width: 8),
                _count((vm.timeRemaining.inMinutes % 60).toString(), "Minutos", false), const SizedBox(width: 8),
                _count((vm.timeRemaining.inSeconds % 60).toString().padLeft(2, '0'), "Segundos", true),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Progresso Geral", style: TextStyle(color: textDark, fontWeight: FontWeight.w500)),
                  Text("${(vm.overallProgress * 100).toInt()}%", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: vm.overallProgress, backgroundColor: Colors.grey[200], color: primaryColor, minHeight: 8, borderRadius: BorderRadius.circular(4)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(spacing: 12, runSpacing: 12, children: [
                _card(context, "Orçamento", "R\$${vm.budgetSpent} / R\$${vm.budgetTotal}"),
                _card(context, "Convidados", "${vm.guestConfirmed} / ${vm.guestTotal}"),
                _card(context, "Fornecedores", "${vm.vendorsHired} / ${vm.vendorsTotal} Contratados", fullWidth: true),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text("Próximos Passos", style: TextStyle(color: textDark, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: vm.urgentTasks.isEmpty ? _empty() : Column(children: vm.urgentTasks.map((t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _taskItem(t))).toList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _count(String v, String l, bool p) => Expanded(child: Column(children: [Container(height: 64, decoration: BoxDecoration(color: p ? primaryColor.withOpacity(0.2) : Colors.white, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: Text(v, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: p ? primaryColor : textDark))), const SizedBox(height: 8), Text(l, style: const TextStyle(fontSize: 12, color: Colors.grey))]));

  Widget _card(BuildContext context, String t, String v, {bool fullWidth = false}) => GestureDetector(onTap: () {
    if (t == "Orçamento") Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetView()));
    if (t == "Fornecedores") Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorView()));
    if (t == "Convidados") Navigator.push(context, MaterialPageRoute(builder: (_) => const GuestView()));
  }, child: Container(width: fullWidth ? double.infinity : null, constraints: fullWidth ? null : const BoxConstraints(minWidth: 150, maxWidth: 180), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: TextStyle(color: textDark, fontWeight: FontWeight.w500)), const SizedBox(height: 8), Text(v, style: TextStyle(color: textDark, fontSize: 18, fontWeight: FontWeight.bold))])));

  Widget _empty() => Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)), child: const Center(child: Text("Tudo em dia! Nenhuma tarefa urgente.", style: TextStyle(color: Colors.grey))));

  Widget _taskItem(dynamic t) {
    final d = t.daysRemaining;
    String dt = d < 0 ? "Atrasado ${d.abs()} dias!" : (d == 0 ? "Hoje!" : (d == 1 ? "Amanhã" : "Prazo: ${t.deadline.day}/${t.deadline.month}"));
    Color c = d <= 0 ? (d < 0 ? Colors.red : Colors.orange) : Colors.grey;
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)), child: Row(children: [Container(height: 40, width: 40, decoration: BoxDecoration(color: primaryColor.withOpacity(0.15), shape: BoxShape.circle), child: Icon(Icons.event_note, color: primaryColor, size: 20)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.title, style: TextStyle(color: textDark, fontWeight: FontWeight.w600, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Text(dt, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w500))]))]));
  }
}