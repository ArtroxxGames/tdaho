import 'package:flutter/material.dart';
import 'package:myapp/models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(id: '1', description: 'Café y tarta', amount: 8.50, category: ExpenseCategory.Ocio, paymentMethod: PaymentMethod.Tarjeta, date: DateTime.now().subtract(const Duration(days: 1))),
    Expense(id: '2', description: 'Compra semanal', amount: 75.20, category: ExpenseCategory.Supermercado, paymentMethod: PaymentMethod.Tarjeta, date: DateTime.now().subtract(const Duration(days: 2))),
    Expense(id: '3', description: 'Billetes de metro', amount: 12.40, category: ExpenseCategory.Transporte, paymentMethod: PaymentMethod.Efectivo, date: DateTime.now().subtract(const Duration(days: 3))),
  ];

  List<Expense> get expenses => _expenses;

  List<Expense> getExpensesForMonth(DateTime month) {
    return _expenses.where((expense) => expense.date.month == month.month && expense.date.year == month.year).toList();
  }

  Map<ExpenseCategory, double> get groupedExpenses {
    final Map<ExpenseCategory, double> data = {};
    for (var expense in _expenses) {
      data.update(expense.category, (value) => value + expense.amount, ifAbsent: () => expense.amount);
    }
    return data;
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void updateExpense(Expense oldExpense, Expense newExpense) {
    final index = _expenses.indexOf(oldExpense);
    if (index != -1) {
      _expenses[index] = newExpense;
      notifyListeners();
    }
  }

  void deleteExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  void deleteAll() {
    _expenses.clear();
    notifyListeners();
  }
}
