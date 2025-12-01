import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planejamento_casamento/ui/features/vendors/vendor_viewmodel.dart';
import '../../../data/models/vendor_model.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/guest_repository.dart';
import '../../../data/repositories/budget_repository.dart';
import '../../../data/models/task_model.dart';

class DashboardViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final GuestRepository _guestRepository;
  final BudgetRepository _budgetRepository;
  final VendorViewModel _vendorViewModel;

  final DateTime weddingDate = DateTime.now().add(const Duration(days: 180));
  Timer? _timer;
  Duration timeRemaining = Duration.zero;

  List<TaskModel> _urgentTasks = [];
  List<TaskModel> get urgentTasks => _urgentTasks;

  int _guestConfirmed = 0;
  int _guestTotal = 0;
  int get guestConfirmed => _guestConfirmed;
  int get guestTotal => _guestTotal;

  double _totalSpent = 0;
  final double _budgetLimit = 50000;

  String get budgetSpent {
    if (_totalSpent > 1000) {
      return "${(_totalSpent / 1000).toStringAsFixed(1)}k";
    }
    return _totalSpent.toStringAsFixed(0);
  }

  String get budgetTotal => "${(_budgetLimit / 1000).toStringAsFixed(0)}k";

  double get overallProgress {
    if (_budgetLimit == 0) return 0;
    return (_totalSpent / _budgetLimit).clamp(0.0, 1.0);
  }

  int get vendorsHired => _vendorViewModel.allVendors.where((v) => v.status == VendorStatus.hired).length;
  int get vendorsTotal => _vendorViewModel.allVendors.length;

  DashboardViewModel(
      this._taskRepository,
      this._guestRepository,
      this._budgetRepository,
      this._vendorViewModel,
      ) {
    _startTimer();
    _listenToTasks();
    _listenToGuests();
    _listenToBudget();

    _vendorViewModel.addListener(notifyListeners);
  }

  void _listenToBudget() {
    _budgetRepository.getExpenses().listen((expenses) {
      _totalSpent = expenses.fold(0, (sum, item) => sum + item.spent);
      notifyListeners();
    });
  }

  void _listenToGuests() {
    _guestRepository.getGuests().listen((guests) {
      _guestTotal = guests.fold(0, (sum, g) => sum + 1 + g.companions);
      _guestConfirmed = guests
          .where((g) => g.isConfirmed)
          .fold(0, (sum, g) => sum + 1 + g.companions);
      notifyListeners();
    });
  }

  void _listenToTasks() {
    _taskRepository.getTasks().listen((allTasks) {
      final pending = allTasks.where((t) => !t.isCompleted).toList();
      pending.sort((a, b) => a.deadline.compareTo(b.deadline));
      _urgentTasks = pending.take(5).toList();
      notifyListeners();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (weddingDate.isAfter(now)) {
        timeRemaining = weddingDate.difference(now);
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _vendorViewModel.removeListener(notifyListeners);
    super.dispose();
  }
}