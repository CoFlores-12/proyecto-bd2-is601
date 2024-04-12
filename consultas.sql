use proyectobd2
GO
SET NOCOUNT ON
GO
-- Regiones con mas reproducciones
-- por ciudad
SELECT 
    r.region_name AS ciudad,
    c.region_name AS pais,
    ct.region_name AS continente,
    COUNT(p.play_id) AS total_plays
FROM 
    regions r
INNER JOIN 
    regions c ON r.parent_id = c.region_id
INNER JOIN 
    regions ct ON c.parent_id = ct.region_id
INNER JOIN 
    users u ON r.region_id = u.region_id
INNER JOIN 
    plays p ON u.user_id = p.user_id
GROUP BY 
    r.region_name, c.region_name, ct.region_name
ORDER BY 
    total_plays DESC;

-- -- por país
SELECT 
    c.region_name AS pais,
    COUNT(p.play_id) AS total_plays
FROM 
    regions r
INNER JOIN 
    regions c ON r.parent_id = c.region_id
INNER JOIN 
    regions ct ON c.parent_id = ct.region_id
INNER JOIN 
    users u ON r.region_id = u.region_id
INNER JOIN 
    plays p ON u.user_id = p.user_id
GROUP BY 
    c.region_name
ORDER BY 
    total_plays DESC;

-- -- por continente
SELECT 
    ct.region_name AS continente,
    COUNT(p.play_id) AS total_plays
FROM 
    regions r
INNER JOIN 
    regions c ON r.parent_id = c.region_id
INNER JOIN 
    regions ct ON c.parent_id = ct.region_id
INNER JOIN 
    users u ON r.region_id = u.region_id
INNER JOIN 
    plays p ON u.user_id = p.user_id
GROUP BY 
    ct.region_name
ORDER BY 
    total_plays DESC;


--categorias con mejor calificacion por region
-- por ciudad
SELECT 
    DISTINCT re.region_name continente,
    cat.title categoria,
    ROUND(AVG(CAST(r.rating_value AS FLOAT)), 2) ranking
FROM ratings r
INNER JOIN content c ON r.content_id = c.content_id
INNER JOIN categories cat ON c.category_id = cat.category_id
INNER JOIN plays p ON c.content_id = p.content_id
INNER JOIN users u ON p.user_id = u.user_id
INNER JOIN regions re ON u.region_id = re.region_id
INNER join regions pa ON re.parent_id = pa.region_id
INNER join regions ct ON pa.parent_id = ct.region_id
GROUP BY  re.region_name, cat.title
order by ranking DESC

-- por pais
SELECT 
    DISTINCT pa.region_name continente,
    cat.title categoria,
    ROUND(AVG(CAST(r.rating_value AS FLOAT)), 2) ranking
FROM ratings r
INNER JOIN content c ON r.content_id = c.content_id
INNER JOIN categories cat ON c.category_id = cat.category_id
INNER JOIN plays p ON c.content_id = p.content_id
INNER JOIN users u ON p.user_id = u.user_id
INNER JOIN regions re ON u.region_id = re.region_id
INNER join regions pa ON re.parent_id = pa.region_id
INNER join regions ct ON pa.parent_id = ct.region_id
GROUP BY  pa.region_name, cat.title
order by ranking DESC

-- por continente
SELECT 
    DISTINCT ct.region_name continente,
    cat.title categoria,
    ROUND(AVG(CAST(r.rating_value AS FLOAT)), 2) ranking
FROM ratings r
INNER JOIN content c ON r.content_id = c.content_id
INNER JOIN categories cat ON c.category_id = cat.category_id
INNER JOIN plays p ON c.content_id = p.content_id
INNER JOIN users u ON p.user_id = u.user_id
INNER JOIN regions re ON u.region_id = re.region_id
INNER join regions pa ON re.parent_id = pa.region_id
INNER join regions ct ON pa.parent_id = ct.region_id
GROUP BY ct.region_name, cat.title
order by ranking DESC