IF EXISTS (SELECT name FROM master.sys.databases WHERE name = N'proyectobd2')
	 use master
	 alter database proyectobd2 set single_user with rollback immediate

	 drop database proyectobd2
GO

CREATE DATABASE proyectobd2
GO

USE proyectobd2
GO

-- Tabla de Regiones
CREATE TABLE regions (
    region_id INT PRIMARY KEY IDENTITY(1,1),
    region_name VARCHAR(100) NOT NULL,
    parent_id INT,
    region_level INT NOT NULL -- Nivel en la jerarquía (1 para continente, 2 para país, 3 para estado)
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
    title VARCHAR(50) NOT NULL,
    description VARCHAR(100)
)
GO

-- Tabla de Contenido
CREATE TABLE content (
    content_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(50) NOT NULL,
    description VARCHAR(100),
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
	resolution VARCHAR(15), --  7680×4320, 3840x2160, 2560×1440, 1920x1080, 1280x720, 854×480, 640×360, 426x240
    duration INT,
	rating_value INT CHECK (rating_value >= 1 AND rating_value <= 5)
)
GO

IF EXISTS (SELECT name FROM master.sys.databases WHERE name = N'proyectobd2Out')
	 use master
	 alter database proyectobd2Out set single_user with rollback immediate

	 drop database proyectobd2Out
GO

-- Crear la base de datos multidimensional
CREATE DATABASE proyectobd2Out;
GO

-- Utilizar la base de datos multidimensional
USE proyectobd2Out;
GO

-- Tablas de Dimensiones
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    ciudad VARCHAR(100),
	pais VARCHAR(100),
	continente VARCHAR(100)
);

CREATE TABLE Devices (
    device_id INT PRIMARY KEY,
    SO VARCHAR(50),
    model VARCHAR(100)
);

CREATE TABLE content (
    content_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(50) NOT NULL,
    description VARCHAR(100),
    release_date DATE,
	titlecat VARCHAR(50),
    descriptioncat VARCHAR(100)
)
GO

-- Tabla de Hechos (Fact Table)
CREATE TABLE Plays (
    play_id INT PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES users(user_id),
    content_id INT FOREIGN KEY REFERENCES content(content_id),
    device_id INT FOREIGN KEY REFERENCES devices(device_id),
    resolution VARCHAR(15),
    duration INT,
	rating_value INT CHECK (rating_value >= 1 AND rating_value <= 5)
);
GO


