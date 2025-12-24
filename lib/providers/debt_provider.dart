import 'package:flutter/material.dart';
import 'package:myapp/models/debt.dart';

class DebtProvider with ChangeNotifier {
  final List<Debt> _debts = [
    Debt(
      id: '1',
      creditor: 'Banco Principal',
      totalAmount: 12000,
      totalInstallments: 12,
      startDate: DateTime(2023, 1, 15),
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
      totalAmount: 800,
      totalInstallments: 6,
      startDate: DateTime(2023, 3, 1),
       paymentStatus: {
        1: PaymentStatus.pagado,
        2: PaymentStatus.pagado,
        3: PaymentStatus.pagado,
        4: PaymentStatus.pagado,
      },
    ),
  ];

  List<Debt> get debts => _debts;

  void addDebt(Debt debt) {
    _debts.add(debt);
    notifyListeners();
  }

  void updateDebt(Debt oldDebt, Debt newDebt) {
    final index = _debts.indexOf(oldDebt);
    if (index != -1) {
      _debts[index] = newDebt;
      notifyListeners();
    }
  }

  void updatePaymentStatus(Debt debt, int installment, PaymentStatus status) {
    final debtIndex = _debts.indexOf(debt);
    if (debtIndex != -1) {
      final newStatus = Map<int, PaymentStatus>.from(debt.paymentStatus);
      newStatus[installment] = status;
      _debts[debtIndex] = debt.copyWith(paymentStatus: newStatus);
      notifyListeners();
    }
  }

  void deleteAll() {
    _debts.clear();
    notifyListeners();
  }
}
