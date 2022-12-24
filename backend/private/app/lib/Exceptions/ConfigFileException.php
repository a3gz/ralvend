<?php

namespace App\Lib\Exceptions;

class ConfigFileException extends HttpException {
  /**
   * @return \App\Lib\Exceptions\HttpException
   */
  public static function fileNotFound(string $fileName) {
    return parent::notFound(
      "Configuration file not found: {$fileName}"
    );
  }
}

// EOF
