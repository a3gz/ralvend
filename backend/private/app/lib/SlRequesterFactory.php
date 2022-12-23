<?php

namespace App\Lib;

class SlRequesterFactory {
  /**
   * @return \App\Lib\SlRequester
   */
  static public function makeRequester(array $headers) {
    $clean = self::extractRequesterInfoFromHeader($headers);
    return new SlRequester($clean);
  }

  /**
   * @return array
   */
  static public function extractRequesterInfoFromHeader(array $headers) {
    $a = [
      'X-AVATAR-KEY' => 'avatarKey',
      'X_AVATAR_KEY' => 'avatarKey',
      'USER-AGENT' => 'userAgent',
      'USER_AGENT' => 'userAgent',
      'X-APP-KEY' => 'appKey',
      'X_APP_KEY' => 'appKey',
      'X-SECONDLIFE-SHARD' => 'shard',
      'X_SECONDLIFE_SHARD' => 'shard',
      'HTTP_X_SECONDLIFE_SHARD' => 'shard',
      'X-SECONDLIFE-OWNER-KEY' => 'ownerKey',
      'X_SECONDLIFE_OWNER_KEY' => 'ownerKey',
      'HTTP_X_SECONDLIFE_OWNER_KEY' => 'ownerKey',
      'X-SECONDLIFE-OWNER-NAME' => 'ownerName',
      'X_SECONDLIFE_OWNER_NAME' => 'ownerName',
      'HTTP_X_SECONDLIFE_OWNER_NAME' => 'ownerName',
      'X-SECONDLIFE-OBJECT-KEY' => 'objectKey',
      'X_SECONDLIFE_OBJECT_KEY' => 'objectKey',
      'HTTP_X_SECONDLIFE_OBJECT_KEY' => 'objectKey',
      'X-SECONDLIFE-OBJECT-NAME' => 'objectName',
      'X_SECONDLIFE_OBJECT_NAME' => 'objectName',
      'HTTP_X_SECONDLIFE_OBJECT_NAME' => 'objectName',
      'X-SECONDLIFE-REGION' => 'region',
      'X_SECONDLIFE_REGION' => 'region',
      'HTTP_X_SECONDLIFE_REGION' => 'region',
      'X-SECONDLIFE-LOCAL-ROTATION' => 'localRotation',
      'X_SECONDLIFE_LOCAL_ROTATION' => 'localRotation',
      'HTTP_X_SECONDLIFE_LOCAL_ROTATION' => 'localRotation',
      'X-SECONDLIFE-LOCAL-POSITION' => 'localPosition',
      'X_SECONDLIFE_LOCAL_POSITION' => 'localPosition',
      'HTTP_X_SECONDLIFE_LOCAL_POSITION' => 'localPosition',
      'X-SECONDLIFE-LOCAL-VELOCITY' => 'localVelocity',
      'X_SECONDLIFE_LOCAL_VELOCITY' => 'localVelocity',
      'HTTP_X_SECONDLIFE_LOCAL_VELOCITY' => 'localVelocity',
    ];

    $clean = SlRequester::emptyData();

    $ak = array_keys($a);
    foreach ($headers as $key => $values) {
      $ukey = strtoupper($key);
      if (in_array($ukey, $ak)) {
        // Slim parses the header values as an array.
        // If the header accepts only one value, we only need [0]
        $clean[$a[$ukey]] = $values[0];
      }
    }
    if (!$clean['avatarKey']) {
      $clean['avatarKey'] = $clean['ownerKey'];
    }

    // Additional information we may need
    $clean['clientIp'] = self::getClientIp();
    return $clean;
  }

  /**
   * @return string
   */
  static protected function getClientIp() {
    return isset($_SERVER['HTTP_CLIENT_IP']) 
      ? $_SERVER['HTTP_CLIENT_IP'] 
      : (isset($_SERVER['HTTP_X_FORWARDED_FOR']) 
          ? $_SERVER['HTTP_X_FORWARDED_FOR'] 
          : $_SERVER['REMOTE_ADDR']);
  }
}

// EOF
