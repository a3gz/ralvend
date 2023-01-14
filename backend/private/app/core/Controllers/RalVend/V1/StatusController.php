<?php

namespace App\Core\Controllers\RalVend\V1;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use Fat\Helpers\ResponseTools;
use Fat\Factory\AppFactory;
use Fat\Helpers\StatusCode as HttpStatus;
use App\Lib\Exceptions;
use App\Core\Controllers\RalVendApiController;

class StatusController extends RalVendApiController {
  public function sync(Request $request, Response $response) {
    try {
      // something
      $posted = $request->getParsedBody();
      $responseData = $posted;
      return ResponseTools::withJson(
        $response,
        $responseData,
        HttpStatus::HTTP_ACCEPTED
      );
    } catch (Exceptions\HttpException $e) {
      return $e->generateHttpResponse($response);
    }
  }
}

// EOF
