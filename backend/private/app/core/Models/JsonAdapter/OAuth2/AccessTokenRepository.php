<?php

namespace App\Core\Models\JsonAdapter\OAuth2;

use League\OAuth2\Server\Repositories\AccessTokenRepositoryInterface;
use League\OAuth2\Server\Entities\AccessTokenEntityInterface;
use League\OAuth2\Server\Entities\ClientEntityInterface;
use League\OAuth2\Server\Entities\ScopeEntityInterface;

class AccessTokenRepository implements AccessTokenRepositoryInterface {
  /**
   * Create a new access token
   *
   * @param ClientEntityInterface  $clientEntity
   * @param ScopeEntityInterface[] $scopes
   * @param mixed                  $userIdentifier
   *
   * @return AccessTokenEntityInterface
   */
  public function getNewToken(
    ClientEntityInterface $clientEntity,
    array $scopes,
    $userIdentifier = null
  ) {
    $theToken = new AccessTokenEntities();
    $theToken->setClient($clientEntity);
    $theToken->setUserIdentifier($userIdentifier);

    $days = 1;
    $t = time() + ($days * 86400);

    $dateTime = new \DateTimeImmutable();
    $dateTime->setTimestamp($t);
    $theToken->setExpiryDateTime($dateTime);

    foreach ($scopes as $aScope) {
      $theToken->addScope($aScope);
    }

    return $theToken;
  }

  /**
   * Persists a new access token to permanent storage.
   *
   * @param AccessTokenEntityInterface $accessTokenEntity
   */
  public function persistNewAccessToken(
    AccessTokenEntityInterface $accessTokenEntity
  ) {
    $accessTokenEntity->write();
  }

  /**
   * Revoke an access token.
   *
   * @param string $tokenId
   */
  public function revokeAccessToken($tokenId) {
    $entity = new AccessTokenEntities();
    $entity->revoke();
  }

  /**
   * Check if the access token has been revoked.
   *
   * @param string $tokenId
   *
   * @return bool Return true if this token has been revoked
   */
  public function isAccessTokenRevoked($tokenId) {
    // An access token that doesn't exist is revoked.
    $entity = new AccessTokenEntities();
    return $entity->isRevoked();
  }
}

// EOF
