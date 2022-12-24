<?php

namespace App\Lib\Middleware;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use League\OAuth2\Server\Exception\OAuthServerException;
use League\OAuth2\Server\ResourceServer;
use App\Lib\ContainerFacade as DI;

class GuardResources {
  private $guard = true;

  public function __construct($guard = true) {
    $this->guard = $guard;
  }

  public function __invoke(
    Request $request,
    RequestHandler $handler
  ) {
    $server = $request->getAttribute(ResourceServer::class);

    // In some situations a preflight OPTIONS request will be received
    // to ask about some stuff before the actual resource request occurs.
    // The preflights don't include the authorization headers so we need to
    // bypass authentication.
    if ($request->getMethod() != 'OPTIONS') {
      try {
        $request = $server->validateAuthenticatedRequest($request);

        // Attempt to extract these attrbiutes from the request and inject them in
        // the container.
        //
        // oauth_access_token_id - the access token identifier
        // oauth_client_id - the client identifier
        // oauth_user_id - the user identifier represented by the access token
        // oauth_scopes - an array of string scope identifiers
        $requestAttributes = $request->getAttributes();
        $attributes = [];
        foreach ($requestAttributes as $name => $value) {
          if (substr($name, 0, 5) === 'oauth') {
            $attributes[$name] = $value;
          }
        }
        $request = $request->withAttribute('oauth', (object)$attributes);

        $response = $handler->handle($request);
        return $response;
      } catch (OAuthServerException $exception) {
        global $_APP_;
        $response = $_APP_->getResponseFactory()->createResponse();
        return $exception->generateHttpResponse($response);
        // @codeCoverageIgnoreStart
      }
    }
  }
}

// EOF
