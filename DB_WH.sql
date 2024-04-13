IF EXISTS (SELECT name FROM master.sys.databases WHERE name = N'proyectobd2WH')
	 use master
	 alter database proyectobd2WH set single_user with rollback immediate

	 drop database proyectobd2WH
GO

CREATE DATABASE proyectobd2WH
GO

USE proyectobd2WH
GO

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
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
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
	rating_value INT CHECK (rating_value >= 1 AND rating_value <= 5)
)
GO