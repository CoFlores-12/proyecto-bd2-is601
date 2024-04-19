IF EXISTS (SELECT name FROM master.sys.databases WHERE name = N'proyectobd2')
	use master
	alter database proyectobd2 set single_user with rollback immediate

	drop database proyectobd2
GO

CREATE DATABASE proyectobd2
GO

USE proyectobd2
GO

CREATE TABLE suscripciones(
	subscripcionId INT IDENTITY PRIMARY KEY,
	descripcion VARCHAR(20),
	precio DECIMAL(4, 2)
)

-- Tabla de Regiones
CREATE TABLE regions (
    region_id INT PRIMARY KEY IDENTITY(1,1),
    region_name VARCHAR(100) NOT NULL,
    parent_id INT,
    region_level INT NOT NULL -- Nivel en la jerarqu�a (1 para continente, 2 para pa�s, 3 para ciudad)
)
GO

-- Tabla de Usuarios
GO
CREATE TABLE users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(15),
	apellido VARCHAR(15),
    fechaSuscripcion DATE,
	suscripcionId int,
    edad INT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    FOREIGN KEY (suscripcionId) REFERENCES suscripciones(subscripcionId),
    region_id INT FOREIGN KEY REFERENCES regions(region_id)
)
GO

-- Tabla de Categorias
CREATE TABLE categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    title_category VARCHAR(50) NOT NULL,
    description_category VARCHAR(100)
)
GO

-- Tabla de Contenido
CREATE TABLE content (
    content_id INT PRIMARY KEY IDENTITY(1,1),
    title_content VARCHAR(50) NOT NULL,
    description_content VARCHAR(100),
    release_date DATE,
    category_id INT FOREIGN KEY REFERENCES categories(category_id)
)
GO

-- Tabla de Dispositivos
CREATE TABLE devices (
    device_id INT PRIMARY KEY IDENTITY(1,1),
    SO VARCHAR(50),
	model VARCHAR(100)
)
GO

-- Tabla de Reproducciones
CREATE TABLE plays (
    play_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    content_id INT FOREIGN KEY REFERENCES content(content_id),
    device_id INT FOREIGN KEY REFERENCES devices(device_id),
	resolution VARCHAR(15),
    duration INT,
	fechaHoraVisita DATETIME,
	rating_value FLOAT CHECK (rating_value >= 0.0 AND rating_value <= 5.0)
)
GO

-- ##################### VIEWS FRO ETL #######################

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
) 
GO
-- ETL query users
CREATE VIEW ETLUsers AS (
    SELECT 
		u.user_id,
        u.fechaSuscripcion fechaSuscripcion,
		u.edad edad,
		s.descripcion descripcionSuscripcion,
		s.precio precioSupscripcion,
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
	INNER JOIN suscripciones s
	ON u.suscripcionId = s.subscripcionId
) 
GO


-- ######################## LLENADO DE DATOS #####################

USE proyectobd2
GO

SET NOCOUNT ON

INSERT INTO regions (region_name, parent_id, region_level)
VALUES ('America del Norte', NULL, 1),('America del Sur', NULL, 1),('Europa', NULL, 1),('Asia', NULL, 1),('Africa', NULL, 1),('Centroamerica', null, 1),('Estados Unidos', 1, 2),('Canada', 1, 2),('M�xico', 1, 2),('Honduras', 6, 2),('El Salvador', 6, 2),('Panama', 6, 2),('Guatemala', 6, 2),('Costa Rica', 6, 2),('Brasil', 2, 2),('Argentina', 2, 2),('Colombia', 2, 2),('Chile', 2, 2),('Peru', 2, 2),('Reino Unido', 3, 2),('Alemania', 3, 2),('Francia', 3, 2),('Espana', 3, 2),('Italia', 3, 2),('China', 4, 2),('India', 4, 2),('Japon', 4, 2),('Corea del Sur', 4, 2),('Rusia', 4, 2),('Nigeria', 5, 2),('Etiopia', 5, 2),('Egipto', 5, 2),('Republica Democratica del Congo', 5, 2),('Sudafrica', 5, 2),('Nueva York',7, 3), ('Los Angeles',7,3),('Toronto',8, 3), ('Montreal',8, 3),('Ciudad de Mexico', 9,3), ('Guadalajara', 9,3),('Tegucigalpa', 10,3), ('San Pedro Sula', 10,3),('San Salvador', 11,3), ('Santa Ana', 11,3),('Ciudad de Panama', 12,3), ('Colon', 12,3),('Ciudad de Guatemala', 13,3), ('Quetzaltenango', 13,3),('San Jose', 14,3), ( 'Liberia', 14,3),( 'Sao Paulo', 15,3), ( 'Rio de Janeiro', 15,3),( 'Buenos Aires', 16,3), ( 'Cordoba', 16,3),( 'Bogota', 17,3), ( 'Medellin', 17,3),( 'Santiago', 18,3), ( 'Valparaiso', 18,3),( 'Lima', 19,3), ( 'Arequipa', 19,3),('Londres', 20, 3),('Manchester', 20, 3),('Berlin', 21, 3),('Munich', 21, 3),('Paris', 22, 3),('Marsella', 22, 3),('Madrid', 23, 3),('Barcelona', 23, 3),('Roma', 24, 3),('Milan', 24, 3),('Pekin', 25, 3),('Shanghai', 25, 3),('Bombay', 26, 3),('Delhi', 26, 3),('Tokio', 27, 3),('Osaka', 27, 3),('Seal', 28, 3),('Busan', 28, 3),('Moscu', 29, 3),('San Petersburgo', 29, 3),('Lagos', 30, 3),('Abuya', 30, 3),('Adis Abeba', 31, 3),('Addis Abeba', 31, 3),('El Cairo', 32, 3),('Alejandria', 32, 3),('Kinshasa', 33, 3),('Lubumbashi', 33, 3),('Ciudad del Cabo', 34, 3),('Johannesburgo', 34, 3);


-- ###################################### TABLA SUSCRIPCIONES ##############################
INSERT INTO suscripciones(descripcion, precio)
VALUES ('Clasica', 3.0),('Familiar', 20.0),('Premium', 5.0),('Normal', 0.0)


--####################################### TABLA USERS #######################################
SET NOCOUNT ON

DECLARE @Counter INT = 1;

DECLARE @rand_date DATE;
DECLARE @rand_age INT;
DECLARE @rand_suscripcionId INT;


WHILE @Counter <= 1000
BEGIN
    SET NOCOUNT ON
	SET @rand_date = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 364 ), '2020-01-01');
	SET @rand_age = ABS(CHECKSUM(NEWID()) % 70) + 10
	SET @rand_suscripcionId = ABS(CHECKSUM(NEWID()) % 4) + 1

	INSERT INTO [dbo].[users]
				(fechaSuscripcion,
				suscripcionId,
				edad,
				[username]
				,[email]
				,[password]
				,[region_id])
			VALUES
				(@rand_date,
				@rand_suscripcionId,
				@rand_age,
				'User' + CONVERT(VARCHAR(10), @Counter)
				,'user' + CONVERT(VARCHAR(10), @Counter) + '@example.com'
				,'User' + CONVERT(VARCHAR(10), @Counter)
				,CAST((RAND() * (90 - 35 + 1) + 35) AS INT))

    SET @Counter = @Counter + 1;
END
GO

--####################################### TABLA CATEGORIES #######################################
SET NOCOUNT ON

INSERT INTO categories (title_category, description_category)
VALUES 
    ('Gaming', 'Videos relacionados con videojuegos y gaming.'),
    ('Cocina', 'Videos de recetas, cocina y gastronom�a.'),
    ('Tutoriales', 'Videos que ofrecen instrucciones y gu�as paso a paso.'),
    ('Viajes', 'Videos relacionados con viajes y turismo.'),
    ('Comedia', 'Videos c�micos y de humor.'),
    ('Fitness', 'Videos de ejercicios y entrenamiento f�sico.'),
    ('M�sica', 'Videos relacionados con la m�sica y conciertos.'),
    ('Belleza', 'Videos de maquillaje, cuidado de la piel y belleza.'),
    ('Tecnologaa', 'Videos sobre gadgets, aplicaciones y avances tecnologicos.'),
    ('Moda', 'Videos sobre tendencias de moda y estilo.'),
    ('Deportes', 'Videos relacionados con deportes y competiciones.'),
    ('Cine y TV', 'Videos sobre peliculas, series y programas de television.'),
    ('Educacion', 'Videos educativos y academicos.'),
    ('Ciencia y Tecnolog�a', 'Videos sobre ciencia, innovaci�n y descubrimientos.'),
    ('Arte y Dise�o', 'Videos sobre arte, dise�o y creatividad.'),
    ('Negocios', 'Videos sobre emprendimiento, finanzas y negocios.'),
    ('Automotriz', 'Videos relacionados con el mundo del automovil y la mecanica.'),
    ('Mascotas', 'Videos sobre mascotas, cuidado animal y entrenamiento.'),
    ('Fotografaa', 'Videos sobre t�cnicas, equipo y consejos de fotografaa.'),
    ('Medio ambiente', 'Videos sobre conservacion, ecologia y medio ambiente.');


--####################################### TABLA CONTENT #######################################
DECLARE @RowCount2 INT = 1;
DECLARE @CurrentDate DATE = GETDATE();

WHILE @RowCount2 <= 1000 
BEGIN
    SET NOCOUNT ON

    DECLARE @Title2 VARCHAR(50);
    SET @Title2 = 'Content ' + CAST(@RowCount2 AS VARCHAR(10)); 

    DECLARE @Description2 VARCHAR(100);
    SET @Description2 = 'Description for content ' + CAST(@RowCount2 AS VARCHAR(10));  

    DECLARE @ReleaseDate DATE;
    SET @ReleaseDate = DATEADD(DAY, -FLOOR(RAND() * 365), @CurrentDate);

    DECLARE @CategoryID INT;
    SET @CategoryID = (CAST(RAND() * 20 AS INT) % 20) + 1;

    INSERT INTO content (title_content, description_content, release_date, category_id)
    VALUES (@Title2, @Description2, @ReleaseDate, @CategoryID);

    SET @RowCount2 = @RowCount2 + 1;
END;

--####################################### TABLA DEVICES #######################################
DECLARE @RowCount3 INT = 1;

DECLARE @OperatingSystems TABLE (OS VARCHAR(50));
INSERT INTO @OperatingSystems VALUES ('Windows 11'),('Windows 10'), ('iOS 17'),('IOS 16'), ('Android 14'), ('Android 13'), ('Linux'), ('Mac') ;

DECLARE @Models TABLE (Model VARCHAR(100));
INSERT INTO @Models VALUES ('Galaxy S24'), ('iPhone 15'), ('Surface Pro'), ('Pixel 5');

WHILE @RowCount3 <= 100
BEGIN
    SET NOCOUNT ON

    DECLARE @OS VARCHAR(50);
    SELECT TOP 1 @OS = OS FROM @OperatingSystems ORDER BY NEWID();

    DECLARE @Model VARCHAR(100);
    SELECT TOP 1 @Model = Model FROM @Models ORDER BY NEWID();

    INSERT INTO devices (SO, model)
    VALUES (@OS, @Model);

    SET @RowCount3 = @RowCount3 + 1;
END;

--####################################### TABLA PLAYS #######################################
DECLARE @RowCount4 INT = 1;
DECLARE @Resolutions TABLE (Resolution VARCHAR(15));
INSERT INTO @Resolutions VALUES ('7680x4320'), ('3840x2160'), ('2560x1440'), ('1920x1080'), ('1280x720'), ('854x480'), ('640x360'), ('426x240');
DECLARE @StartDate DATETIME = '2020-01-01';
DECLARE @EndDate DATETIME = '2020-12-12';

WHILE @RowCount4 <= 5000
BEGIN
    SET NOCOUNT ON

    DECLARE @UserID INT = (CAST(RAND() * 1000 AS INT) % 1000) + 1;
    DECLARE @ContentID INT = (CAST(RAND() * 1000 AS INT) % 1000) + 1;
    DECLARE @DeviceID INT = (CAST(RAND() * 100 AS INT) % 100) + 1;
    DECLARE @Resolution VARCHAR(15);
    SELECT TOP 1 @Resolution = Resolution FROM @Resolutions ORDER BY NEWID();
    DECLARE @Duration INT = (CAST(RAND() * 3600 AS INT) % 3600) + 1;
    DECLARE @RatingValue FLOAT = ROUND(RAND() * 5.0, 2)
	
	DECLARE @RandomDays INT = CAST(RAND() * DATEDIFF(day, @StartDate, @EndDate) AS INT);
	DECLARE @RandomHours INT = CAST(RAND() * 24 AS INT);
	DECLARE @RandomMinutes INT = CAST(RAND() * 60 AS INT);
	DECLARE @RandomSeconds INT = CAST(RAND() * 60 AS INT);

	DECLARE @RandomDateTime DATETIME = DATEADD(SECOND, (ABS(CHECKSUM(NEWID())) % (DATEDIFF(SECOND, @StartDate, @EndDate) + 1)), @StartDate);
	
	INSERT INTO plays (user_id, content_id, device_id, resolution, duration, fechaHoraVisita, rating_value)
    VALUES (@UserID, @ContentID, @DeviceID, @Resolution, @Duration,@RandomDateTime, @RatingValue);

    SET @RowCount4 = @RowCount4 + 1;
END;
