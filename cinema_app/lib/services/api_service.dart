import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/film.dart';

class ApiService {
  final String apiUrl = "https://df37-79-174-199-110.ngrok-free.app";

  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse('$apiUrl/films'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((film) => Film.fromJson(film)).toList();
    } else {
      throw Exception('Échec de la récupération des films. Statut: ${response.statusCode}');
    }
  }

  Future<Film> fetchFilmById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/films/$id'));

    if (response.statusCode == 200) {
      return Film.fromJson(json.decode(response.body));
    } else {
      throw Exception('Film non trouvé. Statut: ${response.statusCode}');
    }
  }

  Future<void> likeFilm(int id) async {
    final response = await http.post(
      Uri.parse('$apiUrl/films/$id'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Échec du like. Statut: ${response.statusCode}');
    }
  }

  Future<void> addFilm(Film newFilm) async {
    final response = await http.post(
      Uri.parse('$apiUrl/films'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newFilm.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Échec de l\'ajout du film. Statut: ${response.statusCode}');
    }
  }

  // Ajout de la méthode deleteFilm
  Future<void> deleteFilm(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/films/$id'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Échec de la suppression du film. Statut: ${response.statusCode}');
    }
  }
}
