<?php

namespace App\Lib\Middleware;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Slim\Psr7\Response;
use App\Lib\SysConfigManager;
use App\Lib\ContainerFacade as DI;

class SysConfigMiddleware {
  /**
   * @return \Slim\Psr7\Response
   */
  public function __invoke(Request $request, RequestHandler $handler): Response {
    $sysConfig = new SysConfigManager();
    DI::set('sysConfig', $sysConfig);
    $response = $handler->handle($request);
    return $response;
  }
}

// EOF
