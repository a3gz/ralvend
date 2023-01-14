<?php

namespace App\Lib;

class ContainerFacade {
  private static $o = null;

  public function __get($key) {
    global $_APP_;
    $container = $_APP_->getContainer();
    if (!isset($container)) {
      throw new \Exception("The container hasn't been registered as global.");
    }
    if (!$container->has($key)) {
      throw new \Exception("Dependency '{$key}' hasn't been injected.");
    }
    return $container->get($key);
  }

  public static function get($key) {
    $i = self::instance();
    return $i->$key;
  }

  public static function has($key) {
    global $_APP_;
    $container = $_APP_->getContainer();
    if (!isset($container)) {
      throw new \Exception("The container hasn't been registered as global.");
    }
    return $container->has($key);
  }

  public static function instance() {
    if (self::$o === null) {
      self::$o = new ContainerFacade();
    }
    return self::$o;
  }

  public static function set(string $key, $value) {
    global $_APP_;
    $container = $_APP_->getContainer();
    $container->set($key, $value);
  }
}

// EOF
