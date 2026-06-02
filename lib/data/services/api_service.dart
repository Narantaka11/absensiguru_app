import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  late Dio _dio;

  static const String baseUrl = 'http://192.168.18.27:8000/api/v1';

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

        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 🔥 LOAD TOKEN SETIAP REQUEST
          final prefs = await SharedPreferences.getInstance();

          final token = prefs.getString('token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('🔥 REQUEST => ${options.method} ${options.uri}');

          print('🔥 TOKEN => ${options.headers['Authorization']}');

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

  // 🔥 SIMPAN TOKEN
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);

    _dio.options.headers['Authorization'] = 'Bearer $token';

    print('✅ TOKEN SAVED => $token');
  }

  // 🔥 HAPUS TOKEN
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');

    _dio.options.headers.remove('Authorization');
  }

  Dio get dio => _dio;

  // 🔥 GET
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

  // 🔥 POST
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);

      return response;
    } on DioException {
      rethrow;
    }
  }

  // 🔥 PUT
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);

      return response;
    } on DioException {
      rethrow;
    }
  }

  // 🔥 DELETE
  Future<Response> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);

      return response;
    } on DioException {
      rethrow;
    }
  }
}
