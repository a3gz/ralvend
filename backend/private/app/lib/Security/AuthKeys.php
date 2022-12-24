<?php

namespace App\Lib\Security;

class AuthKeys {
  public static function getCaPermFilePath() {
    return __DIR__ . '/cacert.pem';
  }

  public static function getEncryptionKey() {
    $r = file_get_contents(self::getEncryptionKeyPath());
    return $r;
  }

  public static function getEncryptionKeyPath() {
    $r = __DIR__ . '/encryption.key';
    return $r;
  }

  public static function getPrivateKeyPath() {
    $r = __DIR__ . '/private.key';
    return $r;
  }

  public static function getPublicKeyPath() {
    $r = __DIR__ . '/public.key';
    return $r;
  }

  public static function makeEncryptionKey() {
    $key = base64_encode(random_bytes(32));
    file_put_contents(self::getEncryptionKeyPath(), $key);
    return $key;
  }
}

// EOF
