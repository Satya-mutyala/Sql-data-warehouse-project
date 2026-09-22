/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================

Script Purpose:

    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:

    - Uses the 'BULK INSERT' command to load data from CSV files to bronze tables.

Parameters:

    None.

    This stored procedure does not accept any parameters or return any values.

Usage Example:

    EXEC bronze.load_bronze;

===============================================================================
*/


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
