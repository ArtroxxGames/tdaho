import 'package:hive_flutter/hive_flutter.dart';

/// Servicio centralizado para gestionar el almacenamiento con Hive
class StorageService {
  static const String debtsBox = 'debts';
  static const String subscriptionsBox = 'subscriptions';
  static const String expensesBox = 'expenses';
  static const String creditCardsBox = 'credit_cards';
  static const String overduePaymentsBox = 'overdue_payments';
  static const String tasksBox = 'tasks';
  static const String notesBox = 'notes';
  static const String coursesBox = 'courses';
  static const String logsBox = 'logs';

  /// Inicializa Hive y abre todas las cajas necesarias
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Abrir todas las cajas
    await Hive.openBox(debtsBox);
    await Hive.openBox(subscriptionsBox);
    await Hive.openBox(expensesBox);
    await Hive.openBox(creditCardsBox);
    await Hive.openBox(overduePaymentsBox);
    await Hive.openBox(tasksBox);
    await Hive.openBox(notesBox);
    await Hive.openBox(coursesBox);
    await Hive.openBox(logsBox);
  }

  /// Obtiene una caja por nombre
  static Box getBox(String boxName) {
    return Hive.box(boxName);
  }

  /// Guarda una lista de objetos en una caja
  static Future<void> saveList<T>(String boxName, List<T> items) async {
    final box = getBox(boxName);
    final List<Map<String, dynamic>> jsonList = 
        items.map((item) => (item as dynamic).toJson() as Map<String, dynamic>).toList();
    await box.put('list', jsonList);
  }

  /// Carga una lista de objetos desde una caja
  static List<T> loadList<T>(String boxName, T Function(Map<String, dynamic>) fromJson) {
    final box = getBox(boxName);
    final data = box.get('list');
    if (data == null) return [];
    
    if (data is List) {
      return data
          .cast<Map>()
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Limpia todos los datos de una caja
  static Future<void> clearBox(String boxName) async {
    final box = getBox(boxName);
    await box.clear();
  }
}

