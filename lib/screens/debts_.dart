import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/widgets/add_debt_form.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  final ScrollController _scrollController = ScrollController();

  void _showDebtForm(BuildContext context, {Debt? debt}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddDebtForm(
            debt: debt,
            onSave: (newDebt) {
              final provider = Provider.of<DebtProvider>(context, listen: false);
              if (debt == null) {
                provider.addDebt(newDebt);
              } else {
                provider.updateDebt(debt, newDebt);
              }
            },
          ),
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
                  if (debtProvider.debts.isEmpty) {
                    return Center(
                      child: Text(
                        '¡No tienes deudas pendientes!',
                        style: GoogleFonts.roboto(fontSize: 18, color: Colors.white70),
                      ),
                    );
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 16),
                        dataTextStyle: GoogleFonts.roboto(fontSize: 14),
                        columns: _buildColumns(),
                        rows: _buildRows(context, debtProvider.debts),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDebtForm(context),
        tooltip: "Añadir Deuda",
        child: const Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final columns = <DataColumn>[DataColumn(label: Text('Acreedor'))];
    final currentYear = DateTime.now().year;

    for (int month = 1; month <= 12; month++) {
      columns.add(DataColumn(label: Text(DateFormat.MMM('es').format(DateTime(currentYear, month)))));
    }
    return columns;
  }

  List<DataRow> _buildRows(BuildContext context, List<Debt> debts) {
    return debts.map((debt) {
      final cells = <DataCell>[_buildCreditorCell(context, debt)];
      for (int i = 0; i < 12; i++) {
        cells.add(_buildPaymentCell(context, debt, i + 1));
      }
      return DataRow(cells: cells);
    }).toList();
  }

   DataCell _buildCreditorCell(BuildContext context, Debt debt) {
    return DataCell(
      Row(
        children: [
          Text(debt.creditor, style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
          IconButton(
            icon: const Icon(Icons.edit, size: 18, color: Colors.white54),
            onPressed: () => _showDebtForm(context, debt: debt),
            tooltip: 'Editar Deuda',
          ),
        ],
      ),
    );
  }


  DataCell _buildPaymentCell(BuildContext context, Debt debt, int installment) {
    final status = debt.getStatusForInstallment(installment);

    return DataCell(
      GestureDetector(
        onTap: () => _showStatusMenu(context, debt, installment, status),
        child: Tooltip(
          message: status.name,
          child: Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
            size: 28,
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pagado:
        return Icons.check_circle;
      case PaymentStatus.pendiente:
        return Icons.radio_button_unchecked;
      case PaymentStatus.atrasado:
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pagado:
        return Colors.green.shade400;
      case PaymentStatus.pendiente:
        return Colors.grey.shade400;
      case PaymentStatus.atrasado:
        return Colors.red.shade400;
      default:
        return Colors.blueGrey;
    }
  }

  void _showStatusMenu(BuildContext context, Debt debt, int installment, PaymentStatus currentStatus) {
    final provider = Provider.of<DebtProvider>(context, listen: false);

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox cell = context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        cell.localToGlobal(Offset.zero, ancestor: overlay),
        cell.localToGlobal(cell.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: PaymentStatus.values.map((status) {
        return PopupMenuItem(
          value: status,
          child: Text(status.name),
        );
      }).toList(),
    ).then((selectedStatus) {
      if (selectedStatus != null && selectedStatus != currentStatus) {
        provider.updatePaymentStatus(debt, installment, selectedStatus);
      }
    });
  }
}
