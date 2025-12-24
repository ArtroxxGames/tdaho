import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/credit_card_provider.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/income_provider.dart';
import 'package:myapp/providers/note_provider.dart';
import 'package:myapp/providers/overdue_payment_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/providers/subscription_provider.dart';
import 'package:myapp/providers/task_provider.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => CreditCardProvider()),
        ChangeNotifierProvider(create: (context) => DebtProvider()),
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => IncomeProvider()),
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => OverduePaymentProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
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
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        );
      },
    );
  }
}
