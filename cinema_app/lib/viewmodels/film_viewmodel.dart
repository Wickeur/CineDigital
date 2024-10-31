import 'package:flutter/material.dart';
import '../models/film.dart';
import '../services/api_service.dart';

class FilmViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Film> _films = [];
  bool _isLoading = true;

  List<Film> get films => _films;
  bool get isLoading => _isLoading;

  FilmViewModel() {
    fetchFilms();
  }

  Future<void> fetchFilms() async {
    _isLoading = true;
    notifyListeners();
    try {
      _films = await _apiService.fetchFilms();
    } catch (e) {
      // Gestion de l'erreur
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> likeFilm(int id) async {
    try {
      await _apiService.likeFilm(id);
      fetchFilms();
    } catch (e) {
      // Gestion de l'erreur
    }
  }

  Future<void> addFilm(Film film) async {
    try {
      await _apiService.addFilm(film);
      fetchFilms();
    } catch (e) {
      // Gestion de l'erreur
    }
  }

  Future<void> deleteFilm(int id) async {
    try {
      await _apiService.deleteFilm(id);
      fetchFilms();
    } catch (e) {
      // Gestion de l'erreur
    }
  }
}
