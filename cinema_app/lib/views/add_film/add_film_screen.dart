import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/film.dart';
import '../../viewmodels/film_viewmodel.dart';

class AddFilmScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController directorController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un Film')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Titre')),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
            TextField(controller: typeController, decoration: InputDecoration(labelText: 'Genre')),
            TextField(controller: directorController, decoration: InputDecoration(labelText: 'Réalisateur')),
            TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'URL de l\'image')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newFilm = Film(
                  id: 0, // L’ID sera généré par le serveur
                  title: titleController.text,
                  description: descriptionController.text,
                  type: typeController.text,
                  director: directorController.text,
                  imageUrl: imageUrlController.text,
                  likes: 0,
                );
                Provider.of<FilmViewModel>(context, listen: false).addFilm(newFilm);
                Navigator.pop(context);
              },
              child: Text('Ajouter le film'),
            ),
          ],
        ),
      ),
    );
  }
}
