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
  // Time To Live for OAuth2 access tokens.
  // Access tokens must be distributed to all the objects in the grid.
  // If you don't set one here it will default to 10 Years. You need to evaluate
  // your security needs and adjust it.
  // https://www.php.net/manual/en/dateinterval.construct.php
  'accessTokenTTL' => 'P10Y',
  // Take a look at the files inside private/app/lib/DataAdapters to know
  // more about this.
  // In particular, the method DataAdapterFactory::makeDataAdapter().
  'dataAdapter' => 'Json',
  // 'methodNotAllowedHandler' => function($container) {
  //   return \Fat\Handlers\MethodNotAllowedExceptionHandler::class . ':methodNotAllowed';
  // },
];

// EOF
