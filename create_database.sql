CREATE DATABASE cisco;
USE cisco;

CREATE TABLE Carreras (
    idCarrera INT PRIMARY KEY AUTO_INCREMENT,
    nombreCarrera VARCHAR(100) NOT NULL,
    tiempoLimiteDiario TIME NOT NULL CHECK (tiempoLimiteDiario > "00:00:00")
);

CREATE TABLE Institutos (
    idInstituto INT PRIMARY KEY AUTO_INCREMENT,
    nombreOficial VARCHAR(100) NOT NULL,
    nombreAbreviado VARCHAR(100) NOT NULL
);

CREATE TABLE Laboratorios (
    idLaboratorio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    contraseñaMaestra VARCHAR(100) NOT NULL,
    idInstituto INT NOT NULL,
    FOREIGN KEY (idInstituto) REFERENCES Institutos(idInstituto)
);

CREATE TABLE PrestamosPorDia (
    idPrestamoPorDia INT PRIMARY KEY AUTO_INCREMENT,
    inicioServicio TIME NOT NULL,
    finServicio TIME NOT NULL,
    fecha DATE NOT NULL,
    idLaboratorio INT NOT NULL,
    FOREIGN KEY(idLaboratorio) REFERENCES Laboratorios(idLaboratorio),
    CHECK(inicioServicio < finServicio)
);

CREATE TABLE Software (
    idSoftware INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(400)
);

CREATE TABLE Computadoras (
    direccionIp VARCHAR(15) PRIMARY KEY,
    numeroMaquina INT NOT NULL CHECK (numeroMaquina > 0),
    estatus ENUM("Disponible", "Ocupada") NOT NULL DEFAULT "Disponible",
    nombreReservante VARCHAR(100) DEFAULT "Disponible",
    idLaboratorio INT NOT NULL,
    FOREIGN KEY (idLaboratorio) REFERENCES Laboratorios(idLaboratorio)
);

CREATE TABLE ComputadoraSoftware (
	idComputadoraSoftware INT PRIMARY KEY AUTO_INCREMENT,
    idComputadora VARCHAR(15) NOT NULL,
    idSoftware INT NOT NULL,
    FOREIGN KEY (idComputadora) REFERENCES Computadoras(direccionIp),
    FOREIGN KEY (idSoftware) REFERENCES Software(idSoftware)
);

CREATE TABLE Estudiantes (
    idEstudiante INT PRIMARY KEY AUTO_INCREMENT,
    nombres VARCHAR(100) NOT NULL,
    apellidoPaterno VARCHAR(100) NOT NULL,
    apellidoMaterno VARCHAR(100) NOT NULL,
    contraseñaAcceso VARCHAR(100) NOT NULL,
    estatusInscripcion ENUM("Activo", "Inactivo") NOT NULL DEFAULT "Activo",
    idCarrera INT NOT NULL,
    FOREIGN KEY (idCarrera) REFERENCES Carreras(idCarrera)
);

CREATE TABLE Bloqueos (
    idBloqueo INT PRIMARY KEY AUTO_INCREMENT,
    inicioBloqueo DATETIME NOT NULL,
    finBloqueo DATETIME,
    motivo VARCHAR(400) NOT NULL,
    idEstudiante INT NOT NULL,
    estatusBloqueo ENUM("Pendiente", "Liberado") NOT NULL DEFAULT "Pendiente",
    FOREIGN KEY (idEstudiante) REFERENCES Estudiantes(idEstudiante),
    CHECK(finBloqueo > inicioBloqueo)
);

CREATE TABLE Prestamos (
    idPrestamo INT PRIMARY KEY AUTO_INCREMENT,
    inicioPrestamo TIME NOT NULL,
    finPrestamo TIME NOT NULL,
    idComputadora VARCHAR(15) NOT NULL,
    idEstudiante INT NOT NULL,
    idPrestamoPorDia INT NOT NULL,
    FOREIGN KEY (idComputadora) REFERENCES Computadoras(direccionIP),
    FOREIGN KEY (idEstudiante) REFERENCES Estudiantes(idEstudiante),
    FOREIGN KEY (idPrestamoPorDia) REFERENCES PrestamosPorDia(idPrestamoPorDia),
    CHECK(finPrestamo > inicioPrestamo)
);