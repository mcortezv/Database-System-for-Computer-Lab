-- 1. Realiza la consulta para saber de los laboratorios cuantas ----------------------------------------------------------------
-- computadoras tienen y de manera adicional saber la información de la
-- universidad a la cual pertenecen, se desea que estén ordenados por el
-- nombre del laboratorio de forma descendiente.
   -- Datos a mostrar
     -- nombreInstitucion
     -- alias
     -- idLaboratorio
	 -- nombreLaboratorio
     -- cantidadComputadoras
     -- Realizado por Leonel Carballo

USE cisco;

SELECT 
    i.nombreOficial AS NombreInstitucion,
    i.nombreAbreviado AS Alias,
    l.idLaboratorio,
    l.nombre AS NombreLaboratorio,
    COUNT(c.direccionIp) AS CantidadComputadoras
FROM 
    Institutos AS i
INNER JOIN
    laboratorios AS l ON l.idInstituto = i.idInstituto
INNER JOIN
    computadoras AS c ON c.idLaboratorio = l.idLaboratorio
GROUP BY
    i.nombreOficial,
    i.nombreAbreviado,
    l.idLaboratorio,
    l.nombre
ORDER BY
    l.nombre DESC;


-- 2. Realiza la consulta para saber de cada carrera cuantos alumnos ------------------------------------------------------------
-- inscritos tienen actualmente, se desea que estén ordenados por 
-- nombre de la carrera de forma descendiente seguido del nombre del 
-- alumno. 
-- Realizado por Manuel Cortez

USE cisco;

SELECT
    c.nombreCarrera,
    COUNT(e.idEstudiante) AS CantidadAlumnos
FROM carreras AS c
LEFT JOIN estudiantes AS e ON c.idCarrera = e.idCarrera
GROUP BY c.nombreCarrera
ORDER BY c.nombreCarrera DESC;


-- 3. Realiza la consulta para saber cuántos apartados por fecha en lo que va ---------------------------------------------------
-- del año (no hardcore) cuenta el laboratorio CISCO, ordena la
-- información por la fecha de forma descendiente.
   -- Datos a mostrar
     -- fecha
     -- cantidadApartados
     -- Realizado por Leonel Carballo

SELECT
    pd.fecha,
    COUNT(pd.idPrestamoPorDia) AS CantidadApartados
FROM prestamosPorDia AS pd
INNER JOIN laboratorios AS l ON l.idLaboratorio = pd.idLaboratorio
WHERE l.nombre = "CISCO" AND YEAR(pd.fecha) = YEAR(CURDATE())
GROUP BY pd.fecha
ORDER BY pd.fecha DESC;


-- 4. Realiza la consulta para saber cuántos apartados por fecha en lo que ----------------------------------------------------
-- van del año (no hardcore) tiene cada carrera en el laboratorio CISCO, 
-- ordena la información por el nombre de la carrera de forma ascendente 
-- seguido de la fecha de forma descendiente. 
-- Realizado por Manuel Cortez

USE cisco;

SELECT
    c.nombreCarrera,
    porDia.fecha,
    COUNT(porDia.idPrestamoPorDia) AS CantidadApartados
FROM prestamospordia AS porDia
INNER JOIN prestamos AS p ON porDia.idPrestamoPorDia = p.idPrestamoPordia
INNER JOIN estudiantes AS e ON p.idEstudiante = e.idEstudiante
INNER JOIN carreras AS c ON e.idCarrera = c.idCarrera
INNER JOIN laboratorios AS l ON porDia.idLaboratorio = l.idLaboratorio
WHERE
	porDia.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) AND porDia.fecha <= CURDATE() AND
	l.nombre = "CISCO"
GROUP BY c.nombreCarrera, porDia.fecha
ORDER BY c.nombreCarrera ASC, porDia.fecha DESC;


-- 5. Realiza la consulta para saber qué carrera es la que tiene más apartados ------------------------------------------------
-- en lo que va del año (no hardcore) en CISCO y en qué fecha sucedió.
   -- Datos a mostrar
     -- nombreCarrera
     -- fecha
     -- cantidadApartados
     -- Realizado por Leonel Carballo

USE cisco;

SELECT
	c.nombreCarrera,
    pd.fecha,
    COUNT(p.idPrestamoPorDia) AS CantidadApartados
FROM
    carreras AS c
INNER JOIN
    estudiantes AS e ON e.idCarrera = c.idCarrera
INNER JOIN
    prestamos AS p ON p.idEstudiante = e.idEstudiante
INNER JOIN
    prestamosPorDia AS pd ON pd.idPrestamoPorDia = p.idPrestamoPorDia
INNER JOIN
	laboratorios AS l ON l.idLaboratorio = pd.idLaboratorio
WHERE
    YEAR(pd.fecha) = YEAR(CURDATE())  
GROUP BY
	pd.fecha,
    p.idPrestamoPorDia,
    c.nombreCarrera
ORDER BY 
    CantidadApartados DESC
LIMIT 1;


-- 6. Realiza la consulta para saber en qué fecha el cisco tuvo menos ---------------------------------------------------
-- minutos de apartados de sus computadoras.
-- Realizado por Manuel Cortez

USE cisco;

SELECT
    porDia.fecha,
    SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosActividad,
    TIMESTAMPDIFF(MINUTE, porDia.inicioServicio, porDia.finServicio) - SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosDeInactividad
FROM prestamosPorDia AS porDia
LEFT JOIN prestamos AS p ON porDia.idPrestamoPorDia = p.idPrestamoPorDia
GROUP BY porDia.fecha, porDia.inicioServicio, porDia.finServicio
ORDER BY MinutosActividad ASC
LIMIT 1;


-- 7. Basado del punto 6 dime cuales fueron las dos carreras que tuvieron ---------------------------------------------
-- menos minutos de apartados.
   -- Datos a mostrar
     -- fecha
     -- nombreCarrera
     -- minutosActividad
     -- minutosInactividad
	 -- Realizado por Leonel Carballo

USE cisco;

SELECT
    pd.fecha,
    c.nombreCarrera,
    SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosActividad,
    SUM(TIMESTAMPDIFF(MINUTE, pd.inicioServicio, pd.finServicio)) - SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosInactividad
FROM 
    prestamospordia AS pd
INNER JOIN 
    prestamos AS p ON pd.idPrestamoPorDia = p.idPrestamoPorDia
INNER JOIN
    estudiantes AS e ON e.idEstudiante = p.idEstudiante
INNER JOIN 
    carreras AS c ON c.idCarrera = e.idCarrera
GROUP BY 
    pd.fecha, c.nombreCarrera
ORDER BY 
    MinutosActividad ASC
LIMIT 2;


-- 8. Realiza la consulta para indicarme los alumnos y que bloqueos tienen, ------------------------------------------
-- ordena la información por la fecha de forma descendiente seguido del 
-- nombre del alumno de forma ascendiente.
-- Realizado por Manuel Cortez

USE cisco;

SELECT
	b.inicioBloqueo AS FechaBloqueo,
	CONCAT(e.nombres, " ", e.apellidoPaterno, " ", e.apellidoMaterno) AS NombreCompleto,
	m.descripcionMotivo AS Motivo,
    COALESCE(b.finBloqueo, "N/A") AS FechaLiberacion
FROM estudiantes AS e
INNER JOIN bloqueos AS b ON e.idEstudiante = b.idEstudiante
INNER JOIN motivos AS m ON b.idMotivo = m.idMotivo
ORDER BY b.inicioBloqueo DESC, e.nombres ASC;


-- 9. Realiza la consulta para indicarme las 5 computadoras que en el último ------------------------------------------
-- mes tiene más apartados e indica la cantidad de apartados por carrera,
-- ordénalos por la cantidad de apartados de forma descendiente.
   -- Datos a mostrar
     -- ip
     -- numero
     -- software (separado por comas)
     -- carrera
     -- cantidadApartados    
     -- Realizado por Leonel Carballo
 
USE cisco;

SELECT
    comp.direccionIP AS IP,
    comp.numeroMaquina AS Numero,
    GROUP_CONCAT(DISTINCT s.nombre SEPARATOR ", ") AS Software,
    c.nombreCarrera AS Carrera,
    COUNT(DISTINCT p.idComputadora) AS CantidadApartados
FROM
    Computadoras AS comp
INNER JOIN
    prestamos AS p ON p.idComputadora = comp.direccionIP
INNER JOIN
    prestamosPorDia AS pd ON pd.idPrestamoPorDia = p.idPrestamoPorDia
INNER JOIN
    estudiantes AS e ON e.idEstudiante = p.idEstudiante
INNER JOIN
    carreras AS c ON c.idCarrera = e.idCarrera
INNER JOIN 
    computadorasoftware AS cs ON cs.idComputadora = comp.direccionIP
INNER JOIN 
    software AS s ON s.idSoftware = cs.idSoftware    
WHERE 
	pd.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY
    comp.direccionIP, comp.numeroMaquina, c.nombreCarrera
ORDER BY
    CantidadApartados DESC
LIMIT 5;


-- 10. Realiza la consulta para indicarme las computadoras que tienen un ------------------------------------------
-- software que contenga la letra “o”.
-- Realizado por Manuel Cortez

USE cisco;

SELECT
    c.direccionIP,
    c.numeroMaquina,
    GROUP_CONCAT(s.nombre ORDER BY s.nombre ASC SEPARATOR ", ") AS Software
FROM computadoras AS c
INNER JOIN computadorasoftware AS cs ON c.direccionIp = cs.idComputadora
INNER JOIN software AS s ON cs.idSoftware = s.idSoftware
WHERE s.nombre LIKE "%o%"
GROUP BY c.direccionIP, c.numeroMaquina;


-- 11.Realiza la consulta para indicarme que ip se repite en el mismo ------------------------------------------
-- laboratorio.
   -- Datos a mostrar
     -- id
     -- ip
     -- numero   
     -- Realizado por Leonel Carballo
     
USE cisco;

SELECT 
    l.idLaboratorio,
    c.direccionIp,
    COUNT(c.direccionIp) AS VecesRepetidas
FROM laboratorios AS l
INNER JOIN computadoras AS c ON c.idLaboratorio = l.idLaboratorio
GROUP BY l.idLaboratorio, c.direccionIp
HAVING VecesRepetidas > 1;


-- 12. Realiza el script donde registres 10 apartados de diferente carrera y que -------------------------------------
-- los minutos de actividad sean de 10 minutos en la fecha de hoy (la fecha 
-- la tiene que tomar fecha y hora actual que se realice el script no 
-- hardcore).
-- Realizado por Manuel Cortez

USE cisco;

INSERT INTO prestamospordia (inicioServicio, finServicio, fecha, idLaboratorio) VALUES 
("08:00:00", "22:00:00", CURDATE(), 1);

INSERT INTO prestamos (inicioPrestamo, finPrestamo, idComputadora, idEstudiante, idPrestamoPorDia) VALUES
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.11", 1, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.12", 11, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.13", 21, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.14", 31, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.15", 41, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.16", 51, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.17", 61, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.18", 71, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.19", 81, 51),
    (CURTIME(), CURTIME() + INTERVAL 10 MINUTE, "192.168.0.20", 91, 51);
    
    
-- 13.Realiza la consulta para indicarme los alumnos que interactuaron en el ------------------------------------------
-- punto 10 muestre la siguiente información.
   -- Datos a mostrar
     -- carrera
     -- tiempoLimiteCarrera
     -- nombreCompletoAlumno
     -- id
     -- minutosActividad
     -- minutosDisponibles
     -- Realizado por Leonel Carballo
  
USE cisco;

SELECT
    c.nombreCarrera,
    c.tiempoLimiteDiario,
    CONCAT(e.nombres, " ",e.apellidoPaterno, " ",e.apellidoMaterno) AS NombreCompleto,
    e.idEstudiante,
    SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosDeUso,
    FLOOR(TIME_TO_SEC(c.tiempoLimiteDiario) / 60)  - SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosDisponibles
FROM
   carreras AS c
INNER JOIN
   estudiantes AS e ON e.idCarrera = c.idCarrera
INNER JOIN 
   prestamos AS p ON p.idEstudiante = e.idEstudiante
WHERE
   p.idPrestamo > 100
GROUP BY
    e.idEstudiante;