import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/widgets/add_debt_form.dart';
import 'package:myapp/theme/app_colors.dart';

enum DebtViewMode { cards, table }

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  final ScrollController _scrollController = ScrollController();
  DebtViewMode _viewMode = DebtViewMode.cards;
  int _selectedYear = DateTime.now().year;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
            onSave: (newDebt) async {
              final provider = Provider.of<DebtProvider>(context, listen: false);
              if (debt == null) {
                await provider.addDebt(newDebt);
              } else {
                await provider.updateDebt(debt, newDebt);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.debts,
                  style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    // Toggle de vista
                    SegmentedButton<DebtViewMode>(
                      segments: const [
                        ButtonSegment(
                          value: DebtViewMode.cards,
                          label: Text('Tarjetas'),
                          icon: Icon(Icons.view_module),
                        ),
                        ButtonSegment(
                          value: DebtViewMode.table,
                          label: Text('Tabla'),
                          icon: Icon(Icons.table_chart),
                        ),
                      ],
                      selected: {_viewMode},
                      onSelectionChanged: (Set<DebtViewMode> newSelection) {
                        setState(() {
                          _viewMode = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ],
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

                  if (_viewMode == DebtViewMode.cards) {
                    return _buildCardsView(context, debtProvider.debts);
                  } else {
                    return _buildTableView(context, debtProvider.debts);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDebtForm(context),
        child: const Icon(Icons.add),
        tooltip: "Añadir Deuda",
      ),
    );
  }

  Widget _buildCardsView(BuildContext context, List<Debt> debts) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: debts.length,
      itemBuilder: (context, index) {
        final debt = debts[index];
        return _buildDebtCard(context, debt);
      },
    );
  }

  Widget _buildDebtCard(BuildContext context, Debt debt) {
    final paidCount = debt.paymentStatus.values.where((s) => s == PaymentStatus.pagado).length;
    final progress = debt.totalInstallments > 0 ? paidCount / debt.totalInstallments : 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.bgCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    debt.creditor,
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white70),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Editar'),
                      onTap: () => _showDebtForm(context, debt: debt),
                    ),
                    PopupMenuItem(
                      child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Eliminar deuda', style: GoogleFonts.oswald()),
                            content: Text('¿Estás seguro?', style: GoogleFonts.roboto()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancelar', style: GoogleFonts.roboto()),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: Text('Eliminar', style: GoogleFonts.roboto()),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await Provider.of<DebtProvider>(context, listen: false).deleteDebt(debt);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Total: ${NumberFormat.currency(symbol: '₲', decimalDigits: 0).format(debt.totalAmount)}',
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuotas: $paidCount/${debt.totalInstallments}',
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : AppColors.accentPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableView(BuildContext context, List<Debt> debts) {
    return Column(
      children: [
        // Navegación de años y leyenda
        _buildTableHeader(context),
        const SizedBox(height: 16),
        // Tabla
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: _buildExcelTable(context, debts),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.bgCard,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Navegación de años
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedYear--;
                    });
                  },
                  tooltip: 'Año anterior',
                ),
                Text(
                  _selectedYear.toString(),
                  style: GoogleFonts.oswald(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _selectedYear++;
                    });
                  },
                  tooltip: 'Año siguiente',
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Leyenda de estados
            Wrap(
              spacing: 24,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem('✓', Colors.green, 'Pagado'),
                _buildLegendItem('●', Colors.orange, 'Pendiente'),
                _buildLegendItem('!', Colors.red, 'Atrasado'),
                _buildLegendItem('-', Colors.grey, 'Futuro'),
                _buildLegendItem('—', Colors.grey.shade600, 'No aplica'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String symbol, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          symbol,
          style: GoogleFonts.roboto(
            fontSize: 20,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildExcelTable(BuildContext context, List<Debt> debts) {
    final monthNames = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];

    return DataTable(
      headingRowHeight: 60,
      dataRowMinHeight: 60,
      dataRowMaxHeight: 80,
      headingTextStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      dataTextStyle: GoogleFonts.roboto(fontSize: 12),
      columns: [
        // Columna fija izquierda
        DataColumn(
          label: Container(
            width: 200,
            child: Text('Deuda'),
          ),
        ),
        // 12 columnas de meses
        ...monthNames.map((month) => DataColumn(
              label: Text(month),
            )),
      ],
      rows: debts.map((debt) {
        final cells = <DataCell>[
          // Celda fija con nombre y progreso
          _buildDebtNameCell(context, debt),
          // 12 celdas de meses
          ...List.generate(12, (index) {
            return _buildMonthCell(context, debt, index + 1);
          }),
        ];
        return DataRow(cells: cells);
      }).toList(),
    );
  }

  DataCell _buildDebtNameCell(BuildContext context, Debt debt) {
    final paidCount = debt.paymentStatus.values.where((s) => s == PaymentStatus.pagado).length;
    final progress = debt.totalInstallments > 0 ? paidCount / debt.totalInstallments : 0.0;

    return DataCell(
      Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              debt.creditor,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : AppColors.accentPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$paidCount/${debt.totalInstallments}',
              style: GoogleFonts.roboto(
                fontSize: 10,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataCell _buildMonthCell(BuildContext context, Debt debt, int month) {
    final status = _getStatusForMonth(debt, month, _selectedYear);
    
    return DataCell(
      GestureDetector(
        onTap: () => _showStatusMenu(context, debt, month, status),
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: _buildStatusIcon(status),
        ),
      ),
    );
  }

  PaymentStatus _getStatusForMonth(Debt debt, int month, int year) {
    // Calcular qué cuota corresponde a este mes/año
    final startDate = debt.startDate;
    final monthsSinceStart = (year - startDate.year) * 12 + (month - startDate.month);
    
    // Si el mes es antes del inicio, no aplica
    if (monthsSinceStart < 0) {
      return PaymentStatus.no_aplica;
    }
    
    // Si el mes es después de todas las cuotas, no aplica
    if (monthsSinceStart >= debt.totalInstallments) {
      return PaymentStatus.no_aplica;
    }
    
    final installment = monthsSinceStart + 1;
    final storedStatus = debt.getStatusForInstallment(installment);
    
    // Si ya está marcado como pagado, mantenerlo
    if (storedStatus == PaymentStatus.pagado) {
      return PaymentStatus.pagado;
    }
    
    // Calcular fecha de vencimiento de esta cuota
    final dueDate = DateTime(year, month, startDate.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    // Si ya pasó la fecha y no está pagado, está atrasado
    if (dueDay.isBefore(today) && storedStatus != PaymentStatus.pagado) {
      return PaymentStatus.atrasado;
    }
    
    // Si es el mes actual o futuro y no está pagado, está pendiente
    if (dueDay.isAfter(today) || dueDay.isAtSameMomentAs(today)) {
      return PaymentStatus.pendiente;
    }
    
    // Si hay un estado almacenado, usarlo
    if (storedStatus != PaymentStatus.pendiente) {
      return storedStatus;
    }
    
    return PaymentStatus.pendiente;
  }

  Widget _buildStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pagado:
        return Tooltip(
          message: 'Pagado',
          child: Text(
            '✓',
            style: GoogleFonts.roboto(
              fontSize: 24,
              color: Colors.green.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case PaymentStatus.pendiente:
        return Tooltip(
          message: 'Pendiente',
          child: Text(
            '●',
            style: GoogleFonts.roboto(
              fontSize: 20,
              color: Colors.orange.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case PaymentStatus.atrasado:
        return Tooltip(
          message: 'Atrasado',
          child: Text(
            '!',
            style: GoogleFonts.roboto(
              fontSize: 24,
              color: Colors.red.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case PaymentStatus.no_aplica:
        return Tooltip(
          message: 'No aplica',
          child: Text(
            '—',
            style: GoogleFonts.roboto(
              fontSize: 20,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  void _showStatusMenu(BuildContext context, Debt debt, int month, PaymentStatus currentStatus) {
    if (currentStatus == PaymentStatus.no_aplica) return;

    final provider = Provider.of<DebtProvider>(context, listen: false);
    
    // Calcular qué cuota corresponde a este mes
    final startDate = debt.startDate;
    final monthsSinceStart = (_selectedYear - startDate.year) * 12 + (month - startDate.month);
    final installment = monthsSinceStart + 1;
    
    if (installment < 1 || installment > debt.totalInstallments) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Estado de Pago',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '${debt.creditor}\nCuota $installment - ${_getMonthName(month)} $_selectedYear',
          style: GoogleFonts.roboto(),
        ),
        actions: PaymentStatus.values
            .where((s) => s != PaymentStatus.no_aplica)
            .map((status) {
          return ElevatedButton(
            onPressed: () {
              provider.updatePaymentStatus(debt, installment, status);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: status == currentStatus
                  ? AppColors.accentPrimary
                  : AppColors.bgCard,
            ),
            child: Text(
              status.name.toUpperCase(),
              style: GoogleFonts.roboto(
                color: status == currentStatus ? Colors.white : Colors.white70,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
}
