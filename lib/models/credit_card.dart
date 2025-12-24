class CreditCard {
  final String id;
  final String name;
  final String? bank;
  final String? lastFourDigits;
  final double? creditLimit;
  final int closingDay; // 1-28
  final int dueDay; // 1-28
  final bool isActive;
  final String? notes;

  CreditCard({
    required this.id,
    required this.name,
    this.bank,
    this.lastFourDigits,
    this.creditLimit,
    required this.closingDay,
    required this.dueDay,
    this.isActive = true,
    this.notes,
  });

  CreditCard copyWith({
    String? id,
    String? name,
    String? bank,
    String? lastFourDigits,
    double? creditLimit,
    int? closingDay,
    int? dueDay,
    bool? isActive,
    String? notes,
  }) {
    return CreditCard(
      id: id ?? this.id,
      name: name ?? this.name,
      bank: bank ?? this.bank,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      creditLimit: creditLimit ?? this.creditLimit,
      closingDay: closingDay ?? this.closingDay,
      dueDay: dueDay ?? this.dueDay,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  String get displayName {
    if (lastFourDigits != null && lastFourDigits!.isNotEmpty) {
      return '$name •••• $lastFourDigits';
    }
    return name;
  }
}

