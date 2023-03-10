<?php

namespace Plugins\keygen\lib;

class KeyGenerator {
  public function generate() {
    $random = microtime() . rand(1000, 9999);
    $hash = substr(hash('sha256', $random), 0, 36);
    // Split in groups of 6 characters
    $split = str_split($hash, 6);
    $hash = implode('-', $split);
    return $hash;
  }
}

// EOF
