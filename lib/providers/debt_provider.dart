import 'package:flutter/material.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/providers/log_provider.dart';
import 'package:myapp/services/storage_service.dart';

class DebtProvider with ChangeNotifier {
  List<Debt> _debts = [];

  DebtProvider() {
    _loadDebts();
  }

  List<Debt> get debts => _debts;

  void _loadDebts() {
    _debts = StorageService.loadList<Debt>(
      StorageService.debtsBox,
      (json) => Debt.fromJson(json),
    );

    // Si no hay datos, cargar datos de muestra
    if (_debts.isEmpty) {
      _debts = [
        Debt(
          id: '1',
          creditor: 'Banco Principal',
          totalAmount: 12000000,
          totalInstallments: 12,
          startDate: DateTime(2024, 1, 15),
          dueDay: 15,
          paymentStatus: {
            1: PaymentStatus.pagado,
            2: PaymentStatus.pagado,
            3: PaymentStatus.atrasado,
            4: PaymentStatus.pendiente,
          },
        ),
        Debt(
          id: '2',
          creditor: 'Tienda de Electrónica',
          totalAmount: 8000000,
          totalInstallments: 6,
          startDate: DateTime(2024, 3, 1),
          dueDay: 5,
          paymentStatus: {
            1: PaymentStatus.pagado,
            2: PaymentStatus.pagado,
            3: PaymentStatus.pagado,
            4: PaymentStatus.pagado,
          },
        ),
      ];
      _saveDebts();
    }
  }

  Future<void> _saveDebts() async {
    await StorageService.saveList(StorageService.debtsBox, _debts);
    notifyListeners();
  }

  Future<void> addDebt(Debt debt) async {
    _debts.add(debt);
    await _saveDebts();
    LogProvider.instance?.info('Deudas', 'Nueva deuda creada: ${debt.creditor}', metadata: {
      'id': debt.id,
      'monto': debt.totalAmount,
      'cuotas': debt.totalInstallments,
    });
  }

  Future<void> updateDebt(Debt oldDebt, Debt newDebt) async {
    final index = _debts.indexOf(oldDebt);
    if (index != -1) {
      _debts[index] = newDebt;
      await _saveDebts();
      LogProvider.instance?.info('Deudas', 'Deuda actualizada: ${newDebt.creditor}');
    }
  }

  Future<void> updatePaymentStatus(Debt debt, int installment, PaymentStatus status) async {
    final debtIndex = _debts.indexOf(debt);
    if (debtIndex != -1) {
      final newStatus = Map<int, PaymentStatus>.from(debt.paymentStatus);
      newStatus[installment] = status;
      _debts[debtIndex] = debt.copyWith(paymentStatus: newStatus);
      await _saveDebts();
      LogProvider.instance?.info('Deudas', 'Estado de cuota actualizado', metadata: {
        'deuda': debt.creditor,
        'cuota': installment,
        'estado': status.name,
      });
    }
  }

  Future<void> deleteDebt(Debt debt) async {
    _debts.remove(debt);
    await _saveDebts();
    LogProvider.instance?.warning('Deudas', 'Deuda eliminada: ${debt.creditor}');
  }

  Future<void> deleteAll() async {
    _debts.clear();
    await _saveDebts();
    LogProvider.instance?.warning('Deudas', 'Todas las deudas eliminadas');
  }
}

