import 'package:flutter/material.dart';

class IncomeProvider with ChangeNotifier {
  double _totalIncome = 0.0;

  double get totalIncome => _totalIncome;

  void setTotalIncome(double income) {
    _totalIncome = income;
    notifyListeners();
  }

  void addIncome(double amount) {
    _totalIncome += amount;
    notifyListeners();
  }

  void removeIncome(double amount) {
    _totalIncome -= amount;
    if (_totalIncome < 0) _totalIncome = 0;
    notifyListeners();
  }
}

