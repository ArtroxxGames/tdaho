import 'package:myapp/core/config/app_config.dart';
import 'package:myapp/repositories/debt_repository.dart';
import 'package:myapp/repositories/local/local_debt_repository.dart';

/// Factory para crear repositorios según el modo configurado
/// Permite cambiar entre repositorios locales y remotos
class RepositoryFactory {
  // Singleton
  static final RepositoryFactory _instance = RepositoryFactory._internal();
  factory RepositoryFactory() => _instance;
  RepositoryFactory._internal();

  final AppConfig _config = AppConfig();

  // Cache de repositorios para singleton por tipo
  final Map<Type, dynamic> _repositories = {};

  /// Obtiene el repositorio de deudas
  DebtRepository get debtRepository {
    if (!_repositories.containsKey(DebtRepository)) {
      _repositories[DebtRepository] = _createDebtRepository();
    }
    return _repositories[DebtRepository] as DebtRepository;
  }

  DebtRepository _createDebtRepository() {
    switch (_config.dataMode) {
      case DataMode.local:
        return LocalDebtRepository();
      case DataMode.remote:
        // TODO: return RemoteDebtRepository();
        throw UnimplementedError('RemoteDebtRepository no implementado');
      case DataMode.hybrid:
        // TODO: return HybridDebtRepository();
        throw UnimplementedError('HybridDebtRepository no implementado');
    }
  }

  // ============ OTROS REPOSITORIOS (A implementar según necesidad) ============
  
  // Future implementations:
  // ExpenseRepository get expenseRepository { ... }
  // SubscriptionRepository get subscriptionRepository { ... }
  // TaskRepository get taskRepository { ... }
  // NoteRepository get noteRepository { ... }
  // CourseRepository get courseRepository { ... }
  // CreditCardRepository get creditCardRepository { ... }
  // OverduePaymentRepository get overduePaymentRepository { ... }

  /// Limpia el cache de repositorios
  /// Útil cuando se cambia el modo de datos
  void clearCache() {
    _repositories.clear();
  }

  /// Reconfigura los repositorios para un nuevo modo
  void reconfigure(DataMode mode) {
    _config.setDataMode(mode);
    clearCache();
  }
}

