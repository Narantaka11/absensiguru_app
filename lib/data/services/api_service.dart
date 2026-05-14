import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  late Dio _dio;

  // 🔥 GANTI DENGAN IP LAPTOP KAMU
  static const String baseUrl = 'http://10.75.85.242:8000/api/v1';

  ApiService._internal() {
    _initializeDio();
  }

  factory ApiService() {
    return _instance;
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),

        // 🔥 DEFAULT HEADER
        headers: {'Accept': 'application/json'},
      ),
    );

    // 🔥 INTERCEPTOR LOGGING
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🔥 REQUEST => ${options.method} ${options.uri}');

          print('🔥 DATA => ${options.data}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE => ${response.statusCode}');

          print('✅ DATA => ${response.data}');

          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR => ${error.response?.statusCode}');

          print('❌ MESSAGE => ${error.message}');

          return handler.next(error);
        },
      ),
    );
  }

  // 🔥 SET TOKEN
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // 🔥 CLEAR TOKEN
  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  // 🔥 GET DIO INSTANCE
  Dio get dio => _dio;

  // 🔥 GET REQUEST
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return response;
    } on DioException {
      rethrow;
    }
  }

  // 🔥 POST REQUEST
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);

      return response;
    } on DioException {
      rethrow;
    }
  }

  // 🔥 PUT REQUEST
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);

      return response;
    } on DioException {
      rethrow;
    }
  }

  // 🔥 DELETE REQUEST
  Future<Response> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);

      return response;
    } on DioException {
      rethrow;
    }
  }
}
