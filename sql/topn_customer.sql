DROP VIEW IF EXISTS topn_customer_view;

CREATE VIEW topn_customer_view AS
WITH customer_spend AS (
    SELECT 
        "CustomerID" AS customer_id,
		"Country" AS country,
        SUM("Quantity" * "UnitPrice") AS total_spend,
        COUNT(DISTINCT "InvoiceNo") AS total_orders,
        MAX("InvoiceDateTime") AS last_order_date,
        MIN("InvoiceDateTime") AS first_order_date
    FROM public.topn_customer
    WHERE "CustomerID" IS NOT NULL
    GROUP BY "CustomerID","Country"
),
ranked_customers AS (
    SELECT
        customer_id,
		country,
        total_spend,
        total_orders,
        first_order_date,
        last_order_date,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
    FROM customer_spend
)
SELECT *
FROM ranked_customers 
ORDER BY spend_rank;
