/*
======================================================================
Quality Checks
======================================================================

Script Purpose:
	This script performs various quality checks for data consistency,
	accuracy and standradization across the 'silver' schemas.
	It includes checks for:
	- NULL or duplicate primary keys.
	- Unwanted spaces in string fields.
	- Data standardization and consistency.
	- Invalid date ranges and orders.
	- Data consistency between related fields.

Usage Notes
	- Run this checks after data loading silver layer.
	- Investigate and resolve any discrepancies found during the checks.

========================================================================
*/


-- ====================================================================
-- Checking 'crm_cust_info'
-- ====================================================================

-- Check for NULLs or duplicates in primary key
SELECT
	cst_id,
	COUNT(*) AS num_of_occurence
FROM
	silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL


-- Check for unwanted spaces
SELECT
	cst_firstname
FROM
	silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT
	cst_lastname
FROM
	silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


-- Data Standardization & Consistency
SELECT DISTINCT
	cst_gndr
FROM
	silver.crm_cust_info

SELECT DISTINCT
	cst_marital_status
FROM
	silver.crm_cust_info


-- ====================================================================
-- Checking 'crm_prd_info'
-- ====================================================================

-- Check for NULLs or duplicates in primary key
SELECT
	prd_id,
	COUNT(*) AS num_of_occurence
FROM
	silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


-- Check for unwanted spaces
SELECT
	prd_nm
FROM
	silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)


-- Check for NULLS or negative numbers
SELECT
	prd_cost
FROM
	silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


-- Data Standardization & Consistency - handlind abbreviations like 'M' in gender we make it more understandable converting it to 'Male'
SELECT DISTINCT
	prd_line
FROM
	silver.crm_prd_info

-- Check for invalid date orders
SELECT
	*
FROM
	silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT
	*
FROM
	silver.crm_prd_info

-- ====================================================================
-- Checking 'crm_sales_details'
-- ====================================================================

-- Check for NULLs or duplicates in primary key
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM
	silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)
	OR sls_ord_num != TRIM(sls_ord_num)


-- Check for invalid dates (negative/zero/out of boundry), we cant cast negative or zero values into date
SELECT
	NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM
	silver.crm_sales_details
WHERE sls_order_dt <= 0
	OR LEN(sls_order_dt) != 8
	OR sls_order_dt < 19000101
	OR sls_order_dt > 20500101


-- Check for invalid dates (negative/zero/out of boundry), we cant cast negative or zero values into date
SELECT
	sls_ship_dt
FROM
	silver.crm_sales_details
WHERE LEN(sls_ship_dt) != 10


SELECT
	*
FROM
	silver.crm_sales_details
WHERE sls_order_dt > sls_due_dt
	OR sls_order_dt > sls_ship_dt


-- Check data consistency: Sales, Quantity, and Price.
-- >> Sales = Quantity * Price.
-- >> NULLS, Negative values or Zero are forbidden.

SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM
	silver.crm_sales_details
WHERE sls_sales != (sls_quantity * sls_price)
	OR sls_sales IS NULL
	OR sls_quantity IS NULL
	OR sls_price IS NULL
	OR sls_sales <= 0
	OR sls_quantity <= 0
	OR sls_price <= 0


-- ====================================================================
-- Checking 'erp_cust_az12'
-- ====================================================================

-- Check if there are primary keys that we cannot connect to crm_cust_info
SELECT
	*
FROM
	silver.erp_cust_az12
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)


-- Check if birthdate is passing the current date and replace it with a NULL
SELECT
	bdate
FROM
	silver.erp_cust_az12
WHERE bdate > GETDATE()


-- Check for missing or wrong values
SELECT
	gen
FROM
	silver.erp_cust_az12
GROUP BY gen

-- ====================================================================
-- Checking 'erp_loc_a101'
-- ====================================================================

-- Check Primary Key quality
SELECT
	cid
FROM
	silver.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)


-- Check countries consistency
SELECT DISTINCT
	cntry
FROM
	silver.erp_loc_a101

-- ====================================================================
-- Checking 'erp_px_cat_g1v2'
-- ====================================================================

-- Check for unwanted spaces
SELECT
	*
FROM
	silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)


-- Check for category consistency
SELECT DISTINCT
	cat
FROM
	silver.erp_px_cat_g1v2


-- Check for subcategory consistency
SELECT DISTINCT
	subcat
FROM
	silver.erp_px_cat_g1v2


-- Check for maintenance consistency
SELECT DISTINCT
	maintenance
FROM
	silver.erp_px_cat_g1v2
