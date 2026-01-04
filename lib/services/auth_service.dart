import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/core/config/app_config.dart';
import 'package:myapp/core/network/api_client.dart';

/// Servicio de autenticación
/// Actualmente funciona en modo local (sin auth)
/// Preparado para conectar con API cuando se implemente
class AuthService extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final AppConfig _config = AppConfig();
  final ApiClient _apiClient = ApiClient();

  // Estado de autenticación
  AuthState _state = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;

  // Getters
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;

  /// Inicializa el servicio, carga sesión guardada si existe
  Future<void> initialize() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      // En modo local, siempre autenticado como usuario local
      if (_config.isLocalMode) {
        _currentUser = User.local();
        _state = AuthState.authenticated;
        notifyListeners();
        return;
      }

      // En modo remoto, verificar token guardado
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token != null) {
        _apiClient.setAuthToken(token);
        // TODO: Validar token con la API
        _currentUser = User(
          id: prefs.getString(_userIdKey) ?? '',
          email: prefs.getString(_userEmailKey) ?? '',
          name: prefs.getString(_userNameKey),
        );
        _state = AuthState.authenticated;
      } else {
        _state = AuthState.unauthenticated;
      }
    } catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Login con email y contraseña
  /// Solo funciona cuando esté conectada la API
  Future<bool> login(String email, String password) async {
    if (_config.isLocalMode) {
      // En modo local, login siempre exitoso
      _currentUser = User.local(email: email);
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    }

    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implementar cuando se conecte la API
      // final response = await _apiClient.post(ApiEndpoints.login, body: {
      //   'email': email,
      //   'password': password,
      // });
      
      throw UnimplementedError('API no conectada');
    } catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = 'Error de autenticación: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Registro de nuevo usuario
  /// Solo funciona cuando esté conectada la API
  Future<bool> register({
    required String email,
    required String password,
    String? name,
  }) async {
    if (_config.isLocalMode) {
      // En modo local, registro siempre exitoso
      _currentUser = User.local(email: email, name: name);
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    }

    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Implementar cuando se conecte la API
      throw UnimplementedError('API no conectada');
    } catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = 'Error de registro: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userNameKey);

      _apiClient.clearAuthToken();
      _currentUser = null;
      _state = AuthState.unauthenticated;
    } catch (e) {
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  /// Recuperar contraseña
  Future<bool> forgotPassword(String email) async {
    if (_config.isLocalMode) {
      return true; // En modo local, siempre exitoso
    }

    try {
      // TODO: Implementar cuando se conecte la API
      throw UnimplementedError('API no conectada');
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  /// Guarda los datos de sesión localmente
  Future<void> _saveSession(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, user.id);
    await prefs.setString(_userEmailKey, user.email);
    if (user.name != null) {
      await prefs.setString(_userNameKey, user.name!);
    }
  }

  /// Limpia el mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

/// Estados de autenticación
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

/// Modelo de usuario
class User {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final bool isLocal;

  User({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
    this.isLocal = false,
  });

  /// Usuario local (sin API)
  factory User.local({String? email, String? name}) {
    return User(
      id: 'local_user',
      email: email ?? 'usuario@local',
      name: name ?? 'Usuario Local',
      isLocal: true,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
    };
  }

  String get displayName => name ?? email.split('@').first;
}

