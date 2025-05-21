-- Crear la base de datos
DROP DATABASE IF  EXISTS usuarios_db;
CREATE DATABASE IF NOT EXISTS usuarios_db;

-- Usar la base de datos creada
USE usuarios_db;

-- Crear la tabla de roles
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Insertar roles
INSERT INTO roles (nombre) VALUES
('Admin'),
('Editor'),
('Usuario');

-- Crear la tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    email VARCHAR(100),
    edad INT,
    ciudad VARCHAR(100),
    id_rol INT,
    FOREIGN KEY (id_rol) REFERENCES roles(id)
);

-- Insertar usuarios
INSERT INTO usuarios (nombre, apellido, email, edad, ciudad, id_rol) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', 30, 'Madrid', 1),
('Ana', 'García', NULL, 25, 'Barcelona', 2),
('Carlos', 'López', 'carlos.lopez@example.com', NULL, 'Sevilla', 3),
('María', 'Rodríguez', 'maria.rodriguez@example.com', 28, NULL, 1),
('Luis', NULL, 'luis@example.com', 35, 'Valencia', 2);

-- Consultar a todos los usuarios
SELECT * FROM usuarios;

-- Consulta INNER JOIN para obtener usuarios y sus roles
SELECT usuarios.nombre, usuarios.apellido, usuarios.email, usuarios.edad, usuarios.ciudad, roles.nombre AS rol
FROM usuarios
INNER JOIN roles ON usuarios.id_rol = roles.id;

-----------------------------------------------------------------------------

-- Contar el número de usuarios
SELECT COUNT(*) AS total_usuarios FROM usuarios;

-- Buscar usuarios por ciudad
DELIMITER $$
CREATE PROCEDURE find_users_city (
    IN p_ciudad VARCHAR(100)
)
BEGIN
    SELECT * FROM usuarios WHERE ciudad = p_ciudad;
END $$
DELIMITER ;
-- CALL find_users_city ('madrid')

-- Actualizar la información de un usuario
DELIMITER $$
CREATE PROCEDURE update_lastName_by_id (
    IN p_id INT,
    IN p_lastName VARCHAR(100)
)
BEGIN
    UPDATE usuarios SET apellido = p_lastName WHERE id = p_id;
END $$
DELIMITER ;
-- CALL update_lastName(#,'')

-- Eliminar un usuario por su ID
DELIMITER $$
CREATE PROCEDURE delete_user (
    IN p_id INT
)
BEGIN
    DELETE FROM usuarios WHERE id = p_id;
END $$
DELIMITER ;
CALL delete_user (2)