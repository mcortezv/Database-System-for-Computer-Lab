-- Report 1: Computer Center --------------------------------------------------------------
    -- Filters
        -- Careers (N Careers, this filter is optional)
        -- Date Range (Start and End Date, this is mandatory)
    -- Table Columns
        -- Computer Center Name
        -- Computer Number
        -- Number of Students
        -- Minutes of use per day
        -- Minutes of inactivity
        -- Date

USE cisco;

SELECT 
    l.nombre AS NombreCentroComputo,
    pc.numeroMaquina AS NumeroDeComputadora,
    COUNT(DISTINCT p.idEstudiante) AS CantidadDeAlumnos,
    SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosDeUsoPorDia,
    TIMESTAMPDIFF(MINUTE, porDia.inicioServicio, porDia.finServicio) - SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosDeInactividad,
    DATE(porDia.fecha) AS Fecha
FROM 
    Laboratorios AS l
INNER JOIN 
    Computadoras AS pc ON l.idLaboratorio = pc.idLaboratorio
INNER JOIN 
    Prestamos AS p ON pc.direccionIP = p.idComputadora
INNER JOIN 
    PrestamosPorDia AS porDia ON p.idPrestamoPorDia = porDia.idPrestamoPorDia
INNER JOIN 
    Estudiantes AS e ON p.idEstudiante = e.idEstudiante
INNER JOIN 
    Carreras AS c ON e.idCarrera = c.idCarrera
WHERE 
	c.idCarrera IN (1, 2, 3, 7, 9, 11, 13, 15, 17, 19, 21) AND
    DATE(porDia.fecha) BETWEEN "2024-10-01" AND "2024-11-19"
GROUP BY 
    l.nombre, pc.numeroMaquina, porDia.inicioServicio, porDia.finServicio, 
    p.inicioPrestamo, p.finPrestamo, DATE(porDia.fecha);


-- Report 2: Careers --------------------------------------------------------------------
    -- Filters
        -- Careers (N Careers, this filter is optional)
        -- Date Range (Start and End Date, this is mandatory)
    -- Table Columns
        -- Career Name
        -- Minutes of use per day
        -- Number of Students
        -- Date 

SELECT 
    c.nombreCarrera AS NombreCarrera,
    SUM(TIMESTAMPDIFF(MINUTE, p.inicioPrestamo, p.finPrestamo)) AS MinutosDeUso,
    COUNT(DISTINCT p.idEstudiante) AS CantidadDeAlumnos,
    DATE(porDia.fecha) AS Fecha
FROM 
    Carreras AS c
INNER JOIN 
    Estudiantes AS e ON c.idCarrera = e.idCarrera
INNER JOIN 
    Prestamos AS p ON e.idEstudiante = p.idEstudiante
INNER JOIN 
    PrestamosPorDia AS porDia ON p.idPrestamoPorDia = porDia.idPrestamoPorDia
WHERE 
	DATE(porDia.fecha) BETWEEN "2024-10-01" AND "2024-11-19"
GROUP BY 
    c.idCarrera, DATE(porDia.fecha);    


-- Report 3: Blockages -------------------------------------------------------------------
    -- Filters
        -- Date Range (Start and End Date, this is mandatory)
    -- Table Columns
        -- Student Name
        -- Block Date
        -- Release Date (if not released, indicate "N/A")
        -- Reasons

USE cisco;

SELECT 
    CONCAT(e.nombres, " ", e.apellidoPaterno, " ", e.apellidoMaterno) AS NombreAlumno,
    DATE(b.inicioBloqueo) AS FechaBloqueo,
    IFNULL(b.finBloqueo, "N/A") AS FechaLiberacion,
    b.motivo AS Motivo
FROM 
    Estudiantes AS e
INNER JOIN 
    Bloqueos AS b ON e.idEstudiante = b.idEstudiante
WHERE 
	DATE(b.inicioBloqueo) BETWEEN "2024-10-15" AND "2024-11-20"
ORDER BY
    e.nombres ASC;


-- Report 4: Query to know how many computers each laboratory has, along with additional 
-- information about the university they belong to. The results should be ordered by 
-- laboratory name in descending order.
    -- Data to Show
        -- InstitutionName
        -- Alias
        -- LabId
        -- LabName
        -- NumberOfComputers

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


-- Report 5: Query to know how many students each career currently has enrolled. 
-- The results should be ordered by career name in descending order followed by the 
-- student name. 

USE cisco;

SELECT
    c.nombreCarrera,
    COUNT(e.idEstudiante) AS CantidadAlumnos
FROM carreras AS c
LEFT JOIN estudiantes AS e ON c.idCarrera = e.idCarrera
GROUP BY c.nombreCarrera
ORDER BY c.nombreCarrera DESC;


-- Report 6: Query to know how many bookings per date have been made so far this year 
-- (non-hardcore) for the CISCO laboratory, ordered by date in descending order.
    -- Data to Show
        -- Date
        -- NumberOfBookings

SELECT
    pd.fecha,
    COUNT(pd.idPrestamoPorDia) AS CantidadApartados
FROM prestamosPorDia AS pd
INNER JOIN laboratorios AS l ON l.idLaboratorio = pd.idLaboratorio
WHERE l.nombre = "CISCO" AND YEAR(pd.fecha) = YEAR(CURDATE())
GROUP BY pd.fecha
ORDER BY pd.fecha DESC;


-- Report 7: Query to know how many bookings per date each career has made so far this 
-- year (non-hardcore) for the CISCO laboratory, ordered by career name in ascending order 
-- followed by date in descending order. 

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


-- Report 8: Query to find the career with the most bookings so far this year ------------
-- (non-hardcore) in CISCO and the date when it occurred.
    -- Data to Show
        -- CareerName
        -- Date
        -- NumberOfBookings

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


-- Report 9: Query to know when CISCO had the least minutes of bookings for its computers.

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


-- Report 10: Based on point 6, tell me which two careers had the least minutes of bookings.
    -- Data to Show
        -- Date
        -- CareerName
        -- ActivityMinutes
        -- InactivityMinutes

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


-- Report 11: Query to show students and their blockages, ordered by date in descending 
-- order followed by student name in ascending order.

USE cisco;

SELECT
	b.inicioBloqueo AS FechaBloqueo,
	CONCAT(e.nombres, " ", e.apellidoPaterno, " ", e.apellidoMaterno) AS NombreCompleto,
	b.motivo AS Motivo,
    COALESCE(b.finBloqueo, "N/A") AS FechaLiberacion
FROM estudiantes AS e
INNER JOIN bloqueos AS b ON e.idEstudiante = b.idEstudiante
ORDER BY b.inicioBloqueo DESC, e.nombres ASC;


-- Report 12: Query to show the 5 computers with the most bookings in the last month, 
-- indicating the number of bookings per career, ordered by the number of bookings in 
-- descending order.
    -- Data to Show
        -- Ip
        -- Number
        -- Software (separated by commas)
        -- Career
        -- NumberOfBookings     
 
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


-- Report 13: Query to show computers with software that contains the letter “o”.

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


-- Report 14: Query to show which IP repeats in the same laboratory. ------------------
    -- Data to Show
        -- Id
        -- Ip
        -- Number  
     
USE cisco;

SELECT 
    l.idLaboratorio,
    c.direccionIp,
    COUNT(c.direccionIp) AS VecesRepetidas
FROM laboratorios AS l
INNER JOIN computadoras AS c ON c.idLaboratorio = l.idLaboratorio
GROUP BY l.idLaboratorio, c.direccionIp
HAVING VecesRepetidas > 1;


-- Report 15: Script to register 10 bookings from different careers, where activity 
-- minutes are 10 minutes on today’s date (the script should take the current date and 
-- time, no hardcore).

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
    
    
-- Report 16: Query to show the students who interacted in point 10 and display the 
-- following information.
    -- Data to Show
        -- Career
        -- CareerTimeLimit
        -- StudentFullName
        -- Id
        -- ActivityMinutes
        -- AvailableMinutes
  
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