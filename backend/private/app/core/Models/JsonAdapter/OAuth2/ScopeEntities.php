<?php

namespace App\Core\Models\JsonAdapter\OAuth2;

use League\OAuth2\Server\Entities\ScopeEntityInterface;
use App\Lib\Traits\JsonTrait;

class ScopeEntities extends AbstractModel implements ScopeEntityInterface {
  use JsonTrait;

  /**
   * @var string 
   */
  protected $table = 'oauth_scopes';

  /**
   * @var array 
   */
  protected $guarded = [
    'id',
    'name',
    'description',
  ];

  /**
   * @var string 
   */
  protected $primaryKey = 'id';

  /**
   * @var boolean
   */
  public $incrementing = false;

  public function getByIdentifier($identifier) {
    $r = $this->where('name', $identifier)->first();
    return $r;
  }

  /**
   * Get the scope's identifier.
   *
   * @return string
   */
  public function getIdentifier() {
    return $this->name;
  }
}

// EOF