import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/film.dart';
import '../../viewmodels/film_viewmodel.dart';

class EditFilmScreen extends StatelessWidget {
  final Film film;

  // Constructeur qui prend le film à modifier
  EditFilmScreen({required this.film});

  @override
  Widget build(BuildContext context) {
    // Initialiser les contrôleurs avec les valeurs existantes du film
    final TextEditingController titleController = TextEditingController(text: film.title);
    final TextEditingController descriptionController = TextEditingController(text: film.description);
    final TextEditingController typeController = TextEditingController(text: film.type);
    final TextEditingController directorController = TextEditingController(text: film.director);
    final TextEditingController imageUrlController = TextEditingController(text: film.imageUrl);

    return Scaffold(
      appBar: AppBar(title: Text('Modifier le Film')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Genre'),
            ),
            TextField(
              controller: directorController,
              decoration: InputDecoration(labelText: 'Réalisateur'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'URL de l\'image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedFilm = Film(
                  id: film.id, // Conserver l'ID pour la mise à jour
                  title: titleController.text,
                  description: descriptionController.text,
                  type: typeController.text,
                  director: directorController.text,
                  imageUrl: imageUrlController.text,
                  likes: film.likes, // Conserver le nombre de likes existant
                );
                Provider.of<FilmViewModel>(context, listen: false).updateFilm(updatedFilm);
                Navigator.pop(context);
              },
              child: Text('Modifier le film'),
            ),
          ],
        ),
      ),
    );
  }
}
