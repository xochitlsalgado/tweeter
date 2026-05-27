import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  // URL local para tus pruebas
  final String baseUrl = 'https://api-galeria-pinturas-1.onrender.com/api'; 
  late http.Client _httpClient;
  SharedPreferences? _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  AuthService._internal() {
    _httpClient = http.Client();
  }

  factory AuthService() => _instance;

  // ESTE MÉTODO LO PIDE TU PROYECTO
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<User> login(String username, String password) async {
    await init();
    final response = await _httpClient.post(
      Uri.parse('$baseUrl/auth/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final token = jsonData['accessToken']?.toString() ?? '';
      await _prefs!.setString(_tokenKey, token);
      final user = User.fromJson(jsonData);
      await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
      return user;
    } else {
      throw Exception('Fallo al iniciar sesión: ${response.body}');
    }
  }

  Future<void> register(String username, String email, String password) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'role': ['user']
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error en registro: ${response.body}');
    }
  }

  Future<void> logout() async {
    await init();
    await _prefs!.remove(_tokenKey);
    await _prefs!.remove(_userKey);
  }

  String? getToken() => _prefs?.getString(_tokenKey);

  // ESTE MÉTODO TAMBIÉN LO PIDE TU PROYECTO
  User? getUser() {
    final userJson = _prefs?.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }
  
  bool isAuthenticated() => getToken() != null && getToken()!.isNotEmpty;

  void dispose() => _httpClient.close();
}
