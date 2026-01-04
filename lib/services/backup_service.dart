import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/debt.dart';
import 'package:myapp/models/subscription.dart';
import 'package:myapp/models/expense.dart';
import 'package:myapp/models/credit_card.dart';
import 'package:myapp/models/overdue_payment.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/models/note.dart';
import 'package:myapp/models/course.dart';
import 'package:myapp/providers/debt_provider.dart';
import 'package:myapp/providers/subscription_provider.dart';
import 'package:myapp/providers/expense_provider.dart';
import 'package:myapp/providers/credit_card_provider.dart';
import 'package:myapp/providers/overdue_payment_provider.dart';
import 'package:myapp/providers/task_provider.dart';
import 'package:myapp/providers/note_provider.dart';
import 'package:myapp/providers/course_provider.dart';
import 'package:myapp/providers/settings_provider.dart';

class BackupService {
  /// Exporta todos los datos a un archivo JSON
  static Future<String?> exportData({
    required BuildContext context,
    required DebtProvider debtProvider,
    required SubscriptionProvider subscriptionProvider,
    required ExpenseProvider expenseProvider,
    required CreditCardProvider creditCardProvider,
    required OverduePaymentProvider overduePaymentProvider,
    required TaskProvider taskProvider,
    required NoteProvider noteProvider,
    required CourseProvider courseProvider,
    required SettingsProvider settingsProvider,
  }) async {
    try {
      // Recopilar todos los datos
      final backupData = {
        'version': '1.0.0',
        'exportDate': DateTime.now().toIso8601String(),
        'data': {
          'debts': debtProvider.debts.map((d) => d.toJson()).toList(),
          'subscriptions': subscriptionProvider.subscriptions.map((s) => s.toJson()).toList(),
          'expenses': expenseProvider.expenses.map((e) => e.toJson()).toList(),
          'creditCards': creditCardProvider.creditCards.map((c) => c.toJson()).toList(),
          'overduePayments': overduePaymentProvider.overduePayments.map((o) => o.toJson()).toList(),
          'tasks': taskProvider.tasks.map((t) => t.toJson()).toList(),
          'notes': noteProvider.notes.map((n) => n.toJson()).toList(),
          'courses': courseProvider.courses.map((c) => c.toJson()).toList(),
          'settings': {
            'currency': settingsProvider.currency.code,
            'exchangeRateUsdPyg': settingsProvider.exchangeRateUsdPyg,
          },
        },
      };

      // Convertir a JSON
      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);

      // Obtener directorio de documentos
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
      final fileName = 'tdaho_backup_$timestamp.json';
      final file = File('${directory.path}/$fileName');

      // Escribir archivo
      await file.writeAsString(jsonString);

      return file.path;
    } catch (e) {
      debugPrint('Error al exportar datos: $e');
      return null;
    }
  }

  /// Importa datos desde un archivo JSON
  static Future<Map<String, dynamic>?> importData(BuildContext context) async {
    try {
      // Seleccionar archivo
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        return {'success': false, 'message': 'No se seleccionó ningún archivo'};
      }

      final filePath = result.files.single.path!;
      final file = File(filePath);
      final jsonString = await file.readAsString();

      // Parsear JSON
      final Map<String, dynamic> backupData;
      try {
        backupData = jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return {'success': false, 'message': 'El archivo JSON no es válido'};
      }

      // Validar estructura
      if (!backupData.containsKey('data')) {
        return {'success': false, 'message': 'El archivo no contiene datos válidos'};
      }

      final data = backupData['data'] as Map<String, dynamic>;

      // Validar y parsear cada tipo de dato
      final validationErrors = <String>[];

      // Validar deudas
      if (data.containsKey('debts')) {
        try {
          final debtsList = data['debts'] as List;
          for (var debtJson in debtsList) {
            Debt.fromJson(debtJson as Map<String, dynamic>);
          }
        } catch (e) {
          validationErrors.add('Deudas: ${e.toString()}');
        }
      }

      // Validar suscripciones
      if (data.containsKey('subscriptions')) {
        try {
          final subscriptionsList = data['subscriptions'] as List;
          for (var subJson in subscriptionsList) {
            Subscription.fromJson(subJson as Map<String, dynamic>);
          }
        } catch (e) {
          validationErrors.add('Suscripciones: ${e.toString()}');
        }
      }

      // Validar gastos
      if (data.containsKey('expenses')) {
        try {
          final expensesList = data['expenses'] as List;
          for (var expJson in expensesList) {
            Expense.fromJson(expJson as Map<String, dynamic>);
          }
        } catch (e) {
          validationErrors.add('Gastos: ${e.toString()}');
        }
      }

      // Validar tarjetas de crédito
      if (data.containsKey('creditCards')) {
        try {
          final cardsList = data['creditCards'] as List;
          for (var cardJson in cardsList) {
            CreditCard.fromJson(cardJson as Map<String, dynamic>);
          }
        } catch (e) {
          validationErrors.add('Tarjetas de crédito: ${e.toString()}');
        }
      }

      // Validar pagos atrasados
      if (data.containsKey('overduePayments')) {
        try {
          final overdueList = data['overduePayments'] as List;
          for (var overdueJson in overdueList) {
            OverduePayment.fromJson(overdueJson as Map<String, dynamic>);
          }
        } catch (e) {
          validationErrors.add('Pagos atrasados: ${e.toString()}');
        }
      }

      // Validar tareas
      if (data.containsKey('tasks')) {
        try {
          final tasksList = data['tasks'] as List;
          for (var taskJson in tasksList) {
            Task.fromJson(taskJson as Map<String, dynamic>);
          }
        } catch (e) {
          validationErrors.add('Tareas: ${e.toString()}');
        }
      }

      // Validar notas
      if (data.containsKey('notes')) {
        try {
          final notesList = data['notes'] as List;
          for (var noteJson in notesList) {
            Note.fromJson(noteJson as Map<String, dynamic>);
          }
        } catch (e) {
          validationErrors.add('Notas: ${e.toString()}');
        }
      }

      // Validar cursos
      if (data.containsKey('courses')) {
        try {
          final coursesList = data['courses'] as List;
          for (var courseJson in coursesList) {
            Course.fromJson(courseJson as Map<String, dynamic>);
          }
        } catch (e) {
          validationErrors.add('Cursos: ${e.toString()}');
        }
      }

      if (validationErrors.isNotEmpty) {
        return {
          'success': false,
          'message': 'Errores de validación:\n${validationErrors.join('\n')}',
        };
      }

      return {
        'success': true,
        'data': data,
        'version': backupData['version'] as String? ?? '1.0.0',
        'exportDate': backupData['exportDate'] as String?,
      };
    } catch (e) {
      debugPrint('Error al importar datos: $e');
      return {'success': false, 'message': 'Error al leer el archivo: ${e.toString()}'};
    }
  }

  /// Aplica los datos importados a los providers
  static Future<void> applyImportedData({
    required BuildContext context,
    required Map<String, dynamic> data,
    required DebtProvider debtProvider,
    required SubscriptionProvider subscriptionProvider,
    required ExpenseProvider expenseProvider,
    required CreditCardProvider creditCardProvider,
    required OverduePaymentProvider overduePaymentProvider,
    required TaskProvider taskProvider,
    required NoteProvider noteProvider,
    required CourseProvider courseProvider,
    required SettingsProvider settingsProvider,
  }) async {
    try {
      // Importar deudas
      if (data.containsKey('debts')) {
        final debtsList = data['debts'] as List;
        for (var debtJson in debtsList) {
          final debt = Debt.fromJson(debtJson as Map<String, dynamic>);
          await debtProvider.addDebt(debt);
        }
      }

      // Importar suscripciones
      if (data.containsKey('subscriptions')) {
        final subscriptionsList = data['subscriptions'] as List;
        for (var subJson in subscriptionsList) {
          final subscription = Subscription.fromJson(subJson as Map<String, dynamic>);
          await subscriptionProvider.addSubscription(subscription);
        }
      }

      // Importar gastos
      if (data.containsKey('expenses')) {
        final expensesList = data['expenses'] as List;
        for (var expJson in expensesList) {
          final expense = Expense.fromJson(expJson as Map<String, dynamic>);
          await expenseProvider.addExpense(expense);
        }
      }

      // Importar tarjetas de crédito
      if (data.containsKey('creditCards')) {
        final cardsList = data['creditCards'] as List;
        for (var cardJson in cardsList) {
          final card = CreditCard.fromJson(cardJson as Map<String, dynamic>);
          await creditCardProvider.addCreditCard(card);
        }
      }

      // Importar pagos atrasados
      if (data.containsKey('overduePayments')) {
        final overdueList = data['overduePayments'] as List;
        for (var overdueJson in overdueList) {
          final overdue = OverduePayment.fromJson(overdueJson as Map<String, dynamic>);
          await overduePaymentProvider.addOverduePayment(overdue);
        }
      }

      // Importar tareas
      if (data.containsKey('tasks')) {
        final tasksList = data['tasks'] as List;
        for (var taskJson in tasksList) {
          final task = Task.fromJson(taskJson as Map<String, dynamic>);
          await taskProvider.addTask(task);
        }
      }

      // Importar notas
      if (data.containsKey('notes')) {
        final notesList = data['notes'] as List;
        for (var noteJson in notesList) {
          final note = Note.fromJson(noteJson as Map<String, dynamic>);
          await noteProvider.addNote(note);
        }
      }

      // Importar cursos
      if (data.containsKey('courses')) {
        final coursesList = data['courses'] as List;
        for (var courseJson in coursesList) {
          final course = Course.fromJson(courseJson as Map<String, dynamic>);
          await courseProvider.addCourse(course);
        }
      }

      // Importar configuración
      if (data.containsKey('settings')) {
        final settings = data['settings'] as Map<String, dynamic>;
        if (settings.containsKey('currency')) {
          final currencyCode = settings['currency'] as String;
          final currency = Currency.values.firstWhere(
            (c) => c.code == currencyCode,
            orElse: () => Currency.pyg,
          );
          await settingsProvider.setCurrency(currency);
        }
        if (settings.containsKey('exchangeRateUsdPyg')) {
          final rate = (settings['exchangeRateUsdPyg'] as num).toDouble();
          await settingsProvider.setExchangeRateUsdPyg(rate);
        }
      }
    } catch (e) {
      debugPrint('Error al aplicar datos importados: $e');
      rethrow;
    }
  }
}

