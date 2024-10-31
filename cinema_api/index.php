<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

require 'config.php';
require 'Film.php';

$filmModel = new Film($pdo);

$requestMethod = $_SERVER['REQUEST_METHOD'];
$requestUri = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
$id = isset($requestUri[1]) ? (int)$requestUri[1] : null;

switch ($requestMethod) {
    case 'GET':
        if ($id) {
            // GET /films/<id>
            echo json_encode($filmModel->getFilm($id));
        } else {
            // GET /films
            echo json_encode($filmModel->getAllFilms());
        }
        break;

    case 'POST':
        if ($id) {
            // POST /films/<id> (like)
            echo json_encode($filmModel->likeFilm($id));
        } else {
            // POST /films (ajouter un film)
            $data = json_decode(file_get_contents('php://input'), true);
            echo json_encode($filmModel->addFilm($data['title'], $data['description'], $data['type'], $data['director'], $data['imageUrl']));
        }
        break;

    case 'PUT':
        // PUT /films/<id> (mettre à jour un film)
        if ($id) {
            $data = json_decode(file_get_contents('php://input'), true);
            echo json_encode($filmModel->updateFilm($id, $data));
        }
        break;

    case 'DELETE':
        // DELETE /films/<id>
        if ($id) {
            if ($filmModel->deleteFilm($id)) {
                echo json_encode(['message' => 'Film deleted successfully.']);
            } else {
                http_response_code(404);
                echo json_encode(['message' => 'Film not found.']);
            }
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method Not Allowed']);
        break;
}
?>