import 'package:flutter/material.dart';
import 'package:planejamento_casamento/ui/common/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:planejamento_casamento/ui/common/widgets/stat_card.dart';
import 'guest_viewmodel.dart';
import '../../../data/models/guest_model.dart';
import 'add_guest_view.dart';

class GuestView extends StatelessWidget {
  const GuestView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GuestViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: const Text(
          'Lista de Convidados',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppColors.textDark), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list, color: AppColors.textDark), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.lightGrey, height: 1.0),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Total',
                          value: viewModel.totalGuests.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Confirmados',
                          value: viewModel.confirmedGuests.toString(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          label: 'Pendentes',
                          value: viewModel.pendingGuests.toString(),
                        ),
                      ),
                    ],
                  ),
                ),

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
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
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

  Widget _buildGuestItem(BuildContext context, GuestModel guest, GuestViewModel vm) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  guest.name.isNotEmpty ? guest.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guest.name, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 16)),
                  Text(
                    guest.companions > 0 ? "+ ${guest.companions} acompanhantes" : "Convidado",
                    style: const TextStyle(color: AppColors.guestIcon, fontSize: 14),
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
                  color: guest.isConfirmed ? AppColors.guestConfirmedBg : AppColors.guestPendingBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: guest.isConfirmed ? AppColors.green : AppColors.orange, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(
                      guest.isConfirmed ? "Confirmado" : "Pendente",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: guest.isConfirmed ? AppColors.guestConfirmedLabel : AppColors.guestPendingLabel,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.guestIcon),
                onPressed: () => vm.toggleConfirmation(guest),
              ),
            ],
          )
        ],
      ),
    );
  }
}
