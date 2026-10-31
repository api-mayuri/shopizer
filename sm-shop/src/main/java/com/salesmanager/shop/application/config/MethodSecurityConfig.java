package com.salesmanager.shop.application.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;

/**
 * Method security: @PreAuthorize/@PostAuthorize (enabled by default), @Secured and JSR-250 annotations.
 * Replaces @EnableGlobalMethodSecurity + GlobalMethodSecurityConfiguration (removed in Spring Security 6).
 */
@Configuration
@EnableMethodSecurity(
		securedEnabled = true,
		jsr250Enabled = true)
public class MethodSecurityConfig {

}
