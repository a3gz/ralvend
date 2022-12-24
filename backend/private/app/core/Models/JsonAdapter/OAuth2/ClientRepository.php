<?php

namespace App\Core\Models\JsonAdapter\OAuth2;

use League\OAuth2\Server\Repositories\ClientRepositoryInterface;

class ClientRepository implements ClientRepositoryInterface {
  /**
   * Get a client.
   *
   * @param string      $clientIdentifier   The client's identifier
   * @param string      $grantType          The grant type used
   * @param null|string $clientSecret       The client's secret (if sent)
   * @param bool        $mustValidateSecret If true the client must attempt to validate the secret if the client
   *                                        is confidential
   *
   * @return ClientEntityInterface
   */
  public function getClientEntity($clientIdentifier) {
    return new ClientEntities();
  }

  /**
   * Validate a client's secret.
   *
   * @param string      $clientIdentifier The client's identifier
   * @param null|string $clientSecret     The client's secret (if sent)
   * @param null|string $grantType        The type of grant the client is using (if sent)
   *
   * @return bool
   */
  public function validateClient($clientIdentifier, $clientSecret, $grantType) {
    if ($grantType !== 'client_credentials') {
      return false;
    }
    $entity = $this->getClientEntity($clientIdentifier);
    if (!$entity) {
      return false;
    }
    return $entity->getSecret() === $clientSecret;
  }
}

// EOF