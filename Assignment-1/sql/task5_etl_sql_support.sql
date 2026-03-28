USE CarSalesDW;
GO

/* Task 5: SQL blocks to support SSIS ETL */

/* 1) Load dim_vehicle (Type 1 upsert) */
MERGE dbo.dim_vehicle AS tgt
USING (
    SELECT DISTINCT
        CONCAT(car_make, '|', car_model, '|', car_year) AS vehicle_nk,
        car_make,
        car_model,
        car_year
    FROM stg.stg_sales
) AS src
ON tgt.vehicle_nk = src.vehicle_nk
WHEN MATCHED AND (
    tgt.car_make <> src.car_make OR
    tgt.car_model <> src.car_model OR
    tgt.car_year <> src.car_year
)
THEN UPDATE SET
    tgt.car_make = src.car_make,
    tgt.car_model = src.car_model,
    tgt.car_year = src.car_year,
    tgt.record_update_dtm = SYSUTCDATETIME()
WHEN NOT MATCHED BY TARGET
THEN INSERT (vehicle_nk, car_make, car_model, car_year)
     VALUES (src.vehicle_nk, src.car_make, src.car_model, src.car_year);
GO

/* 2) Load dim_customer (SCD Type 2 for region changes) */
;WITH src AS (
    SELECT customer_name AS customer_nk, customer_name, region
    FROM stg.stg_customer
    GROUP BY customer_name, region
),
current_dim AS (
    SELECT customer_key, customer_nk, customer_name, region
    FROM dbo.dim_customer
    WHERE is_current = 1
)
/* Close existing rows where region changed */
UPDATE d
SET d.effective_to = DATEADD(SECOND, -1, SYSUTCDATETIME()),
    d.is_current = 0,
    d.record_update_dtm = SYSUTCDATETIME()
FROM dbo.dim_customer d
JOIN src s
    ON d.customer_nk = s.customer_nk
WHERE d.is_current = 1
  AND d.region <> s.region;

/* Insert new current rows (new customer OR changed region) */
INSERT INTO dbo.dim_customer (
    customer_nk, customer_name, region,
    effective_from, effective_to, is_current
)
SELECT
    s.customer_nk,
    s.customer_name,
    s.region,
    SYSUTCDATETIME(),
    '9999-12-31',
    1
FROM src s
LEFT JOIN current_dim c
    ON s.customer_nk = c.customer_nk
WHERE c.customer_nk IS NULL
   OR c.region <> s.region;
GO

/* 3) Load fact_sales */
INSERT INTO dbo.fact_sales (
    txn_id,
    date_key,
    vehicle_key,
    customer_key,
    sale_amount,
    commission_amount,
    accm_txn_create_time
)
SELECT
    s.txn_id,
    CONVERT(INT, FORMAT(s.sale_date, 'yyyyMMdd')) AS date_key,
    ISNULL(v.vehicle_key, 0) AS vehicle_key,
    ISNULL(c.customer_key, 0) AS customer_key,
    s.sale_price,
    s.commission_earned,
    SYSUTCDATETIME()
FROM stg.stg_sales s
LEFT JOIN dbo.dim_vehicle v
    ON v.vehicle_nk = CONCAT(s.car_make, '|', s.car_model, '|', s.car_year)
LEFT JOIN dbo.dim_customer c
    ON c.customer_nk = s.customer_name
   AND c.is_current = 1
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.fact_sales f WHERE f.txn_id = s.txn_id
);
GO

/* 4) Validation queries */
SELECT 'dim_date' AS table_name, COUNT(*) AS cnt FROM dbo.dim_date
UNION ALL
SELECT 'dim_vehicle', COUNT(*) FROM dbo.dim_vehicle
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dbo.dim_customer
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM dbo.fact_sales;
GO

SELECT TOP 20 * FROM dbo.fact_sales ORDER BY sales_fact_key DESC;
GO

SELECT
    d.year_number,
    d.month_number,
    v.car_make,
    SUM(f.sale_amount) AS total_sales,
    SUM(f.commission_amount) AS total_commission
FROM dbo.fact_sales f
JOIN dbo.dim_date d ON d.date_key = f.date_key
JOIN dbo.dim_vehicle v ON v.vehicle_key = f.vehicle_key
GROUP BY d.year_number, d.month_number, v.car_make
ORDER BY d.year_number, d.month_number, v.car_make;
GO