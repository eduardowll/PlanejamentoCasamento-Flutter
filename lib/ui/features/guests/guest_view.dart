import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'guest_viewmodel.dart';
import '../../../data/models/guest_model.dart';
import 'add_guest_view.dart'; // <--- IMPORTANTE: Importe a tela de adicionar

class GuestView extends StatelessWidget {
  const GuestView({super.key});

  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF191121);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GuestViewModel>();

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: Text(
          'Lista de Convidados',
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.search, color: textDark), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list, color: textDark), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),
      ),

      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // --- STATS CARDS ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStatCard(
                  label: 'Total',
                  count: viewModel.totalGuests.toString(),
                  textColor: Colors.pink[900]!,
                  bgColor: Colors.grey[200]!,
                  labelColor: Colors.grey[600]!,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  label: 'Confirmados',
                  count: viewModel.confirmedGuests.toString(),
                  textColor: Colors.green[900]!,
                  bgColor: Colors.green.withOpacity(0.1),
                  labelColor: Colors.green[800]!,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  label: 'Pendentes',
                  count: viewModel.pendingGuests.toString(),
                  textColor: Colors.amber[900]!,
                  bgColor: Colors.amber.withOpacity(0.1),
                  labelColor: Colors.amber[800]!,
                ),
              ],
            ),
          ),

          // --- LISTA ---
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: viewModel.guests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                final guest = viewModel.guests[index];
                return _buildGuestItem(context, guest, viewModel);
              },
            ),
          ),
        ],
      ),

      // --- CORREÇÃO AQUI: Navega para a tela AddGuestView ---
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddGuestView()),
            );
          },
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String count,
    required Color textColor,
    required Color bgColor,
    required Color labelColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: labelColor)),
            const SizedBox(height: 8),
            Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestItem(BuildContext context, GuestModel guest, GuestViewModel vm) {
    return Container(
      color: bgLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  guest.name.isNotEmpty ? guest.name[0].toUpperCase() : '?',
                  style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guest.name, style: TextStyle(color: textDark, fontWeight: FontWeight.w600, fontSize: 16)),
                  // Mostra acompanhantes se houver
                  Text(
                    guest.companions > 0 ? "+ ${guest.companions} acompanhantes" : "Convidado",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: guest.isConfirmed ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: guest.isConfirmed ? Colors.green : Colors.amber, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(
                      guest.isConfirmed ? "Confirmado" : "Pendente",
                      style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500,
                        color: guest.isConfirmed ? Colors.green[800] : Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey[500]),
                onPressed: () => vm.toggleConfirmation(guest),
              ),
            ],
          )
        ],
      ),
    );
  }
}