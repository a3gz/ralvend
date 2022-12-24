<?php

namespace App\Core\Models\JsonAdapter\OAuth2;

use League\OAuth2\Server\Repositories\RefreshTokenRepositoryInterface;
use League\OAuth2\Server\Entities\RefreshTokenEntityInterface;

class RefreshTokenRepository implements RefreshTokenRepositoryInterface {
  /**
   * Creates a new refresh token
   *
   * @return RefreshTokenEntityInterface
   */
  public function getNewRefreshToken() {
    $theToken = new RefreshTokenEntities();

    $days = 60;
    $t = time() + ($days * 86400);

    $dateTime = new \DateTime();
    $dateTime->setTimestamp($t);
    $theToken->setExpiryDateTime($dateTime);

    return $theToken;
  }

  /**
   * Create a new refresh token_name.
   *
   * @param RefreshTokenEntityInterface $refreshTokenEntity
   */
  public function persistNewRefreshToken(RefreshTokenEntityInterface $refreshTokenEntity) {
    // print_r($refreshTokenEntity->toArray()); die();        
    // $refreshTokenEntity->id = $refreshTokenEntity->getIdentifier();
    $refreshTokenEntity->access_token = $refreshTokenEntity->getAccessToken()->getIdentifier();
    $refreshTokenEntity->expires_at = $refreshTokenEntity->getExpiryDateTime()->format($refreshTokenEntity::TIMESTAMP_FORMAT);

    $refreshTokenEntity->save();
  }

  /**
   * Revoke the refresh token.
   *
   * @param string $tokenId
   */
  public function revokeRefreshToken($tokenId) {
    // We revoke access tokens by deleting them 
    // and their scopes.
    $model = new RefreshTokenEntities();
    $theToken = $model->findByTokenId($tokenId);
    if ($theToken) {
      $theToken->delete();
    }
  }

  /**
   * Check if the refresh token has been revoked.
   *
   * @param string $tokenId
   *
   * @return bool Return true if this token has been revoked
   */
  public function isRefreshTokenRevoked($tokenId) {
    // An access token that doesn't exist is revoked.
    $revoked = false;

    $model = new RefreshTokenEntities();
    $theToken = $model->findBytokenId($tokenId);
    if (!$theToken) {
      $revoked = true;
    }
    return $revoked;
  }
}

// EOF