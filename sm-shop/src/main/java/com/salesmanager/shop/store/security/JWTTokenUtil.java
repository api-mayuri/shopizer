package com.salesmanager.shop.store.security;

import java.io.Serial;
import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.Set;

import javax.crypto.SecretKey;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.salesmanager.shop.store.security.user.JWTUser;
import com.salesmanager.shop.utils.DateUtil;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;

/**
 * Used for managing token based authentication for customer and user
 * @author c.samson
 *
 */
@Component
public class JWTTokenUtil implements Serializable {

	/**
	 * 
	 */
	@Serial
	private static final long serialVersionUID = 1L;
	
	
	    static final int GRACE_PERIOD = 200;
	
	
	
	 	static final String CLAIM_KEY_USERNAME = "sub";
	    static final String CLAIM_KEY_AUDIENCE = "aud";
	    static final String CLAIM_KEY_CREATED = "iat";

	    static final String AUDIENCE_UNKNOWN = "unknown";
	    static final String AUDIENCE_API = "api";
	    static final String AUDIENCE_WEB = "web";
	    static final String AUDIENCE_MOBILE = "mobile";
	    static final String AUDIENCE_TABLET = "tablet";


	    private static final Logger LOGGER = LoggerFactory.getLogger(JWTTokenUtil.class);

	    /** HS512 requires a key of at least 512 bits. */
	    static final int MIN_SECRET_BYTES = 64;

	    /** Base64 encoded HMAC key (jwt.secret / SHOPIZER_JWT_SECRET). */
	    @Value("${jwt.secret:}")
	    private String secret;

	    private transient SecretKey signingKey;

	    @PostConstruct
	    void initSigningKey() {
	        this.signingKey = signingKey(secret);
	    }

	    /**
	     * Builds the HMAC key from a Base64 encoded secret (at least 64 bytes).
	     * Without secret a random key is generated: tokens are then only valid until the next restart
	     * and only on this instance.
	     */
	    static SecretKey signingKey(String base64Secret) {
	        if (base64Secret == null || base64Secret.isBlank()) {
	            LOGGER.warn("jwt.secret (SHOPIZER_JWT_SECRET) is not set: using a random key, JWT tokens will not survive a restart "
	                    + "and will not be shared between instances. Set it in production (openssl rand -base64 64).");
	            byte[] random = new byte[MIN_SECRET_BYTES];
	            new SecureRandom().nextBytes(random);
	            return Keys.hmacShaKeyFor(random);
	        }
	        byte[] bytes;
	        try {
	            bytes = Base64.getDecoder().decode(base64Secret.trim());
	        } catch (IllegalArgumentException e) {
	            throw new IllegalStateException("jwt.secret (SHOPIZER_JWT_SECRET) must be Base64 encoded. "
	                    + "Generate one with: openssl rand -base64 64", e);
	        }
	        if (bytes.length < MIN_SECRET_BYTES) {
	            throw new IllegalStateException("jwt.secret (SHOPIZER_JWT_SECRET) is too short: " + bytes.length
	                    + " bytes, at least " + MIN_SECRET_BYTES + " bytes are required for HS512. "
	                    + "Generate one with: openssl rand -base64 64");
	        }
	        return Keys.hmacShaKeyFor(bytes);
	    }

	    @Value("${jwt.expiration}")
	    private Long expiration;

	    public String getUsernameFromToken(String token) {
	        return getClaimFromToken(token, Claims::getSubject);
	    }

	    public Date getIssuedAtDateFromToken(String token) {
	        return getClaimFromToken(token, Claims::getIssuedAt);
	    }

	    public Date getExpirationDateFromToken(String token) {
	        return getClaimFromToken(token, Claims::getExpiration);
	    }

	    public String getAudienceFromToken(String token) {
	        Set<String> audience = getClaimFromToken(token, Claims::getAudience);
	        return (audience == null || audience.isEmpty()) ? null : audience.iterator().next();
	    }

	    public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
	        final Claims claims = getAllClaimsFromToken(token);
	        return claimsResolver.apply(claims);
	    }

	    private Claims getAllClaimsFromToken(String token) {
	        return Jwts.parser()
	                .verifyWith(signingKey)
	                .build()
	                .parseSignedClaims(token)
	                .getPayload();
	    }

	    private Boolean isTokenExpired(String token) {
	        final Date expiration = getExpirationDateFromToken(token);
	        return expiration.before(DateUtil.getDate());
	    }
	    
	    private Boolean isTokenExpiredWithGrace(String token) {
	            Date expiration = getExpirationDateFromToken(token);
	            expiration = addSeconds(expiration,GRACE_PERIOD);
	            return expiration.before(DateUtil.getDate());
	    }

	    private Boolean isCreatedBeforeLastPasswordReset(Date created, Date lastPasswordReset) {
	        return (lastPasswordReset != null && created.before(lastPasswordReset));
	    }
	    
	    private Boolean isCreatedBeforeLastPasswordResetWithGrace(Date created, Date lastPasswordReset) {
	        return (lastPasswordReset != null && created.before(addSeconds(lastPasswordReset,GRACE_PERIOD)));
	    }
	    
	    private Date addSeconds(Date date, Integer seconds) {
	      Calendar cal = Calendar.getInstance();
	      cal.setTime(date);
	      cal.add(Calendar.SECOND, seconds);
	      return cal.getTime();
	    }

	    private String generateAudience() {
	        return AUDIENCE_API;
	    }

	    private Boolean ignoreTokenExpiration(String token) {
	        String audience = getAudienceFromToken(token);
	        return (AUDIENCE_TABLET.equals(audience) || AUDIENCE_MOBILE.equals(audience));
	    }

	    public String generateToken(UserDetails userDetails) {
	        Map<String, Object> claims = new HashMap<>();
	        return doGenerateToken(claims, userDetails.getUsername(), generateAudience());
	    }

	    private String doGenerateToken(Map<String, Object> claims, String subject, String audience) {
	        final Date createdDate = DateUtil.getDate();
	        final Date expirationDate = calculateExpirationDate(createdDate);

	        return Jwts.builder()
	                .claims(claims)
	                .subject(subject)
	                .audience().add(audience).and()
	                .issuedAt(createdDate)
	                .expiration(expirationDate)
	                .signWith(signingKey, Jwts.SIG.HS512)
	                .compact();
	    }
	    
        public Boolean canTokenBeRefreshedWithGrace(String token, Date lastPasswordReset) {
          final Date created = getIssuedAtDateFromToken(token);
          // previously always returned true: a token issued before a password reset could still be refreshed
          return !isCreatedBeforeLastPasswordResetWithGrace(created, lastPasswordReset)
                  && (!isTokenExpiredWithGrace(token) || ignoreTokenExpiration(token));
        }	    

	    public Boolean canTokenBeRefreshed(String token, Date lastPasswordReset) {
	        final Date created = getIssuedAtDateFromToken(token);
	        return !isCreatedBeforeLastPasswordReset(created, lastPasswordReset)
	                && (!isTokenExpired(token) || ignoreTokenExpiration(token));
	    }

	    public String refreshToken(String token) {
	        final Date createdDate = DateUtil.getDate();
	        final Date expirationDate = calculateExpirationDate(createdDate);

	        final Claims claims = getAllClaimsFromToken(token);

	        return Jwts.builder()
	                .claims(claims)
	                .issuedAt(createdDate)
	                .expiration(expirationDate)
	                .signWith(signingKey, Jwts.SIG.HS512)
	                .compact();
	    }

	    public Boolean validateToken(String token, UserDetails userDetails) {
	        JWTUser user = (JWTUser) userDetails;
	        final String username = getUsernameFromToken(token);
	        final Date created = getIssuedAtDateFromToken(token);
	        //final Date expiration = getExpirationDateFromToken(token);
	        
	        boolean usernameEquals = username.equals(user.getUsername());
	        boolean isTokenExpired = isTokenExpired(token);
	        boolean isTokenCreatedBeforeLastPasswordReset = isCreatedBeforeLastPasswordReset(created, user.getLastPasswordResetDate());
	        
	        return (

	        		usernameEquals && !isTokenExpired && !isTokenCreatedBeforeLastPasswordReset
	        );
	    }

	    private Date calculateExpirationDate(Date createdDate) {
	        return new Date(createdDate.getTime() + expiration * 1000);
	    }

}
