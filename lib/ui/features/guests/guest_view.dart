import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'guest_viewmodel.dart';
import '../../../data/models/guest_model.dart';

class GuestView extends StatelessWidget {
  const GuestView({super.key});

  // Cores extraídas do seu Tailwind config
  final Color primaryColor = const Color(0xFF8c30e8);
  final Color bgLight = const Color(0xFFf7f6f8);
  final Color textDark = const Color(0xFF191121);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GuestViewModel>();

    return Scaffold(
      backgroundColor: bgLight,
      // --- HEADER (Igual ao <header> do HTML) ---
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () {}, // Navegação voltar
        ),
        title: Text(
          'Lista de Convidados',
          style: TextStyle(
              color: textDark,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.search, color: textDark), onPressed: () {}),
          IconButton(icon: Icon(Icons.filter_list, color: textDark), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0), // Borda inferior
        ),
      ),

      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // --- STATS CARDS (Igual à div de Stats) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Card Total
                _buildStatCard(
                  label: 'Total',
                  count: viewModel.totalGuests.toString(),
                  textColor: Colors.pink[900]!, // Simulando Zinc
                  bgColor: Colors.grey[200]!,
                  labelColor: Colors.grey[600]!,
                ),
                const SizedBox(width: 12),
                // Card Confirmados
                _buildStatCard(
                  label: 'Confirmados',
                  count: viewModel.confirmedGuests.toString(),
                  textColor: Colors.green[900]!,
                  bgColor: Colors.green.withOpacity(0.1),
                  labelColor: Colors.green[800]!,
                ),
                const SizedBox(width: 12),
                // Card Pendentes
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

          // --- LISTA DE CONVIDADOS ---
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 80), // Espaço para o FAB
              itemCount: viewModel.guests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 1), // Divisória sutil
              itemBuilder: (context, index) {
                final guest = viewModel.guests[index];
                return _buildGuestItem(context, guest, viewModel);
              },
            ),
          ),
        ],
      ),

      // --- FLOATING ACTION BUTTON (Botão Roxo) ---
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          shape: const CircleBorder(),
          onPressed: () => _showAddDialog(context, viewModel),
          child: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
    );
  }

  // Widget auxiliar para os Cards do topo
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
          borderRadius: BorderRadius.circular(12), // rounded-xl
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12, // text-sm
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 24, // text-2xl
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para cada item da lista (replicando o HTML)
  Widget _buildGuestItem(BuildContext context, GuestModel guest, GuestViewModel vm) {
    return Container(
      color: bgLight, // Background light
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Esquerda: Avatar + Textos
          Row(
            children: [
              // Avatar (Placeholder com inicial)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                  // Aqui você pode colocar NetworkImage se tiver URL
                ),
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
                  Text(
                    guest.name,
                    style: TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Convidado", // Subtítulo fixo por enquanto
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Direita: Status Badge + Menu
          Row(
            children: [
              // Badge (Pill shape)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: guest.isConfirmed
                      ? Colors.green.withOpacity(0.1)
                      : Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: guest.isConfirmed ? Colors.green : Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      guest.isConfirmed ? "Confirmado" : "Pendente",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: guest.isConfirmed ? Colors.green[800] : Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Botão de Opções (Menu)
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey[500]),
                onPressed: () {
                  // Ação rápida: Trocar status ao clicar no menu (apenas exemplo)
                  vm.toggleConfirmation(guest);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  // Dialog para adicionar novo convidado
  void _showAddDialog(BuildContext context, GuestViewModel vm) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Convidado'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome do convidado'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              vm.addGuest(controller.text);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

// Extensão rápida para simular cores do Tailwind Zinc
extension ZincColors on Colors {
  static const zinc = Colors.grey; // Simplificação para o padrão Material
}