<?php

namespace App\Core\Models\JsonAdapter\OAuth2;

use League\OAuth2\Server\Entities\AccessTokenEntityInterface;
use League\OAuth2\Server\Entities\ClientEntityInterface;
use League\OAuth2\Server\Entities\ScopeEntityInterface;

use League\OAuth2\Server\Entities\Traits\AccessTokenTrait;
// use League\OAuth2\Server\Entities\Traits\EntityTrait;
// use League\OAuth2\Server\Entities\Traits\TokenEntityTrait;

use DateTimeImmutable;

use App\Lib\ContainerFacade as DI;

class AccessTokenEntities implements AccessTokenEntityInterface {
  use AccessTokenTrait;

  /**
   * @var \App\Lib\SysConfigManager
   */
  protected $sysConfig;

  /**
   * @var string|int
   */
  protected $userIdentifier;

  /**
   * @var ClientEntityInterface
   */
  protected $client;

  public function __construct() {
    $this->sysConfig = DI::get('sysConfig');
  }

  /**
   * Associate a scope with the token.
   *
   * @param ScopeEntityInterface $scope
   */
  public function addScope(ScopeEntityInterface $scope) {
    return;
  }

  /**
   * Get the client that the token was issued to.
   *
   * @return ClientEntityInterface
   */
  public function getClient() {
    return $this->client;
  }

  public function getExpiryDateTime() {
    $date = (new DateTimeImmutable())->setTimestamp(
      (int)$this->sysConfig->asObject()->api->accessToken->expiresAt
    );
    return $date;
  }

  /**
   * @return mixed
   */
  public function getIdentifier() {
    return $this->sysConfig->asObject()->api->accessToken->identifier;
  }

  /**
   * 
   */
  public function getScopes() {
    $r = [];
    if ($this->sysConfig->asObject()->api->accessToken->scopes) {
      $r = $this->sysConfig->asObject()->api->accessToken->scopes;
    }
    return $r;
  }

  /**
   * Get the token user's identifier.
   *
   * @return string|int
   */
  public function getUserIdentifier() {
    return $this->userIdentifier;
  }

  /**
   * @return bool
   */
  public function isRevoked() {
    $identifier = $this->getIdentifier();
    return empty($identifier);
  }

  public function revoke() {
    $this->sysConfig->set('api/accessToken', []);
    $this->write();
  }

  /**
   * Set the client that the token was issued to.
   *
   * @param ClientEntityInterface $client
   */
  public function setClient(ClientEntityInterface $client) {
    $this->client = $client;
  }

  /**
   * Set the date time when the token expires.
   *
   * @param DateTimeImmutable $dateTime
   */
  public function setExpiryDateTime(DateTimeImmutable $dateTime) {
    $this->sysConfig->set(
      'api/accessToken/expiresAt',
      $dateTime->getTimestamp()
    );
  }

  /**
   * Set the date time when the token expires.
   *
   * @param \DateTime $dateTime
   */
  // public function setExpiryDateTime(\DateTime $dateTime) {
  //   $this->expires_at = $dateTime->format(self::TIMESTAMP_FORMAT);
  // }

  /**
   * @param mixed $identifier
   */
  public function setIdentifier($identifier) {
    $this->sysConfig->set('api/accessToken/identifier', $identifier);
  }

  /**
   * Set the identifier of the user associated with the token.
   *
   * @param string|int $identifier The identifier of the user
   */
  public function setUserIdentifier($identifier) {
    $this->userIdentifier = $identifier;
  }

  public function write() {
    $this->sysConfig->write();
  }
}

// EOF
