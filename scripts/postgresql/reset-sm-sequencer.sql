-- Run once after importing existing data (e.g. from MySQL with pgloader) into the PostgreSQL schema.
--
-- Hibernate 6 @TableGenerator (table SM_SEQUENCER) stores the upper bound of the next id block.
-- Hibernate 5 (hibernate.id.new_generator_mappings=false) used a different algorithm, so imported values
-- must be recomputed: seq_count = max(id) + allocationSize + 1 for every generator.
-- Generated from the @TableGenerator annotations of sm-core-model (see docs/DECISIONS.md, D-25 / D-33).


INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CATALOG_ENT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(id) AS m FROM salesmanager.catalog_entry) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CATALOG_SEQ_NEXT_VAL', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(id) AS m FROM salesmanager.catalog) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CATEGORY_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(category_id) AS m FROM salesmanager.category) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CONTENT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(content_id) AS m FROM salesmanager.content) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'COUNTRY_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(country_id) AS m FROM salesmanager.country) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CURRENCY_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(currency_id) AS m FROM salesmanager.currency) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CUSTOMER_OPTION_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(customer_option_id) AS m FROM salesmanager.customer_option) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CUSTOMER_OPT_VAL_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(customer_option_value_id) AS m FROM salesmanager.customer_option_value) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CUSTOMER_REVIEW_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(customer_review_id) AS m FROM salesmanager.customer_review) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CUSTOMER_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(customer_id) AS m FROM salesmanager.customer) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CUST_ATTR_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(customer_attribute_id) AS m FROM salesmanager.customer_attribute) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CUST_OPTSET_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(customer_optionset_id) AS m FROM salesmanager.customer_option_set) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'CUST_OPT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(customer_optin_id) AS m FROM salesmanager.customer_optin) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'FILE_HISTORY_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(file_history_id) AS m FROM salesmanager.file_history) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'GEOZONE_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(geozone_id) AS m FROM salesmanager.geozone) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'GROUP_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(group_id) AS m FROM salesmanager.sm_group) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'LANG_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(language_id) AS m FROM salesmanager.language) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'MANUFACT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(manufacturer_id) AS m FROM salesmanager.manufacturer) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'MERCH_CONF_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(merchant_config_id) AS m FROM salesmanager.merchant_configuration) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'MOD_CONF_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(module_conf_id) AS m FROM salesmanager.module_configuration) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'MR_LOG_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(merchant_log_id) AS m FROM salesmanager.merchant_log) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'OPTIN_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(optin_id) AS m FROM salesmanager.optin) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDERACCOUNTPRODUCT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_account_product_id) AS m FROM salesmanager.order_account_product) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDER_ACCOUNT_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_account_id) AS m FROM salesmanager.order_account) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDER_ATTR_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_attribute_id) AS m FROM salesmanager.order_attribute) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDER_ID_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_id) AS m FROM salesmanager.orders) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDER_PRD_PRICE_ID_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_product_price_id) AS m FROM salesmanager.order_product_price) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDER_PRODUCT_ATTR_ID_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_product_attribute_id) AS m FROM salesmanager.order_product_attribute) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDER_PRODUCT_DL_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_product_download_id) AS m FROM salesmanager.order_product_download) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDER_PRODUCT_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_product_id) AS m FROM salesmanager.order_product) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ORDER_TOTAL_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_account_id) AS m FROM salesmanager.order_total) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PERMISSION_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(permission_id) AS m FROM salesmanager.permission) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRD_TYPE_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_type_id) AS m FROM salesmanager.product_type) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRD_VAR_IMG_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_var_image_id) AS m FROM salesmanager.product_var_image) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_ATTR_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_attribute_id) AS m FROM salesmanager.product_attribute) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_AVAIL_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_avail_id) AS m FROM salesmanager.product_availability) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_DGT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_digital_id) AS m FROM salesmanager.product_digital) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_IMG_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_image_id) AS m FROM salesmanager.product_image) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_OPTION_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_option_id) AS m FROM salesmanager.product_option) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_OPT_SET_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_option_set_id) AS m FROM salesmanager.product_option_set) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_OPT_VAL_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_option_value_id) AS m FROM salesmanager.product_option_value) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_PRICE_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_price_id) AS m FROM salesmanager.product_price) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_RELATION_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_relationship_id) AS m FROM salesmanager.product_relationship) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_REVIEW_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_review_id) AS m FROM salesmanager.product_review) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_id) AS m FROM salesmanager.product) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_VARIN_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_variation_id) AS m FROM salesmanager.product_variation) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_VAR_GROUP_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_variant_group_id) AS m FROM salesmanager.product_variant_group) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'PRODUCT_VAR_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(product_variant_id) AS m FROM salesmanager.product_variant) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'SHIP_QUOTE_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(shipping_quote_id) AS m FROM salesmanager.shipping_quote) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'SHP_CRT_ATTR_ITM_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(shp_cart_attr_item_id) AS m FROM salesmanager.shopping_cart_attr_item) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'SHP_CRT_ITM_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(shp_cart_item_id) AS m FROM salesmanager.shopping_cart_item) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'SHP_CRT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(shp_cart_id) AS m FROM salesmanager.shopping_cart) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'SHP_ORIG_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(ship_origin_id) AS m FROM salesmanager.shiping_origin) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'STATUS_HIST_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(order_status_history_id) AS m FROM salesmanager.order_status_history) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'STORE_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(merchant_id) AS m FROM salesmanager.merchant_store) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'SYST_CONF_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(system_config_id) AS m FROM salesmanager.system_configuration) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'SYST_NOTIF_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(system_notif_id) AS m FROM salesmanager.system_notification) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'TAX_RATE_ID_NEXT_VALUE', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(tax_rate_id) AS m FROM salesmanager.tax_rate) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'TRANSACT_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(transaction_id) AS m FROM salesmanager.sm_transaction) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'TX_CLASS_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(tax_class_id) AS m FROM salesmanager.tax_class) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'USER_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(user_id) AS m FROM salesmanager.users) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'ZONE_SEQ_NEXT_VAL', coalesce(max(m), 0) + 50 + 1 FROM (SELECT max(zone_id) AS m FROM salesmanager.zone) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'category_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.category_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'content_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.content_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'country_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.country_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'custome_review_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.customer_review_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'customer_option_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.customer_option_desc) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'customer_option_value_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.customer_opt_val_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'geozone_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.geozone_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'manufacturer_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.manufacturer_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'product_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.product_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'product_image_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.product_image_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'product_option_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.product_option_desc) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'product_option_value_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.product_option_value_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'product_price_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.product_price_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'product_review_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.product_review_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'product_type_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.product_type_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'product_var_image_desc_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.product_var_image_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'taxrate_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.tax_rate_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);

INSERT INTO salesmanager.sm_sequencer (seq_name, seq_count)
  SELECT 'zone_description_seq', coalesce(max(m), 0) + 1 + 1 FROM (SELECT max(description_id) AS m FROM salesmanager.zone_description) ids
  ON CONFLICT (seq_name) DO UPDATE SET seq_count = greatest(salesmanager.sm_sequencer.seq_count, excluded.seq_count);
