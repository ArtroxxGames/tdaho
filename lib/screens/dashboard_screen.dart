import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:myapp/providers/income_provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/subscription_provider.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/models/expense.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboard,
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildSummary(context),
            const SizedBox(height: 24),
            _buildSectionTitle(l10n.upcomingSubscriptions),
            _buildUpcomingSubscriptions(context),
            const SizedBox(height: 24),
            _buildSectionTitle(l10n.pendingDebts),
            _buildPendingDebts(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final totalIncome = Provider.of<IncomeProvider>(context).totalIncome;
    final totalExpenses = Provider.of<ExpenseProvider>(context).expenses.fold(0.0, (sum, item) => sum + item.amount);
    final balance = totalIncome - totalExpenses;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('Ingresos', totalIncome, Colors.green.shade400),
            _buildSummaryItem('Gastos', totalExpenses, Colors.red.shade400),
            _buildSummaryItem('Balance', balance, Colors.blue.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(title, style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text(
          NumberFormat.currency(symbol: '€').format(amount),
          style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.oswald(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildUpcomingSubscriptions(BuildContext context) {
    final subscriptions = Provider.of<SubscriptionProvider>(context).subscriptions;
    final upcoming = subscriptions.where((s) => s.nextPaymentDate.isAfter(DateTime.now())).toList();

    if (upcoming.isEmpty) {
      return const Text('No hay suscripciones próximas.');
    }

    return _buildCardList(
      itemCount: upcoming.length > 3 ? 3 : upcoming.length, // Show max 3
      itemBuilder: (index) {
        final sub = upcoming[index];
        return ListTile(
          leading: const Icon(Icons.autorenew),
          title: Text(sub.name),
          trailing: Text(DateFormat.yMMMd().format(sub.nextPaymentDate)),
        );
      },
    );
  }

  Widget _buildPendingDebts(BuildContext context) {
    final debts = Provider.of<DebtProvider>(context).debts;
    final pendingDebts = debts.where((d) => d.isPending).toList();

    if (pendingDebts.isEmpty) {
      return const Text('No hay deudas pendientes.');
    }

    return _buildCardList(
      itemCount: pendingDebts.length > 3 ? 3 : pendingDebts.length, // Show max 3
      itemBuilder: (index) {
        final debt = pendingDebts[index];
        return ListTile(
          leading: const Icon(Icons.receipt),
          title: Text(debt.creditor),
          trailing: Text(NumberFormat.currency(symbol: '€').format(debt.totalAmount)),
        );
      },
    );
  }

  Widget _buildCardList({required int itemCount, required Widget Function(int) itemBuilder}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) => itemBuilder(index),
        separatorBuilder: (context, index) => const Divider(height: 1),
      ),
    );
  }
}
