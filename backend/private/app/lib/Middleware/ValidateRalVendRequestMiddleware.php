<?php

namespace App\Lib\Middleware;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Slim\Psr7\Response;
use App\Lib\Exceptions\SecondLifeException;
use App\Lib\SlRequesterFactory;
use App\Lib\SysConfigManager;

class ValidateRalVendRequestMiddleware {
  /**
   * @return \Slim\Psr7\Response
   */
  public function __invoke(Request $request, RequestHandler $handler): Response {
    try {
      $headers = $request->getHeaders();
      $requester = SlRequesterFactory::makeRequester($headers);

      if (!$requester->validShard()) {
        throw SecondLifeException::invalidShard();
      }

      // Check if the owner of the object sending the request
      // has access to the API.
      $ownerKey = $requester->getOwnerKey();
      if (!$ownerKey || !$auth->isAuthorized($ownerKey)) {
        throw SecondLifeException::agentAccessDenied();
      }

      $request = $request->withAttribute('slRequester', $requester);
      $response = $handler->handle($request);
      return $response;
    } catch (SecondLifeException $e) {
      return $e->generateHttpResponse(new Response());
    }
  }
}

// EOF
