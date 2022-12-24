<?php 
namespace App\Core\Models\JsonAdapter\OAuth2;

use League\OAuth2\Server\Entities\RefreshTokenEntityInterface;
use League\OAuth2\Server\Entities\ClientEntityInterface;
use League\OAuth2\Server\Entities\AccessTokenEntityInterface;

use League\OAuth2\Server\Entities\Traits\RefreshTokenTrait;
use League\OAuth2\Server\Entities\Traits\EntityTrait;

class RefreshTokenEntities extends AbstractModel implements RefreshTokenEntityInterface 
{
    // use RefreshTokenTrait;
    // use EntityTrait;
    
    
    /**
     * @var string 
     */
    protected $table = 'oauth_refresh_tokens';
    
    
    /**
     * @var array 
     */
    protected $guarded = [
        'id',
        'refresh_token',
        'access_token',
        'expires_at',
    ];
    
    
    /**
     * @var string 
     */
    protected $primaryKey = 'id';
    
    
    /**
     * @var boolean
     */
    public $incrementing = true;
    
    
    /**
     * Find the refresh token associated to a given access token. 
     * @param string $tokenId 
     * @return RefreshTokenEntities
     */
    public function findByTokenId( $tokenId )
    {
        return $this->where( 'refresh_token', $tokenId )->first();
    } // findByTokenId()
    
    /**
     * {@inheritdoc}
     */
    public function getAccessToken()
    {
        return $this->access_token;
    } // getAccessToken()

    /**
     * Get the token's expiry date time.
     *
     * @return \DateTime
     */
    public function getExpiryDateTime()
    {
        $r = new \DateTime();
        $r->setTimestamp(strtotime($this->expires_at));
        return $r;
    } // getExpiryDateTime()

    /**
     * @return mixed
     */
    public function getIdentifier()
    {
        return $this->refresh_token;
    } // getIdentifier()

    /**
     * {@inheritdoc}
     */
    public function setAccessToken(AccessTokenEntityInterface $accessToken)
    {
        $this->access_token = $accessToken;
    } // setAccessToken()

    /**
     * Set the date time when the token expires.
     *
     * @param \DateTime $dateTime
     */
    public function setExpiryDateTime(\DateTime $dateTime)
    {
        $this->expires_at = $dateTime->format(self::TIMESTAMP_FORMAT);
    } // setExpiryDateTime()
    
    /**
     * @param mixed $identifier
     */
    public function setIdentifier($identifier)
    {
        $this->refresh_token = $identifier;
    } // setIdentifier()    

} // class 

// EOF