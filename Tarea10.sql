-- Tarea 10 - Transacciones Relacionales
-- Alumno: Gianpierre Rodrigo Dulanto Romero
-- Base de Datos II - 2025-2

-- Primero se crea las tablas que se muestran en el diagrama

CREATE TABLE regions (
  region_id   NUMBER         PRIMARY KEY,
  region_name VARCHAR2(25)
);

CREATE TABLE countries (
  country_id   CHAR(2)      PRIMARY KEY,
  country_name VARCHAR2(40),
  region_id    NUMBER,
  CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE locations (
  location_id    NUMBER(4)     PRIMARY KEY,
  street_address VARCHAR2(40),
  postal_code    VARCHAR2(12),
  city           VARCHAR2(30),
  state_province VARCHAR2(25),
  country_id     CHAR(2),
  CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE departments (
  department_id   NUMBER(4)     PRIMARY KEY,
  department_name VARCHAR2(30)  NOT NULL,
  manager_id      NUMBER(6),
  location_id     NUMBER(4),
  CONSTRAINT dept_loc_fk FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE jobs (
  job_id     VARCHAR2(10) PRIMARY KEY,
  job_title  VARCHAR2(35) NOT NULL,
  min_salary NUMBER(6),
  max_salary NUMBER(6)
);

CREATE TABLE employees (
  employee_id    NUMBER(6)   PRIMARY KEY,
  first_name     VARCHAR2(20),
  last_name      VARCHAR2(25) NOT NULL,
  email          VARCHAR2(25) NOT NULL UNIQUE,
  phone_number   VARCHAR2(20),
  hire_date      DATE         NOT NULL,
  job_id         VARCHAR2(10) NOT NULL,
  salary         NUMBER(8,2),
  commission_pct NUMBER(2,2),
  manager_id     NUMBER(6),
  department_id  NUMBER(4),
  CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES departments(department_id),
  CONSTRAINT emp_job_fk  FOREIGN KEY (job_id) REFERENCES jobs(job_id),
  CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE job_history (
  employee_id NUMBER(6),
  start_date  DATE,
  end_date    DATE         NOT NULL,
  job_id      VARCHAR2(10) NOT NULL,
  department_id NUMBER(4)  NOT NULL,
  CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date),
  CONSTRAINT jhist_emp_fk   FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  CONSTRAINT jhist_job_fk   FOREIGN KEY (job_id) REFERENCES jobs(job_id),
  CONSTRAINT jhist_dept_fk  FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- INSERCIÓN DE DATOS BÁSICOS PARA PRUEBA

INSERT INTO regions VALUES (1, 'Europe');
INSERT INTO regions VALUES (2, 'Americas');

INSERT INTO countries VALUES ('US', 'United States of America', 2);
INSERT INTO countries VALUES ('UK', 'United Kingdom', 1);

INSERT INTO locations VALUES (100, '1 Main St', '10001', 'New York', NULL, 'US');
INSERT INTO locations VALUES (200, '221B Baker St', 'NW16XE', 'London', NULL, 'UK');

INSERT INTO departments VALUES (10, 'Administration', NULL, 100);
INSERT INTO departments VALUES (20, 'IT', NULL, 200);
INSERT INTO departments VALUES (90, 'Executive', NULL, 100);
INSERT INTO departments VALUES (60, 'Sales', NULL, 100);
INSERT INTO departments VALUES (50, 'Shipping', NULL, 100);
INSERT INTO departments VALUES (110, 'Marketing', NULL, 200);
INSERT INTO departments VALUES (80, 'Finance', NULL, 200);
INSERT INTO departments VALUES (100, 'Human Resources', NULL, 200);

INSERT INTO jobs VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO jobs VALUES ('IT_PROG', 'Programmer', 4000, 9000);
INSERT INTO jobs VALUES ('FI_MGR',  'Finance Manager', 8200, 16000);
INSERT INTO jobs VALUES ('SA_REP',  'Sales Rep', 6000, 12000);
INSERT INTO jobs VALUES ('SH_CLERK', 'Shipping Clerk', 2500, 5500);

INSERT INTO employees VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', SYSDATE-5000, 'AD_PRES', 24000, NULL, NULL, 90);
INSERT INTO employees VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', SYSDATE-4900, 'IT_PROG', 9000, NULL, 100, 90);
INSERT INTO employees VALUES (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', SYSDATE-4800, 'FI_MGR', 12000, NULL, 100, 80);
INSERT INTO employees VALUES (103, 'John', 'Chen', 'JCHEN', '515.123.4570', SYSDATE-4700, 'SH_CLERK', 3400, NULL, 101, 50);
INSERT INTO employees VALUES (104, 'Luis', 'Lorenzo', 'LLORENZO', '515.123.4571', SYSDATE-4600, 'IT_PROG', 6000, NULL, 102, 60);
INSERT INTO employees VALUES (105, 'Marta', 'Soto', 'MSOTO', '515.123.4572', SYSDATE-4500, 'SA_REP', 8500, NULL, 101, 100);

COMMIT;

-- ===============================================================
-- EJERCICIOS PLANTEADOS DE BLOQUES ANÓNIMOS
-- ===============================================================

-- EJERCICIO 1: Control básico de transacciones
/*
Bloque anónimo que:
- Aumenta en 10% el salario de empleados del departamento 90
- SAVEPOINT
- Aumenta en 5% el salario de depto. 60
- ROLLBACK TO punto1
- COMMIT

Preguntas:
a. ¿Qué departamento mantuvo los cambios?
b. ¿Qué efecto tuvo el ROLLBACK parcial?
c. ¿Qué ocurriría si se ejecutara ROLLBACK sin especificar SAVEPOINT?

Respuestas:
a. Solo los empleados de depto. 90 mantienen el aumento.
b. El rollback parcial revierte lo hecho después del savepoint (depto. 60 no se ve afectado).
c. Un rollback global antes del commit elimina todo cambio.
*/
BEGIN
  UPDATE employees SET salary = salary * 1.10 WHERE department_id = 90;
  SAVEPOINT punto1;
  UPDATE employees SET salary = salary * 1.05 WHERE department_id = 60;
  ROLLBACK TO punto1;
  COMMIT;
END;
/

-- EJERCICIO 2: Bloqueos entre sesiones

/*
En dos sesiones diferentes de Oracle:
• En la primera sesión, ejecute:
UPDATE employees
SET salary = salary + 500
WHERE employee_id = 103;
• Sin ejecutar COMMIT, en la segunda sesión, intente modificar el mismo registro.
• Observe el bloqueo y, desde la primera sesión, ejecute:
ROLLBACK;
• Analice el efecto sobre la segunda sesión.

En Sesión 1:
UPDATE employees SET salary = salary + 500 WHERE employee_id = 103;

En Sesión 2:
UPDATE employees SET salary = salary + 300 WHERE employee_id = 103;

Preguntas:
a. ¿Por qué la segunda sesión quedó bloqueada?
b. ¿Qué comando libera los bloqueos?
c. ¿Qué vistas del diccionario permiten verificar sesiones bloqueadas?

Respuestas:
a. El registro está bloqueado por la sesión 1 el tiempo que dure la transacción, la sesión 2 queda esperando.
b. El commit o rollback de sesión 1 libera el bloqueo.
c. Se pueden revisar bloqueos con:
   SELECT * FROM v$lock;
   SELECT * FROM v$session WHERE username='HR';
*/

-- EJERCICIO 3: Transacción controlada: transferencia de empleado

/*
Cree un bloque anónimo PL/SQL que realice una transferencia de empleado de un
departamento a otro, registrando la transacción en JOB_HISTORY.
Pasos:
• Actualice el department_id del empleado 104 al departamento 110.
• Inserte simultáneamente el registro correspondiente en JOB_HISTORY.
• Si ocurre un error (por ejemplo, departamento inexistente), haga un ROLLBACK y
muestre un mensaje con DBMS_OUTPUT.

Transfiere a un empleado al departamento 110 y agrega el cambio a JOB_HISTORY,
todo como transacción atómica que haga rollback en error.
*/

DECLARE
  v_old_department employees.department_id%TYPE;
  v_job_id employees.job_id%TYPE;
  v_hire_date employees.hire_date%TYPE;
BEGIN
  SELECT department_id, job_id, hire_date INTO v_old_department, v_job_id, v_hire_date
  FROM employees WHERE employee_id = 104;

  UPDATE employees SET department_id = 110 WHERE employee_id = 104;

  INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (104, v_hire_date, SYSDATE, v_job_id, v_old_department);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error en transferencia');
END;
/
/*
Preguntas:
a. ¿Por qué se debe garantizar la atomicidad entre las dos operaciones?
b. ¿Qué pasaría si se produce un error antes del COMMIT?
c. ¿Cómo se asegura la integridad entre EMPLOYEES y JOB_HISTORY?

Respuestas:
a. Garantiza que ambas operaciones se realicen o ninguna.
b. Si falla, rollback deshace todo.
c. Integridad referencial por claves foráneas.
*/

-- EJERCICIO 4: Savepoint y reversión parcial

/*
Bloque que:
- Aumenta 8% salario depto. 100 (SAVEPOINT A)
- Aumenta 5% salario depto. 80 (SAVEPOINT B)
- Borra empleados depto. 50
- Rollback to B
- Commit

Preguntas:
a. ¿Qué cambios quedan persistentes?
b. ¿Qué sucede con las filas eliminadas?
c. ¿Cómo puedes verificar los cambios antes y después del COMMIT?

Respuestas:
a. Permanecen solo los aumentos a deptos. 100 y 80.
b. El delete al depto. 50 se revierte.
c. Se comprueba con SELECT antes/después del bloque.
*/
BEGIN
  UPDATE employees SET salary = salary * 1.08 WHERE department_id = 100;
  SAVEPOINT A;
  UPDATE employees SET salary = salary * 1.05 WHERE department_id = 80;
  SAVEPOINT B;
  DELETE FROM employees WHERE department_id = 50;
  ROLLBACK TO B;
  COMMIT;
END;
/