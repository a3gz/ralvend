<?php

namespace App\Lib\DataAdapter;

use App\Core\Models\JsonAdapter as Models;

class JsonDataAdapter implements DataAdapterInterface {
  /**
   * @return \League\OAuth2\Server\Repositories\AccessTokenRepositoryInterface
   */
  public function makeOAuth2AccessTokenRepository() {
    return new Models\AccessTokenRepository();
  }

  /**
   * @return \League\OAuth2\Server\Repositories\ClientRepositoryInterface
   */
  public function makeOAuth2ClientRepository() {
    return new Models\ClientRepository();
  }

  /**
   * @return \League\OAuth2\Server\Repositories\RefreshTokenRepositoryInterface
   */
  public function makeOAuth2RefreshTokenRepository() {
    return new Models\RefreshTokenRepository();
  }

  /**
   * @return \League\OAuth2\Server\Repositories\ScopeRepositoryInterface
   */
  public function makeOAuth2ScopeRepository() {
    return new Models\ScopeRepository();
  }
}

// EOF
