import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'data/repositories/budget_repository.dart';
import 'data/services/budget_service.dart';
import 'firebase_options.dart';

// Services & Repositories
import 'data/services/guest_service.dart';
import 'data/repositories/guest_repository.dart';
import 'data/services/task_service.dart';
import 'data/repositories/task_repository.dart';

// ViewModels
import 'ui/features/guests/guest_viewmodel.dart';
import 'ui/features/dashboard/dashboard_viewmodel.dart';
import 'ui/features/tasks/task_viewmodel.dart';
import 'ui/features/budget/budget_viewmodel.dart';
import 'ui/features/vendors/vendor_viewmodel.dart';

// View
import 'ui/features/dashboard/dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GuestViewModel(GuestRepository(GuestService()))),
        ChangeNotifierProvider(create: (_) => TaskViewModel(TaskRepository(TaskService()))),
        ChangeNotifierProvider(create: (_) => DashboardViewModel(TaskRepository(TaskService()), GuestRepository(GuestService()), BudgetRepository(BudgetService()))),
        ChangeNotifierProvider(create: (_) => VendorViewModel()),
        ChangeNotifierProvider(create: (_) => BudgetViewModel(BudgetRepository(BudgetService()))),
      ],
      child: MaterialApp(
        title: 'Planejamento de Casamento',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8c30e8)), useMaterial3: true, fontFamily: 'Plus Jakarta Sans'),
        home: const DashboardView(),
      ),
    );
  }
}