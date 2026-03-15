BEGIN;

-- заполняем локациями из 4х источников(покупатели, магазины, поставщики, продавцы)
INSERT INTO dim_location (country, postal_code, city, state)
SELECT DISTINCT country, postal_code, city, state
FROM (
    SELECT
        customer_country AS country,
        customer_postal_code AS postal_code,
        NULL::VARCHAR AS city,
        NULL::VARCHAR AS state
    FROM mock_data
    WHERE customer_country IS NOT NULL
    
    UNION
    
    SELECT
        seller_country,
        seller_postal_code,
        NULL,
        NULL
    FROM mock_data
    WHERE seller_country IS NOT NULL
    
    UNION
    
    SELECT
        store_country,
        NULL,
        store_city,
        store_state
    FROM mock_data
    WHERE store_country IS NOT NULL
    
    UNION
    
    SELECT
        supplier_country,
        NULL,
        supplier_city,
        NULL
    FROM mock_data
    WHERE supplier_country IS NOT NULL
) t;

-- питомцы с породами
INSERT INTO dim_pet (type, breed)
SELECT DISTINCT
    customer_pet_type,
    customer_pet_breed
FROM mock_data
WHERE customer_pet_type IS NOT NULL;

-- покупатели
INSERT INTO dim_customer (
    first_name,
    last_name,
    age,
    email,
    location_id,
    pet_id,
    pet_name
)
SELECT DISTINCT
    m.customer_first_name,
    m.customer_last_name,
    m.customer_age,
    m.customer_email,
    l.location_id,
    p.pet_id,
    m.customer_pet_name
FROM mock_data m
LEFT JOIN dim_location l 
    ON m.customer_country = l.country 
    AND m.customer_postal_code = l.postal_code
    AND l.city IS NULL 
    AND l.state IS NULL
LEFT JOIN dim_pet p 
    ON m.customer_pet_type = p.type 
    AND m.customer_pet_breed = p.breed
WHERE m.customer_email IS NOT NULL;

-- продавцы
INSERT INTO dim_seller (
    first_name,
    last_name,
    email,
    location_id
)
SELECT DISTINCT
    m.seller_first_name,
    m.seller_last_name,
    m.seller_email,
    l.location_id
FROM mock_data m
LEFT JOIN dim_location l 
    ON m.seller_country = l.country 
    AND m.seller_postal_code = l.postal_code
    AND l.city IS NULL 
    AND l.state IS NULL
WHERE m.seller_email IS NOT NULL;

-- категории продуктов
INSERT INTO dim_product_category (name, pet_category)
SELECT DISTINCT
    product_category,
    pet_category
FROM mock_data
WHERE product_category IS NOT NULL;

-- сами продукты
INSERT INTO dim_product (
    name,
    category_id,
    quantity,
    weight,
    color,
    size,
    brand,
    material,
    description,
    release_date,
    expiry_date,
    rating,
    reviews
)
SELECT DISTINCT
    m.product_name,
    c.category_id,
    m.product_quantity,
    m.product_weight,
    m.product_color,
    m.product_size,
    m.product_brand,
    m.product_material,
    m.product_description,
    m.product_release_date,
    m.product_expiry_date,
    m.product_rating,
    m.product_reviews
FROM mock_data m
LEFT JOIN dim_product_category c
    ON c.name = m.product_category
    AND c.pet_category = m.pet_category
WHERE m.product_name IS NOT NULL;

-- магазины
INSERT INTO dim_store (
    name,
    location_id,
    location,
    phone,
    email
)
SELECT DISTINCT
    m.store_name,
    l.location_id,
    m.store_location,
    m.store_phone,
    m.store_email
FROM mock_data m
LEFT JOIN dim_location l
    ON l.country = m.store_country
    AND l.city = m.store_city
    AND l.state = m.store_state
    AND l.postal_code IS NULL
WHERE m.store_name IS NOT NULL;

-- поставщики
INSERT INTO dim_supplier (
    name,
    contact,
    email,
    phone,
    location_id,
    address
)
SELECT DISTINCT
    m.supplier_name,
    m.supplier_contact,
    m.supplier_email,
    m.supplier_phone,
    l.location_id,
    m.supplier_address
FROM mock_data m
LEFT JOIN dim_location l
    ON l.country = m.supplier_country
    AND l.city = m.supplier_city
    AND l.postal_code IS NULL
    AND l.state IS NULL
WHERE m.supplier_email IS NOT NULL;

-- факты
INSERT INTO fact_sale (
    customer_id,
    seller_id,
    product_id,
    store_id,
    supplier_id,
    date,
    price,
    quantity,
    total_price
)
SELECT DISTINCT
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    sp.supplier_id,
    m.sale_date,
    m.product_price,
    m.sale_quantity,
    m.sale_total_price
FROM mock_data m
LEFT JOIN dim_customer c ON
    c.email = m.customer_email
    AND c.first_name = m.customer_first_name
    AND c.last_name = m.customer_last_name
    AND c.age = m.customer_age
    AND c.pet_name = m.customer_pet_name
LEFT JOIN dim_seller s ON
    s.email = m.seller_email
    AND s.first_name = m.seller_first_name
    AND s.last_name = m.seller_last_name
JOIN dim_product p ON
    p.name = m.product_name
    AND p.brand = m.product_brand
    AND p.quantity = m.product_quantity
    AND p.weight = m.product_weight
    AND p.color = m.product_color
    AND p.size = m.product_size
    AND p.material = m.product_material
    AND p.description = m.product_description
    AND p.release_date = m.product_release_date
    AND p.expiry_date = m.product_expiry_date
    AND p.rating = m.product_rating
    AND p.reviews = m.product_reviews
LEFT JOIN dim_store st ON
    st.name = m.store_name
    AND st.phone = m.store_phone
    AND st.email = m.store_email
    AND st.location = m.store_location
LEFT JOIN dim_supplier sp ON
    sp.email = m.supplier_email
    AND sp.name = m.supplier_name
    AND sp.contact = m.supplier_contact
    AND sp.phone = m.supplier_phone
    AND sp.address = m.supplier_address;

COMMIT;