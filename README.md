**Ecommerce Sales Data Warehouse**

Ecommerce platforms generate large volumes of transactional data across customers, products, payments, and time periods. Transforming this operational data into a structured analytics environment is essential for enabling reliable reporting and business intelligence.

This project builds an end-to-end modern data warehouse using Snowflake and dbt, transforming raw OLTP ecommerce data into a star schema and business-ready reporting layer. The goal is to create a structured analytics pipeline that supports scalable, secure, and validated sales reporting.

**General Overview of the Dataset**

The dataset consists of transactional ecommerce records including:


    Clients (customers)
    
    Products
    
    Orders
    
    Order-product relationships
    
    Payment methods
    

The raw data was manually uploaded into the RAW.OLTP schema in Snowflake and represents operational ecommerce data.

Initial inspection showed that while the dataset was relational in nature, it required structured transformation before analytical use:

Data types required casting (e.g., numeric values stored inconsistently)

Date fields required normalization for time dimension joins

Column naming required standardization

Deduplication logic was necessary in staging

Foreign key consistency required validation via dbt relationship tests

No structural corruption was found in the dataset; however, raw-layer inconsistencies required careful validation during transformation to ensure referential integrity and accurate fact table population.

**Data Warehouse Architecture**

The project follows a layered modern analytics architecture:


    RAW (OLTP) → STAGING → STAR_SCHEMA → MARTS → REPORTING
    

**RAW (OLTP)**

Contains manually uploaded source tables exactly as received.

**STAGING (stg_*)**

Cleansed and standardized data

Deduplicated records

Type casting applied

Column naming normalized

Relationship tests implemented

**STAR_SCHEMA**

Implements a dimensional model:


    fact_sales (order-product grain)

    dim_client

    dim_product

    dim_payment_method

    dim_time (generated via macro)
    

Surrogate keys were generated using dbt_utils.generate_surrogate_key().


**MARTS**

Contains the Sales Mart derived from the star schema.

**REPORTING**

Contains aggregated reporting tables, including:


    Sales by Month

    Sales by Product

    Sales by Client
    
    Sales Cube (Client × Product)
    
    Sales Cube (Product × Month)
    

Two reporting tables use SQL GROUP BY CUBE for multidimensional aggregation.


**Data Governance**

Sensitive data was anonymized during transformation:

Client email addresses were hashed using a dbt macro.

No personally identifiable information is exposed in reporting tables.

dbt tests were implemented for:


    Not null constraints
    
    Unique keys
    
    Relationship validation
    

This ensures analytical integrity and responsible data handling practices.

**Technical Challenges Faced**

Several real-world engineering challenges were encountered and resolved:

- Timestamp vs. Date mismatch causing fact join elimination

- Dimension tables rebuilding when staging was temporarily empty

- Fact table collapsing to zero rows due to INNER JOIN dependency failures

- Source misalignment after manual RAW uploads

- Dependency propagation issues requiring selective model rebuilds

All issues were resolved through structured validation of row counts across layers and targeted full-refresh rebuilds of dependent models.

**Project Results**

After full validation, the warehouse successfully produced:


    fact_sales populated with 300 rows
    
    sales_by_month generating 6 monthly aggregates
    
    sales_cube_product_month generating 272 multidimensional combinations
    

All reporting tables are fully populated and validated.

**Business Insights**

Analysis of the reporting layer reveals:

- Revenue is concentrated in high-value electronics products such as Headphones and Smartwatch.

- Sales distribution across available months is relatively stable.

- A long-tail product pattern is visible, where a small number of products drive a disproportionate share of revenue.

- Revenue growth appears driven more by transaction volume than product diversity.

These insights support product prioritization, inventory planning, and revenue optimization strategies.

**Project Structure**
ecommerce-dbt-sales-warehouse
│

├── models

│   ├── prep

│   │   ├── stg_client.sql

│   │   ├── stg_orders.sql

│   │   ├── stg_product.sql

│   │   └── ...

│   │

│   ├── marts

│   │   ├── dim_client.sql

│   │   ├── dim_product.sql

│   │   ├── dim_payment_method.sql

│   │   ├── dim_time.sql

│   │   ├── fct_sales.sql

│   │   ├── sales_by_month.sql

│   │   ├── sales_by_product.sql

│   │   ├── sales_cube_client_product.sql

│   │   └── sales_cube_product_month.sql

│

├── macros

│   ├── generate_dates_dimension.sql

│   └── data_anonymization.sql

│

├── dbt_project.yml

├── packages.yml

└── README.md

**How to Run the Project**
Environment Requirements

This project was developed using:


    Snowflake (Cloud Data Warehouse)
    
    dbt (v1.11+)
    
    Python virtual environment
    
    dbt_utils package
    

**Execution Order**

    Upload RAW Data
    
    Upload source CSV files into RAW.OLTP schema in Snowflake.
    
    Install Dependencies
    
    dbt deps
    
    Run Staging Layer
    
    dbt run --select prep
    
    Build Star Schema
    
    dbt run --select tag:star_schema --full-refresh
    
    Build Reporting Layer
    
    dbt run
    
    Run Tests
    
    dbt test
    

**Key Learnings**

- Dimensional completeness is critical before fact builds.

- Inner joins in fact tables can eliminate all data if dimensions are empty.

- dbt dependency management requires understanding of rebuild propagation.

- Row-count validation across layers is essential in debugging.

Proper schema configuration prevents cross-layer misplacement of models.

**Conclusion**

This project demonstrates the implementation of a complete modern data warehouse pipeline using dbt and Snowflake. By structuring raw operational data into a validated star schema and reporting layer, the project enables scalable, secure, and reliable sales analytics.

The final solution reflects real-world analytics engineering practices, including data governance, dependency management, dimensional modeling, and structured debugging across layered architecture.
