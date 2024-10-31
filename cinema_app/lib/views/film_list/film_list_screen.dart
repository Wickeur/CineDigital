import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/film_viewmodel.dart';
import '../add_film/add_film_screen.dart';
import '../edit_film/edit_film_screen.dart';
import '../film_detail/film_detail_screen.dart';

class FilmListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FilmViewModel>(
      builder: (context, filmViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Films au Cinéma'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFilmScreen()),
                  );
                },
              ),
            ],
          ),
          body: filmViewModel.isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: filmViewModel.films.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final film = filmViewModel.films[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilmDetailScreen(film: film),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: Image.network(
                                  film.imageUrl,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image,
                                        color: Colors.grey);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      film.title,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(film.type, style: TextStyle(color: Colors.white70)),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        // Bouton de like
                                        IconButton(
                                          icon: Icon(Icons.thumb_up,
                                              color: Colors.red),
                                          onPressed: () {
                                            filmViewModel.likeFilm(film.id);
                                          },
                                        ),
                                        // Affichage du nombre de likes juste à côté
                                        Text(
                                          film.likes.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Spacer(),
                                        // Bouton d'édition
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.yellow),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditFilmScreen(film: film),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
