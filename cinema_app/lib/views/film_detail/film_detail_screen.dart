import 'package:flutter/material.dart';
import '../../models/film.dart';

class FilmDetailScreen extends StatelessWidget {
  final Film film;

  FilmDetailScreen({required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(film.title)),
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
            Text(film.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
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
}
