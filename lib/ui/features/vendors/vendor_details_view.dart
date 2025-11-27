import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/review_model.dart';
import 'vendor_details_viewmodel.dart';
import '../../../data/models/vendor_model.dart';

class VendorDetailsView extends StatelessWidget {
  final VendorModel vendor;

  const VendorDetailsView({super.key, required this.vendor});

  // Cores (Mesma paleta da tela anterior)
  final Color primaryColor = const Color(0xFFd8a7b1);
  final Color accentColor = const Color(0xFFc9a959); // Estrelas e FAB
  final Color bgLight = const Color(0xFFfdfafb);
  final Color textLight = const Color(0xFF333333);
  final Color textNeutral = const Color(0xFF888888);

  final Color statusGreen = const Color(0xFF50b86a);
  final Color statusYellow = const Color(0xFFf5b745);
  final Color statusGray = const Color(0xFFa0a0a0);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorDetailsViewModel(),
      child: Scaffold(
        backgroundColor: bgLight,
        // --- APP BAR ---
        appBar: AppBar(
          backgroundColor: bgLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textLight),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(vendor.name, style: TextStyle(color: textLight, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.more_vert, color: textLight), onPressed: () {}),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: const Color(0xFFf3e9dd), height: 1),
          ),
        ),

        body: Consumer<VendorDetailsViewModel>(
          builder: (context, vm, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER INFO (Card de topo) ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: const Color(0xFFf3e9dd).withOpacity(0.5))),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vendor.name, style: TextStyle(color: textLight, fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(vendor.category, style: TextStyle(color: textNeutral, fontSize: 14)),
                              ],
                            ),
                            _buildStatusBadge(vendor.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildContactItem(Icons.call, vendor.phone),
                            const SizedBox(width: 16),
                            _buildContactItem(Icons.mail, vendor.email),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- REVIEW SECTION ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Avaliações + Filtro Recentes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Avaliações (${vm.totalReviews})", style: TextStyle(color: textLight, fontSize: 18, fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFf3e9dd), borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  Text("Recentes", style: TextStyle(color: textLight, fontSize: 14, fontWeight: FontWeight.w600)),
                                  Icon(Icons.expand_more, size: 18, color: textLight),
                                ],
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Nota Grande (4.8)
                        Row(
                          children: [
                            Text(vm.averageRating.toString(), style: TextStyle(color: textLight, fontSize: 32, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildStarRow(vm.averageRating, size: 24),
                                Text("de 5 estrelas", style: TextStyle(color: textNeutral, fontSize: 12)),
                              ],
                            )
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Lista de Comentários
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.reviews.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 24),
                          itemBuilder: (context, index) {
                            return _buildReviewItem(vm.reviews[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // --- FAB (Rate Review) ---
        floatingActionButton: FloatingActionButton(
          backgroundColor: accentColor,
          child: const Icon(Icons.rate_review, color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildReviewItem(ReviewModel review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Avatar Placeholder
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 20,
                  // Tenta pegar a inicial do nome
                  child: Text(review.userName[0], style: TextStyle(color: textLight, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: TextStyle(color: textLight, fontWeight: FontWeight.w600)),
                    Text(review.date, style: TextStyle(color: textNeutral, fontSize: 12)),
                  ],
                ),
              ],
            ),
            _buildStarRow(review.rating, size: 16),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          review.comment,
          style: TextStyle(color: textLight.withOpacity(0.9), height: 1.5, fontSize: 14),
        ),
      ],
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
        icon = Icons.star_border; // Ou star vazio se preferir
      }
      stars.add(Icon(icon, color: accentColor, size: size));
    }
    return Row(children: stars);
  }

  Widget _buildStatusBadge(VendorStatus status) {
    Color color;
    String text;
    switch (status) {
      case VendorStatus.hired: color = statusGreen; text = "Contratado"; break;
      case VendorStatus.budgeting: color = statusYellow; text = "Orçamento"; break;
      case VendorStatus.pending: color = statusGray; text = "Pendente"; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(children: [Icon(icon, size: 18, color: textNeutral), const SizedBox(width: 6), Text(text, style: TextStyle(color: textNeutral, fontSize: 14))]);
  }
}