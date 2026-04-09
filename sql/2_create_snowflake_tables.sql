BEGIN;
-- локации
CREATE TABLE IF NOT EXISTS dim_location (
    location_id BIGSERIAL PRIMARY KEY,
    country VARCHAR(50),
    postal_code VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50)
);
-- питомцы
CREATE TABLE IF NOT EXISTS dim_pet (
    pet_id BIGSERIAL PRIMARY KEY,
    TYPE VARCHAR(50),
    breed VARCHAR(50),
    pet_name VARCHAR(50)
);
-- покупатели
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    email VARCHAR(50),
    location_id BIGINT REFERENCES dim_location(location_id),
    pet_id BIGINT REFERENCES dim_pet(pet_id)
);
-- продавцы
CREATE TABLE IF NOT EXISTS dim_seller (
    seller_id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    location_id BIGINT REFERENCES dim_location(location_id)
);
-- категориии продуктов
CREATE TABLE IF NOT EXISTS dim_product_category (
    category_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50),
    pet_category VARCHAR(50)
);
-- продукты
CREATE TABLE IF NOT EXISTS dim_product (
    product_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50),
    category_id BIGINT REFERENCES dim_product_category(category_id),
    quantity INT,
    weight REAL,
    color VARCHAR(50),
    SIZE VARCHAR(50),
    brand VARCHAR(50),
    material VARCHAR(50),
    description TEXT,
    release_date VARCHAR(50),
    expiry_date VARCHAR(50),
    rating REAL,
    reviews INT
);
-- магазины
CREATE TABLE IF NOT EXISTS dim_store (
    store_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50),
    location_id BIGINT REFERENCES dim_location(location_id),
    LOCATION VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(50)
);
-- поставщики
CREATE TABLE IF NOT EXISTS dim_supplier (
    supplier_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50),
    contact VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50),
    location_id BIGINT REFERENCES dim_location(location_id),
    address VARCHAR(50)
);
-- центр снежинки, табличка с продажами
CREATE TABLE IF NOT EXISTS fact_sale (
    sale_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES dim_customer(customer_id),
    seller_id BIGINT REFERENCES dim_seller(seller_id),
    product_id BIGINT REFERENCES dim_product(product_id),
    store_id BIGINT REFERENCES dim_store(store_id),
    supplier_id BIGINT REFERENCES dim_supplier(supplier_id),
    date VARCHAR(50),
    price float4,
    quantity INT
);

COMMIT;