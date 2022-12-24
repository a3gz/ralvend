<?php
global $_APP_;

$_APP_->post(
  '/auth/token',
  \App\Core\Controllers\OAuth2Controller::class.':authToken'
)
  ->add(new \App\Lib\Middleware\SysConfigMiddleware())
  ->add(new \App\Lib\Middleware\SetupOAuth2ClientCredentialsGrantServer())
  ->add(new \App\Lib\Middleware\SetupOAuth2RefreshTokenGrantServer())
;

$_APP_->get(
  '/auth/test-token',
  \App\Core\Controllers\OAuth2Controller::class.':testToken'
)
  ->add(new \App\Lib\Middleware\GuardResources())
  ->add(new \App\Lib\Middleware\SetupOAuth2Server())
  ->add(new \App\Lib\Middleware\SysConfigMiddleware())
;

