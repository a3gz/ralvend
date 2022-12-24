<?php

namespace App\Lib\Middleware;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use League\OAuth2\Server\ResourceServer;
use App\Lib\Security\AuthKeys as KeyService;
use App\Lib\DataAdapter\DataAdapterFactory;

class SetupOAuth2Server {
  public function __invoke(Request $request, RequestHandler $handler) {
    $dataAdapter = DataAdapterFactory::makeDataAdapter();

    $accessTokenRepository = $dataAdapter->makeOAuth2AccessTokenRepository();
    $publicKeyPath = KeyService::getPublicKeyPath();

    $server = new ResourceServer(
      $accessTokenRepository,
      $publicKeyPath
    );

    $request = $request->withAttribute(ResourceServer::class, $server);

    $response = $handler->handle($request);
    return $response;
  }
}

// EOF
