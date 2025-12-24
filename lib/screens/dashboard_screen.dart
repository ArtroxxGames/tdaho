import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/subscription_provider.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/providers/overdue_payment_provider.dart';
import 'package:myapp/providers/task_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/utils/currency_formatter.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/screens/expenses_screen.dart';
import 'package:myapp/screens/tasks_screen.dart';
import 'package:myapp/screens/debts_screen.dart';
import 'package:myapp/screens/subscriptions_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat.yMMMMEEEEd('es').format(now);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(formattedDate),
            const SizedBox(height: 24),
            _buildSummaryCards(context),
            const SizedBox(height: 24),
            _buildFixedExpensesCard(context),
            const SizedBox(height: 24),
            _buildProductivitySection(context),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildTipOfTheDay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Hola! 👋',
          style: GoogleFonts.oswald(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          formattedDate,
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 768 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildMonthlyInstallmentsCard(context),
            _buildSubscriptionsCard(context),
            _buildOverduePaymentsCard(context),
            _buildTodayExpensesCard(context),
          ],
        );
      },
    );
  }

  Widget _buildMonthlyInstallmentsCard(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    double totalMonthly = 0.0;
    int activeDebts = 0;

    for (var debt in debtProvider.debts) {
      if (debt.isPending) {
        final monthlyPayment = debt.totalAmount / debt.totalInstallments;
        totalMonthly += monthlyPayment;
        activeDebts++;
      }
    }

    return _buildSummaryCard(
      'Cuotas Mensuales',
      CurrencyFormatter.format(totalMonthly, settings: settings),
      '$activeDebts ${activeDebts == 1 ? 'deuda activa' : 'deudas activas'}',
      Colors.blue.shade400,
      Icons.credit_card,
    );
  }

  Widget _buildSubscriptionsCard(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    double totalPyg = 0.0;
    int activeSubscriptions = 0;

    for (var sub in subscriptionProvider.subscriptions) {
      if (sub.billingCycle.name == 'mensual') {
        // Asumimos que el monto está en la moneda configurada
        // En una implementación completa, se convertiría según la moneda de la suscripción
        totalPyg += sub.amount;
      }
      activeSubscriptions++;
    }

    return _buildSummaryCard(
      'Suscripciones',
      CurrencyFormatter.format(totalPyg, settings: settings),
      '$activeSubscriptions ${activeSubscriptions == 1 ? 'suscripción' : 'suscripciones'}',
      Colors.purple.shade400,
      Icons.subscriptions,
    );
  }

  Widget _buildOverduePaymentsCard(BuildContext context) {
    final overdueProvider = Provider.of<OverduePaymentProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    final totalOverdue = overdueProvider.totalOverdue;
    final pendingCount = overdueProvider.pendingCount;
    final hasOverdue = totalOverdue > 0;

    return _buildSummaryCard(
      'Pagos Atrasados',
      CurrencyFormatter.format(totalOverdue, settings: settings),
      hasOverdue
          ? '$pendingCount ${pendingCount == 1 ? 'pago pendiente' : 'pagos pendientes'}'
          : 'Todo al día',
      hasOverdue ? Colors.red.shade400 : Colors.green.shade400,
      Icons.warning,
    );
  }

  Widget _buildTodayExpensesCard(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final now = DateTime.now();

    final todayExpenses = expenseProvider.expenses.where((expense) {
      return expense.date.year == now.year &&
          expense.date.month == now.month &&
          expense.date.day == now.day;
    }).toList();

    final totalToday = todayExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    return _buildSummaryCard(
      'Gastos de Hoy',
      CurrencyFormatter.format(totalToday, settings: settings),
      DateFormat.yMMMd('es').format(now),
      Colors.amber.shade400,
      Icons.shopping_cart,
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(icon, color: color, size: 24)],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: GoogleFonts.oswald(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedExpensesCard(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);

    double totalDebts = 0.0;
    for (var debt in debtProvider.debts) {
      if (debt.isPending) {
        totalDebts += debt.totalAmount / debt.totalInstallments;
      }
    }

    double totalSubscriptions = 0.0;
    for (var sub in subscriptionProvider.subscriptions) {
      if (sub.billingCycle.name == 'mensual') {
        totalSubscriptions += sub.amount;
      }
    }

    final totalFixed = totalDebts + totalSubscriptions;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade600, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Gastos Fijos Mensuales',
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                CurrencyFormatter.format(totalFixed, settings: settings),
                style: GoogleFonts.oswald(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildFixedExpenseBreakdown(
                      'Cuotas',
                      totalDebts,
                      totalFixed,
                      settings,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFixedExpenseBreakdown(
                      'Suscripciones',
                      totalSubscriptions,
                      totalFixed,
                      settings,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFixedExpenseBreakdown(
    String label,
    double amount,
    double total,
    SettingsProvider settings,
  ) {
    final percentage = total > 0 ? (amount / total * 100) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(amount, settings: settings),
          style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: GoogleFonts.roboto(fontSize: 10, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildProductivitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Productividad',
          style: GoogleFonts.oswald(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildProductivityCard(
                'Tareas Kanban',
                _buildTaskStats(context),
                Colors.blue.shade400,
                Icons.check_circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProductivityCard(
                'Educación',
                _buildEducationStats(context),
                Colors.purple.shade400,
                Icons.school,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductivityCard(
    String title,
    Widget content,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.oswald(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStats(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    final pending = tasks.where((t) => t.status == TaskStatus.pendiente).length;
    final inProgress = tasks
        .where((t) => t.status == TaskStatus.en_progreso)
        .length;
    final completed = tasks
        .where((t) => t.status == TaskStatus.completada)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow('Pendientes', pending.toString(), Colors.amber),
        const SizedBox(height: 8),
        _buildStatRow('En Progreso', inProgress.toString(), Colors.blue),
        const SizedBox(height: 8),
        _buildStatRow('Completadas', completed.toString(), Colors.green),
      ],
    );
  }

  Widget _buildEducationStats(BuildContext context) {
    // Por ahora, mostrar placeholder hasta que se implemente el módulo de cursos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatRow('Cursos Activos', '0', Colors.purple),
        const SizedBox(height: 8),
        _buildStatRow('Progreso Promedio', '0%', Colors.purple),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: GoogleFonts.oswald(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 768 ? 4 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildQuickActionButton(
                  context,
                  'Gasto',
                  Icons.add_shopping_cart,
                  Colors.amber.shade400,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExpensesScreen()),
                  ),
                ),
                _buildQuickActionButton(
                  context,
                  'Tarea',
                  Icons.add_task,
                  Colors.blue.shade400,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TasksScreen()),
                  ),
                ),
                _buildQuickActionButton(
                  context,
                  'Deuda',
                  Icons.credit_card,
                  Colors.purple.shade400,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DebtsScreen()),
                  ),
                ),
                _buildQuickActionButton(
                  context,
                  'Suscripción',
                  Icons.subscriptions,
                  Colors.pink.shade400,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SubscriptionsScreen(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipOfTheDay(BuildContext context) {
    final tips = [
      '💡 Divide las tareas grandes en pasos pequeños. ¡Cada paso cuenta!',
      '🎯 Establece recordatorios 3 días antes de los vencimientos importantes.',
      '✨ Celebra cada logro, por pequeño que sea. ¡Tú puedes!',
      '📝 Registra los gastos inmediatamente después de hacerlos.',
      '⏰ Usa la técnica Pomodoro: 25 minutos de trabajo, 5 de descanso.',
      '🎨 Mantén tus listas cortas. Máximo 5-7 tareas visibles.',
      '🔄 Revisa tu dashboard cada mañana para mantenerte organizado.',
    ];

    final today = DateTime.now().day;
    final tip = tips[today % tips.length];

    return Card(
      elevation: 2,
      color: Colors.blue.shade900.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.amber.shade400, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tip del Día',
                    style: GoogleFonts.oswald(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
