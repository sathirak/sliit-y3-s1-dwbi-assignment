/* Task 4: Data Warehouse Schema - CarSalesDW */

IF DB_ID('CarSalesDW') IS NULL
BEGIN
    CREATE DATABASE CarSalesDW;
END
GO

USE CarSalesDW;
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'stg')
    EXEC('CREATE SCHEMA stg');
GO

/* =========================
   1) STAGING TABLES
   ========================= */
IF OBJECT_ID('stg.stg_sales','U') IS NOT NULL DROP TABLE stg.stg_sales;
CREATE TABLE stg.stg_sales (
    txn_id              BIGINT IDENTITY(1,1) PRIMARY KEY,
    sale_date           DATE            NOT NULL,
    customer_name       NVARCHAR(200)   NULL,
    car_make            NVARCHAR(100)   NOT NULL,
    car_model           NVARCHAR(100)   NOT NULL,
    car_year            INT             NOT NULL,
    sale_price          DECIMAL(18,2)   NOT NULL,
    commission_earned   DECIMAL(18,2)   NOT NULL,
    source_system       NVARCHAR(50)    NOT NULL DEFAULT 'SQL_SALES_CSV',
    load_dtm            DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

IF OBJECT_ID('stg.stg_customer','U') IS NOT NULL DROP TABLE stg.stg_customer;
CREATE TABLE stg.stg_customer (
    customer_name       NVARCHAR(200)   NOT NULL,
    region              NVARCHAR(100)   NOT NULL,
    source_system       NVARCHAR(50)    NOT NULL DEFAULT 'CSV_CUSTOMER_MASTER',
    load_dtm            DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

/* =========================
   2) DIMENSIONS
   ========================= */
IF OBJECT_ID('dbo.dim_date','U') IS NOT NULL DROP TABLE dbo.dim_date;
CREATE TABLE dbo.dim_date (
    date_key            INT             NOT NULL PRIMARY KEY,    -- yyyymmdd
    full_date           DATE            NOT NULL UNIQUE,
    day_number          TINYINT         NOT NULL,
    month_number        TINYINT         NOT NULL,
    month_name          NVARCHAR(20)    NOT NULL,
    quarter_number      TINYINT         NOT NULL,
    year_number         SMALLINT        NOT NULL,
    week_of_year        TINYINT         NOT NULL
);
GO

IF OBJECT_ID('dbo.dim_vehicle','U') IS NOT NULL DROP TABLE dbo.dim_vehicle;
CREATE TABLE dbo.dim_vehicle (
    vehicle_key         INT IDENTITY(1,1) PRIMARY KEY,
    vehicle_nk          NVARCHAR(250)   NOT NULL UNIQUE, -- make|model|year
    car_make            NVARCHAR(100)   NOT NULL,
    car_model           NVARCHAR(100)   NOT NULL,
    car_year            INT             NOT NULL,
    vehicle_category    NVARCHAR(100)   NOT NULL DEFAULT 'Passenger',
    record_insert_dtm   DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    record_update_dtm   DATETIME2       NULL
);
GO

IF OBJECT_ID('dbo.dim_customer','U') IS NOT NULL DROP TABLE dbo.dim_customer;
CREATE TABLE dbo.dim_customer (
    customer_key        INT IDENTITY(1,1) PRIMARY KEY,
    customer_nk         NVARCHAR(200)   NOT NULL,  -- customer_name
    customer_name       NVARCHAR(200)   NOT NULL,
    region              NVARCHAR(100)   NOT NULL,
    effective_from      DATETIME2       NOT NULL,
    effective_to        DATETIME2       NOT NULL,
    is_current          BIT             NOT NULL,
    record_insert_dtm   DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),
    record_update_dtm   DATETIME2       NULL
);
GO

CREATE INDEX IX_dim_customer_nk_current
ON dbo.dim_customer(customer_nk, is_current);
GO

/* Unknown member rows */
IF NOT EXISTS (SELECT 1 FROM dbo.dim_vehicle WHERE vehicle_key = 0)
BEGIN
    SET IDENTITY_INSERT dbo.dim_vehicle ON;
    INSERT INTO dbo.dim_vehicle (
        vehicle_key, vehicle_nk, car_make, car_model, car_year, vehicle_category
    ) VALUES (
        0, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 0, 'UNKNOWN'
    );
    SET IDENTITY_INSERT dbo.dim_vehicle OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.dim_customer WHERE customer_key = 0)
BEGIN
    SET IDENTITY_INSERT dbo.dim_customer ON;
    INSERT INTO dbo.dim_customer (
        customer_key, customer_nk, customer_name, region,
        effective_from, effective_to, is_current
    ) VALUES (
        0, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN',
        '1900-01-01', '9999-12-31', 1
    );
    SET IDENTITY_INSERT dbo.dim_customer OFF;
END
GO

/* =========================
   3) FACT TABLE
   ========================= */
IF OBJECT_ID('dbo.fact_sales','U') IS NOT NULL DROP TABLE dbo.fact_sales;
CREATE TABLE dbo.fact_sales (
    sales_fact_key              BIGINT IDENTITY(1,1) PRIMARY KEY,
    txn_id                      BIGINT          NOT NULL, -- natural key from stg
    date_key                    INT             NOT NULL,
    vehicle_key                 INT             NOT NULL,
    customer_key                INT             NOT NULL,

    sale_amount                 DECIMAL(18,2)   NOT NULL,
    commission_amount           DECIMAL(18,2)   NOT NULL,

    accm_txn_create_time        DATETIME2       NOT NULL,
    accm_txn_complete_time      DATETIME2       NULL,
    txn_process_time_hours      DECIMAL(18,2)   NULL,

    dw_insert_dtm               DATETIME2       NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT UQ_fact_sales_txn UNIQUE (txn_id),
    CONSTRAINT FK_fact_sales_date FOREIGN KEY (date_key) REFERENCES dbo.dim_date(date_key),
    CONSTRAINT FK_fact_sales_vehicle FOREIGN KEY (vehicle_key) REFERENCES dbo.dim_vehicle(vehicle_key),
    CONSTRAINT FK_fact_sales_customer FOREIGN KEY (customer_key) REFERENCES dbo.dim_customer(customer_key)
);
GO

/* =========================
   4) DATE DIMENSION POPULATION (2022-01-01 to 2026-12-31)
   ========================= */
;WITH d AS (
    SELECT CAST('2022-01-01' AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt) FROM d WHERE dt < '2026-12-31'
)
INSERT INTO dbo.dim_date (
    date_key, full_date, day_number, month_number,
    month_name, quarter_number, year_number, week_of_year
)
SELECT
    CONVERT(INT, FORMAT(dt, 'yyyyMMdd')),
    dt,
    DATEPART(DAY, dt),
    DATEPART(MONTH, dt),
    DATENAME(MONTH, dt),
    DATEPART(QUARTER, dt),
    DATEPART(YEAR, dt),
    DATEPART(ISO_WEEK, dt)
FROM d
OPTION (MAXRECURSION 2000);
GO