import 'package:myapp/models/debt.dart';
import 'package:myapp/repositories/debt_repository.dart';
import 'package:myapp/services/storage_service.dart';

/// Implementación local del repositorio de deudas
/// Usa Hive para almacenamiento persistente
class LocalDebtRepository implements DebtRepository {
  List<Debt> _cache = [];
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (!_isLoaded) {
      _cache = StorageService.loadList<Debt>(
        StorageService.debtsBox,
        (json) => Debt.fromJson(json),
      );
      _isLoaded = true;
    }
  }

  Future<void> _save() async {
    await StorageService.saveList(StorageService.debtsBox, _cache);
  }

  @override
  Future<List<Debt>> getAll() async {
    await _ensureLoaded();
    return List.from(_cache);
  }

  @override
  Future<Debt?> getById(String id) async {
    await _ensureLoaded();
    try {
      return _cache.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Debt> create(Debt item) async {
    await _ensureLoaded();
    _cache.add(item);
    await _save();
    return item;
  }

  @override
  Future<Debt> update(Debt item) async {
    await _ensureLoaded();
    final index = _cache.indexWhere((d) => d.id == item.id);
    if (index != -1) {
      _cache[index] = item;
      await _save();
    }
    return item;
  }

  @override
  Future<bool> delete(String id) async {
    await _ensureLoaded();
    final removed = _cache.removeWhere((d) => d.id == id);
    await _save();
    return true;
  }

  @override
  Future<void> deleteAll() async {
    _cache.clear();
    await _save();
  }

  @override
  Future<Debt> updatePaymentStatus(String debtId, int installment, PaymentStatus status) async {
    await _ensureLoaded();
    final index = _cache.indexWhere((d) => d.id == debtId);
    if (index != -1) {
      final debt = _cache[index];
      final newStatus = Map<int, PaymentStatus>.from(debt.paymentStatus);
      newStatus[installment] = status;
      final updatedDebt = debt.copyWith(paymentStatus: newStatus);
      _cache[index] = updatedDebt;
      await _save();
      return updatedDebt;
    }
    throw Exception('Deuda no encontrada');
  }

  @override
  Future<List<Debt>> getPendingDebts() async {
    await _ensureLoaded();
    return _cache.where((d) => d.isPending && !d.isCompleted).toList();
  }

  @override
  Future<List<Debt>> getOverdueDebts() async {
    await _ensureLoaded();
    return _cache.where((d) {
      return d.paymentStatus.values.any((s) => s == PaymentStatus.atrasado);
    }).toList();
  }

  @override
  Future<double> getTotalMonthlyPayments() async {
    await _ensureLoaded();
    double total = 0;
    for (var debt in _cache) {
      if (!debt.isCompleted) {
        total += debt.cuotaMensual;
      }
    }
    return total;
  }
}

