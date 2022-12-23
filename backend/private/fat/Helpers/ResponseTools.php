<?php

namespace Fat\Helpers;

use Psr\Http\Message\ResponseInterface as Response;

class ResponseTools {
  static public function stop() {
    die();
  }

  static public function withBody(Response $response, $data, $status = null) {
    $clone = clone $response;
    $clone->getBody()->write($data);
    if (!is_null($status)) {
      $clone = $clone->withStatus($status);
    }
    return $clone;
  }

  static public function withJson(Response $response, $data, $status = null) {
    $clone = clone $response;
    $clone->getBody()->write(json_encode($data));
    if (!is_null($status)) {
      $clone = $clone->withStatus($status);
    }
    $clone = $clone->withHeader('Content-Type', 'application/json');
    return $clone;
  }

  static public function withRedirect(Response $response, $url, $status = null) {
    $clone = clone $response;
    $clone = $clone->withHeader('Location', (string)$url);
    if (!is_null($status)) {
      $clone = $clone->withStatus($status);
    }
    return $clone;
  }
}

// EOF
