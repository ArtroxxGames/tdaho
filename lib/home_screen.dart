
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/dashboard_screen.dart';
import 'screens/debts_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'screens/overdue_payments_screen.dart';
import 'screens/daily_expenses_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/habit_tracker_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/focus_mode_screen.dart';
import 'screens/pomodoro_timer_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/about_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    const SubscriptionsScreen(),
    const OverduePaymentsScreen(),
    const DailyExpensesScreen(),
    const TasksScreen(),
    const RemindersScreen(),
    const NotesScreen(),
    const HabitTrackerScreen(),
    const AchievementsScreen(),
    const FocusModeScreen(),
    const PomodoroTimerScreen(),
    const SettingsScreen(),
    const ProfileScreen(),
    const AboutScreen(),
  ];

  List<String> _getScreenTitles(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.dashboard,
      l10n.debts,
      l10n.subscriptions,
      l10n.overduePayments,
      l10n.dailyExpenses,
      l10n.tasks,
      l10n.reminders,
      l10n.notes,
      l10n.habitTracker,
      l10n.achievements,
      l10n.focusMode,
      l10n.pomodoroTimer,
      l10n.settings,
      l10n.profile,
      l10n.about,
    ];
  }

  final List<IconData> _screenIcons = [
    Icons.dashboard,
    Icons.money_off,
    Icons.subscriptions,
    Icons.payment,
    Icons.request_page,
    Icons.task,
    Icons.alarm,
    Icons.note,
    Icons.repeat,
    Icons.shield_moon_outlined,
    Icons.hourglass_empty,
    Icons.timer,
    Icons.settings,
    Icons.person,
    Icons.info,
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
                AppLocalizations.of(context)!.menu,
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
