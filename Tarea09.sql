-- Tarea 09 - Disparadores o Triggers
-- Alumno: Gianpierre Rodrigo Dulanto Romero
-- Base de Datos II - 2025-2

-- Primero se crea las tablas que se muestran en el diagrama

-- Tabla Regions
CREATE TABLE Regions (
    region_id NUMBER NOT NULL,
    region_name VARCHAR2(25),
    CONSTRAINT reg_id_pk PRIMARY KEY (region_id)
);

-- Tabla Countries
CREATE TABLE Countries (
    country_id CHAR(2) NOT NULL,
    country_name VARCHAR2(40),
    region_id NUMBER,
    CONSTRAINT country_c_id_pk PRIMARY KEY (country_id),
    CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) REFERENCES Regions(region_id)
);

-- Tabla Locations
CREATE TABLE Locations (
    location_id NUMBER(4) NOT NULL,
    street_address VARCHAR2(40),
    postal_code VARCHAR2(12),
    city VARCHAR2(30) NOT NULL,
    state_province VARCHAR2(25),
    country_id CHAR(2),
    CONSTRAINT loc_id_pk PRIMARY KEY (location_id),
    CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

-- Tabla Departments
CREATE TABLE Departments (
    department_id NUMBER(4) NOT NULL,
    department_name VARCHAR2(30) NOT NULL,
    manager_id NUMBER(6),
    location_id NUMBER(4),
    CONSTRAINT dept_id_pk PRIMARY KEY (department_id),
    CONSTRAINT dept_loc_fk FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

-- Tabla Jobs
CREATE TABLE Jobs (
    job_id VARCHAR2(10) NOT NULL,
    job_title VARCHAR2(35) NOT NULL,
    min_salary NUMBER(6),
    max_salary NUMBER(6),
    CONSTRAINT job_id_pk PRIMARY KEY (job_id)
);

-- Tabla Employees
CREATE TABLE Employees (
    employee_id NUMBER(6) NOT NULL,
    first_name VARCHAR2(20),
    last_name VARCHAR2(25) NOT NULL,
    email VARCHAR2(25) NOT NULL,
    phone_number VARCHAR2(20),
    hire_date DATE NOT NULL,
    job_id VARCHAR2(10) NOT NULL,
    salary NUMBER(8,2),
    commission_pct NUMBER(2,2),
    manager_id NUMBER(6),
    department_id NUMBER(4),
    CONSTRAINT emp_emp_id_pk PRIMARY KEY (employee_id),
    CONSTRAINT emp_email_uk UNIQUE (email),
    CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    CONSTRAINT emp_job_fk FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
    CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES Employees(employee_id)
);

-- Agregar FK de manager en Departments
ALTER TABLE Departments 
ADD CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES Employees(employee_id);

-- Tabla Job_History
CREATE TABLE Job_History (
    employee_id NUMBER(6) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    job_id VARCHAR2(10) NOT NULL,
    department_id NUMBER(4),
    CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date),
    CONSTRAINT jhist_job_fk FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
    CONSTRAINT jhist_emp_fk FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    CONSTRAINT jhist_dept_fk FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Luego se crean las tablas auxiliares que se solicita para cumplir con los enunciados requeridos

-- Tabla Horario
CREATE TABLE Horario (
    dia_semana VARCHAR2(15),
    turno VARCHAR2(10),
    hora_inicio TIMESTAMP,
    hora_termino TIMESTAMP,
    PRIMARY KEY (dia_semana, turno)
);

-- Tabla Empleado_Horario
CREATE TABLE Empleado_Horario (
    dia_semana VARCHAR2(15),
    turno VARCHAR2(10),
    employee_id NUMBER(6),
    PRIMARY KEY (dia_semana, turno, employee_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (dia_semana, turno) REFERENCES Horario(dia_semana, turno)
);

-- Tabla Asistencia_Empleado
CREATE TABLE Asistencia_Empleado (
    employee_id NUMBER(6),
    dia_semana VARCHAR2(15),
    fecha_real DATE,
    hora_inicio_real TIMESTAMP,
    hora_termino_real TIMESTAMP,
    PRIMARY KEY (employee_id, fecha_real),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Tabla Capacitacion
CREATE TABLE Capacitacion (
    codigo_capacitacion NUMBER(6) PRIMARY KEY,
    nombre_capacitacion VARCHAR2(100),
    horas_capacitacion NUMBER(4),
    descripcion VARCHAR2(500)
);

-- Tabla EmpleadoCapacitacion
CREATE TABLE EmpleadoCapacitacion (
    employee_id NUMBER(6),
    codigo_capacitacion NUMBER(6),
    PRIMARY KEY (employee_id, codigo_capacitacion),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (codigo_capacitacion) REFERENCES Capacitacion(codigo_capacitacion)
);

-- Insercion de datos para hacer las pruebas

-- Insertar Regions
INSERT INTO Regions VALUES (1, 'Europe');
INSERT INTO Regions VALUES (2, 'Americas');
INSERT INTO Regions VALUES (3, 'Asia');
INSERT INTO Regions VALUES (4, 'Middle East and Africa');

-- Insertar Countries
INSERT INTO Countries VALUES ('US', 'United States of America', 2);
INSERT INTO Countries VALUES ('CA', 'Canada', 2);
INSERT INTO Countries VALUES ('UK', 'United Kingdom', 1);
INSERT INTO Countries VALUES ('DE', 'Germany', 1);
INSERT INTO Countries VALUES ('BR', 'Brazil', 2);
INSERT INTO Countries VALUES ('CH', 'Switzerland', 1);
INSERT INTO Countries VALUES ('JP', 'Japan', 3);
INSERT INTO Countries VALUES ('IN', 'India', 3);
INSERT INTO Countries VALUES ('CN', 'China', 3);
INSERT INTO Countries VALUES ('AU', 'Australia', 3);

-- Insertar Locations
INSERT INTO Locations VALUES (1000, '1297 Via Cola di Rie', '00989', 'Roma', NULL, 'UK');
INSERT INTO Locations VALUES (1100, '93091 Calle della Testa', '10934', 'Venice', NULL, 'UK');
INSERT INTO Locations VALUES (1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP');
INSERT INTO Locations VALUES (1300, '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP');
INSERT INTO Locations VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO Locations VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO Locations VALUES (1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US');
INSERT INTO Locations VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO Locations VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO Locations VALUES (1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA');

-- Insertar Jobs
INSERT INTO Jobs VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO Jobs VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO Jobs VALUES ('AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO Jobs VALUES ('FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO Jobs VALUES ('FI_ACCOUNT', 'Accountant', 4200, 9000);
INSERT INTO Jobs VALUES ('AC_MGR', 'Accounting Manager', 8200, 16000);
INSERT INTO Jobs VALUES ('AC_ACCOUNT', 'Public Accountant', 4200, 9000);
INSERT INTO Jobs VALUES ('SA_MAN', 'Sales Manager', 10000, 20000);
INSERT INTO Jobs VALUES ('SA_REP', 'Sales Representative', 6000, 12000);
INSERT INTO Jobs VALUES ('PU_MAN', 'Purchasing Manager', 8000, 15000);
INSERT INTO Jobs VALUES ('PU_CLERK', 'Purchasing Clerk', 2500, 5500);
INSERT INTO Jobs VALUES ('ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO Jobs VALUES ('ST_CLERK', 'Stock Clerk', 2000, 5000);
INSERT INTO Jobs VALUES ('SH_CLERK', 'Shipping Clerk', 2500, 5500);
INSERT INTO Jobs VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO Jobs VALUES ('MK_MAN', 'Marketing Manager', 9000, 15000);
INSERT INTO Jobs VALUES ('MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO Jobs VALUES ('HR_REP', 'Human Resources Representative', 4000, 9000);
INSERT INTO Jobs VALUES ('PR_REP', 'Public Relations Representative', 4500, 10500);

-- Insertar Departments
INSERT INTO Departments VALUES (10, 'Administration', NULL, 1700);
INSERT INTO Departments VALUES (20, 'Marketing', NULL, 1800);
INSERT INTO Departments VALUES (30, 'Purchasing', NULL, 1700);
INSERT INTO Departments VALUES (40, 'Human Resources', NULL, 1400);
INSERT INTO Departments VALUES (50, 'Shipping', NULL, 1500);
INSERT INTO Departments VALUES (60, 'IT', NULL, 1200);
INSERT INTO Departments VALUES (70, 'Public Relations', NULL, 1000);
INSERT INTO Departments VALUES (80, 'Sales', NULL, 1700);
INSERT INTO Departments VALUES (90, 'Executive', NULL, 1700);
INSERT INTO Departments VALUES (100, 'Finance', NULL, 1700);

-- Insertar Employees
INSERT INTO Employees VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', TO_DATE('17-06-1987', 'DD-MM-YYYY'), 'AD_PRES', 24000, NULL, NULL, 90);
INSERT INTO Employees VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('21-09-1989', 'DD-MM-YYYY'), 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO Employees VALUES (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('13-01-1993', 'DD-MM-YYYY'), 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO Employees VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('03-01-1990', 'DD-MM-YYYY'), 'IT_PROG', 9000, NULL, 102, 60);
INSERT INTO Employees VALUES (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', TO_DATE('21-05-1991', 'DD-MM-YYYY'), 'IT_PROG', 6000, NULL, 103, 60);
INSERT INTO Employees VALUES (105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', TO_DATE('25-06-1997', 'DD-MM-YYYY'), 'IT_PROG', 4800, NULL, 103, 60);
INSERT INTO Employees VALUES (106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', TO_DATE('05-02-1998', 'DD-MM-YYYY'), 'IT_PROG', 4800, NULL, 103, 60);
INSERT INTO Employees VALUES (107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', TO_DATE('07-02-1999', 'DD-MM-YYYY'), 'IT_PROG', 4200, NULL, 103, 60);
INSERT INTO Employees VALUES (108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', TO_DATE('17-08-1994', 'DD-MM-YYYY'), 'FI_MGR', 12000, NULL, 101, 100);
INSERT INTO Employees VALUES (109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', TO_DATE('16-08-1994', 'DD-MM-YYYY'), 'FI_ACCOUNT', 9000, NULL, 108, 100);

-- Actualizar managers en Departments
UPDATE Departments SET manager_id = 100 WHERE department_id = 90;
UPDATE Departments SET manager_id = 108 WHERE department_id = 100;
UPDATE Departments SET manager_id = 103 WHERE department_id = 60;

-- Insertar Job_History
INSERT INTO Job_History VALUES (102, TO_DATE('13-01-1993', 'DD-MM-YYYY'), TO_DATE('24-07-1998', 'DD-MM-YYYY'), 'IT_PROG', 60);
INSERT INTO Job_History VALUES (101, TO_DATE('21-09-1989', 'DD-MM-YYYY'), TO_DATE('27-10-1993', 'DD-MM-YYYY'), 'AC_ACCOUNT', 100);
INSERT INTO Job_History VALUES (101, TO_DATE('28-10-1993', 'DD-MM-YYYY'), TO_DATE('15-03-1997', 'DD-MM-YYYY'), 'AC_MGR', 100);
INSERT INTO Job_History VALUES (100, TO_DATE('17-06-1987', 'DD-MM-YYYY'), TO_DATE('17-06-1993', 'DD-MM-YYYY'), 'AD_ASST', 90);
INSERT INTO Job_History VALUES (103, TO_DATE('03-01-1990', 'DD-MM-YYYY'), TO_DATE('31-12-1992', 'DD-MM-YYYY'), 'IT_PROG', 60);

-- Insertar Horario
INSERT INTO Horario VALUES ('Lunes', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('13:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Lunes', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Martes', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('13:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Martes', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Miércoles', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('13:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Miércoles', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Jueves', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('13:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Jueves', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Viernes', 'Mañana', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('13:00:00', 'HH24:MI:SS'));
INSERT INTO Horario VALUES ('Viernes', 'Tarde', TO_TIMESTAMP('14:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'));

-- Insertar Empleado_Horario
INSERT INTO Empleado_Horario VALUES ('Lunes', 'Mañana', 100);
INSERT INTO Empleado_Horario VALUES ('Martes', 'Mañana', 100);
INSERT INTO Empleado_Horario VALUES ('Miércoles', 'Tarde', 101);
INSERT INTO Empleado_Horario VALUES ('Jueves', 'Tarde', 101);
INSERT INTO Empleado_Horario VALUES ('Viernes', 'Mañana', 102);
INSERT INTO Empleado_Horario VALUES ('Lunes', 'Tarde', 103);
INSERT INTO Empleado_Horario VALUES ('Martes', 'Tarde', 104);
INSERT INTO Empleado_Horario VALUES ('Miércoles', 'Mañana', 105);
INSERT INTO Empleado_Horario VALUES ('Jueves', 'Mañana', 106);
INSERT INTO Empleado_Horario VALUES ('Viernes', 'Tarde', 107);

-- Insertar Asistencia_Empleado
INSERT INTO Asistencia_Empleado VALUES (100, 'Lunes', TO_DATE('06-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('06-10-2025 08:10:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('06-10-2025 13:05:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (100, 'Martes', TO_DATE('07-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('07-10-2025 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('07-10-2025 13:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (101, 'Miércoles', TO_DATE('08-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('08-10-2025 14:15:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('08-10-2025 18:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (101, 'Jueves', TO_DATE('09-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('09-10-2025 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('09-10-2025 17:50:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (102, 'Viernes', TO_DATE('10-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('10-10-2025 08:05:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('10-10-2025 13:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (103, 'Lunes', TO_DATE('13-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('13-10-2025 14:20:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('13-10-2025 18:10:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (104, 'Martes', TO_DATE('14-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('14-10-2025 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('14-10-2025 18:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (105, 'Miércoles', TO_DATE('15-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('15-10-2025 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('15-10-2025 13:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (106, 'Jueves', TO_DATE('16-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('16-10-2025 08:30:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('16-10-2025 13:00:00', 'DD-MM-YYYY HH24:MI:SS'));
INSERT INTO Asistencia_Empleado VALUES (107, 'Viernes', TO_DATE('17-10-2025', 'DD-MM-YYYY'), TO_TIMESTAMP('17-10-2025 14:00:00', 'DD-MM-YYYY HH24:MI:SS'), TO_TIMESTAMP('17-10-2025 18:00:00', 'DD-MM-YYYY HH24:MI:SS'));

-- Insertar Capacitacion
INSERT INTO Capacitacion VALUES (1, 'Oracle Database Fundamentals', 40, 'Curso básico de administración BD Oracle');
INSERT INTO Capacitacion VALUES (2, 'PL/SQL Advanced Programming', 50, 'Programación avanzada en PL/SQL');
INSERT INTO Capacitacion VALUES (3, 'Liderazgo y Gestión de Equipos', 30, 'Desarrollo de habilidades de liderazgo');
INSERT INTO Capacitacion VALUES (4, 'Seguridad Informática', 45, 'Principios de ciberseguridad empresarial');
INSERT INTO Capacitacion VALUES (5, 'Business Intelligence con Oracle', 60, 'Análisis de datos y reportería');
INSERT INTO Capacitacion VALUES (6, 'Atención al Cliente', 25, 'Mejora en habilidades de servicio');
INSERT INTO Capacitacion VALUES (7, 'Gestión de Proyectos Ágiles', 35, 'Metodologías Scrum y Kanban');
INSERT INTO Capacitacion VALUES (8, 'Excel Avanzado', 20, 'Análisis de datos con Excel');
INSERT INTO Capacitacion VALUES (9, 'Comunicación Efectiva', 15, 'Habilidades blandas de comunicación');
INSERT INTO Capacitacion VALUES (10, 'Cloud Computing AWS', 55, 'Servicios en la nube de Amazon');

-- Insertar EmpleadoCapacitacion
INSERT INTO EmpleadoCapacitacion VALUES (100, 1);
INSERT INTO EmpleadoCapacitacion VALUES (100, 2);
INSERT INTO EmpleadoCapacitacion VALUES (101, 3);
INSERT INTO EmpleadoCapacitacion VALUES (102, 1);
INSERT INTO EmpleadoCapacitacion VALUES (102, 4);
INSERT INTO EmpleadoCapacitacion VALUES (103, 5);
INSERT INTO EmpleadoCapacitacion VALUES (104, 6);
INSERT INTO EmpleadoCapacitacion VALUES (105, 7);
INSERT INTO EmpleadoCapacitacion VALUES (106, 8);
INSERT INTO EmpleadoCapacitacion VALUES (107, 9);

COMMIT;

-- Paquete EMPLOYEE_PKG - especificación

CREATE OR REPLACE PACKAGE EMPLOYEE_PKG AS
    -- CRUD basicos
    PROCEDURE insertar_empleado(p_employee_id NUMBER, p_first_name VARCHAR2, p_last_name VARCHAR2, p_email VARCHAR2, p_hire_date DATE, p_job_id VARCHAR2, p_salary NUMBER, p_department_id NUMBER DEFAULT NULL);
    PROCEDURE actualizar_empleado(p_employee_id NUMBER, p_salary NUMBER DEFAULT NULL, p_job_id VARCHAR2 DEFAULT NULL);
    PROCEDURE eliminar_empleado(p_employee_id NUMBER);
    FUNCTION consultar_empleado(p_employee_id NUMBER) RETURN VARCHAR2;
    
    -- 3.1.1 Top 4 empleados con mayor rotación
    PROCEDURE top_4_rotacion;
    
    -- 3.1.2 Promedio de contrataciones por mes
    FUNCTION promedio_contrataciones_mes RETURN NUMBER;
    
    -- 3.1.3 Gastos en salario por región
    PROCEDURE gastos_por_region;
    
    -- 3.1.4 Cálculo de vacaciones
    FUNCTION calcular_vacaciones RETURN NUMBER;
    
    -- 3.1.5 Horas laboradas por empleado en un mes
    FUNCTION horas_laboradas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
    
    -- 3.1.6 Horas de falta por empleado en un mes
    FUNCTION horas_falta(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER;
    
    -- 3.1.7 Reporte de sueldos por horas
    PROCEDURE reporte_sueldo_mensual(p_mes NUMBER, p_anio NUMBER);
    
    -- 3.1.8 Horas totales de capacitación
    FUNCTION horas_capacitacion(p_employee_id NUMBER) RETURN NUMBER;
    
    -- 3.1.9 Listado de empleados por capacitación
    PROCEDURE listado_capacitaciones;
END EMPLOYEE_PKG;
/

-- Paquete EMPLOYEE_PKG - cuerpo

CREATE OR REPLACE PACKAGE BODY EMPLOYEE_PKG AS
    
    -- CRUD: Insertar empleado
    PROCEDURE insertar_empleado(p_employee_id NUMBER, p_first_name VARCHAR2, p_last_name VARCHAR2, p_email VARCHAR2, p_hire_date DATE, p_job_id VARCHAR2, p_salary NUMBER, p_department_id NUMBER DEFAULT NULL) IS
    BEGIN
        INSERT INTO Employees VALUES (p_employee_id, p_first_name, p_last_name, p_email, NULL, p_hire_date, p_job_id, p_salary, NULL, NULL, p_department_id);
        COMMIT;
    END insertar_empleado;
    
    -- CRUD: Actualizar empleado
    PROCEDURE actualizar_empleado(p_employee_id NUMBER, p_salary NUMBER DEFAULT NULL, p_job_id VARCHAR2 DEFAULT NULL) IS
    BEGIN
        UPDATE Employees SET salary = NVL(p_salary, salary), job_id = NVL(p_job_id, job_id) WHERE employee_id = p_employee_id;
        COMMIT;
    END actualizar_empleado;
    
    -- CRUD: Eliminar empleado
    PROCEDURE eliminar_empleado(p_employee_id NUMBER) IS
    BEGIN
        DELETE FROM Job_History WHERE employee_id = p_employee_id;
        DELETE FROM Empleado_Horario WHERE employee_id = p_employee_id;
        DELETE FROM Asistencia_Empleado WHERE employee_id = p_employee_id;
        DELETE FROM EmpleadoCapacitacion WHERE employee_id = p_employee_id;
        DELETE FROM Employees WHERE employee_id = p_employee_id;
        COMMIT;
    END eliminar_empleado;
    
    -- CRUD: Consultar empleado
    FUNCTION consultar_empleado(p_employee_id NUMBER) RETURN VARCHAR2 IS
        v_resultado VARCHAR2(500);
    BEGIN
        SELECT first_name || ' ' || last_name || ' - ' || job_id INTO v_resultado FROM Employees WHERE employee_id = p_employee_id;
        RETURN v_resultado;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 'Empleado no encontrado';
    END consultar_empleado;
    
    -- 3.1.1 Top 4 empleados con mayor rotación
    PROCEDURE top_4_rotacion IS
    BEGIN
        FOR rec IN (
            SELECT e.employee_id, e.last_name, e.first_name, e.job_id, j.job_title, COUNT(jh.job_id) AS cambios
            FROM Employees e
            JOIN Jobs j ON e.job_id = j.job_id
            LEFT JOIN Job_History jh ON e.employee_id = jh.employee_id
            GROUP BY e.employee_id, e.last_name, e.first_name, e.job_id, j.job_title
            ORDER BY cambios DESC
            FETCH FIRST 4 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' - ' || rec.first_name || ' ' || rec.last_name || ' - ' || rec.job_title || ' (' || rec.cambios || ' cambios)');
        END LOOP;
    END top_4_rotacion;
    
    -- 3.1.2 Promedio de contrataciones por mes
    FUNCTION promedio_contrataciones_mes RETURN NUMBER IS
        v_total NUMBER := 0;
        v_count NUMBER := 0;
    BEGIN
        FOR rec IN (
            SELECT TO_CHAR(hire_date, 'Month', 'NLS_DATE_LANGUAGE=SPANISH') AS mes, COUNT(*) / NULLIF(COUNT(DISTINCT EXTRACT(YEAR FROM hire_date)), 0) AS prom
            FROM Employees
            GROUP BY TO_CHAR(hire_date, 'Month', 'NLS_DATE_LANGUAGE=SPANISH'), EXTRACT(MONTH FROM hire_date)
            ORDER BY EXTRACT(MONTH FROM hire_date)
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(rec.mes, 15) || ': ' || ROUND(rec.prom, 2));
            v_total := v_total + rec.prom;
            v_count := v_count + 1;
        END LOOP;
        RETURN ROUND(v_total / NULLIF(v_count, 0), 2);
    END promedio_contrataciones_mes;
    
    -- 3.1.3 Gastos en salario por región
    PROCEDURE gastos_por_region IS
    BEGIN
        FOR rec IN (
            SELECT r.region_name, SUM(e.salary) AS total, COUNT(e.employee_id) AS cantidad, MIN(e.hire_date) AS fecha_antiguo
            FROM Employees e
            JOIN Departments d ON e.department_id = d.department_id
            JOIN Locations l ON d.location_id = l.location_id
            JOIN Countries c ON l.country_id = c.country_id
            JOIN Regions r ON c.region_id = r.region_id
            GROUP BY r.region_name
            ORDER BY total DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(rec.region_name, 25) || ' | Total: $' || LPAD(TO_CHAR(rec.total, '999,999'), 10) || ' | Empleados: ' || rec.cantidad || ' | Fecha antiguo: ' || TO_CHAR(rec.fecha_antiguo, 'DD-MM-YYYY'));
        END LOOP;
    END gastos_por_region;
    
    -- 3.1.4 Cálculo de vacaciones
    FUNCTION calcular_vacaciones RETURN NUMBER IS
        v_total NUMBER := 0;
    BEGIN
        FOR rec IN (
            SELECT employee_id, first_name, last_name, salary, hire_date, TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS anios
            FROM Employees
            ORDER BY anios DESC
        ) LOOP
            DECLARE
                v_monto NUMBER := (rec.salary / 12) * rec.anios;
            BEGIN
                DBMS_OUTPUT.PUT_LINE(RPAD(rec.first_name || ' ' || rec.last_name, 30) || ' | Años: ' || LPAD(rec.anios, 2) || ' | Monto: $' || LPAD(TO_CHAR(ROUND(v_monto, 2), '999,999.99'), 12));
                v_total := v_total + v_monto;
            END;
        END LOOP;
        RETURN ROUND(v_total, 2);
    END calcular_vacaciones;
    
    -- 3.1.5 Horas laboradas
    FUNCTION horas_laboradas(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
        v_horas NUMBER := 0;
    BEGIN
        SELECT SUM((EXTRACT(HOUR FROM (hora_termino_real - hora_inicio_real)) * 60 + EXTRACT(MINUTE FROM (hora_termino_real - hora_inicio_real))) / 60)
        INTO v_horas
        FROM Asistencia_Empleado
        WHERE employee_id = p_employee_id AND EXTRACT(MONTH FROM fecha_real) = p_mes AND EXTRACT(YEAR FROM fecha_real) = p_anio;
        RETURN NVL(ROUND(v_horas, 2), 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 0;
    END horas_laboradas;
    
    -- 3.1.6 Horas de falta
    FUNCTION horas_falta(p_employee_id NUMBER, p_mes NUMBER, p_anio NUMBER) RETURN NUMBER IS
        v_esperadas NUMBER := 0;
    BEGIN
        SELECT COUNT(*) * 5 * 4 INTO v_esperadas FROM Empleado_Horario WHERE employee_id = p_employee_id;
        RETURN GREATEST(v_esperadas - horas_laboradas(p_employee_id, p_mes, p_anio), 0);
    END horas_falta;
    
    -- 3.1.7 Reporte sueldo mensual
    PROCEDURE reporte_sueldo_mensual(p_mes NUMBER, p_anio NUMBER) IS
    BEGIN
        FOR rec IN (
            SELECT DISTINCT e.employee_id, e.first_name, e.last_name, e.salary
            FROM Employees e
            WHERE EXISTS (SELECT 1 FROM Asistencia_Empleado ae WHERE ae.employee_id = e.employee_id AND EXTRACT(MONTH FROM ae.fecha_real) = p_mes AND EXTRACT(YEAR FROM ae.fecha_real) = p_anio)
            ORDER BY e.last_name
        ) LOOP
            DECLARE
                v_horas_lab NUMBER := horas_laboradas(rec.employee_id, p_mes, p_anio);
                v_horas_fal NUMBER := horas_falta(rec.employee_id, p_mes, p_anio);
                v_sueldo NUMBER := rec.salary * (v_horas_lab / NULLIF(v_horas_lab + v_horas_fal, 0));
            BEGIN
                DBMS_OUTPUT.PUT_LINE(RPAD(rec.first_name || ' ' || rec.last_name, 30) || ' | H.Lab: ' || LPAD(v_horas_lab, 6) || ' | H.Falta: ' || LPAD(v_horas_fal, 6) || ' | Sueldo: $' || LPAD(TO_CHAR(ROUND(v_sueldo, 2), '999,999.99'), 12));
            END;
        END LOOP;
    END reporte_sueldo_mensual;
    
    -- 3.1.8 Horas capacitación
    FUNCTION horas_capacitacion(p_employee_id NUMBER) RETURN NUMBER IS
        v_horas NUMBER := 0;
    BEGIN
        SELECT NVL(SUM(c.horas_capacitacion), 0) INTO v_horas FROM EmpleadoCapacitacion ec JOIN Capacitacion c ON ec.codigo_capacitacion = c.codigo_capacitacion WHERE ec.employee_id = p_employee_id;
        RETURN v_horas;
    END horas_capacitacion;
    
    -- 3.1.9 Listado capacitaciones
    PROCEDURE listado_capacitaciones IS
        v_cap_actual VARCHAR2(100);
        v_contador NUMBER;
    BEGIN
        v_cap_actual := NULL;
        v_contador := 0;
        
        FOR rec IN (
            SELECT c.codigo_capacitacion, c.nombre_capacitacion, e.first_name || ' ' || e.last_name AS empleado, c.horas_capacitacion
            FROM Capacitacion c
            JOIN EmpleadoCapacitacion ec ON c.codigo_capacitacion = ec.codigo_capacitacion
            JOIN Employees e ON ec.employee_id = e.employee_id
            ORDER BY c.codigo_capacitacion, empleado
        ) LOOP
            IF v_cap_actual IS NULL OR v_cap_actual != rec.nombre_capacitacion THEN
                IF v_cap_actual IS NOT NULL THEN
                    DBMS_OUTPUT.PUT_LINE('  Total: ' || v_contador || ' empleado(s)');
                    DBMS_OUTPUT.PUT_LINE('');
                END IF;
                DBMS_OUTPUT.PUT_LINE('CAPACITACIÓN: ' || rec.nombre_capacitacion || ' (' || rec.horas_capacitacion || ' horas)');
                DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));
                v_cap_actual := rec.nombre_capacitacion;
                v_contador := 0;
            END IF;
            DBMS_OUTPUT.PUT_LINE('  - ' || rec.empleado);
            v_contador := v_contador + 1;
        END LOOP;
        
        IF v_cap_actual IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('  Total: ' || v_contador || ' empleado(s)');
        END IF;
    END listado_capacitaciones;
    
END EMPLOYEE_PKG;
/

-- implmentacion de triggers

-- 3.2 Trigger validar asistencia
CREATE OR REPLACE TRIGGER trg_validar_asistencia
BEFORE INSERT ON Asistencia_Empleado
FOR EACH ROW
DECLARE
    v_dia VARCHAR2(15);
    v_existe NUMBER;
BEGIN
    SELECT TRIM(TO_CHAR(:NEW.fecha_real, 'Day', 'NLS_DATE_LANGUAGE=SPANISH')) INTO v_dia FROM DUAL;
    IF UPPER(v_dia) != UPPER(:NEW.dia_semana) THEN
        RAISE_APPLICATION_ERROR(-20001, 'El día no corresponde con la fecha');
    END IF;
    SELECT COUNT(*) INTO v_existe FROM Empleado_Horario WHERE employee_id = :NEW.employee_id AND UPPER(dia_semana) = UPPER(:NEW.dia_semana);
    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No tiene horario asignado');
    END IF;
END;
/

-- 3.3 Trigger validar salario
CREATE OR REPLACE TRIGGER trg_validar_salario
BEFORE INSERT OR UPDATE OF salary, job_id ON Employees
FOR EACH ROW
DECLARE
    v_min NUMBER;
    v_max NUMBER;
BEGIN
    SELECT min_salary, max_salary INTO v_min, v_max FROM Jobs WHERE job_id = :NEW.job_id;
    IF :NEW.salary < v_min OR :NEW.salary > v_max THEN
        RAISE_APPLICATION_ERROR(-20010, 'Salario fuera del rango');
    END IF;
END;
/

-- 3.4 Trigger control horario
CREATE OR REPLACE TRIGGER trg_control_horario
BEFORE INSERT ON Asistencia_Empleado
FOR EACH ROW
DECLARE
    v_hora_inicio TIMESTAMP;
    v_diferencia NUMBER;
BEGIN
    SELECT h.hora_inicio INTO v_hora_inicio FROM Empleado_Horario eh JOIN Horario h ON UPPER(eh.dia_semana) = UPPER(h.dia_semana) AND eh.turno = h.turno WHERE eh.employee_id = :NEW.employee_id AND UPPER(eh.dia_semana) = UPPER(:NEW.dia_semana) AND ROWNUM = 1;
    v_diferencia := ABS(EXTRACT(HOUR FROM (:NEW.hora_inicio_real - v_hora_inicio)) * 60 + EXTRACT(MINUTE FROM (:NEW.hora_inicio_real - v_hora_inicio)));
    IF v_diferencia > 30 THEN
        :NEW.hora_inicio_real := NULL;
        :NEW.hora_termino_real := NULL;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

-- Espacio de pruebas realizadas para comprobar lo realizado arriba
SET SERVEROUTPUT ON;

-- Pruebas del paquete EMPLOYEE_PKG
BEGIN
    DBMS_OUTPUT.PUT_LINE('===========================================');
    DBMS_OUTPUT.PUT_LINE('   PRUEBAS PAQUETE EMPLOYEE_PKG');
    DBMS_OUTPUT.PUT_LINE('===========================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.1 Top 4 empleados con mayor rotación ---');
    EMPLOYEE_PKG.top_4_rotacion;
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.2 Promedio contrataciones por mes ---');
    DBMS_OUTPUT.PUT_LINE('Promedio general: ' || EMPLOYEE_PKG.promedio_contrataciones_mes);
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.3 Gastos por región ---');
    EMPLOYEE_PKG.gastos_por_region;
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.4 Cálculo de vacaciones ---');
    DBMS_OUTPUT.PUT_LINE('Total a pagar: $' || EMPLOYEE_PKG.calcular_vacaciones);
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.5 Horas laboradas empleado 100 (Oct 2025) ---');
    DBMS_OUTPUT.PUT_LINE('Horas trabajadas: ' || EMPLOYEE_PKG.horas_laboradas(100, 10, 2025));
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.6 Horas de falta empleado 100 (Oct 2025) ---');
    DBMS_OUTPUT.PUT_LINE('Horas de falta: ' || EMPLOYEE_PKG.horas_falta(100, 10, 2025));
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.7 Reporte sueldo mensual (Oct 2025) ---');
    EMPLOYEE_PKG.reporte_sueldo_mensual(10, 2025);
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.8 Horas capacitación empleado 100 ---');
    DBMS_OUTPUT.PUT_LINE('Total horas: ' || EMPLOYEE_PKG.horas_capacitacion(100));
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('--- 3.1.9 Listado capacitaciones ---');
    EMPLOYEE_PKG.listado_capacitaciones;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===========================================');
    DBMS_OUTPUT.PUT_LINE('   FIN PRUEBAS PAQUETE');
    DBMS_OUTPUT.PUT_LINE('===========================================');
END;
/

-- Pruebas de los triggers
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===========================================');
    DBMS_OUTPUT.PUT_LINE('   PRUEBAS DE TRIGGERS');
    DBMS_OUTPUT.PUT_LINE('===========================================');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Prueba 3.2: Trigger validar asistencia (debe fallar con día incorrecto)
DECLARE
    v_error VARCHAR2(200);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba 3.2: Trigger validar asistencia ---');
    DBMS_OUTPUT.PUT_LINE('Intentando insertar asistencia con día incorrecto...');
    BEGIN
        INSERT INTO Asistencia_Empleado VALUES (108, 'Martes', TO_DATE('06-10-2025', 'DD-MM-YYYY'), 
                                                TO_TIMESTAMP('06-10-2025 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), 
                                                TO_TIMESTAMP('06-10-2025 13:00:00', 'DD-MM-YYYY HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('ERROR: Debería haber fallado');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('OK - Trigger funcionó: ' || SQLERRM);
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Intentando insertar asistencia sin horario asignado...');
    BEGIN
        INSERT INTO Asistencia_Empleado VALUES (109, 'Lunes', TO_DATE('06-10-2025', 'DD-MM-YYYY'), 
                                                TO_TIMESTAMP('06-10-2025 08:00:00', 'DD-MM-YYYY HH24:MI:SS'), 
                                                TO_TIMESTAMP('06-10-2025 13:00:00', 'DD-MM-YYYY HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('ERROR: Debería haber fallado');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('OK - Trigger funcionó: ' || SQLERRM);
            ROLLBACK;
    END;
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Prueba 3.3: Trigger validar salario (debe fallar con salario fuera de rango)
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba 3.3: Trigger validar salario ---');
    DBMS_OUTPUT.PUT_LINE('Intentando actualizar salario fuera de rango...');
    BEGIN
        UPDATE Employees SET salary = 50000 WHERE employee_id = 103;
        DBMS_OUTPUT.PUT_LINE('ERROR: Debería haber fallado');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('OK - Trigger funcionó: ' || SQLERRM);
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Intentando insertar empleado con salario menor al mínimo...');
    BEGIN
        INSERT INTO Employees VALUES (200, 'Test', 'Employee', 'TESTEMP', '555.555.5555', 
                                     SYSDATE, 'IT_PROG', 2000, NULL, NULL, 60);
        DBMS_OUTPUT.PUT_LINE('ERROR: Debería haber fallado');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('OK - Trigger funcionó: ' || SQLERRM);
            ROLLBACK;
    END;
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Prueba 3.4: Trigger control horario (debe marcar inasistencia si llega muy tarde)
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Prueba 3.4: Trigger control horario ---');
    DBMS_OUTPUT.PUT_LINE('Intentando registrar asistencia con más de 30 min de retraso...');
    
    INSERT INTO Asistencia_Empleado VALUES (100, 'Lunes', TO_DATE('20-10-2025', 'DD-MM-YYYY'), 
                                            TO_TIMESTAMP('20-10-2025 09:15:00', 'DD-MM-YYYY HH24:MI:SS'), 
                                            TO_TIMESTAMP('20-10-2025 13:00:00', 'DD-MM-YYYY HH24:MI:SS'));
    
    FOR rec IN (SELECT hora_inicio_real, hora_termino_real 
                FROM Asistencia_Empleado 
                WHERE employee_id = 100 AND fecha_real = TO_DATE('20-10-2025', 'DD-MM-YYYY')) LOOP
        IF rec.hora_inicio_real IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('OK - Se marcó inasistencia por llegar tarde');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Asistencia registrada: ' || TO_CHAR(rec.hora_inicio_real, 'HH24:MI'));
        END IF;
    END LOOP;
    ROLLBACK;
    
    DBMS_OUTPUT.PUT_LINE('Intentando registrar asistencia dentro del rango permitido...');
    INSERT INTO Asistencia_Empleado VALUES (100, 'Lunes', TO_DATE('27-10-2025', 'DD-MM-YYYY'), 
                                            TO_TIMESTAMP('27-10-2025 08:15:00', 'DD-MM-YYYY HH24:MI:SS'), 
                                            TO_TIMESTAMP('27-10-2025 13:00:00', 'DD-MM-YYYY HH24:MI:SS'));
    
    FOR rec IN (SELECT hora_inicio_real, hora_termino_real 
                FROM Asistencia_Empleado 
                WHERE employee_id = 100 AND fecha_real = TO_DATE('27-10-2025', 'DD-MM-YYYY')) LOOP
        IF rec.hora_inicio_real IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('OK - Asistencia registrada correctamente: ' || TO_CHAR(rec.hora_inicio_real, 'HH24:MI'));
        END IF;
    END LOOP;
    ROLLBACK;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('===========================================');
    DBMS_OUTPUT.PUT_LINE('   FIN PRUEBAS TRIGGERS');
    DBMS_OUTPUT.PUT_LINE('===========================================');
END;
/

/*
===========================================
   PRUEBAS PAQUETE EMPLOYEE_PKG
===========================================

--- 3.1.1 Top 4 empleados con mayor rotación ---
101 - Neena Kochhar - Administration Vice President (2 cambios)
100 - Steven King - President (1 cambios)
103 - Alexander Hunold - Programmer (1 cambios)
102 - Lex De Haan - Administration Vice President (1 cambios)

--- 3.1.2 Promedio contrataciones por mes ---
Enero          : 1
Febrero        : 1
Mayo           : 1
Junio          : 1
Agosto         : 2
Septiembre     : 1
Promedio general: 1,17

--- 3.1.3 Gastos por región ---
Americas                  | Total: $    79,000 | Empleados: 5 | Fecha antiguo: 17-06-1987
Asia                      | Total: $    28,800 | Empleados: 5 | Fecha antiguo: 03-01-1990

--- 3.1.4 Cálculo de vacaciones ---
Steven King                    | Años: 38 | Monto: $   76,000.00
Neena Kochhar                  | Años: 36 | Monto: $   51,000.00
Alexander Hunold               | Años: 35 | Monto: $   26,250.00
Bruce Ernst                    | Años: 34 | Monto: $   17,000.00
Lex De Haan                    | Años: 32 | Monto: $   45,333.33
Daniel Faviet                  | Años: 31 | Monto: $   23,250.00
Nancy Greenberg                | Años: 31 | Monto: $   31,000.00
David Austin                   | Años: 28 | Monto: $   11,200.00
Valli Pataballa                | Años: 27 | Monto: $   10,800.00
Diana Lorentz                  | Años: 26 | Monto: $    9,100.00
Total a pagar: $300933,33

--- 3.1.5 Horas laboradas empleado 100 (Oct 2025) ---
Horas trabajadas: 9,92

--- 3.1.6 Horas de falta empleado 100 (Oct 2025) ---
Horas de falta: 30,08

--- 3.1.7 Reporte sueldo mensual (Oct 2025) ---
David Austin                   | H.Lab:      5 | H.Falta:     15 | Sueldo: $    1,200.00
Lex De Haan                    | H.Lab:   4,92 | H.Falta:  15,08 | Sueldo: $    4,182.00
Bruce Ernst                    | H.Lab:      4 | H.Falta:     16 | Sueldo: $    1,200.00
Alexander Hunold               | H.Lab:   3,83 | H.Falta:  16,17 | Sueldo: $    1,723.50
Steven King                    | H.Lab:   9,92 | H.Falta:  30,08 | Sueldo: $    5,952.00
Neena Kochhar                  | H.Lab:   7,58 | H.Falta:  32,42 | Sueldo: $    3,221.50
Diana Lorentz                  | H.Lab:      4 | H.Falta:     16 | Sueldo: $      840.00
Valli Pataballa                | H.Lab:    4,5 | H.Falta:   15,5 | Sueldo: $    1,080.00

--- 3.1.8 Horas capacitación empleado 100 ---
Total horas: 90

--- 3.1.9 Listado capacitaciones ---
CAPACITACIÓN: Oracle Database Fundamentals (40 horas)
----------------------------------------------------------------------
  - Lex De Haan
  - Steven King
  Total: 2 empleado(s)

CAPACITACIÓN: PL/SQL Advanced Programming (50 horas)
----------------------------------------------------------------------
  - Steven King
  Total: 1 empleado(s)

CAPACITACIÓN: Liderazgo y Gestión de Equipos (30 horas)
----------------------------------------------------------------------
  - Neena Kochhar
  Total: 1 empleado(s)

CAPACITACIÓN: Seguridad Informática (45 horas)
----------------------------------------------------------------------
  - Lex De Haan
  Total: 1 empleado(s)

CAPACITACIÓN: Business Intelligence con Oracle (60 horas)
----------------------------------------------------------------------
  - Alexander Hunold
  Total: 1 empleado(s)

CAPACITACIÓN: Atención al Cliente (25 horas)
----------------------------------------------------------------------
  - Bruce Ernst
  Total: 1 empleado(s)

CAPACITACIÓN: Gestión de Proyectos Ágiles (35 horas)
----------------------------------------------------------------------
  - David Austin
  Total: 1 empleado(s)

CAPACITACIÓN: Excel Avanzado (20 horas)
----------------------------------------------------------------------
  - Valli Pataballa
  Total: 1 empleado(s)

CAPACITACIÓN: Comunicación Efectiva (15 horas)
----------------------------------------------------------------------
  - Diana Lorentz
  Total: 1 empleado(s)

===========================================
   FIN PRUEBAS PAQUETE
===========================================

Procedimiento PL/SQL terminado correctamente.

===========================================
   PRUEBAS DE TRIGGERS
===========================================


Procedimiento PL/SQL terminado correctamente.
--- Prueba 3.2: Trigger validar asistencia ---
Intentando insertar asistencia con día incorrecto...
OK - Trigger funcionó: ORA-20001: El día no corresponde con la fecha
ORA-06512: en "SYSTEM.TRG_VALIDAR_ASISTENCIA", línea 7
ORA-04088: error durante la ejecución del disparador 'SYSTEM.TRG_VALIDAR_ASISTENCIA'
Intentando insertar asistencia sin horario asignado...
OK - Trigger funcionó: ORA-20002: No tiene horario asignado
ORA-06512: en "SYSTEM.TRG_VALIDAR_ASISTENCIA", línea 11
ORA-04088: error durante la ejecución del disparador 'SYSTEM.TRG_VALIDAR_ASISTENCIA'


Procedimiento PL/SQL terminado correctamente.
--- Prueba 3.3: Trigger validar salario ---
Intentando actualizar salario fuera de rango...
OK - Trigger funcionó: ORA-20010: Salario fuera del rango
ORA-06512: en "SYSTEM.TRG_VALIDAR_SALARIO", línea 7
ORA-04088: error durante la ejecución del disparador 'SYSTEM.TRG_VALIDAR_SALARIO'
Intentando insertar empleado con salario menor al mínimo...
OK - Trigger funcionó: ORA-20010: Salario fuera del rango
ORA-06512: en "SYSTEM.TRG_VALIDAR_SALARIO", línea 7
ORA-04088: error durante la ejecución del disparador 'SYSTEM.TRG_VALIDAR_SALARIO'


Procedimiento PL/SQL terminado correctamente.
--- Prueba 3.4: Trigger control horario ---
Intentando registrar asistencia con más de 30 min de retraso...
OK - Se marcó inasistencia por llegar tarde
Intentando registrar asistencia dentro del rango permitido...
OK - Asistencia registrada correctamente: 08:15

===========================================
   FIN PRUEBAS TRIGGERS
===========================================

Procedimiento PL/SQL terminado correctamente.
*/