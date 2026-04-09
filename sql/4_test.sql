-- Проверка на соответствие размерам таблиц
SELECT 'dim_location' AS table_name, COUNT(*) FROM dim_location
UNION SELECT 'dim_pet', COUNT(*) FROM dim_pet
UNION SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION SELECT 'dim_seller', COUNT(*) FROM dim_seller
UNION SELECT 'dim_product_category', COUNT(*) FROM dim_product_category
UNION SELECT 'dim_product', COUNT(*) FROM dim_product
UNION SELECT 'dim_store', COUNT(*) FROM dim_store
UNION SELECT 'dim_supplier', COUNT(*) FROM dim_supplier
UNION SELECT 'fact_sale', COUNT(*) FROM fact_sale
UNION SELECT 'mock_data', COUNT(*) FROM mock_data;

-- Аналитический запрос
-- Покупатели, которые купили товары для собак
SELECT DISTINCT
    c.email,
    c.first_name,
    c.last_name,
    pc.pet_category as category
FROM fact_sale fs
JOIN dim_customer c ON fs.customer_id = c.customer_id
JOIN dim_product p ON fs.product_id = p.product_id
JOIN dim_product_category pc ON p.category_id = pc.category_id
WHERE pc.pet_category = 'Dogs'
ORDER BY c.email;

-- Просто вывод таблицы фактов
SELECT * FROM fact_sale;