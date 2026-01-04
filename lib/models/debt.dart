enum PaymentStatus { pagado, pendiente, atrasado, no_aplica }

extension PaymentStatusExtension on PaymentStatus {
  String get name {
    switch (this) {
      case PaymentStatus.pagado:
        return 'pagado';
      case PaymentStatus.pendiente:
        return 'pendiente';
      case PaymentStatus.atrasado:
        return 'atrasado';
      case PaymentStatus.no_aplica:
        return 'no_aplica';
    }
  }

  static PaymentStatus fromString(String name) {
    switch (name) {
      case 'pagado':
        return PaymentStatus.pagado;
      case 'pendiente':
        return PaymentStatus.pendiente;
      case 'atrasado':
        return PaymentStatus.atrasado;
      case 'no_aplica':
        return PaymentStatus.no_aplica;
      default:
        return PaymentStatus.pendiente;
    }
  }
}

class Debt {
  final String id;
  final String creditor;
  final double totalAmount;
  final int totalInstallments;
  final DateTime startDate;
  final int dueDay; // Día de vencimiento (1-28)
  final double? montoCuota; // Cuota mensual calculada o personalizada
  final String? notas;
  final Map<int, PaymentStatus> paymentStatus;

  Debt({
    required this.id,
    required this.creditor,
    required this.totalAmount,
    required this.totalInstallments,
    required this.startDate,
    this.dueDay = 1,
    this.montoCuota,
    this.notas,
    Map<int, PaymentStatus>? paymentStatus,
  }) : paymentStatus = paymentStatus ?? {};

  /// Cuota mensual calculada (si no hay montoCuota personalizado)
  double get cuotaMensual => montoCuota ?? (totalAmount / totalInstallments);

  /// Cantidad de cuotas pagadas
  int get cuotasPagadas => 
      paymentStatus.values.where((s) => s == PaymentStatus.pagado).length;

  /// Porcentaje de progreso
  double get progreso => 
      totalInstallments > 0 ? cuotasPagadas / totalInstallments : 0.0;

  /// Monto restante por pagar
  double get montoRestante => totalAmount - (cuotaMensual * cuotasPagadas);

  /// Si la deuda está completamente pagada
  bool get isCompleted => cuotasPagadas >= totalInstallments;

  PaymentStatus getStatusForInstallment(int installment) {
    return paymentStatus[installment] ?? PaymentStatus.pendiente;
  }

  bool get isPending {
    return paymentStatus.values.any((status) => status == PaymentStatus.pendiente) ||
           paymentStatus.isEmpty;
  }

  Debt copyWith({
    String? id,
    String? creditor,
    double? totalAmount,
    int? totalInstallments,
    DateTime? startDate,
    int? dueDay,
    double? montoCuota,
    String? notas,
    Map<int, PaymentStatus>? paymentStatus,
  }) {
    return Debt(
      id: id ?? this.id,
      creditor: creditor ?? this.creditor,
      totalAmount: totalAmount ?? this.totalAmount,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      startDate: startDate ?? this.startDate,
      dueDay: dueDay ?? this.dueDay,
      montoCuota: montoCuota ?? this.montoCuota,
      notas: notas ?? this.notas,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creditor': creditor,
      'totalAmount': totalAmount,
      'totalInstallments': totalInstallments,
      'startDate': startDate.toIso8601String(),
      'dueDay': dueDay,
      'montoCuota': montoCuota,
      'notas': notas,
      'paymentStatus': paymentStatus.map(
        (key, value) => MapEntry(key.toString(), value.name),
      ),
    };
  }

  factory Debt.fromJson(Map<String, dynamic> json) {
    final paymentStatusMap = <int, PaymentStatus>{};
    if (json['paymentStatus'] != null) {
      final statusJson = json['paymentStatus'] as Map;
      statusJson.forEach((key, value) {
        paymentStatusMap[int.parse(key.toString())] = 
            PaymentStatusExtension.fromString(value.toString());
      });
    }

    return Debt(
      id: json['id'] as String,
      creditor: json['creditor'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalInstallments: json['totalInstallments'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      dueDay: json['dueDay'] as int? ?? 1,
      montoCuota: json['montoCuota'] != null 
          ? (json['montoCuota'] as num).toDouble() 
          : null,
      notas: json['notas'] as String?,
      paymentStatus: paymentStatusMap,
    );
  }
}
