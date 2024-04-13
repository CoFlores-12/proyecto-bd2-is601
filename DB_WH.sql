
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
CREATE TABLE content (
    content_id INT PRIMARY KEY IDENTITY(1,1),
    title_content VARCHAR(50) NOT NULL,
    description_content VARCHAR(100),
    release_date DATE,
	title_category VARCHAR(50),
    description_category VARCHAR(100)
)
GO

-- Tabla de Hechos (Fact Table)
CREATE TABLE Plays (
    play_id INT PRIMARY KEY,
    user_id INT,
    username VARCHAR(50),
    email VARCHAR(100),
    ciudad VARCHAR(100),
	pais VARCHAR(100),
	continente VARCHAR(100),
    content_id INT FOREIGN KEY REFERENCES content(content_id),
    device_id int,
    SO VARCHAR(50),
    model VARCHAR(100),
    resolution VARCHAR(15),
    duration INT,
	rating_value INT CHECK (rating_value >= 1 AND rating_value <= 5)
);
GO