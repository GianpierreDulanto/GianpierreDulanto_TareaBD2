-- Tarea 07 - Procedimientos y Funciones PL/SQL
-- Alumno: Gianpierre Rodrigo Dulanto Romero
-- Base de Datos II - 2025-2

-- Primero se crea las tablas del esquema de proveedores
CREATE TABLE S (
    S_NUM VARCHAR2(3) PRIMARY KEY,
    SNAME VARCHAR2(20),
    STATUS NUMBER(3),
    CITY VARCHAR2(20)
);

CREATE TABLE P (
    P_NUM VARCHAR2(3) PRIMARY KEY,
    PNAME VARCHAR2(20),
    COLOR VARCHAR2(10),
    WEIGHT NUMBER(5,2),
    CITY VARCHAR2(20)
);

CREATE TABLE SP (
    S_NUM VARCHAR2(3),
    P_NUM VARCHAR2(3),
    QTY NUMBER(5),
    PRIMARY KEY (S_NUM, P_NUM),
    FOREIGN KEY (S_NUM) REFERENCES S(S_NUM),
    FOREIGN KEY (P_NUM) REFERENCES P(P_NUM)
);

CREATE TABLE J (
    J_NUM VARCHAR2(3) PRIMARY KEY,
    JNAME VARCHAR2(20),
    CITY VARCHAR2(20)
);

CREATE TABLE SPJ (
    S_NUM VARCHAR2(3),
    P_NUM VARCHAR2(3),
    J_NUM VARCHAR2(3),
    QTY NUMBER(5),
    PRIMARY KEY (S_NUM, P_NUM, J_NUM),
    FOREIGN KEY (S_NUM) REFERENCES S(S_NUM),
    FOREIGN KEY (P_NUM) REFERENCES P(P_NUM),
    FOREIGN KEY (J_NUM) REFERENCES J(J_NUM)
);

-- Se inserta los datos solicitados en la guia
INSERT INTO S VALUES ('S1', 'Smith', 20, 'London');
INSERT INTO S VALUES ('S2', 'Jones', 10, 'Paris');
INSERT INTO S VALUES ('S3', 'Blake', 30, 'Paris');
INSERT INTO S VALUES ('S4', 'Clark', 20, 'London');
INSERT INTO S VALUES ('S5', 'Adams', 30, 'Athens');

INSERT INTO P VALUES ('P1', 'Nut', 'Red', 12, 'London');
INSERT INTO P VALUES ('P2', 'Bolt', 'Green', 17, 'Paris');
INSERT INTO P VALUES ('P3', 'Screw', 'Blue', 17, 'Rome');
INSERT INTO P VALUES ('P4', 'Screw', 'Red', 14, 'London');
INSERT INTO P VALUES ('P5', 'Cam', 'Blue', 12, 'Paris');
INSERT INTO P VALUES ('P6', 'Cog', 'Red', 19, 'London');

INSERT INTO SP VALUES ('S1', 'P1', 300);
INSERT INTO SP VALUES ('S1', 'P2', 200);
INSERT INTO SP VALUES ('S1', 'P3', 400);
INSERT INTO SP VALUES ('S1', 'P4', 200);
INSERT INTO SP VALUES ('S1', 'P5', 100);
INSERT INTO SP VALUES ('S1', 'P6', 100);
INSERT INTO SP VALUES ('S2', 'P1', 300);
INSERT INTO SP VALUES ('S2', 'P2', 400);
INSERT INTO SP VALUES ('S3', 'P2', 200);
INSERT INTO SP VALUES ('S4', 'P2', 200);
INSERT INTO SP VALUES ('S4', 'P4', 300);
INSERT INTO SP VALUES ('S4', 'P5', 400);

INSERT INTO J VALUES ('J1', 'Sorter', 'Paris');
INSERT INTO J VALUES ('J2', 'Display', 'Rome');
INSERT INTO J VALUES ('J3', 'OCR', 'Athens');
INSERT INTO J VALUES ('J4', 'Console', 'Athens');
INSERT INTO J VALUES ('J5', 'RAID', 'London');
INSERT INTO J VALUES ('J6', 'EDS', 'Oslo');
INSERT INTO J VALUES ('J7', 'Tape', 'London');

COMMIT;

-- 4.1.1 - Obtenga el color y ciudad para las partes que no son de París, con un peso mayor de diez.
CREATE OR REPLACE PROCEDURE sp_partes_no_paris IS
BEGIN
    FOR rec IN (SELECT COLOR, CITY 
                FROM P 
                WHERE CITY != 'Paris' AND WEIGHT > 10) 
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.COLOR || ' - ' || rec.CITY);
    END LOOP;
END;
/

-- 4.1.2 - Para todas las partes, obtenga el número de parte y el peso de dichas partes en gramos.
CREATE OR REPLACE PROCEDURE sp_peso_gramos IS
BEGIN
    FOR rec IN (SELECT P_NUM, ROUND(WEIGHT * 453.592, 2) AS PESO_G 
                FROM P) 
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.P_NUM || ': ' || rec.PESO_G || ' gramos');
    END LOOP;
END;
/

-- 4.1.3 - Obtenga el detalle completo de todos los proveedores.
CREATE OR REPLACE PROCEDURE sp_detalle_proveedores IS
BEGIN
    FOR rec IN (SELECT * FROM S ORDER BY S_NUM) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor ' || rec.S_NUM || ': ' || rec.SNAME || 
                           ', Status=' || rec.STATUS || ', Ciudad=' || rec.CITY);
    END LOOP;
END;
/

-- 4.1.4 - Obtenga todas las combinaciones de proveedores y partes para aquellos proveedores y partes co-localizados.
CREATE OR REPLACE PROCEDURE sp_proveedores_partes_misma_ciudad IS
BEGIN
    FOR rec IN (SELECT S.S_NUM, P.P_NUM, S.CITY
                FROM S, P
                WHERE S.CITY = P.CITY) 
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.S_NUM || ' con ' || rec.P_NUM || ' en ' || rec.CITY);
    END LOOP;
END;
/

-- 4.1.5 - Obtenga todos los pares de nombres de ciudades de tal forma que el proveedor localizado en la primera ciudad del par abastece una parte almacenada en la segunda ciudad del par.
CREATE OR REPLACE PROCEDURE sp_pares_ciudades IS
BEGIN
    FOR rec IN (SELECT DISTINCT S.CITY AS CIUDAD_PROV, P.CITY AS CIUDAD_PARTE
                FROM S, P, SP
                WHERE S.S_NUM = SP.S_NUM AND P.P_NUM = SP.P_NUM) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('De ' || rec.CIUDAD_PROV || ' hacia ' || rec.CIUDAD_PARTE);
    END LOOP;
END;
/

-- 4.1.6 - Obtenga todos los pares de número de proveedor tales que los dos proveedores del par estén co-localizados.
CREATE OR REPLACE PROCEDURE sp_proveedores_misma_ciudad IS
BEGIN
    FOR rec IN (SELECT S1.S_NUM AS PROV1, S2.S_NUM AS PROV2, S1.CITY
                FROM S S1, S S2
                WHERE S1.CITY = S2.CITY AND S1.S_NUM < S2.S_NUM) 
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.PROV1 || ' y ' || rec.PROV2 || ' estan en ' || rec.CITY);
    END LOOP;
END;
/

-- 4.1.7 - Obtenga el número total de proveedores.
CREATE OR REPLACE FUNCTION fn_total_proveedores RETURN NUMBER IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total FROM S;
    RETURN v_total;
END;
/

-- 4.1.8 - Obtenga la cantidad mínima y la cantidad máxima para la parte P2.
CREATE OR REPLACE PROCEDURE sp_min_max_p2(p_min OUT NUMBER, p_max OUT NUMBER) IS
BEGIN
    SELECT MIN(QTY), MAX(QTY) INTO p_min, p_max
    FROM SP WHERE P_NUM = 'P2';
END;
/

-- 4.1.9 - Para cada parte abastecida, obtenga el número de parte y el total despachado.
CREATE OR REPLACE PROCEDURE sp_total_por_parte IS
BEGIN
    FOR rec IN (SELECT P_NUM, SUM(QTY) AS TOTAL
                FROM SP GROUP BY P_NUM ORDER BY P_NUM) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Parte ' || rec.P_NUM || ': Total=' || rec.TOTAL);
    END LOOP;
END;
/

-- 4.1.10 - Obtenga el número de parte para todas las partes abastecidas por más de un proveedor.
CREATE OR REPLACE PROCEDURE sp_partes_multiples_prov IS
BEGIN
    FOR rec IN (SELECT P_NUM, COUNT(DISTINCT S_NUM) AS NUM_PROV
                FROM SP GROUP BY P_NUM
                HAVING COUNT(DISTINCT S_NUM) > 1) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Parte ' || rec.P_NUM || ' tiene ' || rec.NUM_PROV || ' proveedores');
    END LOOP;
END;
/

-- 4.1.11 - Obtenga el nombre de proveedor para todos los proveedores que abastecen la parte P2.
CREATE OR REPLACE PROCEDURE sp_proveedores_de_p2 IS
BEGIN
    FOR rec IN (SELECT DISTINCT S.SNAME
                FROM S, SP
                WHERE S.S_NUM = SP.S_NUM AND SP.P_NUM = 'P2') 
    LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.12 - Obtenga el nombre de proveedor de quienes abastecen por lo menos una parte.
CREATE OR REPLACE PROCEDURE sp_proveedores_activos IS
BEGIN
    FOR rec IN (SELECT DISTINCT S.SNAME
                FROM S WHERE S.S_NUM IN (SELECT S_NUM FROM SP)) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.13 - Obtenga el número de proveedor para los proveedores con estado menor que el máximo valor de estado en la tabla S.
CREATE OR REPLACE PROCEDURE sp_status_menor_al_max IS
    v_max NUMBER;
BEGIN
    SELECT MAX(STATUS) INTO v_max FROM S;
    DBMS_OUTPUT.PUT_LINE('Status maximo: ' || v_max);
    
    FOR rec IN (SELECT S_NUM, SNAME, STATUS FROM S WHERE STATUS < v_max) 
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.S_NUM || ' - ' || rec.SNAME || ' (Status=' || rec.STATUS || ')');
    END LOOP;
END;
/

-- 4.1.14 - Obtenga el nombre de proveedor para los proveedores que abastecen la parte P2 (aplicar EXISTS en su solución).
CREATE OR REPLACE PROCEDURE sp_proveedores_p2_exists IS
BEGIN
    FOR rec IN (SELECT SNAME FROM S
                WHERE EXISTS (SELECT 1 FROM SP 
                             WHERE SP.S_NUM = S.S_NUM AND SP.P_NUM = 'P2')) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.15 - Obtenga el nombre de proveedor para los proveedores que no abastecen la parte P2.
CREATE OR REPLACE PROCEDURE sp_no_abastecen_p2 IS
BEGIN
    FOR rec IN (SELECT SNAME FROM S
                WHERE S_NUM NOT IN (SELECT S_NUM FROM SP WHERE P_NUM = 'P2')) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || rec.SNAME);
    END LOOP;
END;
/

-- 4.1.16 - Obtenga el nombre de proveedor para los proveedores que abastecen todas las partes.
CREATE OR REPLACE PROCEDURE sp_abastecen_todas IS
    v_total_partes NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total_partes FROM P;
    
    FOR rec IN (SELECT S.SNAME, COUNT(DISTINCT SP.P_NUM) AS PARTES
                FROM S, SP WHERE S.S_NUM = SP.S_NUM
                GROUP BY S.S_NUM, S.SNAME
                HAVING COUNT(DISTINCT SP.P_NUM) = v_total_partes) 
    LOOP
        DBMS_OUTPUT.PUT_LINE(rec.SNAME || ' abastece todas (' || rec.PARTES || ' partes)');
    END LOOP;
END;
/

-- 4.1.17 - Obtenga el número de parte para todas las partes que pesan más de 16 libras ó son abastecidas por el proveedor S2, ó cumplen con ambos criterios.
CREATE OR REPLACE PROCEDURE sp_peso_mayor_o_s2 IS
BEGIN
    FOR rec IN (SELECT DISTINCT P.P_NUM, P.WEIGHT
                FROM P LEFT JOIN SP ON P.P_NUM = SP.P_NUM
                WHERE P.WEIGHT > 16 OR SP.S_NUM = 'S2'
                ORDER BY P.P_NUM) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Parte ' || rec.P_NUM || ' (Peso=' || rec.WEIGHT || ')');
    END LOOP;
END;
/

SET SERVEROUTPUT ON;

-- Ejecución de los 17 procedimientos y funciones
BEGIN
    DBMS_OUTPUT.PUT_LINE('1. Partes que no son de Paris y pesan más de 10:');
    sp_partes_no_paris;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '2. Peso de cada parte en gramos:');
    sp_peso_gramos;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '3. Detalle completo de proveedores:');
    sp_detalle_proveedores;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '4. Proveedores y partes co-localizados:');
    sp_proveedores_partes_misma_ciudad;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '5. Pares de ciudades proveedor-parte:');
    sp_pares_ciudades;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '6. Pares de proveedores en la misma ciudad:');
    sp_proveedores_misma_ciudad;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '7. Total de proveedores:');
    DBMS_OUTPUT.PUT_LINE('Total: ' || fn_total_proveedores);

    -- Para la pregunta 8 con procedimientos con OUT, se usa un bloque DECLARE aparte , al final la coloqué

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '9. Total despachado por parte:');
    sp_total_por_parte;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '10. Partes abastecidas por más de un proveedor:');
    sp_partes_multiples_prov;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '11. Proveedores que abastecen P2:');
    sp_proveedores_de_p2;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '12. Proveedores que abastecen al menos una parte:');
    sp_proveedores_activos;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '13. Proveedores con status menor al máximo:');
    sp_status_menor_al_max;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '14. Proveedores que abastecen P2:');
    sp_proveedores_p2_exists;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '15. Proveedores que NO abastecen P2:');
    sp_no_abastecen_p2;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '16. Proveedores que abastecen todas las partes:');
    sp_abastecen_todas;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '17. Partes con peso > 16 o abastecidas por S2:');
    sp_peso_mayor_o_s2;
END;
/

-- Pregunta 8, parámetros OUT
DECLARE
    v_min NUMBER;
    v_max NUMBER;
BEGIN
    sp_min_max_p2(v_min, v_max);
    DBMS_OUTPUT.PUT_LINE('Min: ' || v_min || ', Max: ' || v_max);
END;
/


/*
Resultados obtenidos en consola
1. Partes que no son de Paris y pesan más de 10:
Red - London
Blue - Rome
Red - London
Red - London

2. Peso de cada parte en gramos:
P1: 5443,1 gramos
P2: 7711,06 gramos
P3: 7711,06 gramos
P4: 6350,29 gramos
P5: 5443,1 gramos
P6: 8618,25 gramos

3. Detalle completo de proveedores:
Proveedor S1: Smith, Status=20, Ciudad=London
Proveedor S2: Jones, Status=10, Ciudad=Paris
Proveedor S3: Blake, Status=30, Ciudad=Paris
Proveedor S4: Clark, Status=20, Ciudad=London
Proveedor S5: Adams, Status=30, Ciudad=Athens

4. Proveedores y partes co-localizados:
S1 con P1 en London
S4 con P1 en London
S2 con P2 en Paris
S3 con P2 en Paris
S1 con P4 en London
S4 con P4 en London
S2 con P5 en Paris
S3 con P5 en Paris
S1 con P6 en London
S4 con P6 en London

5. Pares de ciudades proveedor-parte:
De London hacia London
De London hacia Paris
De London hacia Rome
De Paris hacia London
De Paris hacia Paris

6. Pares de proveedores en la misma ciudad:
S2 y S3 estan en Paris
S1 y S4 estan en London

7. Total de proveedores:
Total: 5

9. Total despachado por parte:
Parte P1: Total=600
Parte P2: Total=1000
Parte P3: Total=400
Parte P4: Total=500
Parte P5: Total=500
Parte P6: Total=100

10. Partes abastecidas por más de un proveedor:
Parte P1 tiene 2 proveedores
Parte P2 tiene 4 proveedores
Parte P4 tiene 2 proveedores
Parte P5 tiene 2 proveedores

11. Proveedores que abastecen P2:
- Smith
- Jones
- Blake
- Clark

12. Proveedores que abastecen al menos una parte:
- Smith
- Jones
- Blake
- Clark

13. Proveedores con status menor al máximo:
Status maximo: 30
S1 - Smith (Status=20)
S2 - Jones (Status=10)
S4 - Clark (Status=20)

14. Proveedores que abastecen P2:
- Smith
- Jones
- Blake
- Clark

15. Proveedores que NO abastecen P2:
- Adams

16. Proveedores que abastecen todas las partes:
Smith abastece todas (6 partes)

17. Partes con peso > 16 o abastecidas por S2:
Parte P1 (Peso=12)
Parte P2 (Peso=17)
Parte P3 (Peso=17)
Parte P6 (Peso=19)

Procedimiento PL/SQL terminado correctamente.
Min: 200, Max: 400

Procedimiento PL/SQL terminado correctamente.

*/
