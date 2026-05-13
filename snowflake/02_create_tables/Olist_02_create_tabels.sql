
-- ============================================================
-- OLIST_DB.RAW - Create Tables
-- Source: Olist Brazilian E-Commerce (Kaggle)
-- Note: product_name_lenght / product_description_lenght are
--       typos in the source data, corrected to _length here
-- ============================================================

USE WAREHOUSE OLIST_WH;

CREATE OR REPLACE TABLE OLIST_DB.RAW.CUSTOMERS (
    customer_id              VARCHAR(50)  NOT NULL,
    customer_unique_id       VARCHAR(50)  NOT NULL,
    customer_zip_code_prefix VARCHAR(10),
    customer_city            VARCHAR(100),
    customer_state           VARCHAR(2)
);

CREATE OR REPLACE TABLE OLIST_DB.RAW.SELLERS (
    seller_id              VARCHAR(50) NOT NULL,
    seller_zip_code_prefix VARCHAR(10),
    seller_city            VARCHAR(100),
    seller_state           VARCHAR(2)
);

CREATE OR REPLACE TABLE OLIST_DB.RAW.PRODUCTS (
    product_id                 VARCHAR(50)  NOT NULL,
    product_category_name      VARCHAR(100),
    product_name_length        NUMBER(6,0),
    product_description_length NUMBER(8,0),
    product_photos_qty         NUMBER(4,0),
    product_weight_g           NUMBER(10,2),
    product_length_cm          NUMBER(8,2),
    product_height_cm          NUMBER(8,2),
    product_width_cm           NUMBER(8,2)
);

CREATE OR REPLACE TABLE OLIST_DB.RAW.CATEGORY_TRANSLATION (
    product_category_name         VARCHAR(100) NOT NULL,
    product_category_name_english VARCHAR(100)
);

CREATE OR REPLACE TABLE OLIST_DB.RAW.GEOLOCATION (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat             FLOAT,
    geolocation_lng             FLOAT,
    geolocation_city            VARCHAR(100),
    geolocation_state           VARCHAR(2)
);

CREATE OR REPLACE TABLE OLIST_DB.RAW.ORDERS (
    order_id                      VARCHAR(50) NOT NULL,
    customer_id                   VARCHAR(50),
    order_status                  VARCHAR(20),
    order_purchase_timestamp      TIMESTAMP_NTZ,
    order_approved_at             TIMESTAMP_NTZ,
    order_delivered_carrier_date  TIMESTAMP_NTZ,
    order_delivered_customer_date TIMESTAMP_NTZ,
    order_estimated_delivery_date TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE OLIST_DB.RAW.ORDER_ITEMS (
    order_id            VARCHAR(50) NOT NULL,
    order_item_id       NUMBER(4,0) NOT NULL,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date TIMESTAMP_NTZ,
    price               NUMBER(10,2),
    freight_value       NUMBER(10,2)
);

CREATE OR REPLACE TABLE OLIST_DB.RAW.ORDER_PAYMENTS (
    order_id             VARCHAR(50) NOT NULL,
    payment_sequential   NUMBER(4,0),
    payment_type         VARCHAR(30),
    payment_installments NUMBER(4,0),
    payment_value        NUMBER(10,2)
);

CREATE OR REPLACE TABLE OLIST_DB.RAW.ORDER_REVIEWS (
    review_id               VARCHAR(50)   NOT NULL,
    order_id                VARCHAR(50),
    review_score            NUMBER(2,0),
    review_comment_title    VARCHAR(100),
    review_comment_message  VARCHAR(5000),
    review_creation_date    TIMESTAMP_NTZ,
    review_answer_timestamp TIMESTAMP_NTZ
);
