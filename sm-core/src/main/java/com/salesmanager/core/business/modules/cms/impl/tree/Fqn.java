package com.salesmanager.core.business.modules.cms.impl.tree;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Fully qualified name of a node in the CMS tree, e.g. {@code DEFAULT/product/123}.
 * Drop-in replacement for the subset of {@code org.infinispan.tree.Fqn} used by the CMS modules.
 */
public final class Fqn {

	private final List<String> elements;

	private Fqn(List<String> elements) {
		this.elements = Collections.unmodifiableList(elements);
	}

	public static Fqn fromString(String path) {
		List<String> elements = new ArrayList<>();
		if (path != null) {
			for (String element : path.split("/")) {
				if (!element.isEmpty()) {
					elements.add(element);
				}
			}
		}
		return new Fqn(elements);
	}

	public List<String> getElements() {
		return elements;
	}

	@Override
	public String toString() {
		return "/" + String.join("/", elements);
	}
}
