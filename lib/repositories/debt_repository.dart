import 'package:myapp/models/debt.dart';
import 'package:myapp/repositories/base_repository.dart';

/// Interfaz específica para el repositorio de deudas
/// Extiende las operaciones base con métodos específicos
abstract class DebtRepository extends BaseRepository<Debt> {
  /// Actualiza el estado de pago de una cuota específica
  Future<Debt> updatePaymentStatus(String debtId, int installment, PaymentStatus status);

  /// Obtiene deudas con pagos pendientes
  Future<List<Debt>> getPendingDebts();

  /// Obtiene deudas con pagos atrasados
  Future<List<Debt>> getOverdueDebts();

  /// Obtiene el total de cuotas mensuales
  Future<double> getTotalMonthlyPayments();
}

