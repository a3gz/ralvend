<?php

namespace App\Lib\DataAdapter;

use App\Lib\ContainerFacade as DI;

class DataAdapterFactory {
  /**
   * If you want to use a different data management system such as MySQL
   * you need to:
   * 1. Build the models and the data adapter. You can use JsonDataAdapter as
   *    reference.
   * 2. Read the file private/app/config/container/main and look for the
   *    definition of the variable 'dataAdapter'. That's the only thing you
   *    need to change in order to activate your own data adapter.
   * @return \App\Lib\DataAdapter\DataAdapterInterface
   */
  static public function makeDataAdapter() {
    $dataAdapter = DI::get('dataAdapter');
    $methodName = "make{$dataAdapter}DataAdapter";
    return self::$methodName();
  }

  /**
   * @return \App\Lib\DataAdapter\DataAdapterInterface
   */
  static protected function makeJsonDataAdapter() {
    return new JsonDataAdapter();
  }
}
