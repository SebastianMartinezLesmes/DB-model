CREATE DATABASE IF NOT EXISTS test;
USE test;

CREATE TABLE roles (
    idRol INT AUTO_INCREMENT PRIMARY KEY,
    nombreRol VARCHAR(200) NOT NULL
);

CREATE TABLE usuarios (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nombreUsuario VARCHAR(50) NOT NULL,
    apellidoUsuario VARCHAR(50) NOT NULL,
    contraseñaUsuario VARCHAR(100) NOT NULL,
    idRol INT,
    FOREIGN KEY (idRol) REFERENCES roles(idRol)
);

-- Inserciones de los datos
-- roles
INSERT INTO roles (nombreRol) VALUES ('super_admin');
INSERT INTO roles (nombreRol) VALUES ('admin');
INSERT INTO roles (nombreRol) VALUES ('usuario');

-- usuarios
INSERT INTO usuarios (nombreUsuario, apellidoUsuario, contraseñaUsuario, idRol) 
VALUES 
    ('Super', 'Admin', 'password', 1), -- super_admin
    ('Admin1', 'Apellido', 'password', 2), ('Admin2', 'Apellido', 'password', 2), -- admins
    ('Usuario1', 'Apellido', 'password', 3), ('Usuario2', 'Apellido', 'password', 3), -- usuarios
    ('Usuario3', 'Apellido', 'password', 3), ('Usuario4', 'Apellido', 'password', 3), -- usuarios
    ('Usuario5', 'Apellido', 'password', 3), ('Usuario6', 'Apellido', 'password', 3), -- usuarios
    ('Usuario7', 'Apellido', 'password', 3), ('Usuario8', 'Apellido', 'password', 3); -- usuarios

-- Validacion de campos antes de la inserción en la tabla 'usuarios' 
-- para asegurarse de que no se inserten usuarios con el mismo 'nombreUsuario'

CREATE TRIGGER before_insert_usuario
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    DECLARE cnt INT;
    -- Verificar si el nombreUsuario ya existe
    SELECT COUNT(*) INTO cnt 
    FROM usuarios 
    WHERE nombreUsuario = NEW.nombreUsuario;
    
    IF cnt > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre de usuario ya existe';
    END IF;
END;

DELIMITER //

-- permitirá insertar un nuevo usuario en la tabla 'usuarios' validando la existencia del rol especificado

CREATE PROCEDURE insertar_usuario (
    IN p_nombreUsuario VARCHAR(50),
    IN p_apellidoUsuario VARCHAR(50),
    IN p_contraseñaUsuario VARCHAR(100),
    IN p_idRol INT
)
BEGIN
    DECLARE rol_existente INT;
    
    -- Verificar si el rol existe
    SELECT COUNT(*) INTO rol_existente
    FROM roles
    WHERE idRol = p_idRol;
    
    IF rol_existente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El rol especificado no existe';
    ELSE
        -- Insertar el nuevo usuario
        INSERT INTO usuarios (nombreUsuario, apellidoUsuario, contraseñaUsuario, idRol)
        VALUES (p_nombreUsuario, p_apellidoUsuario, p_contraseñaUsuario, p_idRol);
    END IF;
END //

DELIMITER ;
