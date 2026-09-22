/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================

Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.

    Run this script to re-define the DDL structure of Bronze tables.

===============================================================================
*/


CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
SELECT name
FROM sys.schemas;

-- creating tables ........

CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(10),
    cst_create_date DATE
);
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(100),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales MONEY,
    sls_quantity INT,
    sls_price MONEY
);
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(10)
);
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO

--Loadinng data from csv to database using BULK INSERT--

EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN 
   DECLARE @Start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
   BEGIN TRY 
        SET @batch_start_time = GETDATE();
        PRINT '======================================='
        PRINT 'Loading Bronze Layer';
        PRINT '======================================='

        PRINT '----------------------------------------'
        PRINT 'Loading CRM tables';
        PRINT '----------------------------------------'

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into:bronze.crm_cust_info'
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\SQLData\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );
          SET @end_time = GETDATE();
          PRINT '>> Load Duration :'  + CAST(DATEDIFF (second, @start_time, @end_time) AS VARCHAR)+ 'seconds';
          PRINT '>> -----------';

          
        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into:bronze.crm_prd_info'

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\SQLData\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );
         SET @end_time = GETDATE();
          PRINT '>> Load Duration :'  + CAST(DATEDIFF (second, @start_time, @end_time) AS VARCHAR)+ 'seconds';
          PRINT '>> -----------';

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into:bronze.crm_sales_details'

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\SQLData\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );
         SET @end_time = GETDATE();
          PRINT '>> Load Duration :'  + CAST(DATEDIFF (second, @start_time, @end_time) AS VARCHAR)+ 'seconds';
          PRINT '>> -----------';

        PRINT '----------------------------------------'
        PRINT 'Loading ERP tables';
        PRINT '----------------------------------------'

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into:bronze.erp_cust_az12'

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\SQLData\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );
        SET @end_time = GETDATE();
          PRINT '>> Load Duration :'  + CAST(DATEDIFF (second, @start_time, @end_time) AS VARCHAR)+ 'seconds';
          PRINT '>> -----------';

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into:bronze.erp_loc_a101'

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\SQLData\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );
        SET @end_time = GETDATE();
          PRINT '>> Load Duration :'  + CAST(DATEDIFF (second, @start_time, @end_time) AS VARCHAR)+ 'seconds';
          PRINT '>> -----------';

        SET @start_time = GETDATE();
        PRINT '>> Inserting Data Into:bronze.erp_px_cat_g1v2'

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\SQLData\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n'
        );
         SET @end_time = GETDATE();
          PRINT '>> Load Duration :'  + CAST(DATEDIFF (second, @start_time, @end_time) AS VARCHAR)+ 'seconds';
          PRINT '>> -----------';

          SET @batch_end_time = GETDATE();
          PRINT '======================================='
          PRINT 'Loading Bronze Layer is Completed';
          PRINT '       -Total Load Duration:' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR) + 'seconds';
          PRINT '======================================='

    END TRY
    BEGIN CATCH 
    PRINT '==========================================='
    PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
    PRINT 'Error Message' + ERROR_MESSAGE();
    PRINT 'Error Message' + CAST (ERROR_NUMBER() AS VARCHAR);
    PRINT 'Error Message' + CAST (ERROR_STATE() AS VARCHAR);
    PRINT '==========================================='
  END CATCH 
END
