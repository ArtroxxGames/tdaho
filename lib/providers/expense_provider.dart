import 'package:flutter/material.dart';
import 'package:tdah_organizer/models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(
      description: 'Café y croissant',
      amount: 5.50,
      date: DateTime.now(),
      category: ExpenseCategory.comida,
      paymentMethod: PaymentMethod.tarjetaDebito,
    ),
    Expense(
      description: 'Ticket de metro',
      amount: 1.80,
      date: DateTime.now(),
      category: ExpenseCategory.transporte,
      paymentMethod: PaymentMethod.efectivo,
    ),
    Expense(
      description: 'Libro de Flutter',
      amount: 35.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: ExpenseCategory.educacion,
      paymentMethod: PaymentMethod.tarjetaCredito,
    ),
    Expense(
      description: 'Cena con amigos',
      amount: 25.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: ExpenseCategory.ocio,
      paymentMethod: PaymentMethod.tarjetaCredito,
    ),
        Expense(
      description: 'Compra semanal supermercado',
      amount: 75.30,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: ExpenseCategory.comida,
      paymentMethod: PaymentMethod.tarjetaDebito,
    ),
  ];

  ExpenseCategory? _selectedCategory;

  List<Expense> get expenses => _expenses;
  ExpenseCategory? get selectedCategory => _selectedCategory;

  List<Expense> get filteredExpenses {
    if (_selectedCategory == null) {
      return _expenses;
    } else {
      return _expenses.where((exp) => exp.category == _selectedCategory).toList();
    }
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date)); // Keep sorted
    notifyListeners();
  }

  void updateExpense(Expense oldExpense, Expense newExpense) {
    final index = _expenses.indexOf(oldExpense);
    if (index != -1) {
      _expenses[index] = newExpense;
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  void deleteExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  void updateCategoryFilter(ExpenseCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
