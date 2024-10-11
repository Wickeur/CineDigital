const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(cors());

let films = [
  { id: 1, title: 'Film A', description: 'Description du film A' },
  { id: 2, title: 'Film B', description: 'Description du film B' },
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
  res.json(film);
});

// 5. Supprimer un film
app.delete('/films/:id', (req, res) => {
  const filmIndex = films.findIndex(f => f.id === parseInt(req.params.id));
  if (filmIndex === -1) return res.status(404).send('Film non trouvé');

  films.splice(filmIndex, 1);
  res.status(204).send();
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
