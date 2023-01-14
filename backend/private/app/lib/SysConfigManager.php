<?php

namespace App\Lib;

use App\Lib\Exceptions\ConfigFileException;

class SysConfigManager {
  const AS_ASSOC = true;

  /**
   * @var array
   */
  protected $data;

  public function __construct() {
    $this->read();
  }

  /**
   * @return array
   */
  public function asArray() {
    return $this->data;
  }

  /**
   * @return \stdObject
   */
  public function asObject() {
    return json_decode(json_encode($this->data));
  }

  protected function makeFileName() {
    $path = Path::makeUsrPath();
    $absFileName = "{$path}/config.json";
    if (!is_readable($absFileName)) {
      throw ConfigFileException::fileNotFound($absFileName);
    }
    return $absFileName;
  }

  /**
   * @return $this
   */
  protected function read() {
    $absFileName = $this->makeFileName();
    $raw = file_get_contents($absFileName);
    $this->data = json_decode($raw, self::AS_ASSOC);
    return $this;
  }

  public function set(string $path, $value) {
    $pathParts = explode('/', $path);
    $this->update($this->data, $pathParts, $value);
    return $this;
  }

  protected function update(array &$target, array $path, $value) {
    if (count($path) === 1) {
      $target[$path[0]] = $value;
    } else {
      $first = array_shift($path);
      if (isset($target[$first])) {
        $this->update($target[$first], $path, $value);
      }
    }
  }

  public function write() {
    $fileName = $this->makeFileName();
    file_put_contents(
      $fileName,
      json_encode($this->data, JSON_PRETTY_PRINT)
    );
    return $this;
  }
}

// EOF
