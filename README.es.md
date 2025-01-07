# **Sistema de Base de Datos para Laboratorio de Computación**

Este proyecto es un sistema de base de datos diseñado para gestionar laboratorios de computación en una institución educativa. Realiza un seguimiento de estudiantes, carreras, institutos, laboratorios, computadoras, software, y más. La base de datos incluye relaciones y reglas para garantizar un correcto funcionamiento.

---

## **Tabla de Contenidos**
- [Estructura de la Base de Datos](#estructura-de-la-base-de-datos)
- [Creación de la Base de Datos](#creación-de-la-base-de-datos)
- [Inserción de Datos](#inserción-de-datos)
- [Consultas](#consultas)
- [Cómo Usar](#cómo-usar)
- [Licencia](#licencia)

## **Estructura de la Base de Datos**

### Tablas y Relaciones

1. **Carreras**  
   - `idCarrera`: ID único para cada carrera (Clave primaria).  
   - `nombreCarrera`: Nombre de la carrera (obligatorio).  
   - `tiempoLimiteDiario`: Límite de tiempo diario (obligatorio).  

2. **Institutos**  
   - `idInstituto`: ID único para cada instituto (Clave primaria).  
   - `nombreOficial`: Nombre oficial del instituto (obligatorio).  
   - `nombreAbreviado`: Nombre abreviado del instituto (obligatorio).  

3. **Laboratorios**  
   - `idLaboratorio`: ID único para cada laboratorio (Clave primaria).  
   - `nombre`: Nombre del laboratorio (obligatorio).  
   - `contraseñaMaestra`: Contraseña maestra (obligatorio).  
   - `idInstituto`: ID del instituto al que pertenece el laboratorio (Clave foránea).  

4. **PrestamosPorDia**  
   - `idPrestamoPorDia`: ID único para préstamos diarios (Clave primaria).  
   - `inicioServicio`: Hora de inicio (obligatorio).  
   - `finServicio`: Hora de fin (obligatorio).  
   - `fecha`: Fecha (obligatorio).  
   - `idLaboratorio`: ID del laboratorio (Clave foránea).  

5. **Software**  
   - `idSoftware`: ID único para cada software (Clave primaria).  
   - `nombre`: Nombre del software (obligatorio).  
   - `descripcion`: Descripción del software.  

6. **Computadoras**  
   - `direccionIp`: Dirección IP única para la computadora (Clave primaria).  
   - `numeroMaquina`: Número de la computadora (obligatorio).  
   - `estatus`: Estado de la computadora (`Disponible` u `Ocupada`), por defecto es `Disponible`.  
   - `nombreReservante`: Nombre de la persona que reserva la computadora, por defecto es `Disponible`.  
   - `idLaboratorio`: ID del laboratorio al que pertenece la computadora (Clave foránea).  

7. **ComputadoraSoftware**  
   - Relación entre `Computadoras` y `Software`.  
   - `idComputadoraSoftware`: ID único (Clave primaria).  
   - `idComputadora`: ID de la computadora (Clave foránea).  
   - `idSoftware`: ID del software (Clave foránea).  

8. **Estudiantes**  
   - `idEstudiante`: ID único para cada estudiante (Clave primaria).  
   - `nombres`: Nombres del estudiante (obligatorio).  
   - `apellidoPaterno`: Apellido paterno (obligatorio).  
   - `apellidoMaterno`: Apellido materno (obligatorio).  
   - `contraseñaAcceso`: Contraseña de acceso (obligatorio).  
   - `estatusInscripcion`: Estado de inscripción (`Activo` o `Inactivo`), por defecto es `Activo`.  
   - `idCarrera`: ID de la carrera a la que pertenece el estudiante (Clave foránea).  

9. **Bloqueos**  
   - `idBloqueo`: ID único para cada bloqueo (Clave primaria).  
   - `inicioBloqueo`: Hora de inicio del bloqueo (obligatorio).  
   - `finBloqueo`: Hora de fin del bloqueo.  
   - `motivo`: Motivo del bloqueo (obligatorio).  
   - `idEstudiante`: ID del estudiante bloqueado (Clave foránea).  
   - `estatusBloqueo`: Estado del bloqueo (`Pendiente` o `Liberado`), por defecto es `Pendiente`.  

10. **Prestamos**  
    - `idPrestamo`: ID único para cada préstamo (Clave primaria).  
    - `inicioPrestamo`: Hora de inicio del préstamo (obligatorio).  
    - `finPrestamo`: Hora de fin del préstamo (obligatorio).  
    - `idComputadora`: ID de la computadora prestada (Clave foránea).  
    - `idEstudiante`: ID del estudiante que realiza el préstamo (Clave foránea).  
    - `idPrestamoPorDia`: ID del registro diario del préstamo (Clave foránea).  

---

## **Creación de la Base de Datos**

El archivo `create_database.sql` incluye las sentencias `CREATE DATABASE` y `CREATE TABLE` con todas las restricciones necesarias para mantener la integridad referencial y las reglas de negocio.

## **Inserción de Datos**

El archivo `inserts.sql` contiene instrucciones para poblar la base de datos con valores iniciales:

```sql
INSERT INTO Carreras (nombreCarrera, tiempoLimiteDiario) VALUES ('Ingeniería en Sistemas', '02:00:00');
INSERT INTO Institutos (nombreOficial, nombreAbreviado) VALUES ('Instituto Tecnológico de Ejemplo', 'ITE');
-- Más ejemplos disponibles en el archivo.
```

## **Consultas**

El archivo `queries.sql` incluye consultas útiles para aprovechar la información almacenada:

- Ejemplo 1: Obtener estudiantes activos de una carrera específica.
```sql
SELECT * FROM Estudiantes WHERE estatusInscripcion = 'Activo';
```

- Ejemplo 2: Listar laboratorios disponibles de un instituto.
```sql
SELECT nombre FROM Laboratorios WHERE idInstituto = 1;
```

## **Cómo Usar**

### 1. Configuración:
- Asegúrate de tener un servidor SQL compatible (MySQL).
- Carga el archivo `create_database.sql` en tu servidor para crear la estructura.

### 2. Poblar:
- Ejecuta el archivo `inserts.sql` para agregar datos iniciales.

### 3. Consultas:
- Usa `queries.sql` para realizar las operaciones y consultas necesarias.

## **Licencia**
Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo [LICENSE](./LICENSE.md) para más detalles.