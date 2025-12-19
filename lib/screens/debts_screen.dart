import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tdah_organizer/models/debt.dart';
import 'package:tdah_organizer/providers/debt_provider.dart';
import 'package:tdah_organizer/widgets/add_debt_form.dart';

class DebtsScreen extends StatelessWidget {
  const DebtsScreen({super.key});

  void _showAddDebtForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddDebtForm(onAdd: (creditor, amount, dueDate) {
            final newDebt = Debt(creditor: creditor, amount: amount, dueDate: dueDate);
            Provider.of<DebtProvider>(context, listen: false).addDebt(newDebt);
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.debts,
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<DebtProvider>(
                builder: (context, debtProvider, child) {
                  return ListView.builder(
                    itemCount: debtProvider.debts.length,
                    itemBuilder: (context, index) {
                      final debt = debtProvider.debts[index];
                      return _buildDebtCard(context, debt);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDebtForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Deuda",
      ),
    );
  }

  Widget _buildDebtCard(BuildContext context, Debt debt) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              debt.creditor,
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              "\$${debt.amount.toStringAsFixed(2)}",
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red.shade300),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.white70),
                const SizedBox(width: 8),
                Text(
                  "Vence el ${debt.dueDate.day}/${debt.dueDate.month}/${debt.dueDate.year}",
                  style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
