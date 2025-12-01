import 'package:flutter/material.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';
import 'package:planejamento_casamento/ui/common/widgets/task_card.dart';
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
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardContent(),
      const TaskView(),
      const GalleryView(),
      const GuestView(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))),
        child: BottomNavigationBar(
          backgroundColor: AppColors.background.withOpacity(0.9),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textGrey,
          showUnselectedLabels: true,
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
                  Icon(Icons.favorite, color: AppColors.textDark),
                  Text("Maria & João", style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                _count(vm.timeRemaining.inDays.toString(), "Dias", false),
                const SizedBox(width: 8),
                _count((vm.timeRemaining.inHours % 24).toString(), "Horas", false),
                const SizedBox(width: 8),
                _count((vm.timeRemaining.inMinutes % 60).toString(), "Minutos", false),
                const SizedBox(width: 8),
                _count((vm.timeRemaining.inSeconds % 60).toString().padLeft(2, '0'), "Segundos", true),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text("Progresso Geral", style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500)),
                  Text("${(vm.overallProgress * 100).toInt()}%", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                    value: vm.overallProgress, backgroundColor: AppColors.borderLight, color: AppColors.primary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
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
              child: Text("Próximos Passos", style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: vm.urgentTasks.isEmpty
                  ? _empty()
                  : Column(
                      children: vm.urgentTasks
                          .map((t) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TaskCard(task: t, onTap: () {}), // <-- Usando o novo widget!
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _count(String v, String l, bool p) => Expanded(
          child: Column(children: [
        Container(
            height: 64,
            decoration: BoxDecoration(color: p ? AppColors.primary.withOpacity(0.2) : AppColors.surface, borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Text(v, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: p ? AppColors.primary : AppColors.textDark))),
        const SizedBox(height: 8),
        Text(l, style: const TextStyle(fontSize: 12, color: AppColors.textGrey))
      ]));

  Widget _card(BuildContext context, String t, String v, {bool fullWidth = false}) => GestureDetector(
      onTap: () {
        if (t == "Orçamento") Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetView()));
        if (t == "Fornecedores") Navigator.push(context, MaterialPageRoute(builder: (_) => const VendorView()));
        if (t == "Convidados") Navigator.push(context, MaterialPageRoute(builder: (_) => const GuestView()));
      },
      child: Container(
          width: fullWidth ? double.infinity : null,
          constraints: fullWidth ? null : const BoxConstraints(minWidth: 150, maxWidth: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t, style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(v, style: TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold))
          ])));

  Widget _empty() => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: const Center(child: Text("Tudo em dia! Nenhuma tarefa urgente.", style: TextStyle(color: AppColors.textGrey))));

}
