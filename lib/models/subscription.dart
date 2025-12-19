enum BillingCycle { mensual, anual }

class Subscription {
  final String id;
  final String name;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime nextPaymentDate;

  Subscription({
    required this.id,
    required this.name,
    required this.amount,
    required this.billingCycle,
    required this.nextPaymentDate,
  });

  Subscription copyWith({
    String? id,
    String? name,
    double? amount,
    BillingCycle? billingCycle,
    DateTime? nextPaymentDate,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      billingCycle: billingCycle ?? this.billingCycle,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
    );
  }
}
