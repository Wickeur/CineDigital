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
        primarySwatch: Colors.blue,
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
    final response = await http.get(Uri.parse('http://192.168.230.218:3000/films'));

    if (response.statusCode == 200) {
      setState(() {
        films = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Échec de la récupération des films');
    }
  }

  Future<void> addFilm(String title, String description) async {
    final response = await http.post(
      Uri.parse('http://192.168.230.218:3000/films'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'title': title, 'description': description}),
    );

    if (response.statusCode == 201) {
      fetchFilms();
    } else {
      throw Exception('Échec de l\'ajout du film');
    }
  }

  Future<void> updateFilm(int id, String title, String description) async {
    final response = await http.put(
      Uri.parse('http://192.168.230.218:3000/films/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'title': title, 'description': description}),
    );

    if (response.statusCode == 200) {
      fetchFilms();
    } else {
      throw Exception('Échec de la mise à jour du film');
    }
  }

  Future<void> deleteFilm(int id) async {
    final response = await http.delete(Uri.parse('http://192.168.230.218:3000/films/$id'));

    if (response.statusCode == 204) {
      fetchFilms();
    } else {
      throw Exception('Échec de la suppression du film');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Films au Cinéma'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: films.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(films[index]['title']),
                  subtitle: Text(films[index]['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilmDetailScreen(film: films[index]),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteFilm(films[index]['id']);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String title = '';
              String description = '';

              return AlertDialog(
                title: Text('Ajouter un nouveau film'),
                content: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: InputDecoration(hintText: 'Titre du film'),
                    ),
                    TextField(
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: InputDecoration(hintText: 'Description du film'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Annuler'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Ajouter'),
                    onPressed: () {
                      if (title.isNotEmpty && description.isNotEmpty) {
                        addFilm(title, description);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
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
        child: Text(film['description']),
      ),
    );
  }
}
