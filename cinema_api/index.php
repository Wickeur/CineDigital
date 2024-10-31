<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
require 'db.php'; // Fichier qui contient la connexion PDO à la base de données

// Fonction pour récupérer tous les films
function getAllFilms($pdo) {
    $stmt = $pdo->query('SELECT * FROM films');
    $films = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($films);
}

// Fonction pour récupérer un film par ID
function getFilmById($pdo, $id) {
    $stmt = $pdo->prepare('SELECT * FROM films WHERE id = ?');
    $stmt->execute([$id]);
    $film = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($film) {
        echo json_encode($film);
    } else {
        echo json_encode(['error' => 'Film non trouvé']);
    }
}

// Fonction pour ajouter un nouveau film
function addFilm($pdo) {
    $data = json_decode(file_get_contents("php://input"), true);
    if (!empty($data['title']) && !empty($data['description']) && !empty($data['type']) && !empty($data['director']) && !empty($data['imageUrl'])) {
        $stmt = $pdo->prepare("INSERT INTO films (title, description, type, director, imageUrl, likes) VALUES (?, ?, ?, ?, ?, 0)");
        $stmt->execute([$data['title'], $data['description'], $data['type'], $data['director'], $data['imageUrl']]);
        echo json_encode(['message' => 'Film ajouté avec succès']);
    } else {
        echo json_encode(['error' => 'Données incomplètes']);
    }
}

// Fonction pour modifier un film
function updateFilm($pdo, $id) {
    $data = json_decode(file_get_contents("php://input"), true);
    if (!empty($data['title']) && !empty($data['description']) && !empty($data['type']) && !empty($data['director']) && !empty($data['imageUrl'])) {
        $stmt = $pdo->prepare("UPDATE films SET title = ?, description = ?, type = ?, director = ?, imageUrl = ? WHERE id = ?");
        $stmt->execute([$data['title'], $data['description'], $data['type'], $data['director'], $data['imageUrl'], $id]);
        echo json_encode(['message' => 'Film mis à jour avec succès']);
    } else {
        echo json_encode(['error' => 'Données incomplètes']);
    }
}

// Fonction pour supprimer un film
function deleteFilm($pdo, $id) {
    $stmt = $pdo->prepare("DELETE FROM films WHERE id = ?");
    $stmt->execute([$id]);
    echo json_encode(['message' => 'Film supprimé avec succès']);
}

// Fonction pour ajouter un like à un film
function likeFilm($pdo, $id) {
    $stmt = $pdo->prepare("UPDATE films SET likes = likes + 1 WHERE id = ?");
    $stmt->execute([$id]);
    if ($stmt->rowCount() > 0) {
        echo json_encode(['message' => 'Like ajouté avec succès']);
    } else {
        echo json_encode(['error' => 'Film non trouvé ou erreur de mise à jour']);
    }
}

// Gestion des routes
$requestMethod = $_SERVER['REQUEST_METHOD'];
$requestUri = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
$id = isset($requestUri[2]) ? intval($requestUri[2]) : null; // Supposons que l'ID est passé dans l'URL

switch ($requestMethod) {
    case 'GET':
        if (isset($requestUri[1]) && $requestUri[1] === 'films') {
            if ($id === null) {
                getAllFilms($pdo);
            } else {
                getFilmById($pdo, $id);
            }
        } else {
            echo json_encode(['error' => 'Route non trouvée']);
        }
        break;

    case 'POST':
        if (isset($requestUri[1]) && $requestUri[1] === 'films') {
            addFilm($pdo);
        } elseif (isset($requestUri[1]) && $requestUri[1] === 'films' && $id !== null) {
            likeFilm($pdo, $id);
        } else {
            echo json_encode(['error' => 'Route non trouvée']);
        }
        break;

    case 'PUT':
        if (isset($requestUri[1]) && $requestUri[1] === 'films' && $id !== null) {
            updateFilm($pdo, $id);
        } else {
            echo json_encode(['error' => 'Route non trouvée']);
        }
        break;

    case 'DELETE':
        if (isset($requestUri[1]) && $requestUri[1] === 'films' && $id !== null) {
            deleteFilm($pdo, $id);
        } else {
            echo json_encode(['error' => 'Route non trouvée']);
        }
        break;

    default:
        echo json_encode(['error' => 'Méthode non autorisée']);
        break;
}
?>
