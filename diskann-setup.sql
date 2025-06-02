-- List all tables in the current database (public schema is common)
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';


CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name TEXT,
    description TEXT,
    price NUMERIC(10, 2),
    in_stock BOOLEAN,
    description_embedding VECTOR(1536) -- Change dimension based on your model (e.g., 1536 for text-embedding-ada-002)
);

-- Add a generated column to automatically create embeddings on insert/update
-- This is experimental, but very powerful for a demo!
ALTER TABLE products
ALTER COLUMN description_embedding SET GENERATED ALWAYS AS (
    azure_ai.create_embeddings(
        azure_ai.azure_openai_embedding_args('text-embedding-ada-002', description) -- Use your model name and column
    )
) STORED;




CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name TEXT,
    description TEXT,
    price NUMERIC(10, 2),
    in_stock BOOLEAN,
    description_embedding VECTOR(1536) -- Change dimension based on your model (e.g., 1536 for text-embedding-ada-002)
);

-- Add a generated column to automatically create embeddings on insert/update
-- This is experimental, but very powerful for a demo!
ALTER TABLE products
ALTER COLUMN description_embedding SET GENERATED ALWAYS AS (
    azure_ai.create_embeddings(
        azure_ai.azure_openai_embedding_args('text-embedding-ada-002', description) -- Use your model name and column
    )
) STORED;


Insert 

INSERT INTO products (name, description, price, in_stock) VALUES
('Premium Smartwatch', 'A sleek smartwatch with advanced health tracking and long battery life.', 299.99, TRUE),
('Wireless Noise-Cancelling Headphones', 'Immersive audio experience with superior noise cancellation for travel and work.', 199.99, TRUE),
('Compact Digital Camera', 'Capture stunning photos and 4K videos with this easy-to-use digital camera.', 450.00, FALSE),
('Ergonomic Office Chair', 'Supportive and comfortable chair designed for long hours of work, adjustable.', 350.00, TRUE),
('High-Speed External SSD', 'Fast and portable storage solution for backing up large files and gaming.', 150.00, TRUE),
('Smart LED Light Bulbs (4-pack)', 'Control your home lighting with your voice or smartphone app, energy efficient.', 45.00, TRUE),
('Robot Vacuum Cleaner', 'Automated cleaning for your home, smart navigation and powerful suction.', 499.00, FALSE),
('Yoga Mat Pro', 'Thick, non-slip mat for comfortable and stable yoga and fitness workouts.', 35.00, TRUE),
('Portable Espresso Maker', 'Enjoy fresh espresso on the go, perfect for camping and travel.', 99.00, TRUE);


CREATE INDEX idx_products_diskann ON products USING diskann (description_embedding VECTOR_COSINE_OPS);

-- For larger datasets, consider tuning parameters (e.g., higher l_value_ib for better quality)
-- CREATE INDEX idx_products_diskann_tuned ON products USING diskann (description_embedding VECTOR_COSINE_OPS)
-- WITH (max_neighbors = 64, l_value_ib = 200, pq_param_num_chunks = 384); -- Adjust pq_param_num_chunks for 1536 / 4 = 384


-- Get embedding for your query
SELECT azure_ai.create_embeddings(
    azure_ai.azure_openai_embedding_args('text-embedding-ada-002', 'gadgets for smart home')
) AS query_vector;

-- Copy the resulting vector from the above output. Let's assume it's `[...your_query_vector...]`

-- Perform similarity search (top 3 most similar)
SELECT
    product_id,
    name,
    description,
    price,
    description_embedding <=> '[...your_query_vector...]' AS similarity_score
FROM
    products
ORDER BY
    similarity_score
LIMIT 3;


-- Find in-stock products similar to "fitness equipment" and under $100
-- First, get embedding for "fitness equipment"
SELECT azure_ai.create_embeddings(
    azure_ai.azure_openai_embedding_args('text-embedding-ada-002', 'fitness equipment')
) AS query_vector;

-- Let's say the query vector is `[...fitness_query_vector...]`

SELECT
    product_id,
    name,
    description,
    price,
    description_embedding <=> '[...fitness_query_vector...]' AS similarity_score
FROM
    products
WHERE
    in_stock = TRUE AND price < 100.00
ORDER BY
    similarity_score
LIMIT 3;



-- Set search behavior to 'off' to force a sequential scan if no other index is used
SET diskann.iterative_search TO 'off';

EXPLAIN ANALYZE
SELECT
    product_id,
    name,
    description,
    description_embedding <=> '[...your_query_vector...]' AS similarity_score
FROM
    products
ORDER BY
    similarity_score
LIMIT 3;

SET diskann.iterative_search TO 'relaxed_order'; -- Reset it for future DiskANN queries




-- First, create an HNSW index (requires pgvector extension only, which is already enabled)
-- CREATE INDEX idx_products_hnsw ON products USING hnsw (description_embedding vector_cosine_ops);

-- Then run a query using the HNSW index
-- EXPLAIN ANALYZE
-- SELECT
--     product_id,
--     name,
--     description,
--     description_embedding <=> '[...your_query_vector...]' AS similarity_score
-- FROM
--     products
-- ORDER BY
--     similarity_score
-- LIMIT 3;





