<?php

namespace App\Lib\Middleware;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use League\OAuth2\Server\AuthorizationServer;
use League\OAuth2\Server\Grant\RefreshTokenGrant;
use App\Lib\Security\AuthKeys as KeyService;
use App\Lib\DataAdapter\DataAdapterFactory;
use App\Lib\ContainerFacade as DI;

class SetupOAuth2RefreshTokenGrantServer {
  public function __invoke(Request $request, RequestHandler $handler) {
    $posted = $request->getParsedBody();
    if (isset($posted['grant_type']) && ($posted['grant_type'] === 'refresh_token')) {
      $dataAdapter = DataAdapterFactory::makeDataAdapter();

      $clientRepository = $dataAdapter->makeOAuth2ClientRepository();
      $scopeRepository = $dataAdapter->makeOAuth2ScopeRepository();
      $accessTokenRepository = $dataAdapter->makeOAuth2AccessTokenRepository();
      $refreshTokenRepository = $dataAdapter->makeOAuth2RefreshTokenRepository();

      $privateKey = KeyService::getPrivateKeyPath();
      // Encription keys with pass phrase are NOT supported here
      $encryptionKey = KeyService::getEncryptionKey();

      $server = new AuthorizationServer(
        $clientRepository,
        $accessTokenRepository,
        $scopeRepository,
        $privateKey,
        $encryptionKey
      );

      $grant = new RefreshTokenGrant($refreshTokenRepository);

      $interval = DI::has('accessTokenTTL')
        ? trim(DI::get('accessTokenTTL'))
        : 'P10Y';
      $ttl = new \DateInterval($interval);

      $server->enableGrantType($grant, $ttl);

      $request = $request->withAttribute(AuthorizationServer::class, $server);
    }
    $response = $handler->handle($request);
    return $response;
  }
}

// EOF
