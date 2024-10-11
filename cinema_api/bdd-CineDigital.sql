
-- Création de la base de données et de la table
CREATE DATABASE IF NOT EXISTS films_db;
USE films_db;

-- Table des films
CREATE TABLE IF NOT EXISTS films (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    director VARCHAR(255) NOT NULL,
    likes INT DEFAULT 0,
    imageUrl VARCHAR(255) NOT NULL
);

-- Insertion de données initiales
INSERT INTO films (title, description, type, director, likes, imageUrl) VALUES
('Film A', 'Description du film A', 'Action', 'Réalisateur A', 10, 'https://upload.wikimedia.org/wikipedia/en/f/f9/Avengers_Endgame_poster.jpg'),
('Film B', 'Description du film B', 'Drame', 'Réalisateur B', 20, 'https://upload.wikimedia.org/wikipedia/en/9/9a/The_Shawshank_Redemption_movie_poster.jpg'),
('Film C', 'Description du film C', 'Comédie', 'Réalisateur C', 5, 'https://upload.wikimedia.org/wikipedia/en/1/1b/Forrest_Gump_poster.jpg'),
('Film D', 'Description du film D', 'Horreur', 'Réalisateur D', 0, 'https://upload.wikimedia.org/wikipedia/en/d/d6/It_%282017%29_poster.jpg'),
('Film E', 'Description du film E', 'Science-Fiction', 'Réalisateur E', 8, 'https://upload.wikimedia.org/wikipedia/en/8/8f/Blade_Runner_2049_poster.jpg');
