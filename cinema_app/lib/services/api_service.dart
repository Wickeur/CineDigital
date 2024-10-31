import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/film.dart';

class ApiService {
  final String apiUrl = "https://df37-79-174-199-110.ngrok-free.app";

  // Récupérer tous les films
  Future<List<Film>> fetchFilms() async {
    final response = await http.get(Uri.parse('$apiUrl/films'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((film) => Film.fromJson(film)).toList();
    } else {
      throw Exception('Échec de la récupération des films. Statut: ${response.statusCode}');
    }
  }

  // Récupérer un film par ID
  Future<Film> fetchFilmById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/films/$id'));

    if (response.statusCode == 200) {
      return Film.fromJson(json.decode(response.body));
    } else {
      throw Exception('Film non trouvé. Statut: ${response.statusCode}');
    }
  }

  // Liker un film
  Future<void> likeFilm(int id) async {
    final response = await http.post(
      Uri.parse('$apiUrl/films/$id'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Échec du like. Statut: ${response.statusCode}');
    }
  }

  // Ajouter un film
  Future<void> addFilm(Film newFilm) async {
    final response = await http.post(
      Uri.parse('$apiUrl/films'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'title': newFilm.title,
        'description': newFilm.description,
        'type': newFilm.type,
        'director': newFilm.director,
        'imageUrl': newFilm.imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Échec de l\'ajout du film. Statut: ${response.statusCode}');
    }
  }

  // Mettre à jour un film
  Future<void> updateFilm(int id, Film updatedFilm) async {
    final response = await http.put(
      Uri.parse('$apiUrl/films/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'title': updatedFilm.title,
        'description': updatedFilm.description,
        'type': updatedFilm.type,
        'director': updatedFilm.director,
        'imageUrl': updatedFilm.imageUrl,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour du film. Statut: ${response.statusCode}');
    }
  }

  // Supprimer un film
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
