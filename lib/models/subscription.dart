enum BillingCycle { mensual, anual }

extension BillingCycleExtension on BillingCycle {
  String get name {
    switch (this) {
      case BillingCycle.mensual:
        return 'mensual';
      case BillingCycle.anual:
        return 'anual';
    }
  }

  static BillingCycle fromString(String name) {
    switch (name) {
      case 'mensual':
        return BillingCycle.mensual;
      case 'anual':
        return BillingCycle.anual;
      default:
        return BillingCycle.mensual;
    }
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'billingCycle': billingCycle.name,
      'nextPaymentDate': nextPaymentDate.toIso8601String(),
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      billingCycle: BillingCycleExtension.fromString(json['billingCycle'] as String),
      nextPaymentDate: DateTime.parse(json['nextPaymentDate'] as String),
    );
  }
}
