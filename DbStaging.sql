CREATE DATABASE proyectoStaging
GO

CREATE TABLE suscripciones(
	subscripcionId INT IDENTITY PRIMARY KEY,
	descripcion VARCHAR(20),
	precio DECIMAL(3, 2)
)

CREATE TABLE regiones(
	regionId INT IDENTITY PRIMARY KEY,
	descripcion VARCHAR(15),
)

CREATE TABLE paises(
	paisId INT IDENTITY PRIMARY KEY,
	nombre VARCHAR(20),
	regionId INT,
	FOREIGN KEY (regionId) REFERENCES regiones(regionId)
)

CREATE TABLE usuario(
	usuarioId INT IDENTITY PRIMARY KEY,
	nombre VARCHAR(15),
	apellido VARCHAR(15),
	suscripcionId INT,
	fechaSuscripcion DATE,
	edad INT,
	paisId INT,
	FOREIGN KEY (suscripcionId) REFERENCES suscripciones(subscripcionId),
	FOREIGN KEY (paisId) REFERENCES paises(paisId)
)

CREATE TABLE categorias(
	categoriaId INT IDENTITY PRIMARY KEY,
	nombreCategoria VARCHAR(15)
)

CREATE TABLE Videos(
	videoId INT IDENTITY PRIMARY KEY,
	nombre VARCHAR(20),
	descripcion VARCHAR(50),
	fechaSubida DATE,
	vistas INT
)

CREATE TABLE CategoriaVideo(
	videoId INT,
	categoriaId INT,
	PRIMARY KEY (videoId, categoriaId),
	FOREIGN KEY (videoId) REFERENCES Videos(videoId),
	FOREIGN KEY (categoriaId) REFERENCES Categorias(categoriaId)
)

CREATE TABLE RatingVideo(
	videoId INT,
	usuarioId INT,
	rating INT,
	PRIMARY KEY (videoId, usuarioId),
	FOREIGN KEY (videoId) REFERENCES Videos(videoId),
	FOREIGN KEY (usuarioId) REFERENCES usuario(usuarioId),
	CONSTRAINT rating_chk CHECK(rating > 0 AND rating < 5)
)

CREATE TABLE UsuarioVideo(
	usuarioVideoId INT IDENTITY PRIMARY KEY,
	usuarioId INT,
	videoId INT,
	fechaVista DATE,
	FOREIGN KEY (videoId) REFERENCES Videos(videoId),
	FOREIGN KEY (usuarioId) REFERENCES usuario(usuarioId)
)
