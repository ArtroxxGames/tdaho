class Course {
  final String id;
  final String name;
  final String platform;
  final String? url;
  final List<int> studyDays; // 0=Domingo, 1=Lunes, ..., 6=Sábado
  final String? startTime; // HH:MM format
  final int? durationMinutes;
  final int progress; // 0-100
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    String? id,
    required this.name,
    required this.platform,
    this.url,
    List<int>? studyDays,
    this.startTime,
    this.durationMinutes,
    this.progress = 0,
    this.isActive = true,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        studyDays = studyDays ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Course copyWith({
    String? id,
    String? name,
    String? platform,
    String? url,
    List<int>? studyDays,
    String? startTime,
    int? durationMinutes,
    int? progress,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      url: url ?? this.url,
      studyDays: studyDays ?? this.studyDays,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      progress: progress ?? this.progress,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Verificar si el curso está asignado para hoy
  bool isAssignedForToday() {
    final today = DateTime.now();
    final dayOfWeek = today.weekday % 7; // 0=Domingo, 1=Lunes, etc.
    return studyDays.contains(dayOfWeek);
  }

  // Verificar si el curso está asignado para un día específico
  bool isAssignedForDay(int dayOfWeek) {
    return studyDays.contains(dayOfWeek);
  }

  // Obtener nombre del día de la semana
  static String getDayName(int dayOfWeek) {
    const days = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];
    return days[dayOfWeek];
  }

  // Obtener nombre completo del día
  static String getDayFullName(int dayOfWeek) {
    const days = [
      'Domingo',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado'
    ];
    return days[dayOfWeek];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'url': url,
      'studyDays': studyDays,
      'startTime': startTime,
      'durationMinutes': durationMinutes,
      'progress': progress,
      'isActive': isActive,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      platform: json['platform'] as String,
      url: json['url'] as String?,
      studyDays: (json['studyDays'] as List?)?.cast<int>() ?? [],
      startTime: json['startTime'] as String?,
      durationMinutes: json['durationMinutes'] as int?,
      progress: json['progress'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}

