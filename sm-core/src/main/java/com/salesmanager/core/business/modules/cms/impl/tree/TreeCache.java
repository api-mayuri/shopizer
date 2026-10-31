package com.salesmanager.core.business.modules.cms.impl.tree;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * File system backed tree used by the default ("infinispan") CMS modules.
 *
 * Replaces Infinispan TreeCache: the infinispan-tree module does not exist after Infinispan 9.4, and
 * Infinispan 9.4 cannot run on Java 24+ (it relies on {@code Subject.getSubject}, removed with the Security Manager).
 * Data is kept under {@code <location>/<name>/}: one directory per node, one file per key.
 *
 * @param <K> key type
 * @param <V> value type
 */
public class TreeCache<K, V> {

	private final Node<K, V> root;

	public TreeCache(Path directory) {
		try {
			Files.createDirectories(directory);
		} catch (IOException e) {
			throw new UncheckedIOException("Cannot create CMS store " + directory, e);
		}
		this.root = new Node<>(directory);
	}

	public Node<K, V> getRoot() {
		return root;
	}
}
