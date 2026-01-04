import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/credit_card_provider.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/note_provider.dart';
import 'package:myapp/providers/overdue_payment_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/providers/subscription_provider.dart';
import 'package:myapp/providers/task_provider.dart';
import 'package:myapp/providers/course_provider.dart';
import 'package:myapp/providers/log_provider.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/services/storage_service.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/core/config/app_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============ CONFIGURACIÓN DE LA APP ============
  // Configurar modo de datos: local o remoto
  // Cambiar a DataMode.remote cuando se conecte la API
  final appConfig = AppConfig();
  appConfig.configureForLocal();

  // Para conectar con API en el futuro, usar:
  // appConfig.configureForRemote(
  //   baseUrl: 'https://tu-api.com/v1',
  //   timeout: 30,
  // );

  // ============ INICIALIZACIÓN DE SERVICIOS ============

  // Inicializar almacenamiento local (Hive)
  await StorageService.init();

  // Inicializar servicio de autenticación
  final authService = AuthService();
  await authService.initialize();

  // ============ EJECUTAR APP ============
  runApp(
    MultiProvider(
      providers: [
        // Servicios globales
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),

        // Providers de datos
        ChangeNotifierProvider(create: (context) => CreditCardProvider()),
        ChangeNotifierProvider(create: (context) => DebtProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => OverduePaymentProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => LogProvider()),
      ],
      child: const TDAHOrganizerApp(),
    ),
  );
}

class TDAHOrganizerApp extends StatelessWidget {
  const TDAHOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'TDAH Organizer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          // En el futuro, aquí se puede agregar lógica de autenticación:
          // home: Consumer<AuthService>(
          //   builder: (context, auth, child) {
          //     if (auth.isLoading) return const SplashScreen();
          //     if (!auth.isAuthenticated) return const LoginScreen();
          //     return const HomeScreen();
          //   },
          // ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
