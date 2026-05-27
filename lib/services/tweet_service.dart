import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tweet.dart';
import '../models/tweet_response.dart';
<<<<<<< HEAD
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
=======

class TweetService {
  // Usamos 127.0.0.1 para evitar problemas en Linux
  final String baseUrl = 'https://tweeter-api-4txv.onrender.com/api/tweets';

  // 1. Obtener todos los tweets
  Future<List<Tweet>> fetchTweets() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return TweetResponse.fromJson(jsonDecode(response.body)).content;
      } else {
        throw Exception('Error al cargar tweets');
>>>>>>> 9ba01315fa07469fe69784858ebfc85f7a5d1467
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

<<<<<<< HEAD
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
=======
  // 2. Crear un tweet nuevo (Para que el botón funcione)
  Future<void> postTweet(String text) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tweet': text}),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al crear tweet');
>>>>>>> 9ba01315fa07469fe69784858ebfc85f7a5d1467
      }
    } catch (e) {
      throw Exception('Error de conexión al crear: $e');
    }
  }

<<<<<<< HEAD
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
=======
  // 3. Borrar un tweet
  Future<void> deleteTweet(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Error al borrar tweet');
>>>>>>> 9ba01315fa07469fe69784858ebfc85f7a5d1467
      }
    } catch (e) {
      throw Exception('Error de conexión al borrar: $e');
    }
  }
<<<<<<< HEAD
}
=======
} 
>>>>>>> 9ba01315fa07469fe69784858ebfc85f7a5d1467
