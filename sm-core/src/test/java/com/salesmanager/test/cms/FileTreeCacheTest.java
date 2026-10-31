package com.salesmanager.test.cms;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Set;
import java.util.stream.Stream;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import com.salesmanager.core.business.modules.cms.impl.tree.Fqn;
import com.salesmanager.core.business.modules.cms.impl.tree.Node;
import com.salesmanager.core.business.modules.cms.impl.tree.TreeCache;

class FileTreeCacheTest {

	@TempDir
	Path dir;

	@Test
	void storesReadsListsAndRemovesEntries() {
		TreeCache<String, Object> cache = new TreeCache<>(dir.resolve("StoreRepository"));
		Fqn fqn = Fqn.fromString("product-merchant/DEFAULT/SKU1");

		assertNull(cache.getRoot().getChild(fqn));
		Node<String, Object> node = cache.getRoot().addChild(fqn);
		node.put("image 1.png", new byte[] { 1, 2, 3 });
		node.put("image2.jpg", new byte[] { 4 });

		Node<String, Object> again = cache.getRoot().getChild(fqn);
		assertArrayEquals(new byte[] { 1, 2, 3 }, (byte[]) again.get("image 1.png"));
		assertEquals(Set.of("image 1.png", "image2.jpg"), again.getKeys());
		assertEquals(1, cache.getRoot().getChild(Fqn.fromString("product-merchant/DEFAULT")).getChildren().size());

		again.remove("image2.jpg");
		assertEquals(Set.of("image 1.png"), again.getKeys());
		assertNull(again.get("missing"));
	}

	@Test
	void keysCannotEscapeTheNodeDirectory() throws Exception {
		TreeCache<String, Object> cache = new TreeCache<>(dir.resolve("FilesRepository"));
		Node<String, Object> node = cache.getRoot().addChild(Fqn.fromString("store-merchant/DEFAULT"));
		node.put("../../evil.txt", new byte[] { 9 });

		assertEquals(Set.of("../../evil.txt"), node.getKeys());
		try (Stream<Path> files = Files.walk(dir)) {
			assertTrue(files.filter(Files::isRegularFile).allMatch(p -> p.startsWith(dir.resolve("FilesRepository"))));
		}
		assertTrue(Files.notExists(dir.resolve("evil.txt")));
	}
}
