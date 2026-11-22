DROP DATABASE IF EXISTS cubos_de_Rubik;
CREATE DATABASE cubos_de_Rubik
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Selecciona la base de datos para empezar a crear tablas dentro de ella
USE cubos_de_Rubik;

CREATE TABLE Usuarios(
    nombre VARCHAR(100) PRIMARY KEY,
    contrasena VARCHAR(20),
    rol VARCHAR(100) NOT NULL
);

CREATE TABLE TipoCubo(
	id_Tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    forma VARCHAR(100) NOT NULL,
    mejorTiempo DECIMAL(10, 2)
);

CREATE TABLE Soluciones(
	id_Solucion INT AUTO_INCREMENT PRIMARY KEY,
    cubo_solucion VARCHAR(100) NOT NULL,
    id_Tipo INT NOT NULL,
    CONSTRAINT fk_Soluciones_TipoCubo
		FOREIGN KEY(id_Tipo)
        REFERENCES TipoCubo(id_Tipo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE RECORDS(
	nombre VARCHAR(100),
    id_Tipo INT,
    tiempo_solucion DECIMAL(10, 2) NOT NULL,
    fecha_solucion datetime,
    PRIMARY KEY(nombre,id_Tipo,fecha_solucion),
    CONSTRAINT fk_Usuarios_idUsuario
		FOREIGN KEY(nombre)
        REFERENCES Usuarios(nombre)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
	CONSTRAINT fk_TipoCubo_idTipo
		FOREIGN KEY(id_Tipo)
        REFERENCES TipoCubo(id_Tipo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);



DELIMITER //

CREATE TRIGGER tr_calcular_mejor_tiempo
AFTER INSERT ON RECORDS
FOR EACH ROW
BEGIN
    UPDATE TipoCubo
    SET mejorTiempo = (
        SELECT MIN(tiempo_solucion)
        FROM RECORDS
        WHERE id_Tipo = NEW.id_Tipo
    )
    WHERE id_Tipo = NEW.id_Tipo;
END //

DELIMITER ;
