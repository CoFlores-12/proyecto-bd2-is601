-- ETL query content
SELECT        [content].content_id, [content].title_content, [content].description_content, [content].release_date, categories.category_id, categories.description_category, categories.title_category
FROM            categories INNER JOIN
                         [content] ON categories.category_id = [content].category_id
-- ETL query Plays
SELECT 
    p.play_id,
    u.user_id,
    u.username,
    u.email,
    ciudad.region_name AS ciudad,
    pais.region_name AS pais,
    continente.region_name AS continente,
    p.content_id,
    d.device_id,
    d.SO,
    d.model,
    p.resolution,
    p.duration
from plays p
INNER JOIN users u
ON p.user_id = u.user_id
INNER JOIN regions ciudad 
ON u.region_id = ciudad.region_id
INNER JOIN regions pais
on ciudad.parent_id = pais.region_id
INNER JOIN regions continente
ON pais.parent_id = continente.region_id
INNER JOIN devices d
ON p.device_id = d.device_id