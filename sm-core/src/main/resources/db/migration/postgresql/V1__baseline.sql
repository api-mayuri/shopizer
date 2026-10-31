-- Shopizer baseline schema for PostgreSQL.
-- Generated from the Hibernate 6 mapping (hbm2ddl=create on PostgreSQL 18), then cleaned:
--   * pg_dump session settings removed, the schema itself is created by Flyway (spring.flyway.create-schemas)
--   * CHECK constraints generated for enum columns removed, so that new enum values do not need a migration
-- Reference data (countries, languages, currencies, default store, admin user...) is inserted by the
-- application at first start (InitializationDatabase), as before.

CREATE TABLE salesmanager.catalog (
    default_catalog boolean,
    merchant_id integer NOT NULL,
    sort_order integer,
    visible boolean,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    id bigint NOT NULL,
    updt_id character varying(60),
    code character varying(100) NOT NULL
);

CREATE TABLE salesmanager.catalog_entry (
    visible boolean,
    catalog_id bigint NOT NULL,
    category_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    id bigint NOT NULL,
    updt_id character varying(60)
);

CREATE TABLE salesmanager.category (
    category_status boolean,
    depth integer,
    featured boolean,
    merchant_id integer NOT NULL,
    sort_order integer,
    visible boolean,
    category_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    parent_id bigint,
    updt_id character varying(60),
    category_image character varying(100),
    code character varying(100) NOT NULL,
    lineage character varying(255)
);

CREATE TABLE salesmanager.category_description (
    language_id integer NOT NULL,
    category_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    meta_title character varying(120),
    name character varying(120) NOT NULL,
    sef_url character varying(120),
    category_highlight character varying(255),
    meta_description character varying(255),
    meta_keywords character varying(255),
    description text
);

CREATE TABLE salesmanager.content (
    link_to_menu boolean,
    merchant_id integer NOT NULL,
    sort_order integer,
    visible boolean,
    content_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    content_position character varying(10),
    content_type character varying(10),
    updt_id character varying(60),
    code character varying(100) NOT NULL,
    product_group character varying(255)
);

CREATE TABLE salesmanager.content_description (
    language_id integer NOT NULL,
    content_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    sef_url character varying(120),
    meta_description character varying(255),
    meta_keywords character varying(255),
    meta_title character varying(255),
    description text
);

CREATE TABLE salesmanager.country (
    country_id integer NOT NULL,
    country_supported boolean,
    geozone_id bigint,
    country_isocode character varying(255) NOT NULL
);

CREATE TABLE salesmanager.country_description (
    country_id integer NOT NULL,
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.currency (
    currency_currency_code character varying(3) NOT NULL,
    currency_supported boolean,
    currency_id bigint NOT NULL,
    currency_code character varying(255),
    currency_name character varying(255)
);

CREATE TABLE salesmanager.customer (
    billing_country_id integer NOT NULL,
    customer_anonymous boolean,
    customer_gender character(1),
    delivery_country_id integer,
    language_id integer NOT NULL,
    merchant_id integer NOT NULL,
    reset_credentials_exp date,
    review_avg numeric(38,2),
    review_count integer,
    billing_zone_id bigint,
    customer_dob timestamp(6) without time zone,
    customer_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    delivery_zone_id bigint,
    billing_postcode character varying(20),
    delivery_postcode character varying(20),
    billing_telephone character varying(32),
    delivery_telephone character varying(32),
    customer_password character varying(60),
    updt_id character varying(60),
    billing_first_name character varying(64) NOT NULL,
    billing_last_name character varying(64) NOT NULL,
    delivery_first_name character varying(64),
    delivery_last_name character varying(64),
    customer_email_address character varying(96) NOT NULL,
    customer_nick character varying(96),
    billing_city character varying(100),
    billing_company character varying(100),
    billing_state character varying(100),
    customer_company character varying(100),
    delivery_city character varying(100),
    delivery_company character varying(100),
    delivery_state character varying(100),
    latitude character varying(100),
    longitude character varying(100),
    billing_street_address character varying(256),
    delivery_street_address character varying(256),
    reset_credentials_req character varying(256),
    provider character varying(255)
);

CREATE TABLE salesmanager.customer_attribute (
    customer_attribute_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    option_id bigint NOT NULL,
    option_value_id bigint NOT NULL,
    customer_attr_txt_val character varying(255)
);

CREATE TABLE salesmanager.customer_group (
    group_id integer NOT NULL,
    customer_id bigint NOT NULL
);

CREATE TABLE salesmanager.customer_opt_val_description (
    language_id integer NOT NULL,
    customer_opt_val_id bigint,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.customer_optin (
    merchant_id integer NOT NULL,
    customer_optin_id bigint NOT NULL,
    optin_date timestamp(6) without time zone,
    optin_id bigint,
    email character varying(255) NOT NULL,
    first character varying(255),
    last character varying(255),
    value text
);

CREATE TABLE salesmanager.customer_option (
    customer_opt_active boolean,
    customer_opt_public boolean,
    merchant_id integer NOT NULL,
    sort_order integer,
    customer_option_id bigint NOT NULL,
    customer_option_type character varying(10),
    customer_opt_code character varying(255)
);

CREATE TABLE salesmanager.customer_option_desc (
    language_id integer NOT NULL,
    customer_option_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    customer_option_comment character varying(4000),
    description text
);

CREATE TABLE salesmanager.customer_option_set (
    sort_order integer,
    customer_optionset_id bigint NOT NULL,
    customer_option_id bigint NOT NULL,
    customer_option_value_id bigint NOT NULL
);

CREATE TABLE salesmanager.customer_option_value (
    merchant_id integer NOT NULL,
    sort_order integer,
    customer_option_value_id bigint NOT NULL,
    customer_opt_val_code character varying(255),
    customer_opt_val_image character varying(255)
);

CREATE TABLE salesmanager.customer_review (
    reviews_rating double precision,
    status integer,
    customers_id bigint,
    customer_review_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    reviewed_customer_id bigint,
    reviews_read bigint,
    review_date timestamp(6) without time zone,
    updt_id character varying(60)
);

CREATE TABLE salesmanager.customer_review_description (
    language_id integer NOT NULL,
    customer_review_id bigint,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.file_history (
    download_count integer NOT NULL,
    filesize integer NOT NULL,
    merchant_id integer NOT NULL,
    accounted_date timestamp(6) without time zone,
    date_added timestamp(6) without time zone NOT NULL,
    date_deleted timestamp(6) without time zone,
    file_history_id bigint NOT NULL,
    file_id bigint
);

CREATE TABLE salesmanager.geozone (
    geozone_id bigint NOT NULL,
    geozone_code character varying(255),
    geozone_name character varying(255)
);

CREATE TABLE salesmanager.geozone_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    geozone_id bigint,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.language (
    language_id integer NOT NULL,
    sort_order integer,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    updt_id character varying(60),
    code character varying(255) NOT NULL
);

CREATE TABLE salesmanager.manufacturer (
    merchant_id integer NOT NULL,
    sort_order integer,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    manufacturer_id bigint NOT NULL,
    updt_id character varying(60),
    code character varying(100) NOT NULL,
    manufacturer_image character varying(255)
);

CREATE TABLE salesmanager.manufacturer_description (
    language_id integer NOT NULL,
    url_clicked integer,
    date_created timestamp(6) without time zone,
    date_last_click timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    manufacturer_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    manufacturers_url character varying(255),
    description text
);

CREATE TABLE salesmanager.merchant_configuration (
    active boolean,
    merchant_id integer,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    merchant_config_id bigint NOT NULL,
    updt_id character varying(60),
    config_key character varying(255),
    type character varying(255),
    value text
);

CREATE TABLE salesmanager.merchant_language (
    languages_language_id integer NOT NULL,
    stores_merchant_id integer NOT NULL
);

CREATE TABLE salesmanager.merchant_log (
    merchant_id integer NOT NULL,
    merchant_log_id bigint NOT NULL,
    module character varying(25),
    log text
);

CREATE TABLE salesmanager.merchant_store (
    country_id integer NOT NULL,
    currency_format_national boolean,
    in_business_since date,
    is_retailer boolean,
    language_id integer NOT NULL,
    merchant_id integer NOT NULL,
    parent_id integer,
    use_cache boolean,
    seizeunitcode character varying(5),
    weightunitcode character varying(5),
    currency_id bigint NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    zone_id bigint,
    store_postal_code character varying(15),
    invoice_template character varying(25),
    store_template character varying(25),
    store_phone character varying(50),
    store_email character varying(60) NOT NULL,
    updt_id character varying(60),
    domain_name character varying(80),
    store_city character varying(100),
    store_code character varying(100) NOT NULL,
    store_logo character varying(100),
    store_name character varying(100) NOT NULL,
    store_state_prov character varying(100),
    continueshoppingurl character varying(150),
    lineage character varying(255),
    store_address character varying(255)
);

CREATE TABLE salesmanager.module_configuration (
    custom_ind boolean,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    module_conf_id bigint NOT NULL,
    updt_id character varying(60),
    configuration character varying(4000),
    code character varying(255) NOT NULL,
    image character varying(255),
    module character varying(255),
    regions character varying(255),
    type character varying(255),
    details text
);

CREATE TABLE salesmanager.optin (
    merchant_id integer,
    end_date timestamp(6) without time zone,
    optin_id bigint NOT NULL,
    start_date timestamp(6) without time zone,
    code character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL
);

CREATE TABLE salesmanager.order_account (
    order_account_bill_day integer NOT NULL,
    order_account_end_date date,
    order_account_start_date date NOT NULL,
    order_account_id bigint NOT NULL,
    order_id bigint NOT NULL
);

CREATE TABLE salesmanager.order_account_product (
    order_account_product_accnt_dt date,
    order_account_product_end_dt date,
    order_account_product_l_trx_st integer NOT NULL,
    order_account_product_pm_fr_ty integer NOT NULL,
    order_account_product_status integer NOT NULL,
    order_account_product_st_dt date NOT NULL,
    order_account_id bigint NOT NULL,
    order_account_product_eot timestamp(6) without time zone,
    order_account_product_id bigint NOT NULL,
    order_account_product_l_st_dt timestamp(6) without time zone,
    order_product_id bigint NOT NULL
);

CREATE TABLE salesmanager.order_attribute (
    order_attribute_id bigint NOT NULL,
    order_id bigint NOT NULL,
    identifier character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);

CREATE TABLE salesmanager.order_product (
    onetime_charge numeric(38,2) NOT NULL,
    product_quantity integer,
    order_id bigint NOT NULL,
    order_product_id bigint NOT NULL,
    product_name character varying(64) NOT NULL,
    product_sku character varying(255)
);

CREATE TABLE salesmanager.order_product_attribute (
    product_attribute_is_free boolean NOT NULL,
    product_attribute_price numeric(15,4) NOT NULL,
    product_attribute_weight numeric(15,4),
    order_product_attribute_id bigint NOT NULL,
    order_product_id bigint NOT NULL,
    product_option_id bigint NOT NULL,
    product_option_value_id bigint NOT NULL,
    product_attribute_name character varying(255),
    product_attribute_val_name character varying(255)
);

CREATE TABLE salesmanager.order_product_download (
    download_count integer NOT NULL,
    download_maxdays integer NOT NULL,
    order_product_download_id bigint NOT NULL,
    order_product_id bigint NOT NULL,
    order_product_filename character varying(255) NOT NULL
);

CREATE TABLE salesmanager.order_product_price (
    default_price boolean NOT NULL,
    product_price numeric(38,2) NOT NULL,
    product_price_special numeric(38,2),
    order_product_id bigint NOT NULL,
    order_product_price_id bigint NOT NULL,
    prd_price_special_end_dt timestamp(6) without time zone,
    prd_price_special_st_dt timestamp(6) without time zone,
    product_price_code character varying(64) NOT NULL,
    product_price_name character varying(255)
);

CREATE TABLE salesmanager.order_status_history (
    customer_notified integer,
    date_added timestamp(6) without time zone NOT NULL,
    order_id bigint NOT NULL,
    order_status_history_id bigint NOT NULL,
    status character varying(255),
    comments text
);

CREATE TABLE salesmanager.order_total (
    sort_order integer NOT NULL,
    value numeric(15,4) NOT NULL,
    order_account_id bigint NOT NULL,
    order_id bigint NOT NULL,
    module character varying(60),
    code character varying(255) NOT NULL,
    order_total_type character varying(255),
    order_value_type character varying(255),
    title character varying(255),
    text text
);

CREATE TABLE salesmanager.orders (
    billing_country_id integer NOT NULL,
    confirmed_address boolean,
    currency_value numeric(38,2),
    customer_agreed boolean,
    date_purchased date,
    delivery_country_id integer,
    merchantid integer,
    order_total numeric(38,2),
    billing_zone_id bigint,
    currency_id bigint,
    customer_id bigint,
    delivery_zone_id bigint,
    last_modified timestamp(6) without time zone,
    order_date_finished timestamp(6) without time zone,
    order_id bigint NOT NULL,
    billing_postcode character varying(20),
    delivery_postcode character varying(20),
    billing_telephone character varying(32),
    delivery_telephone character varying(32),
    customer_email_address character varying(50) NOT NULL,
    billing_first_name character varying(64) NOT NULL,
    billing_last_name character varying(64) NOT NULL,
    delivery_first_name character varying(64),
    delivery_last_name character varying(64),
    billing_city character varying(100),
    billing_company character varying(100),
    billing_state character varying(100),
    delivery_city character varying(100),
    delivery_company character varying(100),
    delivery_state character varying(100),
    latitude character varying(100),
    longitude character varying(100),
    billing_street_address character varying(256),
    delivery_street_address character varying(256),
    card_type character varying(255),
    cart_code character varying(255),
    cc_cvv character varying(255),
    cc_expires character varying(255),
    cc_number character varying(255),
    cc_owner character varying(255),
    channel character varying(255),
    ip_address character varying(255),
    locale character varying(255),
    order_status character varying(255),
    order_type character varying(255),
    payment_module_code character varying(255),
    payment_type character varying(255),
    shipping_module_code character varying(255)
);

CREATE TABLE salesmanager.permission (
    permission_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    updt_id character varying(60),
    permission_name character varying(255)
);

CREATE TABLE salesmanager.permission_group (
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);

CREATE TABLE salesmanager.product (
    available boolean,
    cond smallint,
    merchant_id integer NOT NULL,
    preorder boolean,
    product_free boolean,
    product_height numeric(38,2),
    product_length numeric(38,2),
    product_ship boolean,
    product_virtual boolean,
    product_weight numeric(38,2),
    product_width numeric(38,2),
    quantity_ordered integer,
    rental_duration integer,
    rental_period integer,
    rental_status smallint,
    review_avg numeric(38,2),
    review_count integer,
    sort_order integer,
    customer_id bigint,
    date_available timestamp(6) without time zone,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    manufacturer_id bigint,
    product_id bigint NOT NULL,
    product_type_id bigint,
    tax_class_id bigint,
    updt_id character varying(60),
    ref_sku character varying(255),
    sku character varying(255)
);

CREATE TABLE salesmanager.product_attribute (
    product_atribute_price numeric(38,2),
    product_attribute_default boolean,
    product_attribute_discounted boolean,
    product_attribute_for_disp boolean,
    product_attribute_free boolean,
    product_attribute_required boolean,
    product_attribute_sort_ord integer,
    product_attribute_weight numeric(38,2),
    option_id bigint NOT NULL,
    option_value_id bigint NOT NULL,
    product_attribute_id bigint NOT NULL,
    product_id bigint NOT NULL
);

CREATE TABLE salesmanager.product_availability (
    available boolean,
    date_available date,
    free_shipping boolean,
    height numeric(38,2),
    length numeric(38,2),
    merchant_id integer,
    quantity integer,
    quantity_ord_max integer,
    quantity_ord_min integer,
    status boolean,
    weight numeric(38,2),
    width numeric(38,2),
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    product_avail_id bigint NOT NULL,
    product_id bigint NOT NULL,
    product_variant bigint,
    updt_id character varying(60),
    owner character varying(255),
    region character varying(255),
    region_variant character varying(255),
    sku character varying(255)
);

CREATE TABLE salesmanager.product_category (
    category_id bigint NOT NULL,
    product_id bigint NOT NULL
);

CREATE TABLE salesmanager.product_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    product_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    download_lnk character varying(255),
    meta_description character varying(255),
    meta_keywords character varying(255),
    meta_title character varying(255),
    product_highlight character varying(255),
    sef_url character varying(255),
    description text
);

CREATE TABLE salesmanager.product_digital (
    product_digital_id bigint NOT NULL,
    product_id bigint NOT NULL,
    file_name character varying(255) NOT NULL
);

CREATE TABLE salesmanager.product_image (
    default_image boolean,
    image_crop boolean,
    image_type integer,
    sort_order integer,
    product_id bigint NOT NULL,
    product_image_id bigint NOT NULL,
    product_image character varying(255),
    product_image_url character varying(255)
);

CREATE TABLE salesmanager.product_image_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    product_image_id bigint NOT NULL,
    updt_id character varying(60),
    alt_tag character varying(100),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.product_opt_set_opt_value (
    productoptionset_product_option_set_id bigint CONSTRAINT product_opt_set_opt_value_productoptionset_product_opt_not_null NOT NULL,
    values_product_option_value_id bigint CONSTRAINT product_opt_set_opt_value_values_product_option_value__not_null NOT NULL
);

CREATE TABLE salesmanager.product_opt_set_prd_type (
    productoptionset_product_option_set_id bigint CONSTRAINT product_opt_set_prd_type_productoptionset_product_opti_not_null NOT NULL,
    producttypes_product_type_id bigint NOT NULL
);

CREATE TABLE salesmanager.product_option (
    merchant_id integer NOT NULL,
    product_option_read boolean,
    product_option_sort_ord integer,
    product_option_id bigint NOT NULL,
    product_option_type character varying(10),
    product_option_code character varying(255)
);

CREATE TABLE salesmanager.product_option_desc (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    product_option_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    product_option_comment character varying(4000),
    description text
);

CREATE TABLE salesmanager.product_option_set (
    merchant_id integer NOT NULL,
    product_option_set_disp boolean,
    product_option_id bigint NOT NULL,
    product_option_set_id bigint NOT NULL,
    product_option_set_code character varying(255)
);

CREATE TABLE salesmanager.product_option_value (
    merchant_id integer NOT NULL,
    product_opt_for_disp boolean,
    product_opt_val_sort_ord integer,
    product_option_value_id bigint NOT NULL,
    product_option_val_code character varying(255),
    product_opt_val_image character varying(255)
);

CREATE TABLE salesmanager.product_option_value_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    product_option_value_id bigint,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.product_price (
    default_price boolean,
    product_price_amount numeric(38,2),
    product_price_special_amount numeric(38,2),
    product_price_special_end_date date,
    product_price_special_st_date date,
    product_avail_id bigint NOT NULL,
    product_identifier_id bigint,
    product_price_id bigint NOT NULL,
    product_price_type character varying(20),
    product_price_code character varying(255) NOT NULL
);

CREATE TABLE salesmanager.product_price_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    product_price_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    price_appender character varying(255),
    description text
);

CREATE TABLE salesmanager.product_relationship (
    active boolean,
    merchant_id integer NOT NULL,
    product_id bigint,
    product_relationship_id bigint NOT NULL,
    related_product_id bigint,
    code character varying(255)
);

CREATE TABLE salesmanager.product_review (
    reviews_rating double precision,
    status integer,
    customers_id bigint,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    product_id bigint,
    product_review_id bigint NOT NULL,
    reviews_read bigint,
    review_date timestamp(6) without time zone,
    updt_id character varying(60)
);

CREATE TABLE salesmanager.product_review_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    product_review_id bigint,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.product_type (
    merchant_id integer,
    prd_type_add_to_cart boolean,
    prd_type_visible boolean,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    product_type_id bigint NOT NULL,
    updt_id character varying(60),
    prd_type_code character varying(255)
);

CREATE TABLE salesmanager.product_type_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    product_type_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.product_var_image (
    default_image boolean,
    product_variant_group_id bigint NOT NULL,
    product_var_image_id bigint NOT NULL,
    product_image character varying(255)
);

CREATE TABLE salesmanager.product_var_image_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    product_id bigint NOT NULL,
    product_var_image_id bigint NOT NULL,
    updt_id character varying(60),
    alt_tag character varying(100),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.product_variant (
    available boolean,
    default_selection boolean,
    sort_order integer,
    date_available timestamp(6) without time zone,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    product_id bigint NOT NULL,
    product_variant_group_id bigint,
    product_variant_id bigint NOT NULL,
    product_variation_id bigint,
    product_variation_value_id bigint,
    updt_id character varying(60),
    code character varying(255),
    sku character varying(255)
);

CREATE TABLE salesmanager.product_variant_group (
    merchant_id integer NOT NULL,
    product_variant_group_id bigint NOT NULL
);

CREATE TABLE salesmanager.product_variation (
    merchant_id integer NOT NULL,
    sort_order integer,
    variant_default boolean,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    option_value_id bigint NOT NULL,
    product_option_id bigint NOT NULL,
    product_variation_id bigint NOT NULL,
    updt_id character varying(60),
    code character varying(100) NOT NULL
);

CREATE TABLE salesmanager.shiping_origin (
    active boolean,
    country_id integer,
    merchant_id integer NOT NULL,
    ship_origin_id bigint NOT NULL,
    zone_id bigint,
    postcode character varying(20),
    city character varying(100),
    state character varying(100),
    street_address character varying(256)
);

CREATE TABLE salesmanager.shipping_quote (
    delivery_country_id integer,
    free_shipping boolean,
    quote_handling numeric(38,2),
    quote_price numeric(38,2),
    shipping_number_days integer,
    cart_id bigint,
    customer_id bigint,
    delivery_zone_id bigint,
    option_delivery_date timestamp(6) without time zone,
    option_shipping_date timestamp(6) without time zone,
    order_id bigint,
    quote_date timestamp(6) without time zone,
    shipping_quote_id bigint NOT NULL,
    delivery_postcode character varying(20),
    delivery_telephone character varying(32),
    delivery_first_name character varying(64),
    delivery_last_name character varying(64),
    delivery_city character varying(100),
    delivery_company character varying(100),
    delivery_state character varying(100),
    delivery_street_address character varying(256),
    ip_address character varying(255),
    module character varying(255) NOT NULL,
    option_code character varying(255),
    option_name character varying(255)
);

CREATE TABLE salesmanager.shopping_cart (
    merchant_id integer NOT NULL,
    customer_id bigint,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    order_id bigint,
    promo_added timestamp(6) without time zone,
    shp_cart_id bigint NOT NULL,
    updt_id character varying(60),
    ip_address character varying(255),
    promo_code character varying(255),
    shp_cart_code character varying(255) NOT NULL
);

CREATE TABLE salesmanager.shopping_cart_attr_item (
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    product_attr_id bigint NOT NULL,
    shp_cart_attr_item_id bigint NOT NULL,
    shp_cart_item_id bigint NOT NULL,
    updt_id character varying(60)
);

CREATE TABLE salesmanager.shopping_cart_item (
    quantity integer,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    product_id bigint NOT NULL,
    product_variant bigint,
    shp_cart_id bigint NOT NULL,
    shp_cart_item_id bigint NOT NULL,
    updt_id character varying(60),
    sku character varying(255)
);

CREATE TABLE salesmanager.sm_group (
    group_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    updt_id character varying(60),
    group_name character varying(255),
    group_type character varying(255)
);

CREATE TABLE salesmanager.sm_sequencer (
    seq_count bigint,
    seq_name character varying(255) NOT NULL
);

CREATE TABLE salesmanager.sm_transaction (
    amount numeric(38,2),
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    order_id bigint,
    transaction_date timestamp(6) without time zone,
    transaction_id bigint NOT NULL,
    updt_id character varying(60),
    payment_type character varying(255),
    transaction_type character varying(255),
    details text
);

CREATE TABLE salesmanager.system_configuration (
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    system_config_id bigint NOT NULL,
    updt_id character varying(60),
    config_key character varying(255),
    value character varying(255)
);

CREATE TABLE salesmanager.system_notification (
    end_date date,
    merchant_id integer,
    start_date date,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    system_notif_id bigint NOT NULL,
    user_id bigint,
    updt_id character varying(60),
    config_key character varying(255),
    value character varying(255)
);

CREATE TABLE salesmanager.tax_class (
    merchant_id integer,
    tax_class_id bigint NOT NULL,
    tax_class_code character varying(10) NOT NULL,
    tax_class_title character varying(32) NOT NULL
);

CREATE TABLE salesmanager.tax_rate (
    country_id integer NOT NULL,
    merchant_id integer NOT NULL,
    piggyback boolean,
    tax_priority integer,
    tax_rate numeric(7,4) NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    parent_id bigint,
    tax_class_id bigint NOT NULL,
    tax_rate_id bigint NOT NULL,
    zone_id bigint,
    updt_id character varying(60),
    store_state_prov character varying(100),
    tax_code character varying(255)
);

CREATE TABLE salesmanager.tax_rate_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    tax_rate_id bigint,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

CREATE TABLE salesmanager.user_group (
    group_id integer NOT NULL,
    user_id bigint NOT NULL
);

CREATE TABLE salesmanager.userconnection (
    userrank integer NOT NULL,
    expiretime bigint,
    accesstoken character varying(255),
    displayname character varying(255),
    imageurl character varying(255),
    profileurl character varying(255),
    providerid character varying(255) NOT NULL,
    provideruserid character varying(255) NOT NULL,
    refreshtoken character varying(255),
    secret character varying(255),
    userid character varying(255) NOT NULL
);

CREATE TABLE salesmanager.users (
    active boolean,
    language_id integer,
    merchant_id integer NOT NULL,
    reset_credentials_exp date,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    last_access timestamp(6) without time zone,
    login_access timestamp(6) without time zone,
    user_id bigint NOT NULL,
    admin_password character varying(60),
    updt_id character varying(60),
    admin_name character varying(100),
    reset_credentials_req character varying(256),
    admin_a1 character varying(255),
    admin_a2 character varying(255),
    admin_a3 character varying(255),
    admin_email character varying(255),
    admin_first_name character varying(255),
    admin_last_name character varying(255),
    admin_q1 character varying(255),
    admin_q2 character varying(255),
    admin_q3 character varying(255)
);

CREATE TABLE salesmanager.zone (
    country_id integer NOT NULL,
    zone_id bigint NOT NULL,
    zone_code character varying(255) NOT NULL
);

CREATE TABLE salesmanager.zone_description (
    language_id integer NOT NULL,
    date_created timestamp(6) without time zone,
    date_modified timestamp(6) without time zone,
    description_id bigint NOT NULL,
    zone_id bigint NOT NULL,
    updt_id character varying(60),
    title character varying(100),
    name character varying(120) NOT NULL,
    description text
);

ALTER TABLE ONLY salesmanager.catalog_entry
    ADD CONSTRAINT catalog_entry_category_id_catalog_id_key UNIQUE (category_id, catalog_id);

ALTER TABLE ONLY salesmanager.catalog_entry
    ADD CONSTRAINT catalog_entry_pkey PRIMARY KEY (id);

ALTER TABLE ONLY salesmanager.catalog
    ADD CONSTRAINT catalog_merchant_id_code_key UNIQUE (merchant_id, code);

ALTER TABLE ONLY salesmanager.catalog
    ADD CONSTRAINT catalog_pkey PRIMARY KEY (id);

ALTER TABLE ONLY salesmanager.category_description
    ADD CONSTRAINT category_description_category_id_language_id_key UNIQUE (category_id, language_id);

ALTER TABLE ONLY salesmanager.category_description
    ADD CONSTRAINT category_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.category
    ADD CONSTRAINT category_merchant_id_code_key UNIQUE (merchant_id, code);

ALTER TABLE ONLY salesmanager.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);

ALTER TABLE ONLY salesmanager.content_description
    ADD CONSTRAINT content_description_content_id_language_id_key UNIQUE (content_id, language_id);

ALTER TABLE ONLY salesmanager.content_description
    ADD CONSTRAINT content_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.content
    ADD CONSTRAINT content_merchant_id_code_key UNIQUE (merchant_id, code);

ALTER TABLE ONLY salesmanager.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (content_id);

ALTER TABLE ONLY salesmanager.country
    ADD CONSTRAINT country_country_isocode_key UNIQUE (country_isocode);

ALTER TABLE ONLY salesmanager.country_description
    ADD CONSTRAINT country_description_country_id_language_id_key UNIQUE (country_id, language_id);

ALTER TABLE ONLY salesmanager.country_description
    ADD CONSTRAINT country_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);

ALTER TABLE ONLY salesmanager.currency
    ADD CONSTRAINT currency_currency_code_key UNIQUE (currency_code);

ALTER TABLE ONLY salesmanager.currency
    ADD CONSTRAINT currency_currency_currency_code_key UNIQUE (currency_currency_code);

ALTER TABLE ONLY salesmanager.currency
    ADD CONSTRAINT currency_currency_name_key UNIQUE (currency_name);

ALTER TABLE ONLY salesmanager.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (currency_id);

ALTER TABLE ONLY salesmanager.customer_attribute
    ADD CONSTRAINT customer_attribute_option_id_customer_id_key UNIQUE (option_id, customer_id);

ALTER TABLE ONLY salesmanager.customer_attribute
    ADD CONSTRAINT customer_attribute_pkey PRIMARY KEY (customer_attribute_id);

ALTER TABLE ONLY salesmanager.customer
    ADD CONSTRAINT customer_merchant_id_customer_nick_key UNIQUE (merchant_id, customer_nick);

ALTER TABLE ONLY salesmanager.customer_opt_val_description
    ADD CONSTRAINT customer_opt_val_description_customer_opt_val_id_language_i_key UNIQUE (customer_opt_val_id, language_id);

ALTER TABLE ONLY salesmanager.customer_opt_val_description
    ADD CONSTRAINT customer_opt_val_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.customer_optin
    ADD CONSTRAINT customer_optin_email_optin_id_key UNIQUE (email, optin_id);

ALTER TABLE ONLY salesmanager.customer_optin
    ADD CONSTRAINT customer_optin_pkey PRIMARY KEY (customer_optin_id);

ALTER TABLE ONLY salesmanager.customer_option_desc
    ADD CONSTRAINT customer_option_desc_customer_option_id_language_id_key UNIQUE (customer_option_id, language_id);

ALTER TABLE ONLY salesmanager.customer_option_desc
    ADD CONSTRAINT customer_option_desc_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.customer_option
    ADD CONSTRAINT customer_option_merchant_id_customer_opt_code_key UNIQUE (merchant_id, customer_opt_code);

ALTER TABLE ONLY salesmanager.customer_option
    ADD CONSTRAINT customer_option_pkey PRIMARY KEY (customer_option_id);

ALTER TABLE ONLY salesmanager.customer_option_set
    ADD CONSTRAINT customer_option_set_customer_option_id_customer_option_valu_key UNIQUE (customer_option_id, customer_option_value_id);

ALTER TABLE ONLY salesmanager.customer_option_set
    ADD CONSTRAINT customer_option_set_pkey PRIMARY KEY (customer_optionset_id);

ALTER TABLE ONLY salesmanager.customer_option_value
    ADD CONSTRAINT customer_option_value_merchant_id_customer_opt_val_code_key UNIQUE (merchant_id, customer_opt_val_code);

ALTER TABLE ONLY salesmanager.customer_option_value
    ADD CONSTRAINT customer_option_value_pkey PRIMARY KEY (customer_option_value_id);

ALTER TABLE ONLY salesmanager.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);

ALTER TABLE ONLY salesmanager.customer_review
    ADD CONSTRAINT customer_review_customers_id_reviewed_customer_id_key UNIQUE (customers_id, reviewed_customer_id);

ALTER TABLE ONLY salesmanager.customer_review_description
    ADD CONSTRAINT customer_review_description_customer_review_id_language_id_key UNIQUE (customer_review_id, language_id);

ALTER TABLE ONLY salesmanager.customer_review_description
    ADD CONSTRAINT customer_review_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.customer_review
    ADD CONSTRAINT customer_review_pkey PRIMARY KEY (customer_review_id);

ALTER TABLE ONLY salesmanager.customer_review
    ADD CONSTRAINT customer_review_reviewed_customer_id_key UNIQUE (reviewed_customer_id);

ALTER TABLE ONLY salesmanager.file_history
    ADD CONSTRAINT file_history_merchant_id_file_id_key UNIQUE (merchant_id, file_id);

ALTER TABLE ONLY salesmanager.file_history
    ADD CONSTRAINT file_history_pkey PRIMARY KEY (file_history_id);

ALTER TABLE ONLY salesmanager.geozone_description
    ADD CONSTRAINT geozone_description_geozone_id_language_id_key UNIQUE (geozone_id, language_id);

ALTER TABLE ONLY salesmanager.geozone_description
    ADD CONSTRAINT geozone_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.geozone
    ADD CONSTRAINT geozone_pkey PRIMARY KEY (geozone_id);

ALTER TABLE ONLY salesmanager.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (language_id);

ALTER TABLE ONLY salesmanager.manufacturer_description
    ADD CONSTRAINT manufacturer_description_manufacturer_id_language_id_key UNIQUE (manufacturer_id, language_id);

ALTER TABLE ONLY salesmanager.manufacturer_description
    ADD CONSTRAINT manufacturer_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.manufacturer
    ADD CONSTRAINT manufacturer_merchant_id_code_key UNIQUE (merchant_id, code);

ALTER TABLE ONLY salesmanager.manufacturer
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (manufacturer_id);

ALTER TABLE ONLY salesmanager.merchant_configuration
    ADD CONSTRAINT merchant_configuration_merchant_id_config_key_key UNIQUE (merchant_id, config_key);

ALTER TABLE ONLY salesmanager.merchant_configuration
    ADD CONSTRAINT merchant_configuration_pkey PRIMARY KEY (merchant_config_id);

ALTER TABLE ONLY salesmanager.merchant_log
    ADD CONSTRAINT merchant_log_pkey PRIMARY KEY (merchant_log_id);

ALTER TABLE ONLY salesmanager.merchant_store
    ADD CONSTRAINT merchant_store_pkey PRIMARY KEY (merchant_id);

ALTER TABLE ONLY salesmanager.merchant_store
    ADD CONSTRAINT merchant_store_store_code_key UNIQUE (store_code);

ALTER TABLE ONLY salesmanager.module_configuration
    ADD CONSTRAINT module_configuration_pkey PRIMARY KEY (module_conf_id);

ALTER TABLE ONLY salesmanager.optin
    ADD CONSTRAINT optin_merchant_id_code_key UNIQUE (merchant_id, code);

ALTER TABLE ONLY salesmanager.optin
    ADD CONSTRAINT optin_pkey PRIMARY KEY (optin_id);

ALTER TABLE ONLY salesmanager.order_account
    ADD CONSTRAINT order_account_pkey PRIMARY KEY (order_account_id);

ALTER TABLE ONLY salesmanager.order_account_product
    ADD CONSTRAINT order_account_product_pkey PRIMARY KEY (order_account_product_id);

ALTER TABLE ONLY salesmanager.order_attribute
    ADD CONSTRAINT order_attribute_pkey PRIMARY KEY (order_attribute_id);

ALTER TABLE ONLY salesmanager.order_product_attribute
    ADD CONSTRAINT order_product_attribute_pkey PRIMARY KEY (order_product_attribute_id);

ALTER TABLE ONLY salesmanager.order_product_download
    ADD CONSTRAINT order_product_download_pkey PRIMARY KEY (order_product_download_id);

ALTER TABLE ONLY salesmanager.order_product
    ADD CONSTRAINT order_product_pkey PRIMARY KEY (order_product_id);

ALTER TABLE ONLY salesmanager.order_product_price
    ADD CONSTRAINT order_product_price_pkey PRIMARY KEY (order_product_price_id);

ALTER TABLE ONLY salesmanager.order_status_history
    ADD CONSTRAINT order_status_history_pkey PRIMARY KEY (order_status_history_id);

ALTER TABLE ONLY salesmanager.order_total
    ADD CONSTRAINT order_total_pkey PRIMARY KEY (order_account_id);

ALTER TABLE ONLY salesmanager.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);

ALTER TABLE ONLY salesmanager.permission_group
    ADD CONSTRAINT permission_group_pkey PRIMARY KEY (group_id, permission_id);

ALTER TABLE ONLY salesmanager.permission
    ADD CONSTRAINT permission_permission_name_key UNIQUE (permission_name);

ALTER TABLE ONLY salesmanager.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (permission_id);

ALTER TABLE ONLY salesmanager.product_attribute
    ADD CONSTRAINT product_attribute_option_id_option_value_id_product_id_key UNIQUE (option_id, option_value_id, product_id);

ALTER TABLE ONLY salesmanager.product_attribute
    ADD CONSTRAINT product_attribute_pkey PRIMARY KEY (product_attribute_id);

ALTER TABLE ONLY salesmanager.product_availability
    ADD CONSTRAINT product_availability_merchant_id_product_id_product_variant_key UNIQUE (merchant_id, product_id, product_variant, region_variant);

ALTER TABLE ONLY salesmanager.product_availability
    ADD CONSTRAINT product_availability_pkey PRIMARY KEY (product_avail_id);

ALTER TABLE ONLY salesmanager.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (category_id, product_id);

ALTER TABLE ONLY salesmanager.product_description
    ADD CONSTRAINT product_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.product_description
    ADD CONSTRAINT product_description_product_id_language_id_key UNIQUE (product_id, language_id);

ALTER TABLE ONLY salesmanager.product_digital
    ADD CONSTRAINT product_digital_pkey PRIMARY KEY (product_digital_id);

ALTER TABLE ONLY salesmanager.product_digital
    ADD CONSTRAINT product_digital_product_id_file_name_key UNIQUE (product_id, file_name);

ALTER TABLE ONLY salesmanager.product_image_description
    ADD CONSTRAINT product_image_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.product_image_description
    ADD CONSTRAINT product_image_description_product_image_id_language_id_key UNIQUE (product_image_id, language_id);

ALTER TABLE ONLY salesmanager.product_image
    ADD CONSTRAINT product_image_pkey PRIMARY KEY (product_image_id);

ALTER TABLE ONLY salesmanager.product
    ADD CONSTRAINT product_merchant_id_sku_key UNIQUE (merchant_id, sku);

ALTER TABLE ONLY salesmanager.product_opt_set_prd_type
    ADD CONSTRAINT product_opt_set_prd_type_pkey PRIMARY KEY (productoptionset_product_option_set_id, producttypes_product_type_id);

ALTER TABLE ONLY salesmanager.product_option_desc
    ADD CONSTRAINT product_option_desc_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.product_option_desc
    ADD CONSTRAINT product_option_desc_product_option_id_language_id_key UNIQUE (product_option_id, language_id);

ALTER TABLE ONLY salesmanager.product_option
    ADD CONSTRAINT product_option_merchant_id_product_option_code_key UNIQUE (merchant_id, product_option_code);

ALTER TABLE ONLY salesmanager.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (product_option_id);

ALTER TABLE ONLY salesmanager.product_option_set
    ADD CONSTRAINT product_option_set_merchant_id_product_option_set_code_key UNIQUE (merchant_id, product_option_set_code);

ALTER TABLE ONLY salesmanager.product_option_set
    ADD CONSTRAINT product_option_set_pkey PRIMARY KEY (product_option_set_id);

ALTER TABLE ONLY salesmanager.product_option_value_description
    ADD CONSTRAINT product_option_value_descript_product_option_value_id_langu_key UNIQUE (product_option_value_id, language_id);

ALTER TABLE ONLY salesmanager.product_option_value_description
    ADD CONSTRAINT product_option_value_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.product_option_value
    ADD CONSTRAINT product_option_value_merchant_id_product_option_val_code_key UNIQUE (merchant_id, product_option_val_code);

ALTER TABLE ONLY salesmanager.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (product_option_value_id);

ALTER TABLE ONLY salesmanager.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);

ALTER TABLE ONLY salesmanager.product_price_description
    ADD CONSTRAINT product_price_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.product_price_description
    ADD CONSTRAINT product_price_description_product_price_id_language_id_key UNIQUE (product_price_id, language_id);

ALTER TABLE ONLY salesmanager.product_price
    ADD CONSTRAINT product_price_pkey PRIMARY KEY (product_price_id);

ALTER TABLE ONLY salesmanager.product_relationship
    ADD CONSTRAINT product_relationship_pkey PRIMARY KEY (product_relationship_id);

ALTER TABLE ONLY salesmanager.product_review
    ADD CONSTRAINT product_review_customers_id_product_id_key UNIQUE (customers_id, product_id);

ALTER TABLE ONLY salesmanager.product_review_description
    ADD CONSTRAINT product_review_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.product_review_description
    ADD CONSTRAINT product_review_description_product_review_id_language_id_key UNIQUE (product_review_id, language_id);

ALTER TABLE ONLY salesmanager.product_review
    ADD CONSTRAINT product_review_pkey PRIMARY KEY (product_review_id);

ALTER TABLE ONLY salesmanager.product_review
    ADD CONSTRAINT product_review_product_id_key UNIQUE (product_id);

ALTER TABLE ONLY salesmanager.product_type_description
    ADD CONSTRAINT product_type_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.product_type_description
    ADD CONSTRAINT product_type_description_product_type_id_language_id_key UNIQUE (product_type_id, language_id);

ALTER TABLE ONLY salesmanager.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (product_type_id);

ALTER TABLE ONLY salesmanager.product_var_image_description
    ADD CONSTRAINT product_var_image_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.product_var_image_description
    ADD CONSTRAINT product_var_image_description_product_var_image_id_language_key UNIQUE (product_var_image_id, language_id);

ALTER TABLE ONLY salesmanager.product_var_image
    ADD CONSTRAINT product_var_image_pkey PRIMARY KEY (product_var_image_id);

ALTER TABLE ONLY salesmanager.product_variant_group
    ADD CONSTRAINT product_variant_group_pkey PRIMARY KEY (product_variant_group_id);

ALTER TABLE ONLY salesmanager.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (product_variant_id);

ALTER TABLE ONLY salesmanager.product_variant
    ADD CONSTRAINT product_variant_product_id_sku_key UNIQUE (product_id, sku);

ALTER TABLE ONLY salesmanager.product_variation
    ADD CONSTRAINT product_variation_merchant_id_product_option_id_option_valu_key UNIQUE (merchant_id, product_option_id, option_value_id);

ALTER TABLE ONLY salesmanager.product_variation
    ADD CONSTRAINT product_variation_pkey PRIMARY KEY (product_variation_id);

ALTER TABLE ONLY salesmanager.shiping_origin
    ADD CONSTRAINT shiping_origin_pkey PRIMARY KEY (ship_origin_id);

ALTER TABLE ONLY salesmanager.shipping_quote
    ADD CONSTRAINT shipping_quote_pkey PRIMARY KEY (shipping_quote_id);

ALTER TABLE ONLY salesmanager.shopping_cart_attr_item
    ADD CONSTRAINT shopping_cart_attr_item_pkey PRIMARY KEY (shp_cart_attr_item_id);

ALTER TABLE ONLY salesmanager.shopping_cart_item
    ADD CONSTRAINT shopping_cart_item_pkey PRIMARY KEY (shp_cart_item_id);

ALTER TABLE ONLY salesmanager.shopping_cart
    ADD CONSTRAINT shopping_cart_pkey PRIMARY KEY (shp_cart_id);

ALTER TABLE ONLY salesmanager.shopping_cart
    ADD CONSTRAINT shopping_cart_shp_cart_code_key UNIQUE (shp_cart_code);

ALTER TABLE ONLY salesmanager.sm_group
    ADD CONSTRAINT sm_group_group_name_key UNIQUE (group_name);

ALTER TABLE ONLY salesmanager.sm_group
    ADD CONSTRAINT sm_group_pkey PRIMARY KEY (group_id);

ALTER TABLE ONLY salesmanager.sm_sequencer
    ADD CONSTRAINT sm_sequencer_pkey PRIMARY KEY (seq_name);

ALTER TABLE ONLY salesmanager.sm_transaction
    ADD CONSTRAINT sm_transaction_pkey PRIMARY KEY (transaction_id);

ALTER TABLE ONLY salesmanager.system_configuration
    ADD CONSTRAINT system_configuration_pkey PRIMARY KEY (system_config_id);

ALTER TABLE ONLY salesmanager.system_notification
    ADD CONSTRAINT system_notification_merchant_id_config_key_key UNIQUE (merchant_id, config_key);

ALTER TABLE ONLY salesmanager.system_notification
    ADD CONSTRAINT system_notification_pkey PRIMARY KEY (system_notif_id);

ALTER TABLE ONLY salesmanager.tax_class
    ADD CONSTRAINT tax_class_merchant_id_tax_class_code_key UNIQUE (merchant_id, tax_class_code);

ALTER TABLE ONLY salesmanager.tax_class
    ADD CONSTRAINT tax_class_pkey PRIMARY KEY (tax_class_id);

ALTER TABLE ONLY salesmanager.tax_rate_description
    ADD CONSTRAINT tax_rate_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.tax_rate_description
    ADD CONSTRAINT tax_rate_description_tax_rate_id_language_id_key UNIQUE (tax_rate_id, language_id);

ALTER TABLE ONLY salesmanager.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (tax_rate_id);

ALTER TABLE ONLY salesmanager.tax_rate
    ADD CONSTRAINT tax_rate_tax_code_merchant_id_key UNIQUE (tax_code, merchant_id);

ALTER TABLE ONLY salesmanager.tax_rate
    ADD CONSTRAINT tax_rate_zone_id_key UNIQUE (zone_id);

ALTER TABLE ONLY salesmanager.userconnection
    ADD CONSTRAINT userconnection_pkey PRIMARY KEY (providerid, provideruserid, userid);

ALTER TABLE ONLY salesmanager.users
    ADD CONSTRAINT users_merchant_id_admin_name_key UNIQUE (merchant_id, admin_name);

ALTER TABLE ONLY salesmanager.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);

ALTER TABLE ONLY salesmanager.zone_description
    ADD CONSTRAINT zone_description_pkey PRIMARY KEY (description_id);

ALTER TABLE ONLY salesmanager.zone_description
    ADD CONSTRAINT zone_description_zone_id_language_id_key UNIQUE (zone_id, language_id);

ALTER TABLE ONLY salesmanager.zone
    ADD CONSTRAINT zone_pkey PRIMARY KEY (zone_id);

ALTER TABLE ONLY salesmanager.zone
    ADD CONSTRAINT zone_zone_code_key UNIQUE (zone_code);

CREATE INDEX code_idx ON salesmanager.content USING btree (code);

CREATE INDEX code_idx2 ON salesmanager.language USING btree (code);

CREATE INDEX cust_opt_code_idx ON salesmanager.customer_option USING btree (customer_opt_code);

CREATE INDEX cust_opt_val_code_idx ON salesmanager.customer_option_value USING btree (customer_opt_val_code);

CREATE INDEX idx6h8m6ocg2jhu3bfieqa0dupb1 ON salesmanager.product_attribute USING btree (product_id);

CREATE INDEX idx9ngqm1gg8oivkujmhee4wt0ox ON salesmanager.product_variant USING btree (product_id);

CREATE INDEX idxlctdd0gcnad49kass3ntxv54n ON salesmanager.category USING btree (lineage);

CREATE INDEX idxrkmg1f192v53wcxln88wrwgrx ON salesmanager.merchant_store USING btree (lineage);

CREATE INDEX module_configuration_module ON salesmanager.module_configuration USING btree (module);

CREATE INDEX prd_avail_prd_idx ON salesmanager.product_availability USING btree (product_id);

CREATE INDEX prd_avail_store_prd_idx ON salesmanager.product_availability USING btree (product_id, merchant_id);

CREATE INDEX prd_option_code_idx ON salesmanager.product_option USING btree (product_option_code);

CREATE INDEX prd_option_val_code_idx ON salesmanager.product_option_value USING btree (product_option_val_code);

CREATE INDEX product_description_sef_url ON salesmanager.product_description USING btree (sef_url);

CREATE INDEX shp_cart_code_idx ON salesmanager.shopping_cart USING btree (shp_cart_code);

CREATE INDEX shp_cart_customer_idx ON salesmanager.shopping_cart USING btree (customer_id);

CREATE INDEX sm_group_group_type ON salesmanager.sm_group USING btree (group_type);

CREATE INDEX tax_class_code_idx ON salesmanager.tax_class USING btree (tax_class_code);

CREATE INDEX usr_name_idx ON salesmanager.users USING btree (admin_name);

ALTER TABLE ONLY salesmanager.product_option_value_description
    ADD CONSTRAINT fk19mnby7atlt85exlypxdxhacx FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_image_description
    ADD CONSTRAINT fk1dhldo18nj9l2y6qympgucynq FOREIGN KEY (product_image_id) REFERENCES salesmanager.product_image(product_image_id);

ALTER TABLE ONLY salesmanager.product_price
    ADD CONSTRAINT fk1dic7jnnk1qikgvwcrf4dw12r FOREIGN KEY (product_avail_id) REFERENCES salesmanager.product_availability(product_avail_id);

ALTER TABLE ONLY salesmanager.geozone_description
    ADD CONSTRAINT fk1t2hp628edebe5d6co2whbla9 FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.order_total
    ADD CONSTRAINT fk1tfvgk5smm80efdcc8uop4he3 FOREIGN KEY (order_id) REFERENCES salesmanager.orders(order_id);

ALTER TABLE ONLY salesmanager.customer_option_set
    ADD CONSTRAINT fk1y5qtsuabhpwft3dyhqrgmtb4 FOREIGN KEY (customer_option_id) REFERENCES salesmanager.customer_option(customer_option_id);

ALTER TABLE ONLY salesmanager.manufacturer_description
    ADD CONSTRAINT fk20t33wr4tp1kt1uyw7s8a3afl FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.customer_group
    ADD CONSTRAINT fk257h3e27f4ujw08doqtq46hho FOREIGN KEY (customer_id) REFERENCES salesmanager.customer(customer_id);

ALTER TABLE ONLY salesmanager.shopping_cart_item
    ADD CONSTRAINT fk2gbimdwe9uysd5xadnfl0xq83 FOREIGN KEY (shp_cart_id) REFERENCES salesmanager.shopping_cart(shp_cart_id);

ALTER TABLE ONLY salesmanager.merchant_store
    ADD CONSTRAINT fk2gn7vpkd9x832urw7c6jlawnn FOREIGN KEY (country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.file_history
    ADD CONSTRAINT fk2k8h4penkjlbtc23vamwyek2g FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_attribute
    ADD CONSTRAINT fk2st60u9twmvvaowwn88mt3lrx FOREIGN KEY (option_id) REFERENCES salesmanager.product_option(product_option_id);

ALTER TABLE ONLY salesmanager.catalog_entry
    ADD CONSTRAINT fk374wks7em54d0oghju0earttl FOREIGN KEY (category_id) REFERENCES salesmanager.category(category_id);

ALTER TABLE ONLY salesmanager.optin
    ADD CONSTRAINT fk37xvfo4the20avv7f1e1771fh FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.system_notification
    ADD CONSTRAINT fk3dykr9pm9ln1uektuw18blb6m FOREIGN KEY (user_id) REFERENCES salesmanager.users(user_id);

ALTER TABLE ONLY salesmanager.customer
    ADD CONSTRAINT fk3k21jw28bbx043c2mnhevg9w4 FOREIGN KEY (delivery_zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.product_attribute
    ADD CONSTRAINT fk3rleultg9fn2dxruefbb18d5t FOREIGN KEY (option_value_id) REFERENCES salesmanager.product_option_value(product_option_value_id);

ALTER TABLE ONLY salesmanager.product_opt_set_opt_value
    ADD CONSTRAINT fk3u6iyag8x8w9tkt7sqcoibjq6 FOREIGN KEY (productoptionset_product_option_set_id) REFERENCES salesmanager.product_option_set(product_option_set_id);

ALTER TABLE ONLY salesmanager.product_category
    ADD CONSTRAINT fk3xw1sbaa29r534jvedimdd7md FOREIGN KEY (category_id) REFERENCES salesmanager.category(category_id);

ALTER TABLE ONLY salesmanager.product_opt_set_prd_type
    ADD CONSTRAINT fk4655h91s0eiinonako9n4h9ha FOREIGN KEY (productoptionset_product_option_set_id) REFERENCES salesmanager.product_option_set(product_option_set_id);

ALTER TABLE ONLY salesmanager.product_digital
    ADD CONSTRAINT fk47fmb5cg68pws7k26txyl1il6 FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.content_description
    ADD CONSTRAINT fk47yxf681u0rfw2kvarhqb0r3v FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_option_set
    ADD CONSTRAINT fk4njy17416fn86muojmtbav1d0 FOREIGN KEY (product_option_id) REFERENCES salesmanager.product_option(product_option_id);

ALTER TABLE ONLY salesmanager.order_attribute
    ADD CONSTRAINT fk4nw5yrtgb4in6leve76bmdnua FOREIGN KEY (order_id) REFERENCES salesmanager.orders(order_id);

ALTER TABLE ONLY salesmanager.customer_attribute
    ADD CONSTRAINT fk4xugs9yd9w4o3sw11fisb8tj5 FOREIGN KEY (option_id) REFERENCES salesmanager.customer_option(customer_option_id);

ALTER TABLE ONLY salesmanager.users
    ADD CONSTRAINT fk4yb3ho4yxvcjniqg09opbm7ja FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_variation
    ADD CONSTRAINT fk5jr2rc6t2p27nwdo5eqwa7658 FOREIGN KEY (product_option_id) REFERENCES salesmanager.product_option(product_option_id);

ALTER TABLE ONLY salesmanager.order_account_product
    ADD CONSTRAINT fk5kiyyb8ekqi9bfowytww8atcx FOREIGN KEY (order_product_id) REFERENCES salesmanager.order_product(order_product_id);

ALTER TABLE ONLY salesmanager.merchant_store
    ADD CONSTRAINT fk5o24aky9161jyofyxmg0g53vv FOREIGN KEY (zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.customer
    ADD CONSTRAINT fk5pas8t9mknk4kkin55t4v300l FOREIGN KEY (billing_country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.customer_review_description
    ADD CONSTRAINT fk5pkgrlk32uqaxkrbve5mws1hj FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_availability
    ADD CONSTRAINT fk5sbh4dx25pmjcqx958hr9ys8h FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.merchant_store
    ADD CONSTRAINT fk63hlw9wp1k1x3f5tke7t2us7s FOREIGN KEY (currency_id) REFERENCES salesmanager.currency(currency_id);

ALTER TABLE ONLY salesmanager.tax_rate_description
    ADD CONSTRAINT fk65c2lqslk5kx25dpkem2r0vxq FOREIGN KEY (tax_rate_id) REFERENCES salesmanager.tax_rate(tax_rate_id);

ALTER TABLE ONLY salesmanager.zone_description
    ADD CONSTRAINT fk69ybu7r3bgpcq65c77ji1udh3 FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_description
    ADD CONSTRAINT fk6esjdaa6vu2t5vjin788a8og6 FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.shiping_origin
    ADD CONSTRAINT fk6k73f1n18kr7mqp708aiwq047 FOREIGN KEY (zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.customer_opt_val_description
    ADD CONSTRAINT fk6rfssi3qfx4pswicxrfb18c1 FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.tax_rate
    ADD CONSTRAINT fk6wm34jcwoembe1qsmle2wtwnv FOREIGN KEY (country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.user_group
    ADD CONSTRAINT fk75kainrhn4kh8j3sw2xbe7v61 FOREIGN KEY (group_id) REFERENCES salesmanager.sm_group(group_id);

ALTER TABLE ONLY salesmanager.permission_group
    ADD CONSTRAINT fk77ly3khyuu40odly02d351s84 FOREIGN KEY (permission_id) REFERENCES salesmanager.permission(permission_id);

ALTER TABLE ONLY salesmanager.product_price_description
    ADD CONSTRAINT fk7bmbrjr8ar5icwdpt8myj6gei FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.tax_rate
    ADD CONSTRAINT fk7bpa9pbl1gnj5y3xbgs3wc0eg FOREIGN KEY (tax_class_id) REFERENCES salesmanager.tax_class(tax_class_id);

ALTER TABLE ONLY salesmanager.product_review_description
    ADD CONSTRAINT fk7byc5jsf5bm4lk674ac44e50m FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.sm_transaction
    ADD CONSTRAINT fk7j0s1gqh2tue1fyh5nyj5kwkp FOREIGN KEY (order_id) REFERENCES salesmanager.orders(order_id);

ALTER TABLE ONLY salesmanager.order_product_attribute
    ADD CONSTRAINT fk7j86rvwaysbok1nuofrnmhmkx FOREIGN KEY (order_product_id) REFERENCES salesmanager.order_product(order_product_id);

ALTER TABLE ONLY salesmanager.order_account_product
    ADD CONSTRAINT fk7oxc8ygov7vd2ajt185jhiwts FOREIGN KEY (order_account_id) REFERENCES salesmanager.order_account(order_account_id);

ALTER TABLE ONLY salesmanager.customer_review
    ADD CONSTRAINT fk7pmqdk9od2af7cl6alx82fkek FOREIGN KEY (reviewed_customer_id) REFERENCES salesmanager.customer(customer_id);

ALTER TABLE ONLY salesmanager.customer_optin
    ADD CONSTRAINT fk7qym878m07cwvs4foe68lvqjt FOREIGN KEY (optin_id) REFERENCES salesmanager.optin(optin_id);

ALTER TABLE ONLY salesmanager.product_review
    ADD CONSTRAINT fk7tm0jrt0hiugo3ep49t3subou FOREIGN KEY (customers_id) REFERENCES salesmanager.customer(customer_id);

ALTER TABLE ONLY salesmanager.customer
    ADD CONSTRAINT fk8122nrpakxu3umk1od4v0xxoa FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_type_description
    ADD CONSTRAINT fk81q74whco5y9fd51aa330hlc0 FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.tax_class
    ADD CONSTRAINT fk82i8puujghcv7fc82qwsgjg8w FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_variant
    ADD CONSTRAINT fk88qb5xufd31481gt7epc8scau FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.category
    ADD CONSTRAINT fk8a09asq5fcx0a88i4m8nsixy FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_option_set
    ADD CONSTRAINT fk8d5vylmhvmckmframdehgwqau FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_option_desc
    ADD CONSTRAINT fk8fiwk5o1gbn2r2u8529yaf9xt FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_variant
    ADD CONSTRAINT fk8nqskhly5tfk07g0padic9am9 FOREIGN KEY (product_variation_id) REFERENCES salesmanager.product_variation(product_variation_id);

ALTER TABLE ONLY salesmanager.product_opt_set_opt_value
    ADD CONSTRAINT fk9dwatblxwc64a5la3bb7qnwd8 FOREIGN KEY (values_product_option_value_id) REFERENCES salesmanager.product_option_value(product_option_value_id);

ALTER TABLE ONLY salesmanager.customer_attribute
    ADD CONSTRAINT fk9fl7iexvdeeeoch9fh35o5vw4 FOREIGN KEY (option_value_id) REFERENCES salesmanager.customer_option_value(customer_option_value_id);

ALTER TABLE ONLY salesmanager.user_group
    ADD CONSTRAINT fk9op4wv63nonsby8y9myjhtho FOREIGN KEY (user_id) REFERENCES salesmanager.users(user_id);

ALTER TABLE ONLY salesmanager.shipping_quote
    ADD CONSTRAINT fk9vb7tbjl8ivygdiqw883fewx7 FOREIGN KEY (delivery_country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.category_description
    ADD CONSTRAINT fka58u7d0ydfgref1iaux5efyov FOREIGN KEY (category_id) REFERENCES salesmanager.category(category_id);

ALTER TABLE ONLY salesmanager.product_var_image
    ADD CONSTRAINT fka691h70ypyp8liquow7qrg81h FOREIGN KEY (product_variant_group_id) REFERENCES salesmanager.product_variant_group(product_variant_group_id);

ALTER TABLE ONLY salesmanager.product_category
    ADD CONSTRAINT fka7245ly271mb0crlhxwhhppsq FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.orders
    ADD CONSTRAINT fkaodv5ffayq8x50q311o2y8m1 FOREIGN KEY (merchantid) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.customer_review
    ADD CONSTRAINT fkayt6tbxp7d4g1qyg8crw2n73p FOREIGN KEY (customers_id) REFERENCES salesmanager.customer(customer_id);

ALTER TABLE ONLY salesmanager.product
    ADD CONSTRAINT fkb8oqtc3j8sqo0t8xdrne7pg69 FOREIGN KEY (tax_class_id) REFERENCES salesmanager.tax_class(tax_class_id);

ALTER TABLE ONLY salesmanager.product_review
    ADD CONSTRAINT fkbfi8de7kxultg1vevq6jc1hn7 FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.product_price_description
    ADD CONSTRAINT fkbwxw861ipjsct606j3dagdjsf FOREIGN KEY (product_price_id) REFERENCES salesmanager.product_price(product_price_id);

ALTER TABLE ONLY salesmanager.customer
    ADD CONSTRAINT fkbxyooiceli2ko29bupdye6jgn FOREIGN KEY (delivery_country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.customer_option_desc
    ADD CONSTRAINT fkc2yiucjbw0wjha8ww7a01qfeo FOREIGN KEY (customer_option_id) REFERENCES salesmanager.customer_option(customer_option_id);

ALTER TABLE ONLY salesmanager.customer_attribute
    ADD CONSTRAINT fkc3318o13i2bpxkci1bh52we5a FOREIGN KEY (customer_id) REFERENCES salesmanager.customer(customer_id);

ALTER TABLE ONLY salesmanager.customer_option
    ADD CONSTRAINT fkcmqnh0rn2hukdfowean5tdy8k FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.country
    ADD CONSTRAINT fkd2q9e14kh1j6tm1gpbct2xwws FOREIGN KEY (geozone_id) REFERENCES salesmanager.geozone(geozone_id);

ALTER TABLE ONLY salesmanager.customer
    ADD CONSTRAINT fkdgjqmj04qt89gmfloo4ofojcw FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.merchant_store
    ADD CONSTRAINT fkdnemo9tl8tjhkxko83psvkv19 FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product
    ADD CONSTRAINT fkeiirvj8eu40h103fth8es1mt0 FOREIGN KEY (product_type_id) REFERENCES salesmanager.product_type(product_type_id);

ALTER TABLE ONLY salesmanager.country_description
    ADD CONSTRAINT fkersrbjot9p9nfukxfd2l27c7t FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.order_product
    ADD CONSTRAINT fkf0sghmn59s14cxrjtrvkvi5yk FOREIGN KEY (order_id) REFERENCES salesmanager.orders(order_id);

ALTER TABLE ONLY salesmanager.merchant_configuration
    ADD CONSTRAINT fkf9bkgf0ysbp5fo9j69shm0pri FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.content
    ADD CONSTRAINT fkfmoi0fkjbtfty3o8fs94t11r1 FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_relationship
    ADD CONSTRAINT fkfskwtawyt85g9h6761fa69ya5 FOREIGN KEY (related_product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.orders
    ADD CONSTRAINT fkfusivmw6q3gjxnmp47n9s74qi FOREIGN KEY (currency_id) REFERENCES salesmanager.currency(currency_id);

ALTER TABLE ONLY salesmanager.tax_rate
    ADD CONSTRAINT fkfwp6yka2qps9jna473e6c6yc1 FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_image
    ADD CONSTRAINT fkgab836d8rxqg8vv55nm02r65i FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.product_option_desc
    ADD CONSTRAINT fkgjqmfofile4hwv867irsnvuc0 FOREIGN KEY (product_option_id) REFERENCES salesmanager.product_option(product_option_id);

ALTER TABLE ONLY salesmanager.merchant_store
    ADD CONSTRAINT fkgkoele515h76u39b9defibkm9 FOREIGN KEY (parent_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.customer_group
    ADD CONSTRAINT fkgrr5v89l1m9sl2qol62bbctq4 FOREIGN KEY (group_id) REFERENCES salesmanager.sm_group(group_id);

ALTER TABLE ONLY salesmanager.customer_review_description
    ADD CONSTRAINT fkhf88oagf6t62k28afn8uaijc7 FOREIGN KEY (customer_review_id) REFERENCES salesmanager.customer_review(customer_review_id);

ALTER TABLE ONLY salesmanager.product
    ADD CONSTRAINT fkhhoq1nd9e0i4m7rt8gkh7d67h FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.zone
    ADD CONSTRAINT fkhn2c1w3e1twhjg7tiwv7vuk67 FOREIGN KEY (country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.customer_option_value
    ADD CONSTRAINT fkho87ssg5rnvwauj3y690a96g6 FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.manufacturer
    ADD CONSTRAINT fkhswph4nthrqwffjekccudsrt2 FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.customer_opt_val_description
    ADD CONSTRAINT fkhwrs6fyqk6vh11yvcflu42yef FOREIGN KEY (customer_opt_val_id) REFERENCES salesmanager.customer_option_value(customer_option_value_id);

ALTER TABLE ONLY salesmanager.order_account
    ADD CONSTRAINT fki6l5isodh81m5hy8ua06hx73n FOREIGN KEY (order_id) REFERENCES salesmanager.orders(order_id);

ALTER TABLE ONLY salesmanager.product_var_image_description
    ADD CONSTRAINT fkibpkivbdn6wqe92gb40l5hffl FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.product_opt_set_prd_type
    ADD CONSTRAINT fkiem30u1enm0p25i7t53jganf4 FOREIGN KEY (producttypes_product_type_id) REFERENCES salesmanager.product_type(product_type_id);

ALTER TABLE ONLY salesmanager.shipping_quote
    ADD CONSTRAINT fkiioesp0vl6x4om1jeajj4uy1t FOREIGN KEY (delivery_zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.merchant_language
    ADD CONSTRAINT fkiisj0tmoujv6n3iqmytvo39kn FOREIGN KEY (stores_merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_var_image_description
    ADD CONSTRAINT fkinpkcxbxyg8yni5ftcvjlt1sp FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.orders
    ADD CONSTRAINT fkipesu5tupnriahutgle6xu9ed FOREIGN KEY (billing_country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.orders
    ADD CONSTRAINT fkit6ti99mv5uvuxqskhurv3y59 FOREIGN KEY (billing_zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.customer_option_set
    ADD CONSTRAINT fkj9vnvyh6hhhftjbcsymgiodm9 FOREIGN KEY (customer_option_value_id) REFERENCES salesmanager.customer_option_value(customer_option_value_id);

ALTER TABLE ONLY salesmanager.merchant_language
    ADD CONSTRAINT fkjwy0pjijh1qmcoivq50o2jgec FOREIGN KEY (languages_language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.customer_optin
    ADD CONSTRAINT fkk5v94dvhsgibaw89hv4m8o5yw FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.content_description
    ADD CONSTRAINT fkk7fabfxn2flvcofwwpyg5sys FOREIGN KEY (content_id) REFERENCES salesmanager.content(content_id);

ALTER TABLE ONLY salesmanager.country_description
    ADD CONSTRAINT fkkd2sy7q97wr2ahvyiiqc4txji FOREIGN KEY (country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.category_description
    ADD CONSTRAINT fkl4j5boteutpu1p8f67kydpnmd FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_image_description
    ADD CONSTRAINT fklhdnpki4sf98wev0pcj2bvnih FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_description
    ADD CONSTRAINT fkm46yjcu59q79qrokgglwq2ove FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.customer_option_desc
    ADD CONSTRAINT fkm4iu7v9db17wk2a03xqbqdlfa FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_availability
    ADD CONSTRAINT fkm9cb3uvgql005wcsqi906pjhg FOREIGN KEY (product_variant) REFERENCES salesmanager.product_variant(product_variant_id);

ALTER TABLE ONLY salesmanager.tax_rate
    ADD CONSTRAINT fkm9snpf6o1nb4j1t80nas8d1ix FOREIGN KEY (zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.order_status_history
    ADD CONSTRAINT fkmhghgf1xy3o0npsp8xkj6wyvq FOREIGN KEY (order_id) REFERENCES salesmanager.orders(order_id);

ALTER TABLE ONLY salesmanager.product_review_description
    ADD CONSTRAINT fkmjivhigdcxmytndlpjuhf4o25 FOREIGN KEY (product_review_id) REFERENCES salesmanager.product_review(product_review_id);

ALTER TABLE ONLY salesmanager.product_availability
    ADD CONSTRAINT fkmjs1xqdsgji88j5uduj83bntl FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_attribute
    ADD CONSTRAINT fkml3nvemdjya159a7669qt1gjd FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.category
    ADD CONSTRAINT fkn3kekntr7pm8g9v8ask698ato FOREIGN KEY (parent_id) REFERENCES salesmanager.category(category_id);

ALTER TABLE ONLY salesmanager.geozone_description
    ADD CONSTRAINT fkn82te2yb2st4hk2qlhl8ileb9 FOREIGN KEY (geozone_id) REFERENCES salesmanager.geozone(geozone_id);

ALTER TABLE ONLY salesmanager.orders
    ADD CONSTRAINT fkn9uvjl8105fsly4doo8rqnv5b FOREIGN KEY (delivery_zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.product_option_value
    ADD CONSTRAINT fknd3nw0mamlk8bkxo8ad5m85pq FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.order_product_price
    ADD CONSTRAINT fknkukiqxrieonyulercgnh857s FOREIGN KEY (order_product_id) REFERENCES salesmanager.order_product(order_product_id);

ALTER TABLE ONLY salesmanager.orders
    ADD CONSTRAINT fknlx97vjyorunxglhy5bird06c FOREIGN KEY (delivery_country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.product_relationship
    ADD CONSTRAINT fknprvswtbgrm6bjfq3cbdl3qsm FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_var_image_description
    ADD CONSTRAINT fko6dx44u06sx0mlvq15oy2wlnj FOREIGN KEY (product_var_image_id) REFERENCES salesmanager.product_var_image(product_var_image_id);

ALTER TABLE ONLY salesmanager.shiping_origin
    ADD CONSTRAINT fkp0dbwsv3sdsp57ex7j5k9b0oq FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.customer
    ADD CONSTRAINT fkp0xcpa3i2mgdr0kq43xiibx40 FOREIGN KEY (billing_zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.shopping_cart_attr_item
    ADD CONSTRAINT fkp42tpa623hyo9ww69v0ohb3er FOREIGN KEY (shp_cart_item_id) REFERENCES salesmanager.shopping_cart_item(shp_cart_item_id);

ALTER TABLE ONLY salesmanager.product_option
    ADD CONSTRAINT fkp8cski5t5f5m4et4fw0uilcgu FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.shiping_origin
    ADD CONSTRAINT fkpqig59usqvs9h0dw4lm8rv7yy FOREIGN KEY (country_id) REFERENCES salesmanager.country(country_id);

ALTER TABLE ONLY salesmanager.zone_description
    ADD CONSTRAINT fkpv4elin6w3b03756obqvk447f FOREIGN KEY (zone_id) REFERENCES salesmanager.zone(zone_id);

ALTER TABLE ONLY salesmanager.product_type_description
    ADD CONSTRAINT fkpwc89ulk7c9asbp2nfy2t4x2j FOREIGN KEY (product_type_id) REFERENCES salesmanager.product_type(product_type_id);

ALTER TABLE ONLY salesmanager.product_variant_group
    ADD CONSTRAINT fkqkn1or09hw4s03b8n1kdwhcsr FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_variation
    ADD CONSTRAINT fkqlm3c2178neue84l5kx51ovoq FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.catalog_entry
    ADD CONSTRAINT fkqp2j48hb3vodovb8gn2o4gox FOREIGN KEY (catalog_id) REFERENCES salesmanager.catalog(id);

ALTER TABLE ONLY salesmanager.product
    ADD CONSTRAINT fkqtt5f0aht5h7ough5rbkkcb33 FOREIGN KEY (customer_id) REFERENCES salesmanager.customer(customer_id);

ALTER TABLE ONLY salesmanager.product_option_value_description
    ADD CONSTRAINT fkqttc6b79yp2s1hyrhg4thag6s FOREIGN KEY (product_option_value_id) REFERENCES salesmanager.product_option_value(product_option_value_id);

ALTER TABLE ONLY salesmanager.shopping_cart
    ADD CONSTRAINT fkqvghr5rmjefe3lw9mcolk30a0 FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.permission_group
    ADD CONSTRAINT fkr7ylutdgqp1nrlbhjwit6y17g FOREIGN KEY (group_id) REFERENCES salesmanager.sm_group(group_id);

ALTER TABLE ONLY salesmanager.product
    ADD CONSTRAINT fkra5mmrdxn3ci86hod7q1u3vu9 FOREIGN KEY (manufacturer_id) REFERENCES salesmanager.manufacturer(manufacturer_id);

ALTER TABLE ONLY salesmanager.catalog
    ADD CONSTRAINT fkranq0rweb0r6j31j565ak51g8 FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.manufacturer_description
    ADD CONSTRAINT fkre4iys57n5cfbgpg3qqgewtrh FOREIGN KEY (manufacturer_id) REFERENCES salesmanager.manufacturer(manufacturer_id);

ALTER TABLE ONLY salesmanager.product_variant
    ADD CONSTRAINT fks1gvb7qb19cuowmhrhuwo7lcv FOREIGN KEY (product_variant_group_id) REFERENCES salesmanager.product_variant_group(product_variant_group_id);

ALTER TABLE ONLY salesmanager.system_notification
    ADD CONSTRAINT fks6qk7l06e0s6m9n04momedgt7 FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_variant
    ADD CONSTRAINT fksa5ijtdrt6dge0op121ox56a0 FOREIGN KEY (product_variation_value_id) REFERENCES salesmanager.product_variation(product_variation_id);

ALTER TABLE ONLY salesmanager.tax_rate_description
    ADD CONSTRAINT fksicb2ydx42o04pvlnxw2mlx0w FOREIGN KEY (language_id) REFERENCES salesmanager.language(language_id);

ALTER TABLE ONLY salesmanager.product_relationship
    ADD CONSTRAINT fkso3cvinykac5wdwu1tjgfotor FOREIGN KEY (product_id) REFERENCES salesmanager.product(product_id);

ALTER TABLE ONLY salesmanager.order_product_download
    ADD CONSTRAINT fkstrda0eweharld63j8pxa2o2r FOREIGN KEY (order_product_id) REFERENCES salesmanager.order_product(order_product_id);

ALTER TABLE ONLY salesmanager.product_type
    ADD CONSTRAINT fkswkvtaq4om2di6x8cd4m22ofn FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.tax_rate
    ADD CONSTRAINT fkt8isen27i3ioa0tw3bl8qlvdh FOREIGN KEY (parent_id) REFERENCES salesmanager.tax_rate(tax_rate_id);

ALTER TABLE ONLY salesmanager.merchant_log
    ADD CONSTRAINT fkto727b9r68qrtn2vvdqdvd4ic FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.users
    ADD CONSTRAINT fktpio656e5t0cja7kx7p79rkh6 FOREIGN KEY (merchant_id) REFERENCES salesmanager.merchant_store(merchant_id);

ALTER TABLE ONLY salesmanager.product_variation
    ADD CONSTRAINT fky6gamyvrpds502pdcqq4voyg FOREIGN KEY (option_value_id) REFERENCES salesmanager.product_option_value(product_option_value_id);
