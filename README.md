# Database System for Computer Lab

## Description
This project is a database system designed to manage computer labs at an educational institution. It keeps track of students, careers, institutes, labs, computers, software, and more. The database includes relationships and rules to make sure everything works correctly.

---

## Table of Contents
- [Database Structure](#database-structure)
- [Database Creation](#database-creation)
- [Data Insertion](#data-insertion)
- [Queries](#queries)
- [How to Use](#how-to-use)
- [License](#license)

## Database Structure

### Tables and Relationships

1. **Carreras**  
   - `idCarrera`: Unique ID for each career (Primary Key).  
   - `nombreCarrera`: Name of the career (required).  
   - `tiempoLimiteDiario`: Daily time limit (required).  

2. **Institutos**  
   - `idInstituto`: Unique ID for each institute (Primary Key).  
   - `nombreOficial`: Official name of the institute (required).  
   - `nombreAbreviado`: Short name of the institute (required).  

3. **Laboratorios**  
   - `idLaboratorio`: Unique ID for each lab (Primary Key).  
   - `nombre`: Lab name (required).  
   - `contraseñaMaestra`: Master password (required).  
   - `idInstituto`: ID of the institute the lab belongs to (Foreign Key).  

4. **PrestamosPorDia**  
   - `idPrestamoPorDia`: Unique ID for daily loans (Primary Key).  
   - `inicioServicio`: Start time (required).  
   - `finServicio`: End time (required).  
   - `fecha`: Date (required).  
   - `idLaboratorio`: ID of the lab (Foreign Key).  

5. **Software**  
   - `idSoftware`: Unique ID for each software (Primary Key).  
   - `nombre`: Software name (required).  
   - `descripcion`: Description of the software.  

6. **Computadoras**  
   - `direccionIp`: Unique IP address for the computer (Primary Key).  
   - `numeroMaquina`: Computer number (required).  
   - `estatus`: Status of the computer (`Disponible` or `Ocupada`), default is `Disponible`.  
   - `nombreReservante`: Name of the person reserving the computer, default is `Disponible`.  
   - `idLaboratorio`: ID of the lab the computer belongs to (Foreign Key).  

7. **ComputadoraSoftware**  
   - Relationship between `Computadoras` and `Software`.  
   - `idComputadoraSoftware`: Unique ID (Primary Key).  
   - `idComputadora`: ID of the computer (Foreign Key).  
   - `idSoftware`: ID of the software (Foreign Key).  

8. **Estudiantes**  
   - `idEstudiante`: Unique ID for each student (Primary Key).  
   - `nombres`: First name(s) of the student (required).  
   - `apellidoPaterno`: Last name (father's side) (required).  
   - `apellidoMaterno`: Last name (mother's side) (required).  
   - `contraseñaAcceso`: Password for access (required).  
   - `estatusInscripcion`: Enrollment status (`Activo` or `Inactivo`), default is `Activo`.  
   - `idCarrera`: ID of the career the student belongs to (Foreign Key).  

9. **Bloqueos**  
   - `idBloqueo`: Unique ID for each block (Primary Key).  
   - `inicioBloqueo`: Start time of the block (required).  
   - `finBloqueo`: End time of the block.  
   - `motivo`: Reason for the block (required).  
   - `idEstudiante`: ID of the blocked student (Foreign Key).  
   - `estatusBloqueo`: Block status (`Pendiente` or `Liberado`), default is `Pendiente`.  

10. **Prestamos**  
    - `idPrestamo`: Unique ID for each loan (Primary Key).  
    - `inicioPrestamo`: Start time of the loan (required).  
    - `finPrestamo`: End time of the loan (required).  
    - `idComputadora`: ID of the computer being borrowed (Foreign Key).  
    - `idEstudiante`: ID of the student borrowing (Foreign Key).  
    - `idPrestamoPorDia`: ID of the daily loan record (Foreign Key).  

---

## Database Creation

The `create_database.sql` file includes the `CREATE DATABASE` and `CREATE TABLE` statements with all necessary constraints to maintain referential integrity and business rules.

## Data Insertion

The `inserts.sql` file contains instructions to populate the database with initial values:

```sql
INSERT INTO Carreras (nombreCarrera, tiempoLimiteDiario) VALUES ('Ingeniería en Sistemas', '02:00:00');
INSERT INTO Institutos (nombreOficial, nombreAbreviado) VALUES ('Instituto Tecnológico de Ejemplo', 'ITE');
-- More examples available in the file.
```

## Queries

The `queries.sql` file includes useful queries to exploit the stored information:

- Example 1: Retrieve active students from a specific career.
```sql
SELECT * FROM Estudiantes WHERE estatusInscripcion = 'Activo';
```

- Example 2: List available labs from an institute.
```sql
SELECT nombre FROM Laboratorios WHERE idInstituto = 1;
```

## How to Use

### 1. Setup:
- Ensure you have a compatible SQL server (MySQL).
- Load the `create_database.sql` file into your server to create the structure.

### 2. Populate:
- Execute the `inserts.sql` file to add initial data.

### 3. Queries:
- Use `queries.sql` to perform the necessary operations and queries.


## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE.md) file for more details.