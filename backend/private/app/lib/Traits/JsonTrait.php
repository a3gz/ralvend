<?php

namespace App\Lib\Traits;

trait JsonTrait {
  /**
   * @return string
   */
  public function jsonSerialize(array $array) {
    return json_encode($array);
  }
}
