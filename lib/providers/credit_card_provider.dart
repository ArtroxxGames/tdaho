import 'package:flutter/material.dart';
import 'package:myapp/models/credit_card.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/services/storage_service.dart';

class CreditCardProvider with ChangeNotifier {
  List<CreditCard> _creditCards = [];

  CreditCardProvider() {
    _loadCreditCards();
  }

  List<CreditCard> get creditCards => _creditCards.where((c) => c.isActive).toList();
  List<CreditCard> get allCreditCards => _creditCards;

  void _loadCreditCards() {
    _creditCards = StorageService.loadList<CreditCard>(
      StorageService.creditCardsBox,
      (json) => CreditCard.fromJson(json),
    );

    // Si no hay datos, cargar datos de muestra
    if (_creditCards.isEmpty) {
      _creditCards = [
        CreditCard(
          id: '1',
          name: 'Visa Principal',
          bank: 'Banco Principal',
          lastFourDigits: '1234',
          creditLimit: 5000000,
          closingDay: 15,
          dueDay: 5,
          isActive: true,
        ),
        CreditCard(
          id: '2',
          name: 'Mastercard',
          bank: 'Banco Secundario',
          lastFourDigits: '5678',
          creditLimit: 3000000,
          closingDay: 20,
          dueDay: 10,
          isActive: true,
        ),
      ];
      _saveCreditCards();
    }
  }

  Future<void> _saveCreditCards() async {
    await StorageService.saveList(StorageService.creditCardsBox, _creditCards);
    notifyListeners();
  }

  Future<void> addCreditCard(CreditCard card) async {
    _creditCards.add(card);
    await _saveCreditCards();
  }

  Future<void> updateCreditCard(CreditCard oldCard, CreditCard newCard) async {
    final index = _creditCards.indexOf(oldCard);
    if (index != -1) {
      _creditCards[index] = newCard;
      await _saveCreditCards();
    }
  }

  Future<void> deleteCreditCard(CreditCard card) async {
    _creditCards.remove(card);
    await _saveCreditCards();
  }

  Future<void> toggleActive(CreditCard card) async {
    final index = _creditCards.indexOf(card);
    if (index != -1) {
      _creditCards[index] = card.copyWith(isActive: !card.isActive);
      await _saveCreditCards();
    }
  }

  CreditCard? getCreditCardById(String? id) {
    if (id == null) return null;
    try {
      return _creditCards.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtener gastos de una tarjeta para un mes específico
  // El mes se determina por el día de cierre
  List<Expense> getExpensesForMonth(
    CreditCard card,
    DateTime month,
    ExpenseProvider expenseProvider,
  ) {
    // Calcular el período de facturación basado en el día de cierre
    final closingDate = DateTime(month.year, month.month, card.closingDay);
    final previousClosingDate = closingDate.subtract(const Duration(days: 30));

    return expenseProvider.expenses.where((expense) {
      if (expense.creditCardId != card.id) return false;
      if (expense.date.isAfter(previousClosingDate) && expense.date.isBefore(closingDate.add(const Duration(days: 1)))) {
        return true;
      }
      return false;
    }).toList();
  }

  // Calcular total a pagar de una tarjeta en un mes
  double getTotalToPay(
    CreditCard card,
    DateTime month,
    ExpenseProvider expenseProvider,
  ) {
    final expenses = getExpensesForMonth(card, month, expenseProvider);
    return expenses.fold(0.0, (sum, expense) {
      // Si es en cuotas, solo contar la cuota actual
      if (expense.isInstallment && expense.currentInstallment != null) {
        return sum + expense.installmentAmount;
      }
      return sum + expense.amount;
    });
  }

  // Calcular disponible (límite - gastos)
  double? getAvailable(
    CreditCard card,
    DateTime month,
    ExpenseProvider expenseProvider,
  ) {
    if (card.creditLimit == null) return null;
    final totalToPay = getTotalToPay(card, month, expenseProvider);
    return card.creditLimit! - totalToPay;
  }

  // Calcular porcentaje de uso
  double getUsagePercentage(
    CreditCard card,
    DateTime month,
    ExpenseProvider expenseProvider,
  ) {
    if (card.creditLimit == null) return 0.0;
    final totalToPay = getTotalToPay(card, month, expenseProvider);
    return (totalToPay / card.creditLimit!) * 100;
  }

  Future<void> deleteAll() async {
    _creditCards.clear();
    await _saveCreditCards();
  }
}

