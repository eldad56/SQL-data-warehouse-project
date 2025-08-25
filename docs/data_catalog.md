# Data Dictionary for Gold Layer
## Overview
The gold layer is the business-level representation, structured to support analytical and reporting use cases. It consists of **dimension tables**
and **fact tables** for specific business metrics.
***
1. gold.dim_customers
  * **Purpose:** Stores customer details enriched with demographic and geographic data.
* **Columns:**

| Column Name | Data Type | Descripition |  
|:-----|:---|:-----|
| customer_key | BIGINT | Surrogate key uniquely identifying each customer record in the customer dimension table. |
| customer_id | INT | Unique numerical identifier assigned to each customer. |
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| first_name | NVARCHAR(50) | The customer's first name, as recorded in the system. |
| last_name | NVARCHAR(50) | The customer's last name or family name. |
| country | NVARCHAR(50) | The country of residence for the customer (e.g., 'Australia'). |
| marital_status | NVARCHAR(50) | The marital status of the customer (e.g., 'Married', 'Single'). |
| gender | NVARCHAR(50) | The gender of the customer (e.g., 'Male', 'Female'). |
| birth_date | DATE | Date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1982-05-14). |
| create_date | DATE | The date and time when the customer record was created in the system. |
***

2. gold.dim_products
  * **Purpose:** Provides information about the products and their attributes.
* **Columns:**

| Column Name | Data Type | Descripition |  
|:-----|:---|:-----|
| product_key | BIGINT | Surrogate key uniquely identifying each product record in the product dimension table. |
| product_id | INT | A Unique identifier assigned to the product for internal tracking and referencing. |
| product_number | NVARCHAR(50) | A structured alphanumeric code representing the product, often used for categorization or inventory. |
| product_name | NVARCHAR(50) | Descriptive name of the product, including key details such as type, color and size. |
| category_id | NVARCHAR(50) | A unique identifier for the product's category, linking to it's high-level classification. |
| category | NVARCHAR(50) | The broader classification of the product (e.g., Bikes, Components) to group related items. |
| subcategory | NVARCHAR(50) | A more detailed classification of the product within the category such as product type. |
| maintenance | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g., 'Yes', 'No'). |
| cost | INT | The cost or base price of the product, measured in monetary units. |
| product_line | NVARCHAR(50) | The specific product line or series to which the product belongs (e.g., Road, Mountain). |
| start_date | DATE | The date when the product became available for sale or use. |
***

2. gold.fact_sales
  * **Purpose:** Stores transactional sales data for analytical purposes.
* **Columns:**

| Column Name | Data Type | Descripition |  
|:-----|:---|:-----|
| order_number | NVARCHAR(50) | A unique alphanumeric identifier for each sales order (e.g., 'SO51254'). |
| product_key | BIGINT | Surrogate key linking the order to the product dimension table. |
| customer_key | BIGINT | Surrogate key linking the order to the customer dimension table. |
| order_date | DATE | The date the order was placed. |
| ship_date | DATE | The date the order was shipped to the customer. |
| due_date | DATE | The date the order needs to be delivered to the customer. |
| sales_amount | INT | The sum of quantity * price. |
| quantity | INT | The entire quantity of the product specified in the order. |
| price | INT | The price of a single unit of the product specified in the order. |


