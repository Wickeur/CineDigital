<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require 'db.php'; // Fichier qui contient la connexion PDO à la base de données

// Récupérer tous les films
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->query('SELECT * FROM films');
    $films = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($films);
}

// Ajouter un nouveau film
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!empty($data['title']) && !empty($data['description']) && !empty($data['type']) && !empty($data['director']) && !empty($data['imageUrl'])) {
        $stmt = $pdo->prepare("INSERT INTO films (title, description, type, director, imageUrl, likes) VALUES (?, ?, ?, ?, ?, 0)");
        $stmt->execute([$data['title'], $data['description'], $data['type'], $data['director'], $data['imageUrl']]);
        echo json_encode(['message' => 'Film ajouté avec succès']);
    } else {
        echo json_encode(['error' => 'Données incomplètes']);
    }
}

// Modifier un film
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!empty($data['id']) && !empty($data['title']) && !empty($data['description']) && !empty($data['type']) && !empty($data['director']) && !empty($data['imageUrl'])) {
        $stmt = $pdo->prepare("UPDATE films SET title = ?, description = ?, type = ?, director = ?, imageUrl = ? WHERE id = ?");
        $stmt->execute([$data['title'], $data['description'], $data['type'], $data['director'], $data['imageUrl'], $data['id']]);
        echo json_encode(['message' => 'Film mis à jour avec succès']);
    } else {
        echo json_encode(['error' => 'Données incomplètes ou ID manquant']);
    }
}

// Supprimer un film
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data['id'])) {
        $stmt = $pdo->prepare("DELETE FROM films WHERE id = ?");
        $stmt->execute([$data['id']]);
        echo json_encode(['message' => 'Film supprimé avec succès']);
    } else {
        echo json_encode(['error' => 'ID non fourni']);
    }
}
?>
