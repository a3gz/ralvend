<?php

namespace App\Lib;

class Path extends \Fat\Helpers\Path {
  static public function makeTempPath(string $x = '') {
    if (!empty($x) && substr($x, 0, 1) !== '/') {
      $x = "/{$x}";
    }
    return parent::makeEtcPath("/temp{$x}");
  }

  static public function makeUsrPath(string $x = '') {
    if (!empty($x) && substr($x, 0, 1) !== '/') {
      $x = "/{$x}";
    }
    return self::makeTempPath("/usr{$x}");
  }
}