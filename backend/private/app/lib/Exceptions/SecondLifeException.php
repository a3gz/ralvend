<?php

namespace App\Lib\Exceptions;

use A3gZ\PhpExceptions\HttpException;

class SecondLifeException extends HttpException {
  public static function accountAlreadyExists() {
    return new static(
      "The requesting avatar is already registered",
      'account_exists',
      409,
      null,
      null);
  }

  public static function agentAccessDenied() {
    return parent::accessDenied(
      "The agent isn't registered or its access grant has been temporarily revoked."
    );
  }

  public static function invalidShard() {
    return parent::badRequest(
      'The request source is not recognized.'
    );
  }

  /**
   * Invalid user agent.
   * This API only accepts request from a Second Life script.
   */
  public static function invalidUserAgent() {
    return parent::badRequest(
      'This API cannot be accessed this way.'
    );
  }

  public static function objectAccessDenied() {
    return parent::accessDenied(
      "The object isn't registered or its access grant has been temporarily revoked."
    );
  }
}
