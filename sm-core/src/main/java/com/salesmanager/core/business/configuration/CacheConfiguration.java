package com.salesmanager.core.business.configuration;

import java.net.URISyntaxException;

import javax.cache.Caching;
import javax.cache.spi.CachingProvider;

import org.springframework.cache.Cache;
import org.springframework.cache.jcache.JCacheCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Spring cache backed by Ehcache 3 through JCache (JSR-107).
 * Replaces spring/shopizer-core-ehcache.xml (Ehcache 2, removed from Spring Framework 6).
 * Cache definitions are in spring/ehcache3.xml.
 */
@Configuration
public class CacheConfiguration {

	public static final String EHCACHE_CONFIG = "/spring/ehcache3.xml";
	public static final String EHCACHE_PROVIDER = "org.ehcache.jsr107.EhcacheCachingProvider";
	public static final String OBJECT_CACHE = "com.shopizer.OBJECT_CACHE";

	@Bean(destroyMethod = "close")
	public javax.cache.CacheManager jCacheManager() throws URISyntaxException {
		CachingProvider provider = Caching.getCachingProvider(EHCACHE_PROVIDER);
		return provider.getCacheManager(CacheConfiguration.class.getResource(EHCACHE_CONFIG).toURI(),
				CacheConfiguration.class.getClassLoader());
	}

	@Bean("serviceCacheManager")
	public JCacheCacheManager serviceCacheManager(javax.cache.CacheManager jCacheManager) {
		return new JCacheCacheManager(jCacheManager);
	}

	@Bean("serviceCache")
	public Cache serviceCache(JCacheCacheManager serviceCacheManager) {
		return serviceCacheManager.getCache(OBJECT_CACHE);
	}

}
