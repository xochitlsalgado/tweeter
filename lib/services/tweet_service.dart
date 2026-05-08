import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tweet.dart';
import '../models/tweet_response.dart';

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
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

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
      }
    } catch (e) {
      throw Exception('Error de conexión al crear: $e');
    }
  }

  // 3. Borrar un tweet
  Future<void> deleteTweet(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Error al borrar tweet');
      }
    } catch (e) {
      throw Exception('Error de conexión al borrar: $e');
    }
  }
} 
