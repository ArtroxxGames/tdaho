enum PaymentStatus { pagado, pendiente, atrasado, no_aplica }

class Debt {
  final String id;
  final String creditor;
  final double totalAmount;
  final int totalInstallments;
  final DateTime startDate;
  final Map<int, PaymentStatus> paymentStatus;

  Debt({
    required this.id,
    required this.creditor,
    required this.totalAmount,
    required this.totalInstallments,
    required this.startDate,
    Map<int, PaymentStatus>? paymentStatus,
  }) : paymentStatus = paymentStatus ?? {};

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
    Map<int, PaymentStatus>? paymentStatus,
  }) {
    return Debt(
      id: id ?? this.id,
      creditor: creditor ?? this.creditor,
      totalAmount: totalAmount ?? this.totalAmount,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      startDate: startDate ?? this.startDate,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}
