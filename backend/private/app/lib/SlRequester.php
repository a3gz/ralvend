<?php

namespace App\Lib;

use App\Lib\Exceptions\SecondLifeException;
use App\Lib\Factory\ApplicationsModelFactory;

class SlRequester {
  protected $data = [];

  protected $fields = [
    'appKey' => [
      'label' => 'APP key',
      'required' => true,
    ],
    'avatarKey' => [
      'label' => 'Avatar key',
      'required' => true,
    ],
    'region' => [
      'label' => 'Region',
      'required' => true,
    ],
    'shard' => [
      'label' => 'Shard',
      'required' => true,
    ],
    'objectName' => [
      'label' => 'Object name',
      'required' => false,
    ],
    'objectKey' => [
      'label' => 'Object key',
      'required' => true,
    ],
    'ownerName' => [
      'label' => 'Object owner name',
      'required' => false,
    ],
    'ownerKey' => [
      'label' => 'Object owner key',
      'required' => false,
    ],
    'avatarName' => [
      'label' => 'Avatar name',
      'required' => false,
    ],
    'localVelocity' => [
      'label' => 'Local velocity',
      'required' => false,
    ],
    'localRotation' => [
      'label' => 'Local rotation',
      'required' => false,
    ],
    'localPosition' => [
      'label' => 'Local position',
      'required' => false,
    ],
    'clientIp' => [
      'label' => 'Client IP address',
      'required' => false,
    ],
    'userAgent' => [
      'label' => 'User agent',
      'required' => false,
    ],
  ];

  public function __construct(array $params = null) {
    foreach ($this->fields as $key => $field) {
      if (isset($params) && is_array($params)) {
        $isRequired = isset($field['required']) && $field['required'] === true;
        if ($isRequired && !in_array($key, array_keys($params))) {
          throw SecondLifeException::badRequest(
            "{$field['label']} is required but it was not found in the request"
          );
        }
      }
      $this->data[$key] = isset($params[$key])
        ? $params[$key]
        : null;
    }
  }

  public function __call($methodName, $args) {
    if (substr($methodName, 0, 3) === 'get') {
      $field = strtolower(substr($methodName, 3, 1)) . substr($methodName, 4);
      return $this->data[$field];
    }
    return call_user_func_array([$this, $methodName], $args);
  }

  public function __get($key) {
    if (isset($this->data[$key])) {
      return $this->data[$key];
    }
    return $this->$key;
  }

  public function authenticate() {
    $appKey = $this->getAppKey();
    if (!$appKey) {
      throw SecondLifeException::badRequest("APP KEY is missing");
    }
    $ownerKey = $this->getOwnerKey();
    if (!$ownerKey) {
      throw SecondLifeException::badRequest("Owner KEY is missing");
    }
    $repo = ApplicationsModelFactory::makeRepo();
    $theApplication = $repo->findByAppKey($appKey);
    if (!$theApplication) {
      throw SecondLifeException::badRequest("Invalid APP key");
    }
    if (!$theApplication->belongsToAvatar($ownerKey)) {
      throw SecondLifeException::badRequest("(APP,Owner) KEYs don't match");
    }
  }

  /**
   * @return array
   */
  static public function emptyData() {
    $r = [];
    $o = new SlRequester();
    return $o->toArray();
  }

  /**
   * @return string
   */
  public function getAppKey() {
    return $this->data['appKey'];
  }

  /**
   * @return string
   */
  public function getAvatarKey() {
    return $this->data['avatarKey'];
  }
  
  /**
   * @return string
   */
  public function getRegion() {
    return $this->data['region'];
  }

  /**
   * @return string
   */
  public function getShrad() {
    return $this->data['shrad'];
  }

  /**
   * @return string
   */
  public function getObjectKey() {
    return $this->data['objectKey'];
  }

  /**
   * @return string
   */
  public function getObjectName() {
    return $this->data['objectName'];
  }

  /**
   * @return string
   */
  public function getOwnerKey() {
    return $this->data['ownerKey'];
  }

  /**
   * @return string
   */
  public function getOwnerName() {
    return $this->data['ownerName'];
  }

  /**
   * @return string
   */
  public function getAvatarName() {
    return $this->data['avatarName'];
  }

  /**
   * @return string
   */
  public function getLocalVelocity() {
    return $this->data['localVelocity'];
  }

  /**
   * @return string
   */
  public function getLocalRotation() {
    return $this->data['localRotation'];
  }

  /**
   * @return string
   */
  public function getLocalPosition() {
    return $this->data['localPosition'];
  }

  /**
   * @return string
   */
  public function getClientIp() {
    return $this->data['clientIp'];
  }

  /**
   * @return string
   */
  public function getUserAgent() {
    return $this->data['userAgent'];
  }

  public function isAuthorizedAdmin() {
    $avatarKey = $this->avatarKey;
    $ownerKey = $this->ownerKey;
    $objectKey = $this->objectKey;
    if ($avatarKey !== $ownerKey) {
      return false;
    }
    $authorizedAdmins = [$avatarKey]; // MUST come from DB!
    $avatarIsAdmin = in_array($avatarKey, $authorizedAdmins);
    $objectIsAdmin = in_array($objectKey, $authorizedAdmins);
    if (!$avatarIsAdmin && !$objectIsAdmin) {
      return false;
    }
    return true;
  }

  public function toArray() {
    return $this->data;
  }

  public function validShard() {
    $validShards = [
      'Production',
      'OpenSim',
    ];
    return in_array($this->shard, $validShards);
  }

  public function validMediaUserAgent($force = false) {
    if (!$force && !$this->userAgent) {
      return true;
    }
    $fingerprint = 'SECONDLIFE';
    $found = strpos(strtoupper($this->userAgent), $fingerprint) !== false;
    return $found !== false;
  }
}

// EOF