/*
=========================================================
Create Database and Schemas
=========================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse'.

    If the database already exists, it will be dropped and
    recreated. The script also creates three schemas for
    organizing data according to the Medallion Architecture:

        - bronze : Raw source data
        - silver : Cleaned and transformed data
        - gold   : Business-ready data

Warning:
    Running this script will permanently delete the
    existing 'DataWarehouse' database and all its contents.

    Make sure you have a backup before executing.
=========================================================
*/

-- Drop and recreate the DataWarehouse database
DROP DATABASE IF EXISTS DataWarehouse;

CREATE DATABASE DataWarehouse;

-- Select the database
USE DataWarehouse;

-- Create schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

-- Verify creation
SHOW DATABASES;
