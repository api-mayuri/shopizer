package com.salesmanager.shop.store.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.Collections;
import java.util.Date;

import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import com.salesmanager.shop.store.security.user.JWTUser;

import io.jsonwebtoken.security.SignatureException;

class JWTTokenUtilTest {

	private static String randomSecret() {
		byte[] bytes = new byte[64];
		new SecureRandom().nextBytes(bytes);
		return Base64.getEncoder().encodeToString(bytes);
	}

	private static JWTTokenUtil util(String secret) {
		JWTTokenUtil util = new JWTTokenUtil();
		ReflectionTestUtils.setField(util, "secret", secret);
		ReflectionTestUtils.setField(util, "expiration", 3600L);
		util.initSigningKey();
		return util;
	}

	private static JWTUser user(String name, Date lastPasswordReset) {
		return new JWTUser(1L, name, "First", "Last", name, "pwd", Collections.emptyList(), true, lastPasswordReset);
	}

	@Test
	void generatesAndValidatesToken() {
		JWTTokenUtil util = util(randomSecret());
		JWTUser user = user("admin@shopizer.com", null);

		String token = util.generateToken(user);

		assertEquals("admin@shopizer.com", util.getUsernameFromToken(token));
		assertEquals("api", util.getAudienceFromToken(token));
		assertTrue(util.validateToken(token, user));
		assertFalse(util.validateToken(token, user("other@shopizer.com", null)));
	}

	@Test
	void tokenSignedWithAnotherKeyIsRejected() {
		String token = util(randomSecret()).generateToken(user("a@b.c", null));
		JWTTokenUtil other = util(randomSecret());
		assertThrows(SignatureException.class, () -> other.getUsernameFromToken(token));
	}

	@Test
	void refreshKeepsSubjectAndIsDeniedAfterPasswordReset() throws Exception {
		JWTTokenUtil util = util(randomSecret());
		JWTUser user = user("a@b.c", null);
		String token = util.generateToken(user);

		Thread.sleep(1100); // iat has a one second precision
		String refreshed = util.refreshToken(token);
		assertNotEquals(token, refreshed);
		assertEquals("a@b.c", util.getUsernameFromToken(refreshed));

		assertTrue(util.canTokenBeRefreshedWithGrace(token, null));
		Date passwordResetLater = new Date(System.currentTimeMillis() + 3_600_000L);
		assertFalse(util.canTokenBeRefreshedWithGrace(token, passwordResetLater));
	}

	@Test
	void blankSecretUsesRandomKey() {
		JWTTokenUtil util = util("");
		String token = util.generateToken(user("a@b.c", null));
		assertEquals("a@b.c", util.getUsernameFromToken(token));
	}

	@Test
	void shortOrInvalidSecretIsRejected() {
		// the former default secret
		assertThrows(IllegalStateException.class, () -> util("aSecret"));
		assertThrows(IllegalStateException.class, () -> util(Base64.getEncoder().encodeToString(new byte[32])));
		assertThrows(IllegalStateException.class, () -> util("not base64 !!"));
	}
}
