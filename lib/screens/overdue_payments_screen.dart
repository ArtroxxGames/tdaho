import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/overdue_payment.dart';
import 'package:myapp/providers/overdue_payment_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/utils/currency_formatter.dart';
import 'package:myapp/widgets/add_overdue_payment_form.dart';

class OverduePaymentsScreen extends StatelessWidget {
  const OverduePaymentsScreen({super.key});

  void _showOverduePaymentForm(
    BuildContext context, {
    OverduePayment? payment,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddOverduePaymentForm(
            payment: payment,
            onSave: (newPayment) async {
              final provider = Provider.of<OverduePaymentProvider>(
                context,
                listen: false,
              );
              if (payment == null) {
                await provider.addOverduePayment(newPayment);
              } else {
                // Para editar, eliminamos el anterior y agregamos el nuevo
                await provider.deleteOverduePayment(payment);
                await provider.addOverduePayment(newPayment);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pagos Atrasados',
              style: GoogleFonts.oswald(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSummaryCards(context),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<OverduePaymentProvider>(
                builder: (context, provider, child) {
                  final pendingPayments = provider.pendingPayments;

                  if (pendingPayments.isEmpty) {
                    return _buildAllUpToDateCard(context);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryByDebt(context, provider),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pendingPayments.length,
                          itemBuilder: (context, index) {
                            return _buildPaymentCard(
                              context,
                              pendingPayments[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOverduePaymentForm(context),
        child: const Icon(Icons.add),
        tooltip: "Registrar Atraso",
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Consumer<OverduePaymentProvider>(
      builder: (context, provider, child) {
        final settings = Provider.of<SettingsProvider>(context);
        final totalOverdue = provider.totalOverdue;
        final pendingCount = provider.pendingCount;
        final currentMonth = DateFormat.yMMMM('es').format(DateTime.now());

        return Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Acumulado',
                totalOverdue,
                totalOverdue > 0 ? Colors.red.shade400 : Colors.green.shade400,
                settings,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Pagos Pendientes',
                pendingCount.toDouble(),
                Colors.orange.shade400,
                settings,
                isCount: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mes Actual',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentMonth,
                        style: GoogleFonts.oswald(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    double value,
    Color color,
    SettingsProvider settings, {
    bool isCount = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              isCount
                  ? value.toInt().toString()
                  : CurrencyFormatter.format(value, settings: settings),
              style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllUpToDateCard(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2,
        color: Colors.green.shade900.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 64, color: Colors.green.shade400),
              const SizedBox(height: 16),
              Text(
                '¡Todo al día!',
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No tienes pagos atrasados pendientes.',
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryByDebt(
    BuildContext context,
    OverduePaymentProvider provider,
  ) {
    final summary = provider.getSummaryByDebt();
    if (summary.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen por Concepto',
              style: GoogleFonts.oswald(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...summary.entries.map((entry) {
              final settings = Provider.of<SettingsProvider>(context);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(entry.value, settings: settings),
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, OverduePayment payment) {
    final settings = Provider.of<SettingsProvider>(context);
    final provider = Provider.of<OverduePaymentProvider>(
      context,
      listen: false,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: payment.isDueToday
              ? Colors.orange.shade400
              : payment.daysOverdue > 0
              ? Colors.red.shade400
              : Colors.amber.shade400,
          child: Icon(
            payment.isDueToday
                ? Icons.warning
                : payment.daysOverdue > 0
                ? Icons.error
                : Icons.schedule,
            color: Colors.white,
          ),
        ),
        title: Text(
          payment.debtName,
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              payment.month,
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              payment.statusText,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: payment.isDueToday
                    ? Colors.orange.shade400
                    : payment.daysOverdue > 0
                    ? Colors.red.shade400
                    : Colors.amber.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Vencimiento: ${DateFormat.yMMMd().format(payment.dueDate)}',
              style: GoogleFonts.roboto(fontSize: 11, color: Colors.white54),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(payment.amount, settings: settings),
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () async {
                    await provider.markAsPaid(payment);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pago marcado como pagado',
                          style: GoogleFonts.roboto(),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  tooltip: 'Marcar como Pagado',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Eliminar Pago Atrasado',
                          style: GoogleFonts.oswald(),
                        ),
                        content: Text(
                          '¿Estás seguro de eliminar este registro de pago atrasado?',
                          style: GoogleFonts.roboto(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.roboto(),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await provider.deleteOverduePayment(payment);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text(
                              'Eliminar',
                              style: GoogleFonts.roboto(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Eliminar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
