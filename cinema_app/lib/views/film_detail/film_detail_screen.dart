import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/film.dart';
import '../../viewmodels/film_viewmodel.dart';

class FilmDetailScreen extends StatelessWidget {
  final Film film;

  FilmDetailScreen({required this.film});

  @override
  Widget build(BuildContext context) {
    final filmViewModel = Provider.of<FilmViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(film.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, filmViewModel),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              film.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, color: Colors.grey);
              },
            ),
            SizedBox(height: 16),
            Text(
              film.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text('Genre: ${film.type}', style: TextStyle(color: Colors.white70)),
            Text('Réalisateur: ${film.director}', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 16),
            Text(film.description, style: TextStyle(fontSize: 16, color: Colors.white)),
            SizedBox(height: 16),
            Text('${film.likes} likes', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, FilmViewModel filmViewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer ce film ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                await filmViewModel.deleteFilm(film.id);
                Navigator.pop(context); // Ferme la modale de confirmation
                Navigator.pop(context); // Retourne à la liste des films
              },
              child: Text('Supprimer'),
              // style: TextButton.styleFrom(primary: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
