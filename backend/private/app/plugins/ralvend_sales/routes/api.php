<?php

global $_APP_;

$_APP_->post(
  '/sales',
  \Plugins\ralvend_sales\controllers\SalesController::class . ':create'
);

// EOF
