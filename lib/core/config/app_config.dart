/// Configuración global de la aplicación
/// Permite cambiar entre modo local y remoto (API)
class AppConfig {
  // Singleton
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  /// Modo de datos: local (Hive) o remoto (API)
  DataMode _dataMode = DataMode.local;
  
  /// URL base de la API (para cuando se implemente)
  String _apiBaseUrl = 'https://api.example.com/v1';
  
  /// Timeout para requests HTTP (segundos)
  int _apiTimeout = 30;

  // ============ GETTERS ============
  
  DataMode get dataMode => _dataMode;
  String get apiBaseUrl => _apiBaseUrl;
  int get apiTimeout => _apiTimeout;
  bool get isLocalMode => _dataMode == DataMode.local;
  bool get isRemoteMode => _dataMode == DataMode.remote;

  // ============ SETTERS ============
  
  void setDataMode(DataMode mode) {
    _dataMode = mode;
  }

  void setApiBaseUrl(String url) {
    _apiBaseUrl = url;
  }

  void setApiTimeout(int seconds) {
    _apiTimeout = seconds;
  }

  /// Configuración para modo local (default)
  void configureForLocal() {
    _dataMode = DataMode.local;
  }

  /// Configuración para modo remoto (API)
  void configureForRemote({
    required String baseUrl,
    int timeout = 30,
  }) {
    _dataMode = DataMode.remote;
    _apiBaseUrl = baseUrl;
    _apiTimeout = timeout;
  }
}

/// Modos de almacenamiento de datos
enum DataMode {
  /// Datos almacenados localmente con Hive
  local,
  
  /// Datos sincronizados con API remota
  remote,
  
  /// Modo híbrido: local con sync a remoto (futuro)
  hybrid,
}

