<?php

global $_APP_;

$_APP_->get(
  '/tools/keygen',
  \Plugins\keygen\controllers\KeyGenController::class . ':generate'
);

// EOF
