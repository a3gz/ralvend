<?php

namespace Fat\Helpers;

use Fat\Helpers\FileSystem;

class Path {
  static public function makeAppPath(string $x = '') {
    if (!empty($x) && substr($x, 0, 1) !== '/') {
      $x = "/{$x}";
    }
    $r = APP_PATH . $x;
    FileSystem::instance()->createDir($r);
    return $r;
  }

  static public function makeEtcPath(string $x = '') {
    if (!empty($x) && substr($x, 0, 1) !== '/') {
      $x = "/{$x}";
    }
    $r = ETC_PATH . $x;
    FileSystem::instance()->createDir($r);
    return $r;
  }

  static public function makePluginsPath(string $x = '') {
    if (!empty($x) && substr($x, 0, 1) !== '/') {
      $x = "/{$x}";
    }
    $r = self::makeAppPath("/plugins{$x}");
    return $r;
  }

  static public function makePrivatePath(string $x = '') {
    if (!empty($x) && substr($x, 0, 1) !== '/') {
      $x = "/{$x}";
    }
    $r = PRIVATE_PATH . $x;
    FileSystem::instance()->createDir($r);
    return $r;
  }

  static public function makePublicPath(string $x = '') {
    if (!empty($x) && substr($x, 0, 1) !== '/') {
      $x = "/{$x}";
    }
    $r = PUBLIC_PATH . $x;
    FileSystem::instance()->createDir($r);
    return $r;
  }
}

// EOF