enum ExpenseCategory { Supermercado, Transporte, Ocio, Hogar, Salud, Otros }
enum PaymentMethod { Efectivo, Tarjeta, Transferencia }

class Expense {
  final String id;
  final String description;
  final double amount;
  final ExpenseCategory category;
  final PaymentMethod paymentMethod;
  final DateTime date;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.date,
  });

  Expense copyWith({
    String? id,
    String? description,
    double? amount,
    ExpenseCategory? category,
    PaymentMethod? paymentMethod,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
    );
  }
}
