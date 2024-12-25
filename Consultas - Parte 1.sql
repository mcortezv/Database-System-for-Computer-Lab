-- Reporte 1: Centro de Computo ----------------------------------------------------------------
	 -- Filtros
		-- Carreras (N Carreras y es opcional este filtro)
		-- Rango de Fechas (Fecha de Inicio y Fin y es obligatorio)
	-- Columnas de la Tabla
		-- Nombre del Centro de Computo
		-- Número de Computadora
		-- Cantidad de Alumnos
		-- Minutos de uso por dia
		-- Minutos de inactividad
		-- Fecha

SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode, "ONLY_FULL_GROUP_BY",""));
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
    l.nombre, pc.numeroMaquina, DATE(porDia.fecha);


-- Reporte 2: Carreras -------------------------------------------------------------------------
	-- Filtros
		-- Carreras (N Carreras y es opcional este filtro)
		-- Rango de Fechas (Fecha de Inicio y Fin y es obligatorio)
	-- Columnas de la Tabla
		-- Nombre de la Carrera
		-- Minutos de uso por dia
		-- Cantidad de Alumnos
		-- Fecha 

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


-- Reporte 3: Bloqueos -------------------------------------------------------------------------
	-- Filtros
		-- Rango de Fechas (Fecha de Inicio y Fin y es obligatorio)
	-- Columnas de la Tabla
		-- Nombre del Alumno
		-- Fecha de Bloqueo
		-- Fecha de Liberación en caso de no estar liberado indicar “N/A”
		-- Motivos

USE cisco;

SELECT 
    CONCAT(e.nombres, " ", e.apellidoPaterno, " ", e.apellidoMaterno) AS NombreAlumno,
    DATE(b.inicioBloqueo) AS FechaBloqueo,
    IFNULL(b.finBloqueo, "N/A") AS FechaLiberacion,
    m.descripcionMotivo AS Motivo
FROM 
    Estudiantes AS e
INNER JOIN 
    Bloqueos AS b ON e.idEstudiante = b.idEstudiante
INNER JOIN
	Motivos AS m ON b.idMotivo = m.idMotivo
WHERE 
	DATE(b.inicioBloqueo) BETWEEN "2024-10-15" AND "2024-11-20"
ORDER BY
    e.nombres ASC;