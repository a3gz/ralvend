<?php

namespace Plugins\ralvend_sales\controllers;

use App\RalVendApiController;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Fat\Factory\AppFactory;
use Lib\Exceptions;

class SalesController extends RalVendApiController {
  public function create(Request $request, Response $response) {
    try {
      // something
    } catch (Exceptions\HttpException $e) {
      return $e->generateHttpResponse($response);
    }
  }
}

// EOF
