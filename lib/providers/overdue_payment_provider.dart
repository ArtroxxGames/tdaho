import 'package:flutter/material.dart';
import 'package:myapp/models/overdue_payment.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/providers/debt_provider.dart';

class OverduePaymentProvider with ChangeNotifier {
  final List<OverduePayment> _overduePayments = [];

  List<OverduePayment> get overduePayments => _overduePayments;

  // Obtener pagos pendientes (no pagados)
  List<OverduePayment> get pendingPayments {
    return _overduePayments.toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Obtener total acumulado de pagos atrasados
  double get totalOverdue {
    return _overduePayments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  // Obtener cantidad de pagos pendientes
  int get pendingCount => _overduePayments.length;

  void addOverduePayment(OverduePayment payment) {
    _overduePayments.add(payment);
    notifyListeners();
  }

  void markAsPaid(OverduePayment payment) {
    _overduePayments.remove(payment);
    notifyListeners();
  }

  void deleteOverduePayment(OverduePayment payment) {
    _overduePayments.remove(payment);
    notifyListeners();
  }

  void deleteAll() {
    _overduePayments.clear();
    notifyListeners();
  }

  // Detectar automáticamente pagos atrasados desde las deudas
  void detectOverdueFromDebts(DebtProvider debtProvider) {
    final now = DateTime.now();

    // Limpiar pagos automáticos anteriores (opcional: mantener solo los manuales)
    // Por ahora, solo agregamos sin duplicar

    for (var debt in debtProvider.debts) {
      // Verificar cada cuota pendiente
      for (
        int installment = 1;
        installment <= debt.totalInstallments;
        installment++
      ) {
        final status = debt.getStatusForInstallment(installment);

        // Si está atrasado, crear un pago atrasado
        if (status == PaymentStatus.atrasado) {
          // Calcular la fecha de vencimiento de esta cuota
          // Usa el día del mes de la fecha de inicio
          final installmentDate = DateTime(
            debt.startDate.year,
            debt.startDate.month + (installment - 1),
            debt.startDate.day,
          );

          // Verificar si ya existe un pago atrasado para esta deuda y cuota
          final existingPayment = _overduePayments.firstWhere(
            (p) =>
                p.debtId == debt.id && p.month.contains('Cuota $installment'),
            orElse: () => OverduePayment(
              id: '',
              debtName: '',
              month: '',
              amount: 0,
              dueDate: DateTime.now(),
            ),
          );

          // Solo agregar si no existe y está realmente atrasado
          if (existingPayment.id.isEmpty && installmentDate.isBefore(now)) {
            final monthlyPayment = debt.totalAmount / debt.totalInstallments;
            final monthName = _getMonthName(installmentDate.month);

            addOverduePayment(
              OverduePayment(
                id: '${debt.id}_installment_$installment',
                debtId: debt.id,
                debtName: debt.creditor,
                month:
                    '$monthName ${installmentDate.year} - Cuota $installment',
                amount: monthlyPayment,
                dueDate: installmentDate,
              ),
            );
          }
        }
      }
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month - 1];
  }

  // Obtener resumen por concepto (agrupar por deuda)
  Map<String, double> getSummaryByDebt() {
    final Map<String, double> summary = {};
    for (var payment in _overduePayments) {
      summary.update(
        payment.debtName,
        (value) => value + payment.amount,
        ifAbsent: () => payment.amount,
      );
    }
    return summary;
  }
}
