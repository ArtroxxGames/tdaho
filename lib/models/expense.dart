import 'package:flutter/material.dart';

enum ExpenseCategory {
  comida('Comida', Icons.fastfood, Colors.orange),
  transporte('Transporte', Icons.directions_bus, Colors.blue),
  hogar('Hogar', Icons.home, Colors.green),
  ocio('Ocio', Icons.sports_esports, Colors.purple),
  salud('Salud', Icons.healing, Colors.red),
  educacion('Educación', Icons.school, Colors.teal),
  ropa('Ropa', Icons.checkroom, Colors.pink),
  otros('Otros', Icons.category, Colors.grey);

  const ExpenseCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

enum PaymentMethod {
  efectivo('Efectivo'),
  tarjetaCredito('Tarjeta de Crédito'),
  tarjetaDebito('Tarjeta de Débito'),
  transferencia('Transferencia');

  const PaymentMethod(this.label);
  final String label;
}

class Expense {
  final String description;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final PaymentMethod paymentMethod;

  Expense({
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.paymentMethod,
  });
}
