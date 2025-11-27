import 'dart:async';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  // Data do Casamento (Mockada para 6 meses no futuro)
  final DateTime weddingDate = DateTime.now().add(const Duration(days: 180));

  // Variáveis do Timer
  late Timer _timer;
  Duration timeRemaining = Duration.zero;

  // Dados Mockados (Depois conectaremos com os Repositories reais)
  double get overallProgress => 0.6; // 60%
  String get budgetSpent => "25k";
  String get budgetTotal => "50k";
  int get guestConfirmed => 95; // Puxaremos do GuestRepository depois
  int get guestTotal => 200;
  int get vendorsHired => 5;
  int get vendorsTotal => 8;

  DashboardViewModel() {
    _startTimer();
  }

  void _startTimer() {
    // Atualiza o contador a cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (weddingDate.isAfter(now)) {
        timeRemaining = weddingDate.difference(now);
        notifyListeners();
      } else {
        _timer.cancel(); // Casamento chegou!
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}