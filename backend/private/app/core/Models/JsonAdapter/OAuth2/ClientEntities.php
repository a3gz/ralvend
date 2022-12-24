<?php

namespace App\Core\Models\JsonAdapter\OAuth2;

use League\OAuth2\Server\Entities\ClientEntityInterface;
use League\OAuth2\Server\Entities\Traits\ClientTrait;
use League\OAuth2\Server\Entities\Traits\EntityTrait;
use App\Lib\ContainerFacade as DI;

class ClientEntities implements ClientEntityInterface {
  use ClientTrait;
  use EntityTrait;

  public function __construct() {
    $this->isConfidential = true;
    $this->identifier = $this->getKey();
    $this->name = 'RalVendOAuth2Client';
    $this->redirectdUri = '';
  }

  public function getKey() {
    return DI::get('sysConfig')->asObject()->api->client->id;
  }

  public function getSecret() {
    return DI::get('sysConfig')->asObject()->api->client->secret;
  }
}

// EOF
