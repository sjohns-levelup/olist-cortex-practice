-- ============================================================
-- OLIST_DB.RAW - Load Tables
-- ============================================================

USE WAREHOUSE OLIST_WH;

-- File format for all Olist CSVs
CREATE OR REPLACE FILE FORMAT OLIST_DB.RAW.OLIST_CSV_FORMAT
    TYPE                = CSV
    FIELD_DELIMITER     = ','
    RECORD_DELIMITER    = '\n'
    SKIP_HEADER         = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF             = ('NULL', 'null', '')
    EMPTY_FIELD_AS_NULL = TRUE
    TRIM_SPACE          = TRUE;

-- CUSTOMERS
COPY INTO OLIST_DB.RAW.CUSTOMERS
    FROM @OLIST_DB.RAW.OLIST_STAGE/olist_customers_dataset.csv
    FILE_FORMAT = (FORMAT_NAME = 'OLIST_DB.RAW.OLIST_CSV_FORMAT')
    ON_ERROR = 'ABORT_STATEMENT';

-- SELLERS
COPY INTO OLIST_DB.RAW.SELLERS
    FROM @OLIST_DB.RAW.OLIST_STAGE/olist_sellers_dataset.csv
    FILE_FORMAT = (FORMAT_NAME = 'OLIST_DB.RAW.OLIST_CSV_FORMAT')
    ON_ERROR = 'ABORT_STATEMENT';

-- PRODUCTS
COPY INTO OLIST_DB.RAW.PRODUCTS
    FROM @OLIST_DB.RAW.OLIST_STAGE/olist_products_dataset.csv
    FILE_FORMAT = (FORMAT_NAME = 'OLIST_DB.RAW.OLIST_CSV_FORMAT')
    ON_ERROR = 'ABORT_STATEMENT';

-- CATEGORY_TRANSLATION
COPY INTO OLIST_DB.RAW.CATEGORY_TRANSLATION
    FROM @OLIST_DB.RAW.OLIST_STAGE/product_category_name_translation.csv
    FILE_FORMAT = (FORMAT_NAME = 'OLIST_DB.RAW.OLIST_CSV_FORMAT')
    ON_ERROR = 'ABORT_STATEMENT';

-- GEOLOCATION
COPY INTO OLIST_DB.RAW.GEOLOCATION
    FROM @OLIST_DB.RAW.OLIST_STAGE/olist_geolocation_dataset.csv
    FILE_FORMAT = (FORMAT_NAME = 'OLIST_DB.RAW.OLIST_CSV_FORMAT')
    ON_ERROR = 'ABORT_STATEMENT';

-- ORDERS
COPY INTO OLIST_DB.RAW.ORDERS
    FROM @OLIST_DB.RAW.OLIST_STAGE/olist_orders_dataset.csv
    FILE_FORMAT = (FORMAT_NAME = 'OLIST_DB.RAW.OLIST_CSV_FORMAT')
    ON_ERROR = 'ABORT_STATEMENT';

-- ORDER_ITEMS
COPY INTO OLIST_DB.RAW.ORDER_ITEMS
    FROM @OLIST_DB.RAW.OLIST_STAGE/olist_order_items_dataset.csv
    FILE_FORMAT = (FORMAT_NAME = 'OLIST_DB.RAW.OLIST_CSV_FORMAT')
    ON_ERROR = 'ABORT_STATEMENT';

-- ORDER_PAYMENTS
COPY INTO OLIST_DB.RAW.ORDER_PAYMENTS


-- ============================================================
-- Load Validation
-- ============================================================

-- 1. Row counts -- all tables should have > 0 rows
SELECT 'CUSTOMERS'          AS table_name, COUNT(*) AS row_count FROM OLIST_DB.RAW.CUSTOMERS
UNION ALL
SELECT 'SELLERS',           COUNT(*) FROM OLIST_DB.RAW.SELLERS
UNION ALL
SELECT 'PRODUCTS',          COUNT(*) FROM OLIST_DB.RAW.PRODUCTS
UNION ALL
SELECT 'CATEGORY_TRANSLATION', COUNT(*) FROM OLIST_DB.RAW.CATEGORY_TRANSLATION
UNION ALL
SELECT 'GEOLOCATION',       COUNT(*) FROM OLIST_DB.RAW.GEOLOCATION
UNION ALL
SELECT 'ORDERS',            COUNT(*) FROM OLIST_DB.RAW.ORDERS
UNION ALL
SELECT 'ORDER_ITEMS',       COUNT(*) FROM OLIST_DB.RAW.ORDER_ITEMS
UNION ALL
SELECT 'ORDER_PAYMENTS',    COUNT(*) FROM OLIST_DB.RAW.ORDER_PAYMENTS
UNION ALL
SELECT 'ORDER_REVIEWS',     COUNT(*) FROM OLIST_DB.RAW.ORDER_REVIEWS
ORDER BY table_name;

-- 2. Referential integrity -- order_items should only reference valid orders
SELECT 'ORDER_ITEMS orphaned orders' AS check_name, COUNT(*) AS failures
FROM OLIST_DB.RAW.ORDER_ITEMS oi
LEFT JOIN OLIST_DB.RAW.ORDERS o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 3. Referential integrity -- orders should only reference valid customers
SELECT 'ORDERS orphaned customers' AS check_name, COUNT(*) AS failures
FROM OLIST_DB.RAW.ORDERS o
LEFT JOIN OLIST_DB.RAW.CUSTOMERS c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 4. Null check on critical keys
SELECT 'ORDERS null order_id' AS check_name, COUNT(*) AS failures
FROM OLIST_DB.RAW.ORDERS WHERE order_id IS NULL
UNION ALL
SELECT 'ORDER_ITEMS null order_id', COUNT(*)
FROM OLIST_DB.RAW.ORDER_ITEMS WHERE order_id IS NULL
UNION ALL
SELECT 'CUSTOMERS null customer_id', COUNT(*)
FROM OLIST_DB.RAW.CUSTOMERS WHERE customer_id IS NULL;

-- 5. Sanity check on value ranges
SELECT
    MIN(price)          AS min_price,
    MAX(price)          AS max_price,
    MIN(freight_value)  AS min_freight,
    MAX(freight_value)  AS max_freight
FROM OLIST_DB.RAW.ORDER_ITEMS;

-- 6. Order status distribution -- should see a mix of statuses
SELECT order_status, COUNT(*) AS count
FROM OLIST_DB.RAW.ORDERS
GROUP BY order_status
ORDER BY count DESC;



