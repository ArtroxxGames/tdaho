enum ExpenseCategory { Supermercado, Transporte, Ocio, Hogar, Salud, Otros }
enum PaymentMethod { Efectivo, Tarjeta, Transferencia }

extension ExpenseCategoryExtension on ExpenseCategory {
  String get name {
    switch (this) {
      case ExpenseCategory.Supermercado:
        return 'Supermercado';
      case ExpenseCategory.Transporte:
        return 'Transporte';
      case ExpenseCategory.Ocio:
        return 'Ocio';
      case ExpenseCategory.Hogar:
        return 'Hogar';
      case ExpenseCategory.Salud:
        return 'Salud';
      case ExpenseCategory.Otros:
        return 'Otros';
    }
  }

  static ExpenseCategory fromString(String name) {
    switch (name) {
      case 'Supermercado':
        return ExpenseCategory.Supermercado;
      case 'Transporte':
        return ExpenseCategory.Transporte;
      case 'Ocio':
        return ExpenseCategory.Ocio;
      case 'Hogar':
        return ExpenseCategory.Hogar;
      case 'Salud':
        return ExpenseCategory.Salud;
      case 'Otros':
        return ExpenseCategory.Otros;
      default:
        return ExpenseCategory.Otros;
    }
  }
}

extension PaymentMethodExtension on PaymentMethod {
  String get name {
    switch (this) {
      case PaymentMethod.Efectivo:
        return 'Efectivo';
      case PaymentMethod.Tarjeta:
        return 'Tarjeta';
      case PaymentMethod.Transferencia:
        return 'Transferencia';
    }
  }

  static PaymentMethod fromString(String name) {
    switch (name) {
      case 'Efectivo':
        return PaymentMethod.Efectivo;
      case 'Tarjeta':
        return PaymentMethod.Tarjeta;
      case 'Transferencia':
        return PaymentMethod.Transferencia;
      default:
        return PaymentMethod.Efectivo;
    }
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'category': category.name,
      'paymentMethod': paymentMethod.name,
      'date': date.toIso8601String(),
      'creditCardId': creditCardId,
      'isInstallment': isInstallment,
      'numberOfInstallments': numberOfInstallments,
      'currentInstallment': currentInstallment,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: ExpenseCategoryExtension.fromString(json['category'] as String),
      paymentMethod: PaymentMethodExtension.fromString(json['paymentMethod'] as String),
      date: DateTime.parse(json['date'] as String),
      creditCardId: json['creditCardId'] as String?,
      isInstallment: json['isInstallment'] as bool? ?? false,
      numberOfInstallments: json['numberOfInstallments'] as int?,
      currentInstallment: json['currentInstallment'] as int?,
    );
  }
}
