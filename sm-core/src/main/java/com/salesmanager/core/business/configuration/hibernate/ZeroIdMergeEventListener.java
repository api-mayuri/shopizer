package com.salesmanager.core.business.configuration.hibernate;

import org.hibernate.HibernateException;
import org.hibernate.event.spi.EventSource;
import org.hibernate.event.spi.MergeContext;
import org.hibernate.event.spi.MergeEvent;
import org.hibernate.event.spi.MergeEventListener;
import org.hibernate.id.Assigned;
import org.hibernate.persister.entity.EntityPersister;
import org.hibernate.proxy.HibernateProxy;

/**
 * Keeps the Hibernate 5 behaviour Shopizer relies on: an entity whose generated identifier is {@code 0}
 * is a new entity.
 *
 * Shopizer DTOs carry {@code id = 0} for new objects, and mappers copy it into the entities. Spring Data
 * then calls {@code merge()} (the id is not null). Hibernate 5 inserted such an entity, Hibernate 6.6+ throws
 * "Row was updated or deleted by another transaction (or unsaved-value mapping was incorrect)".
 * This listener runs before the default merge listener and resets such an identifier to {@code null},
 * so the entity is handled as transient (including cascaded merges).
 */
public class ZeroIdMergeEventListener implements MergeEventListener {

	@Override
	public void onMerge(MergeEvent event) throws HibernateException {
		resetZeroId(event);
	}

	@Override
	public void onMerge(MergeEvent event, MergeContext copiedAlready) throws HibernateException {
		resetZeroId(event);
	}

	private void resetZeroId(MergeEvent event) {
		Object entity = event.getOriginal();
		if (entity == null || entity instanceof HibernateProxy || event.getRequestedId() != null) {
			return;
		}
		EventSource session = event.getSession();
		if (session.getPersistenceContextInternal().isEntryFor(entity)) {
			return; // already managed
		}
		EntityPersister persister = session.getEntityPersister(event.getEntityName(), entity);
		if (persister.getGenerator() instanceof Assigned) {
			return; // application assigned ids are left untouched
		}
		Object id = persister.getIdentifier(entity, session);
		if (id instanceof Number number && number.longValue() == 0L) {
			persister.setIdentifier(entity, null, session);
		}
	}

}
