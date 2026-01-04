import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:myapp/core/config/app_config.dart';

/// Cliente HTTP para comunicación con la API
/// Se activará cuando se implemente el backend
class ApiClient {
  // Singleton
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final AppConfig _config = AppConfig();
  String? _authToken;
  
  // Headers base para todas las requests
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  /// Establece el token de autenticación
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Verifica si hay token de autenticación
  bool get isAuthenticated => _authToken != null;

  /// Limpia el token de autenticación
  void clearAuthToken() {
    _authToken = null;
  }

  // ============ MÉTODOS HTTP ============
  // Estos métodos estarán disponibles cuando se conecte a la API
  
  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    // TODO: Implementar cuando se conecte la API
    throw UnimplementedError('API no conectada. Usar modo local.');
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    // TODO: Implementar cuando se conecte la API
    throw UnimplementedError('API no conectada. Usar modo local.');
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    // TODO: Implementar cuando se conecte la API
    throw UnimplementedError('API no conectada. Usar modo local.');
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    // TODO: Implementar cuando se conecte la API
    throw UnimplementedError('API no conectada. Usar modo local.');
  }

  /// Construye la URL completa
  String _buildUrl(String endpoint, [Map<String, String>? queryParams]) {
    final uri = Uri.parse('${_config.apiBaseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams).toString();
    }
    return uri.toString();
  }
}

/// Respuesta genérica de la API
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final ApiError? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.error,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(ApiError error, {int? statusCode}) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }
}

/// Error de API
class ApiError {
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String? ?? 'UNKNOWN',
      message: json['message'] as String? ?? 'Error desconocido',
      details: json['details'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() => 'ApiError($code): $message';
}

