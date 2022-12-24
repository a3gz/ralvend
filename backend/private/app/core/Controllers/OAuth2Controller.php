<?php

namespace App\Core\Controllers;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use League\OAuth2\Server\AuthorizationServer;
use League\OAuth2\Server\Exception\OAuthServerException;
use App\Lib\Exceptions;
use App\Lib\ContainerFacade as DI;

class OAuth2Controller {
  public function authToken(Request $request, Response $response) {
    try {
      $server = $request->getAttribute(AuthorizationServer::class);
      if (!$server) {
        throw Exceptions\HttpException::accessDenied(
          'Authorization server is unreachable'
        );
      }
      return $server->respondToAccessTokenRequest($request, $response);
    } catch (OAuthServerException $exception) {
      return $exception->generateHttpResponse($response);
    } catch (Exceptions\HttpException $exception) {
      return $exception->generateHttpResponse($response);
    } catch (\Exception $exception) {
      return (new Exceptions\EncodedException(
        $exception,
        DI::get('logger')
      ))->response($response);
    }
  }

  public function testToken(Request $request, Response $response) {
    try {
      $body = $response->getBody();
      $body->write('OK!');
      return $response->withBody($body);
    } catch (OAuthServerException $exception) {
      return $exception->generateHttpResponse($response);
    }
  }
}

// EOF
