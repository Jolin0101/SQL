/*
Select*
From customer
*/

/*
SELECT*
From customer
ORDER BY customer_last_name,customer_first_name
LIMIT 10
*/


/*
SELECT*, (quantity*cost_to_customer_per_qty) AS price
From customer_purchases
ORDER BY vendor_id >=8 and vendor_id<=10
*/

/*
SELECT*
From customer_purchases
Where product_id in (4,9)
*/

/*
SELECT
product_id,product_name,
CASE WHEN product_qty_type = 'unit' Then 'unit'
Else 'bulk'
END AS prod_qty_type_condensed
From product;
*/

/*
SELECT
product_id,product_name,
CASE WHEN product_qty_type = 'unit' Then 'unit'
Else 'bulk'
END AS prod_qty_type_condensed,

CASE WHEN LOWER (product_name) like '%pepper%' Then 1
ELSE 0
End AS pepper_flag
From product;
*/

/*
SELECT*

From vendor
Inner JOIN vendor_booth_assignments
ON Vendor.vendor_id  = vendor_booth_assignments.vendor_id

Order by vendor_name,market_date
*/