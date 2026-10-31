package com.salesmanager.core.business.modules.cms.impl;

import java.nio.file.Paths;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.salesmanager.core.business.modules.cms.impl.tree.TreeCache;

/**
 * Base class of the default CMS stores (product images, static content, downloads).
 * Content is kept on the file system under {@code <location>/<namedCache>/} (see {@link TreeCache}).
 * Previously an Infinispan TreeCache persisted in a single file store at the same location.
 */
public abstract class CacheManagerImpl implements CacheManager {

  private static final Logger LOGGER = LoggerFactory.getLogger(CacheManagerImpl.class);

  protected String location = null;

  @SuppressWarnings("rawtypes")
  private TreeCache treeCache = null;

  protected void init(String namedCache, String locationFolder) {
    try {
      this.location = locationFolder;
      treeCache = new TreeCache<String, Object>(Paths.get(locationFolder, namedCache));
      LOGGER.debug("CMS store {} started in {}", namedCache, locationFolder);
    } catch (Exception e) {
      LOGGER.error("Error while instantiating CMS store " + namedCache, e);
    }
  }

  @SuppressWarnings("rawtypes")
  public TreeCache getTreeCache() {
    return treeCache;
  }

}
