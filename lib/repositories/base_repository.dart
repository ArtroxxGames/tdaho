/// Interfaz base para todos los repositorios
/// Define las operaciones CRUD básicas que deben implementar
/// tanto los repositorios locales como los remotos
abstract class BaseRepository<T> {
  /// Obtiene todos los items
  Future<List<T>> getAll();

  /// Obtiene un item por su ID
  Future<T?> getById(String id);

  /// Crea un nuevo item
  Future<T> create(T item);

  /// Actualiza un item existente
  Future<T> update(T item);

  /// Elimina un item por su ID
  Future<bool> delete(String id);

  /// Elimina todos los items
  Future<void> deleteAll();
}

/// Resultado de una operación de repositorio
class RepositoryResult<T> {
  final bool success;
  final T? data;
  final String? errorMessage;
  final RepositoryErrorType? errorType;

  RepositoryResult._({
    required this.success,
    this.data,
    this.errorMessage,
    this.errorType,
  });

  factory RepositoryResult.success(T data) {
    return RepositoryResult._(success: true, data: data);
  }

  factory RepositoryResult.error(String message, {RepositoryErrorType? type}) {
    return RepositoryResult._(
      success: false,
      errorMessage: message,
      errorType: type ?? RepositoryErrorType.unknown,
    );
  }

  bool get isError => !success;
}

/// Tipos de error del repositorio
enum RepositoryErrorType {
  notFound,
  validation,
  network,
  unauthorized,
  serverError,
  localStorageError,
  unknown,
}

