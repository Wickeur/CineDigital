import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/film_viewmodel.dart';
import 'views/film_list/film_list_screen.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FilmViewModel()),
      ],
      child: MaterialApp(
        title: 'Films au Cinéma',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: FilmListScreen(),
      ),
    );
  }
}
