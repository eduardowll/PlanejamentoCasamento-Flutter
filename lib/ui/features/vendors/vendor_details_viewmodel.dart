import 'package:flutter/material.dart';
import '../../../data/models/review_model.dart';
import '../../../data/models/vendor_model.dart';
import './vendor_viewmodel.dart';

class VendorDetailsViewModel extends ChangeNotifier {
  VendorModel _vendor;
  final VendorViewModel _vendorViewModel;

  VendorDetailsViewModel({
    required VendorModel vendor,
    required VendorViewModel vendorViewModel
  }) : _vendor = vendor,
        _vendorViewModel = vendorViewModel;

  VendorModel get vendor => _vendor;
  List<ReviewModel> get reviews => _vendor.reviews;
  double get averageRating => _vendor.rating;
  int get totalReviews => _vendor.reviews.length;

  bool get isHired => _vendor.status == VendorStatus.hired;

  void toggleHiringStatus() {

    final newStatus = isHired ? VendorStatus.pending : VendorStatus.hired;

    final updatedVendor = _vendor.copyWith(status: newStatus);

    _vendor = updatedVendor;
    notifyListeners();

    _vendorViewModel.updateVendor(updatedVendor);
  }
}