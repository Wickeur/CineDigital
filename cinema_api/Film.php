<?php
class Film {
    private $pdo;

    public function __construct($pdo) {
        $this->pdo = $pdo;
    }

    public function getAllFilms() {
        $stmt = $this->pdo->query("SELECT * FROM films");
        return $stmt->fetchAll();
    }

    public function getFilm($id) {
        $stmt = $this->pdo->prepare("SELECT * FROM films WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function addFilm($title, $description, $type, $director, $imageUrl) {
        $stmt = $this->pdo->prepare("INSERT INTO films (title, description, type, director, imageUrl) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$title, $description, $type, $director, $imageUrl]);
        return $this->getFilm($this->pdo->lastInsertId());
    }

    public function likeFilm($id) {
        $stmt = $this->pdo->prepare("UPDATE films SET likes = likes + 1 WHERE id = ?");
        $stmt->execute([$id]);
        return $this->getFilm($id);
    }

    public function updateFilm($id, $data) {
        $stmt = $this->pdo->prepare("UPDATE films SET title = ?, description = ?, type = ?, director = ?, imageUrl = ? WHERE id = ?");
        $stmt->execute([$data['title'], $data['description'], $data['type'], $data['director'], $data['imageUrl'], $id]);
        return $this->getFilm($id);
    }

    public function deleteFilm($id) {
        $stmt = $this->pdo->prepare("DELETE FROM films WHERE id = ?");
        return $stmt->execute([$id]);
    }
}
?>