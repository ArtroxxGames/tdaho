class OverduePayment {
  final String id;
  final String? debtId; // ID de la deuda relacionada (opcional)
  final String debtName; // Nombre de la deuda
  final String month; // Mes del pago atrasado (texto libre, ej: "Enero 2024")
  final double amount;
  final DateTime dueDate; // Fecha de vencimiento original
  final DateTime createdAt;

  OverduePayment({
    required this.id,
    this.debtId,
    required this.debtName,
    required this.month,
    required this.amount,
    required this.dueDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Calcular días de atraso desde la fecha de vencimiento
  int get daysOverdue {
    final now = DateTime.now();
    final difference = now.difference(dueDate).inDays;
    return difference > 0 ? difference : 0;
  }

  // Verificar si vence hoy
  bool get isDueToday {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  // Obtener texto descriptivo del estado
  String get statusText {
    if (isDueToday) return 'Vence hoy';
    if (daysOverdue == 0) return 'Vence pronto';
    return '$daysOverdue ${daysOverdue == 1 ? 'día' : 'días'} de atraso';
  }

  OverduePayment copyWith({
    String? id,
    String? debtId,
    String? debtName,
    String? month,
    double? amount,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return OverduePayment(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      debtName: debtName ?? this.debtName,
      month: month ?? this.month,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

