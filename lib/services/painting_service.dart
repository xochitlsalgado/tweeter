import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/painting.dart';
import 'auth_service.dart';

class PaintingService {
  final String baseUrl = 'https://tweeter-api-4txv.onrender.com/api/paintings';
  final AuthService _authService = AuthService();

  Future<List<Painting>> fetchPaintings() async {
    final token = _authService.getToken();
    final response = await http.get(Uri.parse('$baseUrl/all'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Painting.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar galería');
    }
  }

  Future<void> addPainting(String title, String year, String desc, String url) async {
    final token = _authService.getToken();
    await http.post(Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({'title': title, 'year': year, 'description': desc, 'imageUrl': url}));
  }

  // FUNCIÓN PARA ELIMINAR
  Future<void> deletePainting(int id) async {
    final token = _authService.getToken();
    await http.delete(Uri.parse('$baseUrl/$id'),
        headers: {'Authorization': 'Bearer $token'});
  }

  // FUNCIÓN PARA EDITAR
  Future<void> updatePainting(int id, String title, String year, String desc, String url) async {
    final token = _authService.getToken();
    await http.put(Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({'title': title, 'year': year, 'description': desc, 'imageUrl': url}));
  }
}
