<?php

namespace App\Core\Models\JsonAdapter\OAuth2;

use League\OAuth2\Server\Repositories\ScopeRepositoryInterface;
use League\OAuth2\Server\Entities\ClientEntityInterface;

class ScopeRepository implements ScopeRepositoryInterface {
  /**
   * Return information about a scope.
   *
   * @param string $identifier The scope identifier
   *
   * @return ScopeEntityInterface
   */
  public function getScopeEntityByIdentifier($identifier) {
    $model = new ScopeEntities();
    $r = $model->getByIdentifier($identifier);
    return $r;
  }

  /**
   * Given a client, grant type and optional user identifier validate the set of scopes requested are valid and optionally
   * append additional scopes or remove requested scopes.
   *
   * @param ScopeEntityInterface[] $scopes
   * @param string                 $grantType
   * @param ClientEntityInterface  $clientEntity
   * @param null|string            $userIdentifier
   *
   * @return ScopeEntityInterface[]
   */
  public function finalizeScopes(
    array $scopes,
    $grantType,
    ClientEntityInterface $clientEntity,
    $userIdentifier = null
  ) {
    // TO-DO
    return $scopes;
  }
}

// EOF
