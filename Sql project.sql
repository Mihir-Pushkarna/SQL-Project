show databases;
use orders;
show tables;

SELECT CARTON_ID, ((LEN)*(WIDTH)*(HEIGHT)) AS CARTON_VOL,
CASE
WHEN ((LEN)*(WIDTH)*(HEIGHT)) > (SELECT (PRODUCT.(LEN)*PRODUCT.(WIDTH)*PRODUCT.(HEIGHT)*PRODUCT.(PRODUCT_QUANTITY)) FROM PRODUCT 
JOIN ORDER_ITEMS ON ORDER_ITEMS.PRODUCT_ID =PRODUCT.PRODUCT_ID
WHERE ORDER_ITEMS.ORDER_ID = 10006) THEN 'Yes'
 ELSE 'No'
 END AS OPTIMUM
FROM CARTON; 

SELECT online_customer.CUSTOMER_ID, online_customer.CUSTOMER_FNAME, online_customer.CUSTOMER_LNAME,
 order_items.ORDER_ID, sum(order_items.PRODUCT_QUANTITY) as product_qty
FROM (online_customer INNER JOIN order_header ON online_customer.CUSTOMER_ID = order_header.CUSTOMER_ID) 
INNER JOIN order_items ON order_header.ORDER_ID = order_items.ORDER_ID
where payment_mode in ('credit card','net banking') and order_status = 'shipped'
GROUP BY online_customer.CUSTOMER_FNAME, online_customer.CUSTOMER_LNAME, order_items.ORDER_ID
HAVING (((sum(order_items.PRODUCT_quantity))>10));

Select order_header.order_id, online_customer.customer_id, concat(customer_fname,' ',customer_lname) as 'customer full name', 
sum(order_items.PRODUCT_QUANTITY) as product_qty 
FROM (online_customer INNER JOIN order_header ON online_customer.CUSTOMER_ID = order_header.CUSTOMER_ID) 
INNER JOIN order_items ON order_header.ORDER_ID = order_items.ORDER_ID
where customer_fname like 'A%' and order_header.ORDER_ID >10030 and order_status = 'shipped'
group by order_header.order_id, online_customer.customer_id, concat(customer_fname,' ',customer_lname)

SELECT PRODUCT_CLASS_DESC, COUNTRY, 
SUM(product_quantity) AS 'total quantity', sum(product_price), SUM(product_quantity* product_price) AS 'total value'
FROM PRODUCT p ,ADDRESS a, ONLINE_CUSTOMER oc ,ORDER_HEADER oh,ORDER_ITEMS oi,PRODUCT_CLASS pc WHERE
oh.CUSTOMER_ID = OC.CUSTOMER_ID 
AND
oi.PRODUCT_ID = p.PRODUCT_ID
AND
pc.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE 
AND
oi.ORDER_ID = oh.ORDER_ID
AND
oc.ADDRESS_ID = a.ADDRESS_ID 
AND
a.COUNTRY IN ('India')
group by PRODUCT_CLASS_DESC, country
order by SUM(product_quantity) DESC limit 1 
