const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(cors());

let films = [
    { 
      id: 1, 
      title: 'Film A', 
      description: 'Description du film A', 
      type: 'Action', // Nouveau champ pour le type de film
      director: 'Réalisateur A', // Nouveau champ pour le réalisateur
      likes: 0, 
      imageUrl: 'https://upload.wikimedia.org/wikipedia/en/f/f9/Avengers_Endgame_poster.jpg'
    },
    { 
      id: 2, 
      title: 'Film B', 
      description: 'Description du film B', 
      type: 'Drame', // Nouveau champ pour le type de film
      director: 'Réalisateur B', // Nouveau champ pour le réalisateur
      likes: 0, 
      imageUrl: 'https://upload.wikimedia.org/wikipedia/en/9/9a/The_Shawshank_Redemption_movie_poster.jpg'
    }
];

// 1. Récupérer tous les films
app.get('/films', (req, res) => {
  res.json(films);
});

// 2. Récupérer un film par ID
app.get('/films/:id', (req, res) => {
  const film = films.find(f => f.id === parseInt(req.params.id));
  if (!film) return res.status(404).send('Film non trouvé');
  res.json(film);
});

// 3. Ajouter un nouveau film
app.post('/films', (req, res) => {
  const newFilm = {
    id: films.length + 1,
    title: req.body.title,
    description: req.body.description,
    type: req.body.type, // Nouveau champ pour le type
    director: req.body.director, // Nouveau champ pour le réalisateur
    likes: 0, // Initialisation du compteur de likes à 0
    imageUrl: req.body.imageUrl, // Nouvelle propriété pour l'URL de l'image
  };
  films.push(newFilm);
  res.status(201).json(newFilm);
});

// 4. Modifier un film
app.put('/films/:id', (req, res) => {
  const film = films.find(f => f.id === parseInt(req.params.id));
  if (!film) return res.status(404).send('Film non trouvé');

  film.title = req.body.title;
  film.description = req.body.description;
  film.type = req.body.type; // Mise à jour du type de film
  film.director = req.body.director; // Mise à jour du réalisateur
  film.imageUrl = req.body.imageUrl; // Mise à jour de l'URL de l'image
  res.json(film);
});

// 5. Supprimer un film
app.delete('/films/:id', (req, res) => {
  const filmIndex = films.findIndex(f => f.id === parseInt(req.params.id));
  if (filmIndex === -1) return res.status(404).send('Film non trouvé');

  films.splice(filmIndex, 1);
  res.status(204).send();
});

// 6. Incrémenter les likes pour un film
app.post('/films/:id/like', (req, res) => {
    const film = films.find(f => f.id === parseInt(req.params.id));
    if (!film) return res.status(404).send('Film non trouvé');
    
    film.likes += 1; // Incrémente le compteur de likes
    res.json(film);
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
