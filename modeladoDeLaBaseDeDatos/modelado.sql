
-- creamos la base de datos para la plataforma de peliculas

CREATE DATABASE app_data;

-- TABLAS SIN CLAVES FORANEAS

-- primero crearemos las tablas que no tienen una clave foranea
-- para evitar problemas al crear la base de datos

-- una tabla para almacenar los datos de los usuarios

CREATE TABLE cliente (
  id_cliente SERIAL PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL,
  apellido VARCHAR(30),
  nombre_usuario VARCHAR(250) UNIQUE NOT NULL,
  correo_electronico VARCHAR(250) UNIQUE NOT NULL,
  activo BOOLEAN NOT NULL,
  fecha_registro TIMESTAMP NOT NULL
);

-- una tabla para almacenar los datos de las peliculas

CREATE TABLE pelicula (
  id_pelicula SERIAL PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  descripcion TEXT,
  direccion_url TEXT UNIQUE NOT NULL,
  portada_url TEXT UNIQUE NOT NULL,
  duracion INT NOT NULL,
  año_estreno INT NOT NULL,
  fecha_registro TIMESTAMP NOT NULL
);

-- una tabla para almacenar los datos de los actores que participaron 
-- en las peliculas

CREATE TABLE actor (
  id_actor SERIAL PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL,
  apellido VARCHAR(30) NOT NULL
);

-- una tabla para almacenar las clasificacion que puede tener cada pelicula

CREATE TABLE clasificacion (
  id_clasificacion SERIAL PRIMARY KEY,
  clasificacion VARCHAR(30) UNIQUE NOT NULL
);

-- una tabla para almacenar los idiomas de las diferentes peliculas

CREATE TABLE idioma (
  id_idioma SERIAL PRIMARY KEY,
  idioma VARCHAR(30) UNIQUE NOT NULL
);

-- TABLAS QUE CUENTAN CON CLAVES FORANEAS

-- una tabla para almacenar las peliculas que vieron los clientes

CREATE TABLE cliente_pelicula (
  id_cliente INT,
  id_pelicula INT,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
  ON UPDATE CASCADE
  ON DELETE CASCADE,
  FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
  ON UPDATE CASCADE
  ON DELETE CASCADE
);

-- una tabla para almacenar las peliculas donde participo los actores

CREATE TABLE actor_pelicula (
  id_actor INT,
  id_pelicula INT,
  FOREIGN KEY (id_actor) REFERENCES actor(id_actor)
  ON UPDATE CASCADE
  ON DELETE CASCADE,
  FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
  ON UPDATE CASCADE
  ON DELETE CASCADE
);

-- una tabla para almacenar las peliculas con sus clasificaciones

CREATE TABLE clasificacion_pelicula (
  id_clasificacion INT,
  id_pelicula INT,
  FOREIGN KEY (id_clasificacion) REFERENCES clasificacion(id_clasificacion)
  ON UPDATE CASCADE
  ON DELETE CASCADE,
  FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
  ON UPDATE CASCADE
  ON DELETE CASCADE
);

-- una tabla para almacenar las peliculas que estan en diferentes idiomas

CREATE TABLE idioma_pelicula (
  id_idioma INT,
  id_pelicula INT,
  FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma)
  ON UPDATE CASCADE
  ON DELETE CASCADE,
  FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula)
  ON UPDATE CASCADE
  ON DELETE CASCADE
);


CREATE FUNCTION insertar_cliente(
    nombre VARCHAR,
    apellido VARCHAR,
    edad INT,
    nombre_usuario VARCHAR,
    correo_electronico VARCHAR,
    activo BOOLEAN
) 
RETURNS VOID AS $$
BEGIN
    INSERT INTO cliente (nombre, apellido, edad, nombre_usuario, correo_electronico, activo, ultima_actualizacion)
    VALUES (nombre, apellido, edad, nombre_usuario, correo_electronico, activo, NOW());
END;
$$ LANGUAGE plpgsql;






// 1. Insertar un nuevo cliente
db.clientes.insertOne({
    "nombre": "Ana",
    "apellido": "García",
    "nombre_usuario": "anagarcia",
    "correo_electronico": "anagarcia@example.com",
    "activo": true,
    "fecha_registro": new Date()
});

// 2. Encontrar un cliente por nombre de usuario
db.clientes.findOne({"nombre_usuario": "juanperez"});

// 3. Actualizar el estado activo de un cliente
db.clientes.updateOne({"nombre_usuario": "juanperez"}, {$set: {"activo": false}});

// 4. Eliminar un cliente por ID
db.clientes.deleteOne({"id_cliente": 1});

// 5. Insertar una nueva película
db.peliculas.insertOne({
    "titulo": "Pelicula 2",
    "descripcion": "Descripción de la película 2",
    "direccion_url": "http://example.com/pelicula2",
    "portada_url": "http://example.com/portada2",
    "duracion": 150,
    "año_estreno": 2024,
    "fecha_registro": new Date()
});

// 6. Encontrar una película por título
db.peliculas.findOne({"titulo": "Pelicula 1"});

// 7. Actualizar la duración de una película
db.peliculas.updateOne({"titulo": "Pelicula 1"}, {$set: {"duracion": 130}});

// 8. Eliminar una película por ID
db.peliculas.deleteOne({"id_pelicula": 1});

// 9. Agregar un actor a una película
db.peliculas.updateOne({"titulo": "Pelicula 2"}, {$push: {"actores": {"id_actor": 2, "nombre": "Actor 2", "apellido": "Apellido 2"}}});

// 10. Agregar una clasificación a una película
db.peliculas.updateOne({"titulo": "Pelicula 2"}, {$push: {"clasificaciones": {"id_clasificacion": 2, "clasificacion": "R"}}});

// 11. Agregar un idioma a una película
db.peliculas.updateOne({"titulo": "Pelicula 2"}, {$push: {"idiomas": {"id_idioma": 2, "idioma": "Inglés"}}});

// 12. Encontrar todas las películas vistas por un cliente
db.clientes.findOne({"nombre_usuario": "juanperez"}, {"peliculas_vistas": 1});

// 13. Agregar una película vista a un cliente
db.clientes.updateOne({"nombre_usuario": "anagarcia"}, {$push: {"peliculas_vistas": {"id_pelicula": 2, "titulo": "Pelicula 2", "fecha_vista": new Date()}}});

// 14. Encontrar todas las películas de un actor
db.peliculas.find({"actores.id_actor": 1});

// 15. Encontrar todas las películas con una clasificación específica
db.peliculas.find({"clasificaciones.clasificacion": "PG-13"});

// 16. Encontrar todas las películas en un idioma específico
db.peliculas.find({"idiomas.idioma": "Español"});

// 17. Contar el número de clientes activos
db.clientes.countDocuments({"activo": true});

// 18. Contar el número de películas de un año específico
db.peliculas.countDocuments({"año_estreno": 2023});

// 19. Actualizar la dirección URL de una portada de película
db.peliculas.updateOne({"titulo": "Pelicula 2"}, {$set: {"portada_url": "http://example.com/nueva_portada2"}});

// 20. Eliminar una película vista de un cliente
db.clientes.updateOne({"nombre_usuario": "juanperez"}, {$pull: {"peliculas_vistas": {"id_pelicula": 1}}});
























