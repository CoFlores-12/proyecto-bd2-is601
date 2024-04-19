
IF EXISTS (SELECT name FROM master.sys.databases WHERE name = N'proyectobd2WH')
	 use master
	 alter database proyectobd2WH set single_user with rollback immediate

	 drop database proyectobd2WH
GO

-- Crear la base de datos multidimensional
CREATE DATABASE proyectobd2WH;
GO

-- Utilizar la base de datos multidimensional
USE proyectobd2WH;
GO

-- Tablas de Dimensiones
CREATE TABLE DIM_content (
    --content
    content_id INT PRIMARY KEY,
    title_content VARCHAR(50),
    description_content VARCHAR(100),
    release_date DATE,
    --
    category_id INT,
	title_category VARCHAR(50),
    description_category VARCHAR(100)
)

CREATE TABLE DIM_users(
    --user
    user_id INT PRIMARY KEY,
    fechaSuscripcion DATE,
    edad INT,
    --suscripcion
	descripcionSuscripcion VARCHAR(20),
	precioSuscripcion DECIMAL(4, 2),
    --region
    ciudad VARCHAR(100),
	pais VARCHAR(100),
	continente VARCHAR(100),
)
GO

CREATE TABLE DIM_devices (
    device_id INT PRIMARY KEY,
    SO VARCHAR(50),
	model VARCHAR(100)
)
GO


-- Tabla de Hechos (Fact Table)
CREATE TABLE HECH_Plays (
    --plays
    play_id INT PRIMARY KEY,
    --users
    user_id INT FOREIGN KEY REFERENCES DIM_users(user_id),
    --content
    content_id INT FOREIGN KEY REFERENCES DIM_content(content_id),
    --devices
    device_id int FOREIGN KEY REFERENCES DIM_devices(device_id),
	fechaHoraPlay DATETIME,
	rating_value FLOAT CHECK (rating_value >= 0.0 AND rating_value <= 5.0)	
);
GO