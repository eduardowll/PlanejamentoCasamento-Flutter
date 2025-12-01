import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/app_colors.dart';
import '../../common/widgets/primary_button.dart';
import '../../common/widgets/review_list_item.dart';
import '../../common/widgets/vendor_status_badge.dart';
import './vendor_viewmodel.dart';
import 'vendor_details_viewmodel.dart';
import '../../../data/models/vendor_model.dart';

class VendorDetailsView extends StatelessWidget {
  final VendorModel vendor;

  const VendorDetailsView({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    final vendorViewModel = Provider.of<VendorViewModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => VendorDetailsViewModel(vendor: vendor, vendorViewModel: vendorViewModel),
      child: Consumer<VendorDetailsViewModel>(
        builder: (context, vm, child) {
          final isHired = vm.vendor.status == VendorStatus.hired;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(vendor.name, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
              centerTitle: true,
              actions: [
                IconButton(icon: const Icon(Icons.more_vert, color: AppColors.textDark), onPressed: () {}),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: AppColors.border, height: 1),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.5))),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vm.vendor.name, style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(vm.vendor.category, style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
                              ],
                            ),
                            VendorStatusBadge(status: vm.vendor.status),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 24,
                            runSpacing: 8,
                            children: [
                              _buildContactItem(Icons.call, vm.vendor.phone),
                              _buildContactItem(Icons.mail, vm.vendor.email),
                            ],
                          ),
                        ),
                        // ---------------------------------------------
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Avaliações (${vm.totalReviews})", style: const TextStyle(color: AppColors.textDark, fontSize: 18, fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: const [
                                  Text("Recentes", style: TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w600)),
                                  Icon(Icons.expand_more, size: 18, color: AppColors.textDark),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(vm.averageRating.toStringAsFixed(1), style: const TextStyle(color: AppColors.textDark, fontSize: 32, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildStarRow(vm.averageRating, size: 24),
                                const Text("de 5 estrelas", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        vm.reviews.isEmpty
                            ? const Center(child: Text("Nenhuma avaliação ainda.", style: TextStyle(color: AppColors.textGrey)))
                            : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.reviews.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 24),
                          itemBuilder: (context, index) {
                            return ReviewListItem(review: vm.reviews[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: AppColors.background,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PrimaryButton(
                  label: isHired ? "Contratado" : "Contratar",
                  onPressed: vm.toggleHiringStatus,
                  color: isHired ? AppColors.green : AppColors.primary,
                  icon: isHired ? Icons.check : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStarRow(double rating, {double size = 20}) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      IconData icon;
      if (rating >= i) {
        icon = Icons.star;
      } else if (rating >= i - 0.5) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }
      stars.add(Icon(icon, color: AppColors.orange, size: size));
    }
    return Row(children: stars);
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: AppColors.textGrey, fontSize: 14))
        ]
    );
  }
}