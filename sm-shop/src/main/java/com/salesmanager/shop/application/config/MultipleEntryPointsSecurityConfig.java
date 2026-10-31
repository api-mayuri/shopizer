package com.salesmanager.shop.application.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.DefaultAuthenticationEventPublisher;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.ProviderNotFoundException;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.www.BasicAuthenticationEntryPoint;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;

import com.salesmanager.shop.admin.security.UserAuthenticationSuccessHandler;
import com.salesmanager.shop.admin.security.WebUserServices;
import com.salesmanager.shop.store.controller.customer.facade.CustomerFacade;
import com.salesmanager.shop.store.security.AuthenticationTokenFilter;
import com.salesmanager.shop.store.security.ServicesAuthenticationSuccessHandler;
import com.salesmanager.shop.store.security.admin.JWTAdminAuthenticationProvider;
import com.salesmanager.shop.store.security.admin.JWTAdminServicesImpl;
import com.salesmanager.shop.store.security.customer.JWTCustomerAuthenticationProvider;
import com.salesmanager.shop.store.security.services.CredentialsService;
import com.salesmanager.shop.store.security.services.CredentialsServiceImpl;

/**
 * Main entry point for security - shop/customer - services - api private (admin) - api auth (customer).
 *
 * Component based configuration (SecurityFilterChain beans), replaces the former
 * WebSecurityConfigurerAdapter based configuration. Each chain keeps its own
 * AuthenticationManager, built the same way the adapters used to build them:
 * a ProviderManager with a DaoAuthenticationProvider (chain specific UserDetailsService + BCrypt).
 *
 * @author dur9213
 */
@Configuration
@EnableWebSecurity
public class MultipleEntryPointsSecurityConfig {

	private static final String API_VERSION = "/api/v*";

	@Bean
	public AuthenticationTokenFilter authenticationTokenFilter() {
		return new AuthenticationTokenFilter();
	}

	@Bean
	public CredentialsService credentialsService() {
		return new CredentialsServiceImpl();
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public UserAuthenticationSuccessHandler userAuthenticationSuccessHandler() {
		return new UserAuthenticationSuccessHandler();
	}

	@Bean
	public ServicesAuthenticationSuccessHandler servicesAuthenticationSuccessHandler() {
		return new ServicesAuthenticationSuccessHandler();
	}

	@Bean
	public CustomerFacade customerFacade() {
		return new com.salesmanager.shop.store.controller.customer.facade.CustomerFacadeImpl();
	}

	/**
	 * Spring Security needs a single (primary) AuthenticationManager for its global configuration.
	 * Every SecurityFilterChain below sets its own manager, and injection points use explicit
	 * qualifiers, so this one only acts as a fail-safe: it authenticates nobody.
	 */
	@Bean
	@Primary
	public AuthenticationManager globalAuthenticationManager() {
		return authentication -> {
			throw new ProviderNotFoundException("No global authentication manager, use a chain specific one");
		};
	}

	@Bean
	public WebSecurityCustomizer webSecurityCustomizer() {
		return web -> web.ignoring().requestMatchers("/", "/error", "/resources/**", "/static/**", "/services/public/**", "/swagger-ui.html", "/swagger-ui/**");
	}

	private static ProviderManager providerManager(AuthenticationProvider... providers) {
		ProviderManager manager = new ProviderManager(providers);
		manager.setAuthenticationEventPublisher(new DefaultAuthenticationEventPublisher());
		return manager;
	}

	private static DaoAuthenticationProvider daoProvider(UserDetailsService userDetailsService,
			PasswordEncoder passwordEncoder) {
		DaoAuthenticationProvider provider = new DaoAuthenticationProvider(userDetailsService);
		provider.setPasswordEncoder(passwordEncoder);
		return provider;
	}

	private static BasicAuthenticationEntryPoint entryPoint(String realm) {
		BasicAuthenticationEntryPoint entryPoint = new BasicAuthenticationEntryPoint();
		entryPoint.setRealmName(realm);
		return entryPoint;
	}

	/**
	 * shop / customer
	 */
	@Configuration
	public static class CustomerConfiguration {

		@Bean("customerAuthenticationManager")
		public AuthenticationManager customerAuthenticationManager(
				@Qualifier("customerDetailsService") UserDetailsService customerDetailsService,
				PasswordEncoder passwordEncoder) {
			return providerManager(daoProvider(customerDetailsService, passwordEncoder));
		}

		@Bean
		public AuthenticationEntryPoint shopAuthenticationEntryPoint() {
			return entryPoint("shop-realm");
		}

		@Bean
		@Order(1)
		public SecurityFilterChain customerFilterChain(HttpSecurity http,
				@Qualifier("customerAuthenticationManager") AuthenticationManager customerAuthenticationManager)
				throws Exception {
			http
					.securityMatcher("/shop/**")
					.authenticationManager(customerAuthenticationManager)
					.csrf(csrf -> csrf.disable())
					.authorizeHttpRequests(requests -> requests
							.requestMatchers("/shop/").permitAll()
							.requestMatchers("/shop/**").permitAll()
							.requestMatchers("/shop/customer/logon*").permitAll()
							.requestMatchers("/shop/customer/registration*").permitAll()
							.requestMatchers("/shop/customer/logout*").permitAll()
							.requestMatchers("/shop/customer/customLogon*").permitAll()
							.requestMatchers("/shop/customer/denied*").permitAll()
							.requestMatchers("/shop/customer/**").hasRole("AUTH_CUSTOMER")
							.anyRequest().authenticated())
					.httpBasic(basic -> basic
							.authenticationEntryPoint(shopAuthenticationEntryPoint()))
					.logout(logout -> logout
							.logoutUrl("/shop/customer/logout")
							.logoutSuccessUrl("/shop/")
							.invalidateHttpSession(true)
							.deleteCookies("JSESSIONID")
							.invalidateHttpSession(false))
					.exceptionHandling(handling -> handling.accessDeniedPage("/shop/"));
			return http.build();
		}
	}

	/**
	 * services api v0
	 *
	 * @deprecated
	 */
	@Configuration
	public static class ServicesApiConfiguration {

		@Bean("servicesAuthenticationManager")
		public AuthenticationManager servicesAuthenticationManager(
				@Qualifier("userDetailsService") WebUserServices userDetailsService, PasswordEncoder passwordEncoder) {
			return providerManager(daoProvider(userDetailsService, passwordEncoder));
		}

		@Bean
		public AuthenticationEntryPoint servicesAuthenticationEntryPoint() {
			return entryPoint("rest-customer-realm");
		}

		@Bean
		@Order(2)
		public SecurityFilterChain servicesFilterChain(HttpSecurity http,
				@Qualifier("servicesAuthenticationManager") AuthenticationManager servicesAuthenticationManager,
				ServicesAuthenticationSuccessHandler servicesAuthenticationSuccessHandler) throws Exception {
			http
					.securityMatcher("/services/**")
					.authenticationManager(servicesAuthenticationManager)
					.csrf(csrf -> csrf.disable())
					.authorizeHttpRequests(requests -> requests
							.requestMatchers("/services/public/**").permitAll()
							.requestMatchers("/services/private/**").hasRole("AUTH")
							.anyRequest().authenticated())
					.httpBasic(basic -> basic.authenticationEntryPoint(servicesAuthenticationEntryPoint()))
					.formLogin(login -> login
							.successHandler(servicesAuthenticationSuccessHandler));
			return http.build();
		}
	}

	/**
	 * api - private (admin users, JWT)
	 */
	@Configuration
	public static class UserApiConfiguration {

		@Bean
		public JWTAdminAuthenticationProvider jwtAdminAuthenticationProvider(
				JWTAdminServicesImpl jwtUserDetailsService) {
			return new JWTAdminAuthenticationProvider(jwtUserDetailsService);
		}

		@Bean("jwtAdminAuthenticationManager")
		public AuthenticationManager jwtAdminAuthenticationManager(JWTAdminServicesImpl jwtUserDetailsService,
				JWTAdminAuthenticationProvider jwtAdminAuthenticationProvider, PasswordEncoder passwordEncoder) {
			return providerManager(daoProvider(jwtUserDetailsService, passwordEncoder),
					jwtAdminAuthenticationProvider);
		}

		@Bean
		public AuthenticationEntryPoint apiAdminAuthenticationEntryPoint() {
			return entryPoint("api-admin-realm");
		}

		@Bean
		@Order(5)
		public SecurityFilterChain userApiFilterChain(HttpSecurity http,
				@Qualifier("jwtAdminAuthenticationManager") AuthenticationManager jwtAdminAuthenticationManager,
				AuthenticationTokenFilter authenticationTokenFilter) throws Exception {
			http
					.securityMatcher(API_VERSION + "/private/**")
					.authenticationManager(jwtAdminAuthenticationManager)
					.authorizeHttpRequests(requests -> requests
							.requestMatchers(API_VERSION + "/private/login*").permitAll()
							.requestMatchers(API_VERSION + "/private/refresh").permitAll()
							.requestMatchers(HttpMethod.OPTIONS, API_VERSION + "/private/**").permitAll()
							.requestMatchers(API_VERSION + "/private/**").hasRole("AUTH")
							.anyRequest().authenticated())
					.httpBasic(basic -> basic.authenticationEntryPoint(apiAdminAuthenticationEntryPoint()))
					.addFilterAfter(authenticationTokenFilter, BasicAuthenticationFilter.class)
					.csrf(csrf -> csrf.disable());
			return http.build();
		}
	}

	/**
	 * customer api (JWT)
	 */
	@Configuration
	public static class CustomerApiConfiguration {

		@Bean
		public JWTCustomerAuthenticationProvider jwtCustomerAuthenticationProvider(
				@Qualifier("jwtCustomerDetailsService") UserDetailsService jwtCustomerDetailsService) {
			return new JWTCustomerAuthenticationProvider(jwtCustomerDetailsService);
		}

		@Bean("jwtCustomerAuthenticationManager")
		public AuthenticationManager jwtCustomerAuthenticationManager(
				@Qualifier("jwtCustomerDetailsService") UserDetailsService jwtCustomerDetailsService,
				PasswordEncoder passwordEncoder) {
			return providerManager(daoProvider(jwtCustomerDetailsService, passwordEncoder));
		}

		@Bean
		public AuthenticationEntryPoint apiCustomerAuthenticationEntryPoint() {
			return entryPoint("api-customer-realm");
		}

		@Bean
		@Order(6)
		public SecurityFilterChain customerApiFilterChain(HttpSecurity http,
				@Qualifier("jwtCustomerAuthenticationManager") AuthenticationManager jwtCustomerAuthenticationManager,
				AuthenticationTokenFilter authenticationTokenFilter) throws Exception {
			http
					.securityMatcher(API_VERSION + "/auth/**")
					.authenticationManager(jwtCustomerAuthenticationManager)
					.authorizeHttpRequests(requests -> requests
							.requestMatchers(API_VERSION + "/auth/refresh").permitAll()
							.requestMatchers(API_VERSION + "/auth/login").permitAll()
							.requestMatchers(API_VERSION + "/auth/register").permitAll()
							.requestMatchers(HttpMethod.OPTIONS, API_VERSION + "/auth/**").permitAll()
							.requestMatchers(API_VERSION + "/auth/**").hasRole("AUTH_CUSTOMER")
							.anyRequest().authenticated())
					.httpBasic(basic -> basic
							.authenticationEntryPoint(apiCustomerAuthenticationEntryPoint()))
					.csrf(csrf -> csrf.disable())
					.addFilterAfter(authenticationTokenFilter, BasicAuthenticationFilter.class);
			return http.build();
		}
	}

}
