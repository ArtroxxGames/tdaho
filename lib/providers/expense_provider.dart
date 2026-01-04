import 'package:flutter/material.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/providers/log_provider.dart';
import 'package:myapp/services/storage_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  ExpenseProvider() {
    _loadExpenses();
  }

  List<Expense> get expenses => _expenses;

  void _loadExpenses() {
    _expenses = StorageService.loadList<Expense>(
      StorageService.expensesBox,
      (json) => Expense.fromJson(json),
    );

    // Si no hay datos, cargar datos de muestra
    if (_expenses.isEmpty) {
      _expenses = [
        Expense(
          id: '1',
          description: 'Café y tarta',
          amount: 8.50,
          category: ExpenseCategory.Ocio,
          paymentMethod: PaymentMethod.Tarjeta,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Expense(
          id: '2',
          description: 'Compra semanal',
          amount: 75.20,
          category: ExpenseCategory.Supermercado,
          paymentMethod: PaymentMethod.Tarjeta,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Expense(
          id: '3',
          description: 'Billetes de metro',
          amount: 12.40,
          category: ExpenseCategory.Transporte,
          paymentMethod: PaymentMethod.Efectivo,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
      _saveExpenses();
    }
  }

  Future<void> _saveExpenses() async {
    await StorageService.saveList(StorageService.expensesBox, _expenses);
    notifyListeners();
  }

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

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await _saveExpenses();
    LogProvider.instance?.info('Gastos', 'Nuevo gasto registrado: ${expense.description}', metadata: {
      'monto': expense.amount,
      'categoria': expense.category.name,
    });
  }

  Future<void> updateExpense(Expense oldExpense, Expense newExpense) async {
    final index = _expenses.indexOf(oldExpense);
    if (index != -1) {
      _expenses[index] = newExpense;
      await _saveExpenses();
      LogProvider.instance?.info('Gastos', 'Gasto actualizado: ${newExpense.description}');
    }
  }

  Future<void> deleteExpense(Expense expense) async {
    _expenses.remove(expense);
    await _saveExpenses();
    LogProvider.instance?.warning('Gastos', 'Gasto eliminado: ${expense.description}');
  }

  Future<void> deleteAll() async {
    _expenses.clear();
    await _saveExpenses();
    LogProvider.instance?.warning('Gastos', 'Todos los gastos eliminados');
  }
}
