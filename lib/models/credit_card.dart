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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bank': bank,
      'lastFourDigits': lastFourDigits,
      'creditLimit': creditLimit,
      'closingDay': closingDay,
      'dueDay': dueDay,
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'] as String,
      name: json['name'] as String,
      bank: json['bank'] as String?,
      lastFourDigits: json['lastFourDigits'] as String?,
      creditLimit: json['creditLimit'] != null 
          ? (json['creditLimit'] as num).toDouble()
          : null,
      closingDay: json['closingDay'] as int,
      dueDay: json['dueDay'] as int,
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String?,
    );
  }
}

