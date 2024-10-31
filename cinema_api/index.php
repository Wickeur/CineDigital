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
function updateFilm($pdo) {
    $data = json_decode(file_get_contents("php://input"), true);
    if (!empty($data['id']) && !empty($data['title']) && !empty($data['description']) && !empty($data['type']) && !empty($data['director']) && !empty($data['imageUrl'])) {
        $stmt = $pdo->prepare("UPDATE films SET title = ?, description = ?, type = ?, director = ?, imageUrl = ? WHERE id = ?");
        $stmt->execute([$data['title'], $data['description'], $data['type'], $data['director'], $data['imageUrl'], $data['id']]);
        echo json_encode(['message' => 'Film mis à jour avec succès']);
    } else {
        echo json_encode(['error' => 'Données incomplètes ou ID manquant']);
    }
}

// Fonction pour supprimer un film
function deleteFilm($pdo) {
    $data = json_decode(file_get_contents("php://input"), true);
    if (isset($data['id'])) {
        $stmt = $pdo->prepare("DELETE FROM films WHERE id = ?");
        $stmt->execute([$data['id']]);
        echo json_encode(['message' => 'Film supprimé avec succès']);
    } else {
        echo json_encode(['error' => 'ID non fourni']);
    }
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
$id = isset($_GET['id']) ? intval($_GET['id']) : null;

switch ($requestMethod) {
    case 'GET':
        if ($id === null) {
            getAllFilms($pdo);
        } else {
            // Ici, vous pourriez également ajouter une fonction pour récupérer un film par ID
            echo json_encode(['error' => 'Méthode non autorisée pour récupérer un film par ID']);
        }
        break;

    case 'POST':
        if ($id === null) {
            addFilm($pdo);
        } else {
            likeFilm($pdo, $id);
        }
        break;

    case 'PUT':
        updateFilm($pdo);
        break;

    case 'DELETE':
        deleteFilm($pdo);
        break;

    default:
        echo json_encode(['error' => 'Méthode non autorisée']);
        break;
}
?>
