package com.salesmanager.core.business.modules.cms.impl.tree;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * A node of the file system backed CMS tree: a node is a directory, each data key is a file of that directory.
 * Drop-in replacement for the subset of {@code org.infinispan.tree.Node} used by the CMS modules
 * (values are {@code byte[]}).
 *
 * Child names and keys are URL-encoded on disk, so a key can never escape the node directory.
 *
 * @param <K> key type (always String in Shopizer)
 * @param <V> value type (always byte[] in Shopizer)
 */
public class Node<K, V> {

	private static final String CHILD_PREFIX = "node_";
	private static final String KEY_PREFIX = "key_";

	private final Path directory;

	Node(Path directory) {
		this.directory = directory;
	}

	private static String encode(String name) {
		return URLEncoder.encode(name, StandardCharsets.UTF_8);
	}

	private static String decode(String name) {
		return URLDecoder.decode(name, StandardCharsets.UTF_8);
	}

	private Path childPath(Fqn fqn) {
		Path path = directory;
		for (String element : fqn.getElements()) {
			path = path.resolve(CHILD_PREFIX + encode(element));
		}
		return path;
	}

	private Path keyPath(Object key) {
		return directory.resolve(KEY_PREFIX + encode(String.valueOf(key)));
	}

	/** @return the child node, or null when it does not exist */
	public Node<K, V> getChild(Fqn fqn) {
		Path path = childPath(fqn);
		return Files.isDirectory(path) ? new Node<>(path) : null;
	}

	/** Creates the child node (and intermediate nodes) when needed. */
	public Node<K, V> addChild(Fqn fqn) {
		Path path = childPath(fqn);
		try {
			Files.createDirectories(path);
		} catch (IOException e) {
			throw new UncheckedIOException("Cannot create CMS node " + path, e);
		}
		return new Node<>(path);
	}

	public Set<Node<K, V>> getChildren() {
		Set<Node<K, V>> children = new LinkedHashSet<>();
		try (DirectoryStream<Path> stream = Files.newDirectoryStream(directory, CHILD_PREFIX + "*")) {
			for (Path path : stream) {
				if (Files.isDirectory(path)) {
					children.add(new Node<>(path));
				}
			}
		} catch (IOException e) {
			throw new UncheckedIOException("Cannot list CMS node " + directory, e);
		}
		return children;
	}

	@SuppressWarnings("unchecked")
	public Set<K> getKeys() {
		Set<K> keys = new LinkedHashSet<>();
		try (DirectoryStream<Path> stream = Files.newDirectoryStream(directory, KEY_PREFIX + "*")) {
			for (Path path : stream) {
				if (Files.isRegularFile(path)) {
					keys.add((K) decode(path.getFileName().toString().substring(KEY_PREFIX.length())));
				}
			}
		} catch (IOException e) {
			throw new UncheckedIOException("Cannot list CMS node " + directory, e);
		}
		return keys;
	}

	@SuppressWarnings("unchecked")
	public V get(K key) {
		Path path = keyPath(key);
		if (!Files.isRegularFile(path)) {
			return null;
		}
		try {
			return (V) Files.readAllBytes(path);
		} catch (IOException e) {
			throw new UncheckedIOException("Cannot read CMS entry " + path, e);
		}
	}

	public V put(K key, V value) {
		if (!(value instanceof byte[])) {
			throw new IllegalArgumentException("CMS values must be byte[]");
		}
		V previous = get(key);
		Path path = keyPath(key);
		try {
			Files.createDirectories(directory);
			Path tmp = Files.createTempFile(directory, ".tmp", null);
			Files.write(tmp, (byte[]) value);
			Files.move(tmp, path, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.ATOMIC_MOVE);
		} catch (IOException e) {
			throw new UncheckedIOException("Cannot write CMS entry " + path, e);
		}
		return previous;
	}

	/** Removes a data key of this node (child nodes are not affected, as with Infinispan). */
	public V remove(K key) {
		V previous = get(key);
		try {
			Files.deleteIfExists(keyPath(key));
		} catch (IOException e) {
			throw new UncheckedIOException("Cannot remove CMS entry " + keyPath(key), e);
		}
		return previous;
	}

	@Override
	public boolean equals(Object o) {
		return o instanceof Node && ((Node<?, ?>) o).directory.equals(directory);
	}

	@Override
	public int hashCode() {
		return directory.hashCode();
	}
}
