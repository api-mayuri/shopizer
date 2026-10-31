package com.salesmanager.core.business.modules.cms.impl;

import com.salesmanager.core.business.modules.cms.impl.tree.TreeCache;

public interface CacheManager extends CMSManager {

  @SuppressWarnings("rawtypes")
  TreeCache getTreeCache();

  /** Releases resources of the store (nothing to release for the file system store). */
  default void stop() {
  }

}
