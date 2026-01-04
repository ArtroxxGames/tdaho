import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/credit_cards_screen.dart';
import 'package:myapp/screens/dashboard_screen.dart';
import 'package:myapp/screens/debts_screen.dart';
import 'package:myapp/screens/expenses_screen.dart';
import 'package:myapp/screens/overdue_payments_screen.dart';
import 'package:myapp/screens/subscriptions_screen.dart';
import 'package:myapp/screens/notes_screen.dart';
import 'package:myapp/screens/focus_mode_screen.dart';
import 'package:myapp/screens/settings_screen.dart';
import 'package:myapp/screens/courses_screen.dart';
import 'package:myapp/screens/tasks_screen.dart';
import 'package:myapp/screens/logs_screen.dart';
import 'package:myapp/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DebtsScreen(),
    const ExpensesScreen(),
    const SubscriptionsScreen(),
    const CreditCardsScreen(),
    const OverduePaymentsScreen(),
    const CoursesScreen(),
    const TasksScreen(),
    const NotesScreen(),
    const FocusModeScreen(),
    const LogsScreen(),
    const SettingsScreen(),
  ];

  List<String> _getScreenTitles(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.dashboard,
      l10n.debts,
      l10n.expenses,
      l10n.subscriptions,
      'Tarjetas',
      'Pagos Atrasados',
      'Cursos',
      l10n.tasks,
      l10n.notes,
      l10n.focus,
      'Logs',
      'Configuración',
    ];
  }

  final List<IconData> _screenIcons = [
    Icons.dashboard_rounded,
    Icons.credit_card_rounded,
    Icons.shopping_cart_rounded,
    Icons.subscriptions_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.warning_rounded,
    Icons.school_rounded,
    Icons.checklist_rounded,
    Icons.note_rounded,
    Icons.center_focus_strong_rounded,
    Icons.list_alt_rounded,
    Icons.settings_rounded,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenTitles = _getScreenTitles(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitles[_selectedIndex]),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Menú', // Hardcoded for now
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            for (int i = 0; i < screenTitles.length; i++)
              ListTile(
                leading: Icon(_screenIcons[i]),
                title: Text(screenTitles[i]),
                onTap: () {
                  _onItemTapped(i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
    );
  }
}
