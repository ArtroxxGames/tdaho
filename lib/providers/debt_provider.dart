import 'package:flutter/material.dart';
import 'package:tdah_organizer/models/debt.dart';

class DebtProvider with ChangeNotifier {
  final List<Debt> _debts = [
    Debt(
      creditor: "Tarjeta de Crédito Visa",
      totalAmount: 1200.00,
      installmentAmount: 100.00,
      startDate: DateTime(2023, 1, 15),
      numberOfInstallments: 12,
      payments: {
        1: PaymentStatus.pagado,
        2: PaymentStatus.pagado,
        3: PaymentStatus.pagado,
        4: PaymentStatus.atrasado,
        5: PaymentStatus.pendiente,
      },
    ),
    Debt(
      creditor: "Préstamo Automotriz",
      totalAmount: 8000.00,
      installmentAmount: 250.00,
      startDate: DateTime(2023, 2, 1),
      numberOfInstallments: 32,
    ),
    Debt(
      creditor: "Crédito de Consumo",
      totalAmount: 1500.00,
      installmentAmount: 125.00,
      startDate: DateTime(2023, 4, 20),
      numberOfInstallments: 12,
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

  void deleteDebt(Debt debt) {
    _debts.remove(debt);
    notifyListeners();
  }

  void updatePaymentStatus(Debt debt, int installmentNumber, PaymentStatus status) {
    final debtIndex = _debts.indexOf(debt);
    if (debtIndex != -1) {
      _debts[debtIndex].updatePaymentStatus(installmentNumber, status);
      notifyListeners();
    }
  }
}
