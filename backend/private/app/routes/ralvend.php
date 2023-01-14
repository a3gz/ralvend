<?php

global $_APP_;

$_APP_->group('/v1', function($proxy) {
  $proxy->post(
    '/status',
    \App\Core\Controllers\StatusController::class . ':sync'
  );
})->add(new \App\Lib\Middleware\ValidateRalVendRequestMiddleware());

// EOF
