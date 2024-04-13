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
	precio DECIMAL(3, 2)
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
	resolution VARCHAR(15), --  7680�4320, 3840x2160, 2560�1440, 1920x1080, 1280x720, 854�480, 640�360, 426x240
    duration INT,
	rating_value INT CHECK (rating_value >= 1 AND rating_value <= 5)
)
GO

--tabla de horario espectadores
	CREATE TABLE horario_expectadores (
    ID_horario INT PRIMARY KEY IDENTITY(1,1),
    hora_dia VARCHAR(15),
    fechaSuscripcion DATE,
	cantidad_espectadores INT,
    region_id INT NOT NULL FOREIGN KEY REFERENCES regions(region_id)
)
GO

USE proyectobd2
GO

SET NOCOUNT ON

INSERT INTO regions (region_name, parent_id, region_level)
VALUES
('Am�rica del Norte', NULL, 1),('Am�rica del Sur', NULL, 1),('Europa', NULL, 1),('Asia', NULL, 1),('�frica', NULL, 1),('Centroam�rica', null, 1),('Estados Unidos', 1, 2),('Canad�', 1, 2),('M�xico', 1, 2),('Honduras', 6, 2),('El Salvador', 6, 2),('Panama', 6, 2),('Guatemala', 6, 2),('Costa Rica', 6, 2),('Brasil', 2, 2),('Argentina', 2, 2),('Colombia', 2, 2),('Chile', 2, 2),('Per�', 2, 2),('Reino Unido', 3, 2),('Alemania', 3, 2),('Francia', 3, 2),('Espa�a', 3, 2),('Italia', 3, 2),('China', 4, 2),('India', 4, 2),('Jap�n', 4, 2),('Corea del Sur', 4, 2),('Rusia', 4, 2),('Nigeria', 5, 2),('Etiop�a', 5, 2),('Egipto', 5, 2),('Rep�blica Democr�tica del Congo', 5, 2),('Sud�frica', 5, 2),('Nueva York',7, 3), ('Los �ngeles',7,3),('Toronto',8, 3), ('Montreal',8, 3),('Ciudad de M�xico', 9,3), ('Guadalajara', 9,3),('Tegucigalpa', 10,3), ('San Pedro SUla', 10,3),('San Salvador', 11,3), ('GuadalajaraSanta Ana', 11,3),('Ciudad de Panam�', 12,3), ('Col�n', 12,3),('Ciudad de Guatemala', 13,3), ('Quetzaltenango', 13,3),('San Jos�', 14,3), ( 'Liberia', 14,3),( 'S�o Paulo', 15,3), ( 'R�o de Janeiro', 15,3),( 'Buenos Aires', 16,3), ( 'C�rdoba', 16,3),( 'Bogot�', 17,3), ( 'Medell�n', 17,3),( 'Santiago', 18,3), ( 'Valpara�so', 18,3),( 'Lima', 19,3), ( 'Arequipa', 19,3),('Londres', 20, 3),('Manchester', 20, 3),('Berl�n', 21, 3),('M�nich', 21, 3),('Par�s', 22, 3),('Marsella', 22, 3),('Madrid', 23, 3),('Barcelona', 23, 3),('Roma', 24, 3),('Mil�n', 24, 3),('Pek�n', 25, 3),('Shangh�i', 25, 3),('Bombay', 26, 3),('Delhi', 26, 3),('Tokio', 27, 3),('Osaka', 27, 3),('Se�l', 28, 3),('Busan', 28, 3),('Mosc�', 29, 3),('San Petersburgo', 29, 3),('Lagos', 30, 3),('Abuya', 30, 3),('Ad�s Abeba', 31, 3),('Addis Abeba', 31, 3),('El Cairo', 32, 3),('Alejandr�a', 32, 3),('Kinshasa', 33, 3),('Lubumbashi', 33, 3),('Ciudad del Cabo', 34, 3),('Johannesburgo', 34, 3);


--####################################### TABLA USERS #######################################
SET NOCOUNT ON

DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN
    SET NOCOUNT ON

	INSERT INTO [dbo].[users]
				([username]
				,[email]
				,[password]
				,[region_id])
			VALUES
				('User' + CONVERT(VARCHAR(10), @Counter)
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
    ('Tecnolog�a', 'Videos sobre gadgets, aplicaciones y avances tecnol�gicos.'),
    ('Moda', 'Videos sobre tendencias de moda y estilo.'),
    ('Deportes', 'Videos relacionados con deportes y competiciones.'),
    ('Cine y TV', 'Videos sobre pel�culas, series y programas de televisi�n.'),
    ('Educaci�n', 'Videos educativos y acad�micos.'),
    ('Ciencia y Tecnolog�a', 'Videos sobre ciencia, innovaci�n y descubrimientos.'),
    ('Arte y Dise�o', 'Videos sobre arte, dise�o y creatividad.'),
    ('Negocios', 'Videos sobre emprendimiento, finanzas y negocios.'),
    ('Automotriz', 'Videos relacionados con el mundo del autom�vil y la mec�nica.'),
    ('Mascotas', 'Videos sobre mascotas, cuidado animal y entrenamiento.'),
    ('Fotograf�a', 'Videos sobre t�cnicas, equipo y consejos de fotograf�a.'),
    ('Medio ambiente', 'Videos sobre conservaci�n, ecolog�a y medio ambiente.');


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
INSERT INTO @OperatingSystems VALUES ('Windows'), ('iOS'), ('Android'), ('Linux');

DECLARE @Models TABLE (Model VARCHAR(100));
INSERT INTO @Models VALUES ('Galaxy S24'), ('iPhone 15'), ('Surface Pro'), ('Pixel 5');

WHILE @RowCount3 <= 100  -- Cambia este valor al n�mero deseado de registros
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

WHILE @RowCount4 <= 1000
BEGIN
    SET NOCOUNT ON

    DECLARE @UserID INT = (CAST(RAND() * 1000 AS INT) % 1000) + 1;

    DECLARE @ContentID INT = (CAST(RAND() * 1000 AS INT) % 1000) + 1;

    DECLARE @StartDate DATETIME = '2020-01-01';
    DECLARE @EndDate DATETIME = '2020-12-31';
    DECLARE @RandomDays INT = CAST(RAND() * DATEDIFF(day, @StartDate, @EndDate) AS INT);
    DECLARE @Timestamp DATETIME = DATEADD(day, @RandomDays, @StartDate);

    DECLARE @DeviceID INT = (CAST(RAND() * 100 AS INT) % 100) + 1;

    DECLARE @Resolutions TABLE (Resolution VARCHAR(15));
    INSERT INTO @Resolutions VALUES ('7680x4320'), ('3840x2160'), ('2560x1440'), ('1920x1080'), ('1280x720'), ('854x480'), ('640x360'), ('426x240');
    DECLARE @Resolution VARCHAR(15);
    SELECT TOP 1 @Resolution = Resolution FROM @Resolutions ORDER BY NEWID();

    DECLARE @Duration INT = (CAST(RAND() * 3600 AS INT) % 3600) + 1;
    DECLARE @RatingValue INT = (CAST(RAND() * 5 AS INT) % 5) + 1;

    INSERT INTO plays (user_id, content_id, device_id, resolution, duration, rating_value)
    VALUES (@UserID, @ContentID, @DeviceID, @Resolution, @Duration, @RatingValue);

    -- Incrementar el contador
    SET @RowCount4 = @RowCount4 + 1;
END;

--##########################tabla de horario espectadores#######################
-- Declaración de variables
DECLARE @RowCount INT = 1;
DECLARE @TotalRows INT = 1000; -- Cambia este valor según la cantidad de filas que desees insertar

-- Bucle para insertar filas en la tabla
WHILE @RowCount <= @TotalRows
BEGIN
    -- Generar valores aleatorios para hora_dia
    DECLARE @HoraDia VARCHAR(15);
    SET @HoraDia = CONVERT(VARCHAR(2), CAST(RAND() * 23 AS INT)) + ':' + RIGHT('00' + CONVERT(VARCHAR(2), CAST(RAND() * 59 AS INT)), 2);

    -- Generar valores aleatorios para fechaSuscripcion
    DECLARE @FechaSuscripcion DATE;
    SET @FechaSuscripcion = DATEADD(day, -CAST(RAND() * 365 AS INT), GETDATE()); -- Retrocede hasta un año desde la fecha actual

    -- Generar valores aleatorios para cantidad_espectadores
    DECLARE @CantidadEspectadores INT;
    SET @CantidadEspectadores = CAST(RAND() * 1000 AS INT); -- Número aleatorio entre 0 y 999

    -- Generar valores aleatorios para region_id (asumiendo que existe una tabla regions)
    DECLARE @RegionID INT;
    SET @RegionID = (SELECT TOP 1 region_id FROM regions ORDER BY NEWID());

    -- Insertar fila en la tabla horario_expectadores
    INSERT INTO horario_expectadores (hora_dia, fechaSuscripcion, cantidad_espectadores, region_id)
    VALUES (@HoraDia, @FechaSuscripcion, @CantidadEspectadores, @RegionID);

    -- Incrementar contador
    SET @RowCount = @RowCount + 1;
END;
