-- ETL query content
CREATE VIEW ETLContent AS (
    SELECT 
        c.content_id, 
        c.title_content, 
        c.description_content, 
        c.release_date, 
        ca.category_id, 
        ca.title_category,
        ca.description_category
    FROM categories ca
    INNER JOIN 
        content c ON ca.category_id = c.category_id
) GO
-- ETL query users
CREATE VIEW ETLUsers AS (
    SELECT 
        u.*,
        ciudad.region_name AS ciudad,
        pais.region_name AS pais,
        continente.region_name AS continente
    FROM users u
    INNER JOIN regions ciudad 
    ON u.region_id = ciudad.region_id
    INNER JOIN regions pais
    on ciudad.parent_id = pais.region_id
    INNER JOIN regions continente
    ON pais.parent_id = continente.region_id
) GO
-- ETL query devices
SELECT * FROM devices

-- ETL query Plays
SELECT * FROM plays