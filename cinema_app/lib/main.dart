import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Films au Cinéma',
      theme: ThemeData(
        brightness: Brightness.dark, // Style sombre
        primarySwatch: Colors.red,   // Couleurs Netflix-like
        scaffoldBackgroundColor: Colors.black, // Arrière-plan noir
      ),
      home: FilmListScreen(),
    );
  }
}

class FilmListScreen extends StatefulWidget {
  @override
  _FilmListScreenState createState() => _FilmListScreenState();
}

class _FilmListScreenState extends State<FilmListScreen> {
  List films = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFilms();
  }

  Future<void> fetchFilms() async {
    final response = await http.get(Uri.parse('http://localhost:3000/films'));

    if (response.statusCode == 200) {
      setState(() {
        films = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Échec de la récupération des films');
    }
  }

  Future<void> likeFilm(int id) async {
    final response = await http.post(Uri.parse('http://localhost:3000/films/$id/like'));

    if (response.statusCode == 200) {
      fetchFilms(); // Rafraîchir les films après avoir liké
    } else {
      throw Exception('Échec du like');
    }
  }

  Future<void> addFilm(Map<String, String> newFilm) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/films'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newFilm),
    );

    if (response.statusCode == 201) {
      fetchFilms(); // Rafraîchir les films après l'ajout
    } else {
      throw Exception('Échec de l\'ajout du film');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Films au Cinéma'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFilmScreen(addFilm: addFilm),
                ),
              );
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0), // Padding général
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 20), // Ajout d'espace en haut et en bas
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Deux colonnes pour un meilleur aspect visuel
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.65, // Format portrait plus grand pour mieux voir les images
                ),
                itemCount: films.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilmDetailScreen(film: films[index]),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Bords arrondis
                      ),
                      color: Colors.black87, // Carte sombre
                      elevation: 5, // Ombre pour séparer visuellement les cartes
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              films[index]['imageUrl'],
                              height: 180, // Hauteur ajustée
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300], // Fond gris clair
                                  height: 180,
                                  width: double.infinity,
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey[700], // Icône en gris foncé
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0), // Ajout de padding autour du texte
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  films[index]['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Genre: ${films[index]['type']}',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Réalisateur: ${films[index]['director']}',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.thumb_up, color: Colors.red),
                                      onPressed: () {
                                        likeFilm(films[index]['id']);
                                      },
                                    ),
                                    Text(
                                      '${films[index]['likes']} likes',
                                      style: TextStyle(color: Colors.white),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFilmScreen(addFilm: addFilm),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddFilmScreen extends StatelessWidget {
  final Function addFilm;

  AddFilmScreen({required this.addFilm});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController directorController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Film'),
      ),
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
                Map<String, String> newFilm = {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'type': typeController.text,
                  'director': directorController.text,
                  'imageUrl': imageUrlController.text,
                };
                addFilm(newFilm);
                Navigator.pop(context); // Fermer la page après l'ajout
              },
              child: Text('Ajouter le film'),
            ),
          ],
        ),
      ),
    );
  }
}

class FilmDetailScreen extends StatelessWidget {
  final dynamic film;

  FilmDetailScreen({required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(film['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              film['imageUrl'],
              height: 300, // Limite la hauteur à 300 pixels
              width: double.infinity,
              fit: BoxFit.cover, // Assure que l'image couvre la largeur sans déformer l'aspect
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error); // Afficher une icône en cas d'erreur
              },
            ),
            SizedBox(height: 16),
            Text(
              film['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text('Genre: ${film['type']}', style: TextStyle(color: Colors.white70)),
            Text('Réalisateur: ${film['director']}', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 16),
            Text(
              film['description'],
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
