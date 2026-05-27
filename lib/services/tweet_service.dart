import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tweet.dart';
import '../models/tweet_response.dart';
import 'auth_service.dart';

class TweetService {
  // URL local para pruebas
  final String baseUrl = 'http://localhost:8080/api/tweets';
  final AuthService _authService = AuthService();

  // 1. OBTENER TWEETS (GET)
  Future<List<Tweet>> fetchTweets() async {
    try {
      final token = _authService.getToken();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Seguridad JWT
        },
      );

      if (response.statusCode == 200) {
        return TweetResponse.fromJson(jsonDecode(response.body)).content;
      } else {
        throw Exception('Error al cargar tweets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // 2. CREAR TWEET (POST) - ¡ESTA ES LA QUE TE FALTABA!
  Future<void> postTweet(String text) async {
    try {
      final token = _authService.getToken();
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'tweet': text}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al crear: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión al crear: $e');
    }
  }

  // 3. BORRAR TWEET (DELETE)
  Future<void> deleteTweet(int id) async {
    try {
      final token = _authService.getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al borrar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al borrar: $e');
    }
  }
}
