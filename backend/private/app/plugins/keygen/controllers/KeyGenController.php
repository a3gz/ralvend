<?php

namespace Plugins\keygen\controllers;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;
use App\Lib\Path;
use Plugins\keygen\templates\DefaultTemplate;
use Plugins\keygen\lib\KeyGenerator;

class KeyGenController {
  public function generate(Request $request, Response $response) {
    $generator = new KeyGenerator();
    $n = 4;
    $keys = [];
    for ($i=0; $i < $n; $i++) {
      $keys[] = $generator->generate();
    }
    $tpl = new DefaultTemplate(Path::makePluginsPath('/keygen'));
    $tpl->define('content', 'views/generated-key')
      ->setData([
        'keys' => $keys,
      ])
      ->write($response);
    return $response;
  }
}

// EOF
