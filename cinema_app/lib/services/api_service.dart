import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/film.dart';

class ApiService {
  final String apiUrl = "https://4f5c-79-174-199-110.ngrok-free.app/";

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse('$apiUrl/films'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((film) => Film.fromJson(film)).toList();
    } else {
      throw Exception('Échec de la récupération des films');
    }
  }

  Future<void> likeFilm(int id) async {
    final response = await http.post(Uri.parse('$apiUrl/films/$id/like'));

    if (response.statusCode != 200) {
      throw Exception('Échec du like');
    }
  }

  Future<void> addFilm(Film newFilm) async {
    final response = await http.post(
      Uri.parse('$apiUrl/films'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newFilm.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Échec de l\'ajout du film');
    }
  }
}
