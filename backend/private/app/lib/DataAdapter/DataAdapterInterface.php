<?php

namespace App\Lib\DataAdapter;

interface DataAdapterInterface {
  /**
   * @return \League\OAuth2\Server\Repositories\AccessTokenRepositoryInterface
   */
  public function makeOAuth2AccessTokenRepository();

  /**
   * @return \League\OAuth2\Server\Repositories\ClientRepositoryInterface
   */
  public function makeOAuth2ClientRepository();

  /**
   * @return \League\OAuth2\Server\Repositories\RefreshTokenRepositoryInterface
   */
  public function makeOAuth2RefreshTokenRepository();

  /**
   * @return \League\OAuth2\Server\Repositories\ScopeRepositoryInterface
   */
  public function makeOAuth2ScopeRepository();
}

// EOF
