<?php
return [
  'errorHandler' => [
    'displayErrorDetails' => true,
    'logError' => true,
    'logErrorDetails' => true,
  ],
  'notFoundHandler' => function ($container) {
    return \App\Core\Controllers\NotFountExceptionHandler::class . ':notFound';
  },
  // Take a look at the files inside private/app/lib/DataAdapters to know
  // more about this.
  // In particular, the method DataAdapterFactory::makeDataAdapter().
  'dataAdapter' => 'Json',
  // 'methodNotAllowedHandler' => function($container) {
  //   return \Fat\Handlers\MethodNotAllowedExceptionHandler::class . ':methodNotAllowed';
  // },
];

// EOF
