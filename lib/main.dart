import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:planejamento_casamento/ui/features/dashboard/dashboard_view.dart';
import 'package:planejamento_casamento/ui/features/dashboard/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';

// Importações do Firebase e das suas camadas
import 'firebase_options.dart';
import 'data/services/guest_service.dart';
import 'data/repositories/guest_repository.dart';
import 'ui/features/guests/guest_viewmodel.dart';
import 'ui/features/guests/guest_view.dart';

void main() async {
  // 1. Garante que o motor do Flutter está pronto
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o Firebase com a configuração gerada pelo CLI
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. MultiProvider: É aqui que a "mágica" da Injeção de Dependência acontece.
    // Estamos criando o ViewModel e disponibilizando ele para o app todo.
    return MultiProvider(
      providers: [
        // ViewModel dos Convidados (que já existia)
        ChangeNotifierProvider(
          create: (_) => GuestViewModel(
            GuestRepository(GuestService()),
          ),
        ),
        // NOVO: ViewModel do Dashboard (Timer e Totais)
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Planejamento de Casamento',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8c30e8)),
          useMaterial3: true,
          // Fonte padrão para ficar igual ao design
          fontFamily: 'Plus Jakarta Sans',
        ),
        // Define o Dashboard como a tela inicial
        home: const DashboardView(),
      ),
    );
  }
}