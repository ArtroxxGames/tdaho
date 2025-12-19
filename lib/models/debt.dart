enum PaymentStatus { pendiente, pagado, atrasado }

class Debt {
  final String creditor;
  final double totalAmount;
  final double installmentAmount;
  final DateTime startDate;
  final int numberOfInstallments;
  // Un mapa para rastrear el estado de cada cuota. La clave es el número de la cuota (ej: 1, 2, 3...)
  final Map<int, PaymentStatus> payments;

  Debt({
    required this.creditor,
    required this.totalAmount,
    required this.installmentAmount,
    required this.startDate,
    required this.numberOfInstallments,
    Map<int, PaymentStatus>? payments,
  }) : payments = payments ??
            Map.fromIterables(
              List.generate(numberOfInstallments, (i) => i + 1),
              List.generate(numberOfInstallments, (i) => PaymentStatus.pendiente),
            );

  // Lógica para obtener el estado de una cuota específica
  PaymentStatus getStatusForInstallment(int installmentNumber) {
    return payments[installmentNumber] ?? PaymentStatus.pendiente;
  }

  // Lógica para actualizar el estado de una cuota
  void updatePaymentStatus(int installmentNumber, PaymentStatus status) {
    if (payments.containsKey(installmentNumber)) {
      payments[installmentNumber] = status;
    }
  }
}
