enum ExpenseCategory { Supermercado, Transporte, Ocio, Hogar, Salud, Otros }
enum PaymentMethod { Efectivo, Tarjeta, Transferencia }

class Expense {
  final String id;
  final String description;
  final double amount;
  final ExpenseCategory category;
  final PaymentMethod paymentMethod;
  final DateTime date;
  final String? creditCardId; // ID de la tarjeta si el pago fue con tarjeta
  final bool isInstallment; // Si el pago es en cuotas
  final int? numberOfInstallments; // Número total de cuotas
  final int? currentInstallment; // Cuota actual

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.date,
    this.creditCardId,
    this.isInstallment = false,
    this.numberOfInstallments,
    this.currentInstallment,
  });

  Expense copyWith({
    String? id,
    String? description,
    double? amount,
    ExpenseCategory? category,
    PaymentMethod? paymentMethod,
    DateTime? date,
    String? creditCardId,
    bool? isInstallment,
    int? numberOfInstallments,
    int? currentInstallment,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      creditCardId: creditCardId ?? this.creditCardId,
      isInstallment: isInstallment ?? this.isInstallment,
      numberOfInstallments: numberOfInstallments ?? this.numberOfInstallments,
      currentInstallment: currentInstallment ?? this.currentInstallment,
    );
  }

  // Calcular el monto por cuota
  double get installmentAmount {
    if (!isInstallment || numberOfInstallments == null || numberOfInstallments! <= 0) {
      return amount;
    }
    return amount / numberOfInstallments!;
  }
}
