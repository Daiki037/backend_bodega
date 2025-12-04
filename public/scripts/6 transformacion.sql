--===================================================================================================================================================================================
--BODEGA DE DATOS SISTEMA YACHAY - RPCMP
--REGISTRO POBLACIONAL DE CANCER DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================
--MARZO DE 2025
--TRANSFORMACION DE DATOS A PARTIR DE LOS DATOS LIMPIOS DE LOS TUMORES-FUENTE DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================

--Crear la tabla tumores_pasto_transformado a partir de la tabla tumores_pasto_limpio.
BEGIN;
CREATE TABLE etl.tumores_pasto_transformado AS SELECT * FROM etl.tumores_pasto_limpio;
COMMIT;
--SELECT 41345
--Query returned successfully in 376 msec.
--COMMIT
--Query returned successfully in 764 msec.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1. Campo cod_sexo
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_sexo SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 426 msec.
--COMMIT
--Query returned successfully in 384 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Campo sexo
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN sexo SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 388 msec.
--COMMIT
--Query returned successfully in 483 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3. Campo edad_paciente
--Crear los atributos cod_grupo_etario1 y cod_grupo_etario2 de tipo SMALLINT y grupo_etario1 y grupo_etario2 de
--tipo TEXT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_grupo_etario1 SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_grupo_etario2 SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD grupo_etario1 TEXT;
ALTER TABLE etl.tumores_pasto_transformado ADD grupo_etario2 TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 118 msec.
--COMMIT
--Query returned successfully in 120 msec.
--Actualizar los atributos cod_grupo_etario1 y grupo_etario1 discretizando el atributo edad_paciente en 18 grupos
--quinquenales, el grupo 0 para 0 años conocido como Lactantes y el grupo 19 para Desconocido, de acuerdo a la
--siguiente relacion:
--0 -> 0 (Lactantes) -> De 0 años de edad
--1 -> 1 - 4 -> De 1 a 4 años de edad
--2 -> 5 - 9 -> De 5 a 9 años de edad
--3 -> 10 - 14 -> De 10 a 14 años de edad
--4 -> 15 - 19 -> De 15 a 19 años de edad
--5 -> 20 - 24 -> De 20 a 24 años de edad
--6 -> 25 - 29 -> De 25 a 29 años de edad
--7 -> 30 - 34 -> De 30 a 34 años de edad
--8 -> 35 - 39 -> De 35 a 39 años de edad
--9 -> 40 - 44 -> De 40 a 44 años de edad
--10 -> 45 - 49 -> De 45 a 49 años de edad
--11 -> 50 - 54 -> De 50 a 54 años de edad
--12 -> 55 - 59 -> De 55 a 59 años de edad
--13 -> 60 - 64 -> De 60 a 64 años de edad
--14 -> 65 - 69 -> De 65 a 69 años de edad
--15 -> 70 - 74 -> De 70 a 74 años de edad
--16 -> 75 - 79 -> De 75 a 79 años de edad
--17 -> 80 - 84 -> De 80 a 84 años de edad
--18 -> 85 y más -> De 85 y más años de edad
--19 -> Desconocido
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_grupo_etario1 = CASE
WHEN edad_paciente = 999 THEN 19
WHEN edad_paciente = 0 THEN 0
WHEN edad_paciente BETWEEN 1 AND 4 THEN 1
WHEN edad_paciente BETWEEN 5 AND 9 THEN 2
WHEN edad_paciente BETWEEN 10 AND 14 THEN 3
WHEN edad_paciente BETWEEN 15 AND 19 THEN 4
WHEN edad_paciente BETWEEN 20 AND 24 THEN 5
WHEN edad_paciente BETWEEN 25 AND 29 THEN 6
WHEN edad_paciente BETWEEN 30 AND 34 THEN 7
WHEN edad_paciente BETWEEN 35 AND 39 THEN 8
WHEN edad_paciente BETWEEN 40 AND 44 THEN 9
WHEN edad_paciente BETWEEN 45 AND 49 THEN 10
WHEN edad_paciente BETWEEN 50 AND 54 THEN 11
WHEN edad_paciente BETWEEN 55 AND 59 THEN 12
WHEN edad_paciente BETWEEN 60 AND 64 THEN 13
WHEN edad_paciente BETWEEN 65 AND 69 THEN 14
WHEN edad_paciente BETWEEN 70 AND 74 THEN 15
WHEN edad_paciente BETWEEN 75 AND 79 THEN 16
WHEN edad_paciente BETWEEN 80 AND 84 THEN 17
WHEN edad_paciente >= 85 THEN 18
ELSE 19 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 207 msec.
--COMMIT
--Query returned successfully in 1 secs 101 msec.
BEGIN;
UPDATE etl.tumores_pasto_transformado SET grupo_etario1 = CASE
WHEN edad_paciente = 999 THEN 'Desconocido'
WHEN edad_paciente = 0 THEN '0 (Lactantes)'
WHEN edad_paciente BETWEEN 1 AND 4 THEN '1 - 4'
WHEN edad_paciente BETWEEN 5 AND 9 THEN '5 - 9'
WHEN edad_paciente BETWEEN 10 AND 14 THEN '10 - 14'
WHEN edad_paciente BETWEEN 15 AND 19 THEN '15 - 19'
WHEN edad_paciente BETWEEN 20 AND 24 THEN '20 - 24'
WHEN edad_paciente BETWEEN 25 AND 29 THEN '25 - 29'
WHEN edad_paciente BETWEEN 30 AND 34 THEN '30 - 34'
WHEN edad_paciente BETWEEN 35 AND 39 THEN '35 - 39'
WHEN edad_paciente BETWEEN 40 AND 44 THEN '40 - 44'
WHEN edad_paciente BETWEEN 45 AND 49 THEN '45 - 49'
WHEN edad_paciente BETWEEN 50 AND 54 THEN '50 - 54'
WHEN edad_paciente BETWEEN 55 AND 59 THEN '55 - 59'
WHEN edad_paciente BETWEEN 60 AND 64 THEN '60 - 64'
WHEN edad_paciente BETWEEN 65 AND 69 THEN '65 - 69'
WHEN edad_paciente BETWEEN 70 AND 74 THEN '70 - 74'
WHEN edad_paciente BETWEEN 75 AND 79 THEN '75 - 79'
WHEN edad_paciente BETWEEN 80 AND 84 THEN '80 - 84'
WHEN edad_paciente >= 85 THEN '85 y más'
ELSE 'Desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 465 msec.
--COMMIT
--Query returned successfully in 1 secs 660 msec.
--Actualizar los atributos cod_grupo_etario2 y grupo_etario2 a partir de los valores de cod_grupo_etario1 y
--grupo_etario1 con la salvedad de que el grupo 0 desaparece y se incluye en el grupo 1 cambiando su descripcion
--de '1 - 4' a '0 - 4' de acuerdo a la siguiente relacion:
--1 -> 0 - 4 -> De 0 a 4 años de edad
--2 -> 5 - 9 -> De 5 a 9 años de edad
--...
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_grupo_etario2 = CASE
WHEN cod_grupo_etario1 = 0 THEN 1
ELSE cod_grupo_etario1 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 830 msec.
--COMMIT
--Query returned successfully in 720 msec.
BEGIN;
UPDATE etl.tumores_pasto_transformado SET grupo_etario2 = CASE
WHEN grupo_etario1 = '0 (Lactantes)' THEN '0 - 4'
WHEN grupo_etario1 = '1 - 4' THEN '0 - 4'
ELSE grupo_etario1 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 93 msec.
--COMMIT
--Query returned successfully in 1 secs 201 msec.
--Crear el atributo descripcion_edad de tipo TEXT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD descripcion_edad TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 167 msec.
--COMMIT
--Query returned successfully in 136 msec.
--Actualizar el atributo descripcion_edad con el valor de la edad
BEGIN;
UPDATE etl.tumores_pasto_transformado SET descripcion_edad = edad_paciente;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 349 msec.
--COMMIT
--Query returned successfully in 1 secs 136 msec.
--Actualizar los valores 999 del atributo descripcion_edad por Desconocido
BEGIN;
UPDATE etl.tumores_pasto_transformado SET descripcion_edad = CASE
WHEN descripcion_edad = '999' THEN 'Desconocido' ELSE descripcion_edad END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 908 msec.
--COMMIT
--Query returned successfully in 730 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4. Campo cod_estado_vital
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_estado_vital SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 916 msec.
--COMMIT
--Query returned successfully in 572 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5. Campo estado_vital
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN estado_vital SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 74 msec.
--COMMIT
--Query returned successfully in 77 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--6. Campo fecha_diagnostico
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN fecha_diagnostico SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 100 msec.
--COMMIT
--Query returned successfully in 72 msec.
--Crear los atributos cod_dia_diagnostico,dia_diagnostico,cod_mes_diagnostico,mes_diagnostico,ano_diagnostico de
--tipo SMALLINT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_dia_diagnostico SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD dia_diagnostico SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_mes_diagnostico SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD mes_diagnostico SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD ano_diagnostico SMALLINT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 120 msec.
--COMMIT
--Query returned successfully in 69 msec.
--Separar la fecha de diagnostico en los campos creados
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
cod_dia_diagnostico = CAST(split_part(fecha_diagnostico, '-', 1) AS SMALLINT),
dia_diagnostico = CAST(split_part(fecha_diagnostico, '-', 1) AS SMALLINT),
cod_mes_diagnostico = CAST(split_part(fecha_diagnostico, '-', 2) AS SMALLINT),
mes_diagnostico = CAST(split_part(fecha_diagnostico, '-', 2) AS SMALLINT),
ano_diagnostico = CAST(split_part(fecha_diagnostico, '-', 3) AS SMALLINT);
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 639 msec.
--COMMIT
--Query returned successfully in 637 msec.
--Reemplazar el valor 99 del atributo cod_dia_diagnostico por el valor de 32 estableciendo un orden para el
--atributo dia_diagnostico
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_dia_diagnostico = 32 WHERE cod_dia_diagnostico = 99;
COMMIT;
--UPDATE 1132
--Query returned successfully in 148 msec.
--COMMIT
--Query returned successfully in 85 msec.
--Reemplazar el valor 99 del atributo cod_mes_diagnostico por el valor de 13 estableciendo un orden para el
--atributo mes_diagnostico
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_mes_diagnostico = 13 WHERE cod_mes_diagnostico = 99;
COMMIT;
--UPDATE 592
--Query returned successfully in 400 msec.
--COMMIT
--Query returned successfully in 203 msec.
--Crear los atributos trimestre_diagnostico y semestre_diagnostico de tipo TEXT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD trimestre_diagnostico TEXT;
ALTER TABLE etl.tumores_pasto_transformado ADD semestre_diagnostico TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 88 msec.
--COMMIT
--Query returned successfully in 73 msec.
--Actualizar el atributo trimestre_diagnostico discretizando el atributo mes_diagnostico en 4 grupos de meses y el
--grupo 0 para Desconocido, de acuerdo a la siguiente relacion:
--0 -> Desconocido -> mes 99
--1 -> Trimestre 1 (de enero a marzo) -> meses 1 al 3
--2 -> Trimestre 2 (de abril a junio) -> meses 4 al 6
--3 -> Trimestre 3 (de julio a septiembre) -> meses 7 al 9
--4 -> Trimestre 4 (de octubre a diciembre) -> meses 10 al 12
BEGIN;
UPDATE etl.tumores_pasto_transformado SET trimestre_diagnostico = CASE
WHEN mes_diagnostico = 99 THEN 'Desconocido'
WHEN mes_diagnostico BETWEEN 1 AND 3 THEN 'Trimestre 1 (de enero a marzo)'
WHEN mes_diagnostico BETWEEN 4 AND 6 THEN 'Trimestre 2 (de abril a junio)'
WHEN mes_diagnostico BETWEEN 7 AND 9 THEN 'Trimestre 3 (de julio a septiembre)'
WHEN mes_diagnostico BETWEEN 10 AND 12 THEN 'Trimestre 4 (de octubre a diciembre)'
ELSE 'Desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 771 msec.
--COMMIT
--Query returned successfully in 878 msec.
--Actualizar el atributo semestre_diagnostico discretizando el atributo mes_diagnostico en 2 grupos de meses y el
--grupo 0 para Desconocido, de acuerdo a la siguiente relacion:
--0 -> Desconocido -> mes 99
--1 -> Semestre 1 (de enero a junio) -> meses 1 al 6
--2 -> Semestre 2 (de julio a diciembre) -> meses 7 al 12
BEGIN;
UPDATE etl.tumores_pasto_transformado SET semestre_diagnostico = CASE
WHEN mes_diagnostico = 99 THEN 'Desconocido'
WHEN mes_diagnostico BETWEEN 1 AND 6 THEN 'Semestre 1 (de enero a junio)'
WHEN mes_diagnostico BETWEEN 7 AND 12 THEN 'Semestre 2 (de julio a diciembre)'
ELSE 'Desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 792 msec.
--COMMIT
--Query returned successfully in 592 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--7. Campo cod_base_diagnostico
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_base_diagnostico SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 522 msec.
--COMMIT
--Query returned successfully in 616 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--8. Campo base_diagnostico
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN base_diagnostico SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 136 msec.
--COMMIT
--Query returned successfully in 71 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--9. Campo cod_localizacion
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_localizacion SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 736 msec.
--COMMIT
--Query returned successfully in 650 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--10. Campo localizacion
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN localizacion SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 155 msec.
--COMMIT
--Query returned successfully in 75 msec.
--Actualizar el campo localizacion omitiendo la parte inicial que contiene el codigo de localizacion en la
--nomenclatura CIEO-3
BEGIN;
UPDATE etl.tumores_pasto_transformado SET localizacion =
TRIM(SUBSTRING(localizacion FROM POSITION(' ' IN localizacion) + 1));
COMMIT;
--UPDATE 41345
--Query returned successfully in 735 msec.
--COMMIT
--Query returned successfully in 1 secs 94 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--11. Campo cod_cieo3_grupo
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_cieo3_grupo SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 455 msec.
--COMMIT
--Query returned successfully in 588 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--12. Campo no_cieo3_grupo
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN no_cieo3_grupo SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 458 msec.
--COMMIT
--Query returned successfully in 508 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--13. Campo cieo3_grupo
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cieo3_grupo SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 73 msec.
--COMMIT
--Query returned successfully in 72 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--14. Campo cod_morfologia
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_morfologia SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 498 msec.
--COMMIT
--Query returned successfully in 516 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--15. Campo morfologia
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN morfologia SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 70 msec.
--COMMIT
--Query returned successfully in 72 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--16. Campo cod_cie10
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_cie10 SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 785 msec.
--COMMIT
--Query returned successfully in 818 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--17. Campo cie10
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cie10 SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 72 msec.
--COMMIT
--Query returned successfully in 93 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--18. Campo cod_cie10_grupo
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_cie10_grupo SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 720 msec.
--COMMIT
--Query returned successfully in 571 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--19. Campo cie10_grupo_general
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cie10_grupo_general SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 123 msec.
--COMMIT
--Query returned successfully in 66 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--20. Campo cie10_grupo_excepto_c44
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cie10_grupo_excepto_c44 SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 130 msec.
--COMMIT
--Query returned successfully in 68 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--21. Campo cod_grupo_cie10
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_grupo_cie10 SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 220 msec.
--COMMIT
--Query returned successfully in 574 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--22. Campo grupo_cie10
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN grupo_cie10 SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 114 msec.
--COMMIT
--Query returned successfully in 69 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--23. Campo cod_lateralidad
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_lateralidad SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 590 msec.
--COMMIT
--Query returned successfully in 75 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--24. Campo lateralidad
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN lateralidad SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 128 msec.
--COMMIT
--Query returned successfully in 78 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--25. Campo cod_comportamiento
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_comportamiento SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 576 msec.
--COMMIT
--Query returned successfully in 71 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--26. Campo comportamiento
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN comportamiento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 134 msec.
--COMMIT
--Query returned successfully in 65 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--27. Campo cod_grado_diferenciacion
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_grado_diferenciacion SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 831 msec.
--COMMIT
--Query returned successfully in 136 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--28. Campo grado_diferenciacion
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN grado_diferenciacion SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 72 msec.
--COMMIT
--Query returned successfully in 71 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--29. Campo cod_mencion_cancer
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_mencion_cancer SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 852 msec.
--COMMIT
--Query returned successfully in 1 secs 83 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--30. Campo mencion_cancer
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN mencion_cancer SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 146 msec.
--COMMIT
--Query returned successfully in 110 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--31. Campo cod_profesion_expedidor
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_profesion_expedidor SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 932 msec.
--COMMIT
--Query returned successfully in 1 secs 131 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--32. Campo profesion_expedidor
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN profesion_expedidor SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 116 msec.
--COMMIT
--Query returned successfully in 159 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--33. Campo fecha_ultimo_contacto
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN fecha_ultimo_contacto SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 121 msec.
--COMMIT
--Query returned successfully in 116 msec.
--Crear los atributos de tipo SMALLINT
--cod_dia_muerte,dia_muerte,cod_mes_muerte,mes_muerte,ano_muerte,
--cod_dia_ultimo_contacto,dia_ultimo_contacto,cod_mes_ultimo_contacto,mes_ultimo_contacto,ano_ultimo_contacto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_dia_muerte SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD dia_muerte SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_mes_muerte SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD mes_muerte SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD ano_muerte SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_dia_ultimo_contacto SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD dia_ultimo_contacto SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_mes_ultimo_contacto SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD mes_ultimo_contacto SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD ano_ultimo_contacto SMALLINT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 136 msec.
--COMMIT
--Query returned successfully in 122 msec.
--Separar la fecha de ultimo contacto en los campos creados para la fecha de muerte cuando el estado vital es MUERTO
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
cod_dia_muerte = CAST(split_part(fecha_ultimo_contacto, '-', 1) AS SMALLINT),
dia_muerte = CAST(split_part(fecha_ultimo_contacto, '-', 1) AS SMALLINT),
cod_mes_muerte = CAST(split_part(fecha_ultimo_contacto, '-', 2) AS SMALLINT),
mes_muerte = CAST(split_part(fecha_ultimo_contacto, '-', 2) AS SMALLINT),
ano_muerte = CAST(split_part(fecha_ultimo_contacto, '-', 3) AS SMALLINT)
WHERE estado_vital = 'MUERTO';
COMMIT;
--UPDATE 18975
--Query returned successfully in 707 msec.
--COMMIT
--Query returned successfully in 839 msec.
--Asignar el valor de 0 a los campos cod_dia_muerte, dia_muerte, cod_mes_muerte, mes_muerte y ano_muerte cuando
--el estado vital es VIVO
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
cod_dia_muerte = 0, dia_muerte = 0, cod_mes_muerte = 0, mes_muerte = 0, ano_muerte = 0
WHERE estado_vital = 'VIVO';
COMMIT;
--UPDATE 19857
--Query returned successfully in 558 msec.
--COMMIT
--Query returned successfully in 585 msec.
--Reemplazar el valor 99 del atributo cod_dia_muerte por el valor de 32 estableciendo un orden para el atributo
--dia_muerte
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_dia_muerte = 32 WHERE cod_dia_muerte = 99;
COMMIT;
--UPDATE 1493
--Query returned successfully in 242 msec.
--COMMIT
--Query returned successfully in 175 msec.
--Reemplazar los valores nulos del atributo cod_dia_muerte por el valor de 33 estableciendo un orden para el
--atributo dia_muerte
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_dia_muerte = 33 WHERE cod_dia_muerte IS NULL;
COMMIT;
--UPDATE 2513
--Query returned successfully in 145 msec.
--COMMIT
--Query returned successfully in 165 msec.
--Reemplazar el valor 99 del atributo cod_mes_muerte por el valor de 13 estableciendo un orden para el atributo
--mes_muerte
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_mes_muerte = 13 WHERE cod_mes_muerte = 99;
COMMIT;
--UPDATE 1385
--Query returned successfully in 82 msec.
--COMMIT
--Query returned successfully in 123 msec.
--Reemplazar los valores nulos del atributo cod_mes_muerte por el valor de 14 estableciendo un orden para el
--atributo mes_muerte
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_mes_muerte = 14 WHERE cod_mes_muerte IS NULL;
COMMIT;
--UPDATE 2513
--Query returned successfully in 144 msec.
--COMMIT
--Query returned successfully in 123 msec.
--Separar la fecha de ultimo contacto en los nuevos campos creados para la fecha de ultimo contacto para todos los
--estados vitales
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
cod_dia_ultimo_contacto = CAST(split_part(fecha_ultimo_contacto, '-', 1) AS SMALLINT),
dia_ultimo_contacto = CAST(split_part(fecha_ultimo_contacto, '-', 1) AS SMALLINT),
cod_mes_ultimo_contacto = CAST(split_part(fecha_ultimo_contacto, '-', 2) AS SMALLINT),
mes_ultimo_contacto = CAST(split_part(fecha_ultimo_contacto, '-', 2) AS SMALLINT),
ano_ultimo_contacto = CAST(split_part(fecha_ultimo_contacto, '-', 3) AS SMALLINT);
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 143 msec.
--COMMIT
--Query returned successfully in 1 secs 233 msec.
--Reemplazar el valor 99 del atributo cod_dia_ultimo_contacto por el valor de 32 estableciendo un orden para el
--atributo dia_ultimo_contacto
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_dia_ultimo_contacto = 32 WHERE cod_dia_ultimo_contacto = 99;
COMMIT;
--UPDATE 4262
--Query returned successfully in 155 msec.
--COMMIT
--Query returned successfully in 85 msec.
--Reemplazar el valor 99 del atributo cod_mes_ultimo_contacto por el valor de 13 estableciendo un orden para el
--atributo mes_ultimo_contacto
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_mes_ultimo_contacto = 13 WHERE cod_mes_ultimo_contacto = 99;
COMMIT;
--UPDATE 4020
--Query returned successfully in 147 msec.
--COMMIT
--Query returned successfully in 203 msec.
--Crear los atributos de tipo TEXT
--trimestre_muerte, trimestre_ultimo_contacto, semestre_muerte y semestre_ultimo_contacto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD trimestre_muerte TEXT;
ALTER TABLE etl.tumores_pasto_transformado ADD semestre_muerte TEXT;
ALTER TABLE etl.tumores_pasto_transformado ADD trimestre_ultimo_contacto TEXT;
ALTER TABLE etl.tumores_pasto_transformado ADD semestre_ultimo_contacto TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 77 msec.
--COMMIT
--Query returned successfully in 172 msec.
--Actualizar el atributo trimestre_muerte discretizando el atributo mes_muerte en 4 grupos de meses, grupo 0 para
--Desconocido, grupo 5 (No aplica) para los registros 0 (estado vital VIVO) y grupo 6 (Sin informacion) para los
--registros nulos (estados vitales PERDIDO EN EL SEGUIMIENTO y DESCONOCIDO) de acuerdo a la siguiente relacion:
--0 -> Desconocido -> mes 99
--1 -> Trimestre 1 (de enero a marzo) -> meses 1 al 3
--2 -> Trimestre 2 (de abril a junio) -> meses 4 al 6
--3 -> Trimestre 3 (de julio a septiembre) -> meses 7 al 9
--4 -> Trimestre 4 (de octubre a diciembre) -> meses 10 al 12
--5 -> No aplica -> mes 0
--6 -> Sin información -> mes nulo
BEGIN;
UPDATE etl.tumores_pasto_transformado SET trimestre_muerte = CASE
WHEN mes_muerte = 99 THEN 'Desconocido'
WHEN mes_muerte BETWEEN 1 AND 3 THEN 'Trimestre 1 (de enero a marzo)'
WHEN mes_muerte BETWEEN 4 AND 6 THEN 'Trimestre 2 (de abril a junio)'
WHEN mes_muerte BETWEEN 7 AND 9 THEN 'Trimestre 3 (de julio a septiembre)'
WHEN mes_muerte BETWEEN 10 AND 12 THEN 'Trimestre 4 (de octubre a diciembre)'
WHEN mes_muerte = 0 THEN 'No aplica'
ELSE 'Sin información' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 366 msec.
--COMMIT
--Query returned successfully in 1 secs 2 msec.
--Actualizar el atributo trimestre_ultimo_contacto discretizando el atributo mes_ultimo_contacto en 4 grupos de meses
--y grupo 0 para Desconocido, de acuerdo a la siguiente relacion:
--0 -> Desconocido -> mes 99
--1 -> Trimestre 1 (de enero a marzo) -> meses 1 al 3
--2 -> Trimestre 2 (de abril a junio) -> meses 4 al 6
--3 -> Trimestre 3 (de julio a septiembre) -> meses 7 al 9
--4 -> Trimestre 4 (de octubre a diciembre) -> meses 10 al 12
BEGIN;
UPDATE etl.tumores_pasto_transformado SET trimestre_ultimo_contacto = CASE
WHEN mes_ultimo_contacto = 99 THEN 'Desconocido'
WHEN mes_ultimo_contacto BETWEEN 1 AND 3 THEN 'Trimestre 1 (de enero a marzo)'
WHEN mes_ultimo_contacto BETWEEN 4 AND 6 THEN 'Trimestre 2 (de abril a junio)'
WHEN mes_ultimo_contacto BETWEEN 7 AND 9 THEN 'Trimestre 3 (de julio a septiembre)'
WHEN mes_ultimo_contacto BETWEEN 10 AND 12 THEN 'Trimestre 4 (de octubre a diciembre)'
ELSE 'Desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 764 msec.
--COMMIT
--Query returned successfully in 1 secs 5 msec.
--Actualizar el atributo semestre_muerte discretizando el atributo mes_muerte en 2 grupos de meses, el grupo 0 para
--Desconocido, el grupo 3 (No aplica) para los registros 0 (estado vital VIVO) y el grupo 4 (Sin información) para los
--registros nulos (estados vitales PERDIDO EN EL SEGUIMIENTO y DESCONOCIDO), de acuerdo a la siguiente relacion:
--0 -> Desconocido -> mes 99
--1 -> Semestre 1 (de enero a junio) -> meses 1 al 6
--2 -> Semestre 2 (de julio a diciembre) -> meses 7 al 12
--3 -> No aplica -> mes 0
--4 -> Sin información -> mes nulo
BEGIN;
UPDATE etl.tumores_pasto_transformado SET semestre_muerte = CASE
WHEN mes_muerte = 99 THEN 'Desconocido'
WHEN mes_muerte BETWEEN 1 AND 6 THEN 'Semestre 1 (de enero a junio)'
WHEN mes_muerte BETWEEN 7 AND 12 THEN 'Semestre 2 (de julio a diciembre)'
WHEN mes_muerte = 0 THEN 'No aplica'
ELSE 'Sin información' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 134 msec.
--COMMIT
--Query returned successfully in 1 secs 282 msec.
--Actualizar el atributo semestre_ultimo_contacto discretizando el atributo mes_ultimo_contacto en 2 grupos de meses
--y el grupo 0 para Desconocido, de acuerdo a la siguiente relacion:
--0 -> Desconocido -> mes 99
--1 -> Semestre 1 (de enero a junio) -> meses 1 al 6
--2 -> Semestre 2 (de julio a diciembre) -> meses 7 al 12
BEGIN;
UPDATE etl.tumores_pasto_transformado SET semestre_ultimo_contacto = CASE
WHEN mes_ultimo_contacto = 99 THEN 'Desconocido'
WHEN mes_ultimo_contacto BETWEEN 1 AND 6 THEN 'Semestre 1 (de enero a junio)'
WHEN mes_ultimo_contacto BETWEEN 7 AND 12 THEN 'Semestre 2 (de julio a diciembre)'
ELSE 'Desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 742 msec.
--COMMIT
--Query returned successfully in 1 secs 217 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--34. Campo cod_fuente
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_fuente SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 246 msec.
--COMMIT
--Query returned successfully in 101 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--35. Campo fuente
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN fuente SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 128 msec.
--COMMIT
--Query returned successfully in 145 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--36. Campo cod_tratamiento
--Modificar el tipo de dato a SMALLINT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_tratamiento SET DATA TYPE SMALLINT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 19 msec.
--COMMIT
--Query returned successfully in 439 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--37. Campo tratamiento
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN tratamiento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 115 msec.
--COMMIT
--Query returned successfully in 67 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--38. Campo cod_estado_enfermedad
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_estado_enfermedad SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 40 msec.
--COMMIT
--Query returned successfully in 492 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--39. Campo estado_enfermedad
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN estado_enfermedad SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 122 msec.
--COMMIT
--Query returned successfully in 75 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--40. Campo fecha_tratamiento
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN fecha_tratamiento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 119 msec.
--COMMIT
--Query returned successfully in 120 msec.
--Crear los atributos cod_dia_tratamiento,dia_tratamiento,cod_mes_tratamiento,mes_tratamiento,ano_tratamiento de
--tipo SMALLINT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_dia_tratamiento SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD dia_tratamiento SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD cod_mes_tratamiento SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD mes_tratamiento SMALLINT;
ALTER TABLE etl.tumores_pasto_transformado ADD ano_tratamiento SMALLINT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 88 msec.
--COMMIT
--Query returned successfully in 170 msec.
--Separar la fecha de tratamiento en los campos creados
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
ano_tratamiento = CAST(SUBSTRING(fecha_tratamiento FROM 1 FOR 4) AS SMALLINT),
cod_mes_tratamiento = CAST(SUBSTRING(fecha_tratamiento FROM 5 FOR 2) AS SMALLINT),
mes_tratamiento = CAST(SUBSTRING(fecha_tratamiento FROM 5 FOR 2) AS SMALLINT),
cod_dia_tratamiento = CAST(SUBSTRING(fecha_tratamiento FROM 7 FOR 2) AS SMALLINT),
dia_tratamiento = CAST(SUBSTRING(fecha_tratamiento FROM 7 FOR 2) AS SMALLINT);
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 57 msec.
--COMMIT
--Query returned successfully in 866 msec.
--Reemplazar el valor 99 del atributo cod_dia_tratamiento por el valor de 32 estableciendo un orden para el
--atributo dia_tratamiento
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_dia_tratamiento = 32 WHERE cod_dia_tratamiento = 99;
COMMIT;
--UPDATE 32467
--Query returned successfully in 771 msec.
--COMMIT
--Query returned successfully in 615 msec.
--Reemplazar el valor 99 del atributo cod_mes_tratamiento por el valor de 13 estableciendo un orden para el
--atributo mes_tratamiento
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cod_mes_tratamiento = 13 WHERE cod_mes_tratamiento = 99;
COMMIT;
--UPDATE 31767
--Query returned successfully in 711 msec.
--COMMIT
--Query returned successfully in 405 msec.
--Crear los atributos trimestre_tratamiento y semestre_tratamiento de tipo TEXT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD trimestre_tratamiento TEXT;
ALTER TABLE etl.tumores_pasto_transformado ADD semestre_tratamiento TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 74 msec.
--COMMIT
--Query returned successfully in 146 msec.
--Actualizar el atributo trimestre_tratamiento discretizando el atributo mes_tratamiento en 4 grupos de meses y el
--grupo 0 para Desconocido, de acuerdo a la siguiente relacion:
--0 -> Desconocido -> mes 99
--1 -> Trimestre 1 (de enero a marzo) -> meses 1 al 3
--2 -> Trimestre 2 (de abril a junio) -> meses 4 al 6
--3 -> Trimestre 3 (de julio a septiembre) -> meses 7 al 9
--4 -> Trimestre 4 (de octubre a diciembre) -> meses 10 al 12
BEGIN;
UPDATE etl.tumores_pasto_transformado SET trimestre_tratamiento = CASE
WHEN mes_tratamiento = 99 THEN 'Desconocido'
WHEN mes_tratamiento BETWEEN 1 AND 3 THEN 'Trimestre 1 (de enero a marzo)'
WHEN mes_tratamiento BETWEEN 4 AND 6 THEN 'Trimestre 2 (de abril a junio)'
WHEN mes_tratamiento BETWEEN 7 AND 9 THEN 'Trimestre 3 (de julio a septiembre)'
WHEN mes_tratamiento BETWEEN 10 AND 12 THEN 'Trimestre 4 (de octubre a diciembre)'
ELSE 'Desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 2 secs 43 msec.
--COMMIT
--Query returned successfully in 1 secs 305 msec.
--Actualizar el atributo semestre_tratamiento discretizando el atributo mes_tratamiento en 2 grupos de meses y el
--grupo 0 para Desconocido, de acuerdo a la siguiente relacion:
--0 -> Desconocido -> mes 99
--1 -> Semestre 1 (de enero a junio) -> meses 1 al 6
--2 -> Semestre 2 (de julio a diciembre) -> meses 7 al 12
BEGIN;
UPDATE etl.tumores_pasto_transformado SET semestre_tratamiento = CASE
WHEN mes_tratamiento = 99 THEN 'Desconocido'
WHEN mes_tratamiento BETWEEN 1 AND 6 THEN 'Semestre 1 (de enero a junio)'
WHEN mes_tratamiento BETWEEN 7 AND 12 THEN 'Semestre 2 (de julio a diciembre)'
ELSE 'Desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 271 msec.
--COMMIT
--Query returned successfully in 1 secs 495 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--41. Campo orden_tratamiento
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN orden_tratamiento SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 829 msec.
--COMMIT
--Query returned successfully in 713 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--42. Campo cod_departamento
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_departamento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 17 msec.
--COMMIT
--Query returned successfully in 718 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--43. Campo departamento
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN departamento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 119 msec.
--COMMIT
--Query returned successfully in 81 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--44. Campo cod_municipio
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_municipio SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 143 msec.
--COMMIT
--Query returned successfully in 982 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--45. Campo municipio
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN municipio SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 125 msec.
--COMMIT
--Query returned successfully in 120 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--46. Campo cod_zona
--Modificar el tipo de dato a char(1)
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_zona SET DATA TYPE CHAR(1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 590 msec.
--COMMIT
--Query returned successfully in 1 secs 48 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--47. Campo zona
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN zona SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 180 msec.
--COMMIT
--Query returned successfully in 130 msec.
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET zona = UPPER(zona);
COMMIT;
--UPDATE 41345
--Query returned successfully in 498 msec.
--COMMIT
--Query returned successfully in 1 secs 644 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--48. Campo cod_barrio_comuna
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_barrio_comuna SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 180 msec.
--COMMIT
--Query returned successfully in 732 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--49. Campo barrio_comuna
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN barrio_comuna SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 184 msec.
--COMMIT
--Query returned successfully in 890 msec.
--Crear los atributos barrio_vereda y comuna_corregimiento de tipo TEXT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD barrio_vereda TEXT;
ALTER TABLE etl.tumores_pasto_transformado ADD comuna_corregimiento TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 142 msec.
--COMMIT
--Query returned successfully in 172 msec.
--Actualizar el atributo barrio_vereda a partir del campo barrio_comuna dependiendo de la zona, acorde a la siguiente
--relacion:
--1. zona DESCONOCIDA -> barrio_vereda = Barrio o Vereda desconocido
--2. zona URBANA -> barrio_vereda = barrio_comuna
--3. zona RURAL -> barrio_vereda extrae el nombre de la Vereda del atributo barrio_comuna
BEGIN;
UPDATE etl.tumores_pasto_transformado SET barrio_vereda = CASE
WHEN zona = 'DESCONOCIDA' THEN 'Barrio o Vereda desconocido'
WHEN zona = 'URBANA' THEN barrio_comuna
WHEN zona = 'RURAL' THEN TRIM(SUBSTRING(barrio_comuna FROM 1 FOR POSITION('(' IN barrio_comuna) - 1))
ELSE 'Barrio o Vereda desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 142 msec.
--COMMIT
--Query returned successfully in 1 secs 105 msec.
--Actualizar el valor 'Rural desconocido' a 'Vereda desconocida' del atributo barrio_vereda
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
barrio_vereda = 'Vereda desconocida' WHERE barrio_vereda = 'Rural desconocido';
COMMIT;
--UPDATE 93
--Query returned successfully in 76 msec.
--COMMIT
--Query returned successfully in 73 msec.
--Actualizar el valor 'Urbano desconocido' a 'Barrio desconocido' del atributo barrio_vereda
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
barrio_vereda = 'Barrio desconocido' WHERE barrio_vereda = 'Urbano desconocido';
COMMIT;
--UPDATE 121
--Query returned successfully in 82 msec.
--COMMIT
--Query returned successfully in 75 msec.
--Actualizar el atributo comuna_corregimiento a partir de los campos cod_comuna_corregimiento y barrio_comuna
--dependiendo de la zona, acorde a la siguiente relacion:
--1. zona DESCONOCIDA -> comuna_corregimiento = Comuna o Corregimiento desconocido
--2. zona URBANA -> comuna_corregimiento = cod_comuna_corregimiento
--3. zona RURAL -> comuna_corregimiento extrae el nombre del Corregimiento del atributo barrio_comuna (esta entre
--parentesis)
BEGIN;
UPDATE etl.tumores_pasto_transformado SET comuna_corregimiento = CASE
WHEN zona = 'DESCONOCIDA' THEN 'Desconocido'
WHEN zona = 'URBANA' THEN cod_comuna_corregimiento
WHEN zona = 'RURAL' THEN TRIM(SUBSTRING(barrio_comuna FROM '\((.*?)\)'))
ELSE 'Desconocido' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 607 msec.
--COMMIT
--Query returned successfully in 902 msec.
--Actualizar los valores del atributo comuna_corregimiento dependiendo del tipo de dato (numero o texto) por su
--descripcion acorde a la siguiente relacion y teniendo en cuenta de excluir la zona DESCONOCIDA puesto que para este
--caso el atributo conserva el valor de Desconocido:
--99 -> Comuna desconocida
--Desconocido y Zona RURAL -> Corregimiento desconocido
--Desconocido y Zona DESCONOCIDA -> Comuna o Corregimiento desconocido
--Numeros de comuna -> Concatenar la palabra Comuna antes del numero de la comuna
--Corregimiento -> Concatenar la palabra Corregimiento antes del nombre del corregimiento (comuna_corregimiento)
BEGIN;
UPDATE etl.tumores_pasto_transformado SET comuna_corregimiento = CASE
WHEN comuna_corregimiento = '99' THEN 'Comuna desconocida'
WHEN comuna_corregimiento = 'Desconocido' AND zona = 'RURAL' THEN 'Corregimiento desconocido'
WHEN comuna_corregimiento = 'Desconocido' AND zona = 'DESCONOCIDA' THEN 'Comuna o Corregimiento desconocido'
WHEN comuna_corregimiento ~ '^[0-9]+$' THEN 'Comuna ' || comuna_corregimiento
ELSE 'Corregimiento ' || comuna_corregimiento END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 257 msec.
--COMMIT
--Query returned successfully in 1 secs 28 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--50. Campo cod_comuna_corregimiento
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_comuna_corregimiento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 50 msec.
--COMMIT
--Query returned successfully in 1 secs 136 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--51. Campo cod_barrio_vereda
--Modificar el tipo de dato a texto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN cod_barrio_vereda SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 3 msec.
--COMMIT
--Query returned successfully in 819 msec.

--===================================================================================================================================================================================
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TRANSFORMACIONES REFERENTES A INDICADORES
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--52. Campo fi (frecuencia absoluta de incidencia) que tambien representa la cantidad de casos de cancer
--Crear el atributo fi de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD fi INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 134 msec.
--COMMIT
--Query returned successfully in 118 msec.
--Actualizar el atributo fi con valor de 1 para todos los casos de cancer, es decir todos los diferentes tumores
--registrados sin tener en cuenta las fuentes asociadas a cada tumor
BEGIN;
UPDATE etl.tumores_pasto_transformado AS t1 SET fi = CASE
WHEN t2.id = 1 THEN 1 ELSE 0 END
FROM (SELECT ctid, ROW_NUMBER() OVER (PARTITION BY tumor ORDER BY ctid) AS id FROM etl.tumores_pasto_transformado) AS t2
WHERE t1.ctid = t2.ctid;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 940 msec.
--COMMIT
--Query returned successfully in 2 secs 3 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--53. Campo proy_poblacion_mundial_estandar (proyeccion de poblacion mundial estandar)
--Crear el atributo proy_poblacion_mundial_estandar de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD proy_poblacion_mundial_estandar INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 150 msec.
--COMMIT
--Query returned successfully in 87 msec.
--Actualizar para todos los casos (variable fi en 1) el atributo proy_poblacion_mundial_estandar a partir del valor
--de proyeccion de poblacion mundial estandar (poblacion) registrado en la tabla auxiliar (etl.tab_aux_pobmundialestandar)
--dependiendo del grupo etario
BEGIN;
UPDATE etl.tumores_pasto_transformado t1 SET proy_poblacion_mundial_estandar = t2.poblacion
FROM etl.tab_aux_pobmundialestandar t2 WHERE t1.grupo_etario1 = t2.grupo_etario1;
COMMIT;
--UPDATE 41345
--Query returned successfully in 983 msec.
--COMMIT
--Query returned successfully in 989 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--54. Campo cantidad_pacientes
--Crear el atributo cantidad_pacientes de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cantidad_pacientes INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 142 msec.
--COMMIT
--Query returned successfully in 75 msec.
--Actualizar para todos los casos (variable fi en 1) el atributo cantidad_pacientes con valor de 1 para todos los
--diferentes pacientes registrados sin tener en cuenta el tumor ni las fuentes asociadas a cada tumor
BEGIN;
UPDATE etl.tumores_pasto_transformado AS t1 SET cantidad_pacientes = CASE
WHEN t2.id = 1 THEN 1 ELSE 0 END
FROM (SELECT ctid, ROW_NUMBER() OVER (PARTITION BY paciente ORDER BY ctid) AS id FROM etl.tumores_pasto_transformado) AS t2
WHERE t1.ctid = t2.ctid;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 532 msec.
--COMMIT
--Query returned successfully in 1 secs 323 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--55. Campo cantidad_caso_fuente que representa la cantidad de reportes que han hecho las diferentes fuentes de los
--diferentes casos de cancer
--Crear el atributo cantidad_caso_fuente de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cantidad_caso_fuente INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 72 msec.
--COMMIT
--Query returned successfully in 94 msec.
--Actualizar el atributo cantidad_caso_fuente con valor de 1 para todos los registros de la tabla que representan
--los reportes de diferentes fuentes asociadas a cada caso de cáncer
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cantidad_caso_fuente = 1;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 213 msec.
--COMMIT
--Query returned successfully in 1 secs 358 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--56. Campo cdmv (casos con un diagnostico morfologicamente verificado)
--Crear el atributo cdmv de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cdmv INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 158 msec.
--COMMIT
--Query returned successfully in 75 msec.
--Actualizar el atributo cdmv con valor de 1 para aquellos casos (variable fi en 1) en los que el campo
--cod_base_diagnostico es igual a 5 (citologia y hematologia) o 7 (histologia de un tumor primario)
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cdmv = CASE
WHEN fi = 1 AND cod_base_diagnostico IN ('5','7') THEN 1 ELSE 0 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 978 msec.
--COMMIT
--Query returned successfully in 1 secs 662 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--57. Campo cscd (casos conocidos solo por certificado de defuncion)
--Crear el atributo cscd de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cscd INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 156 msec.
--COMMIT
--Query returned successfully in 85 msec.
--Actualizar el atributo cscd con valor de 1 para aquellos casos (variable fi en 1) en los que el campo
--cod_base_diagnostico es igual a 0 (solo certificado de defuncion)
BEGIN;
UPDATE etl.tumores_pasto_transformado SET cscd = CASE
WHEN fi = 1 AND cod_base_diagnostico = '0' THEN 1 ELSE 0 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 2 secs 109 msec.
--COMMIT
--Query returned successfully in 1 secs 70 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--58. Campo mccpm (muertes por cancer que fueron certificadas por personal medico)
--Crear el atributo mccpm de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD mccpm INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 92 msec.
--COMMIT
--Query returned successfully in 75 msec.
--Actualizar el atributo mccpm con valor de 1 para aquellos casos (variable fi en 1) en estado vital MUERTO (codigo 2)
--en los que el campo cod_profesion_expedidor es igual a 1 (medico tratante), 2 (medico no tratante) y 3 (medico
--legista)
BEGIN;
UPDATE etl.tumores_pasto_transformado SET mccpm = CASE
WHEN fi = 1 AND cod_estado_vital = '2' AND cod_profesion_expedidor IN ('1','2','3') THEN 1 ELSE 0 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 355 msec.
--COMMIT
--Query returned successfully in 1 secs 8 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--59. Campo ccopd (casos de cancer de origen primario desconocido - localizacion C809)
--Crear el atributo ccopd de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD ccopd INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 91 msec.
--COMMIT
--Query returned successfully in 67 msec.
--Actualizar el atributo ccopd con valor de 1 para aquellos casos (variable fi en 1) en los que el campo cod_localizacion
--es igual a 809 (C80.9  Sitio primario desconocido)
BEGIN;
UPDATE etl.tumores_pasto_transformado SET ccopd = CASE
WHEN fi = 1 AND cod_localizacion = '809' THEN 1 ELSE 0 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 2 secs 283 msec.
--COMMIT
--Query returned successfully in 1 secs 41 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--60. Campo mcopm (muertes de cancer de origen primario desconocido - localizacion C809)
--Crear el atributo mcopm de tipo INTEGER
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD mcopm INTEGER;
COMMIT;
--ALTER TABLE
--Query returned successfully in 93 msec.
--COMMIT
--Query returned successfully in 72 msec.
--Actualizar el atributo mcopm con valor de 1 para aquellos casos (variable fi en 1) en estado vital MUERTO (codigo 2)
--en los que el campo cod_localizacion es igual a 809 (C80.9  Sitio primario desconocido)
BEGIN;
UPDATE etl.tumores_pasto_transformado SET mcopm = CASE
WHEN fi = 1 AND cod_estado_vital = '2' AND cod_localizacion = '809' THEN 1 ELSE 0 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 310 msec.
--COMMIT
--Query returned successfully in 1 secs 34 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--61. Campo edad_muerte
--Crear el atributo edad_muerte de tipo SMALLINT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD edad_muerte SMALLINT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 166 msec.
--COMMIT
--Query returned successfully in 70 msec.
--Actualizar el atributo edad_muerte con el calculo de la edad para los registros con estado_vital igual a 'MUERTO',
--incluyendo el valor 999 para edad DESCONOCIDA y con el valor de 997 para los registros con estado_vital igual a
--'VIVO' y el valor de 998 para otros estados vitales ('PERDIDO EN EL SEGUIMIENTO' y 'DESCONOCIDO')
BEGIN;
UPDATE etl.tumores_pasto_transformado SET edad_muerte = CASE
WHEN estado_vital = 'MUERTO' THEN (
CASE
	WHEN fecha_ultimo_contacto = '99-99-9999' THEN 999
	WHEN fecha_nacimiento = '99-99-9999' THEN (
		CASE
			WHEN edad_paciente = 999 THEN 999
			ELSE (
				CASE
					WHEN fecha_diagnostico LIKE '99-99-%' OR fecha_ultimo_contacto LIKE '99-99-%' THEN
						edad_paciente + ano_muerte - ano_diagnostico
					WHEN fecha_diagnostico LIKE '99-%' OR fecha_ultimo_contacto LIKE '99-%' OR fecha_diagnostico IS NULL OR fecha_ultimo_contacto IS NULL THEN
						CASE
							WHEN ano_diagnostico <= ano_muerte AND mes_diagnostico <= mes_muerte THEN
								edad_paciente + ano_muerte - ano_diagnostico
							WHEN ano_diagnostico < ano_muerte AND mes_diagnostico > mes_muerte	THEN
								edad_paciente + ano_muerte - ano_diagnostico - 1
							ELSE 999
						END
					ELSE
            			edad_paciente + EXTRACT(YEAR FROM AGE(fecha_ultimo_contacto::timestamp,fecha_diagnostico::timestamp::DATE))
				END
			)
		END
	)
	WHEN fecha_nacimiento LIKE '99-99-%' OR fecha_ultimo_contacto LIKE '99-99-%' THEN
		ano_muerte - CAST(SUBSTRING(fecha_nacimiento FROM 7 FOR 10) AS INTEGER)
	WHEN fecha_nacimiento LIKE '99-%' OR fecha_ultimo_contacto LIKE '99-%' OR fecha_nacimiento IS NULL OR fecha_ultimo_contacto IS NULL THEN
		CASE
			WHEN CAST(SUBSTRING(fecha_nacimiento FROM 7 FOR 10) AS INTEGER) <= ano_muerte
				AND CAST(SUBSTRING(fecha_nacimiento FROM 4 FOR 2) AS INTEGER) <= mes_muerte THEN
				ano_muerte - CAST(SUBSTRING(fecha_nacimiento FROM 7 FOR 10) AS INTEGER)
			WHEN CAST(SUBSTRING(fecha_nacimiento FROM 7 FOR 10) AS INTEGER) < ano_muerte
				AND CAST(SUBSTRING(fecha_nacimiento FROM 4 FOR 2) AS INTEGER) > mes_muerte THEN
				ano_muerte - CAST(SUBSTRING(fecha_nacimiento FROM 7 FOR 10) AS INTEGER) - 1
			ELSE 999
		END
	ELSE
		EXTRACT(YEAR FROM AGE(fecha_ultimo_contacto::timestamp,fecha_nacimiento::timestamp::DATE))
END
)
WHEN estado_vital = 'VIVO' THEN 997
ELSE 998 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 2 secs 23 msec.
--COMMIT
--Query returned successfully in 1 secs 572 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--62. Campo esperanza_vida (esperanza de vida)
--Crear el atributo esperanza_vida de tipo NUMERIC
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD esperanza_vida NUMERIC(4,1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 167 msec.
--COMMIT
--Query returned successfully in 194 msec.
--Actualizar el atributo esperanza_vida con el valor de la esperanza de vida asociada al campo edad_paciente puesto
--que corresponde con la edad de incidencia. Cabe resaltar que tendra un valor de 999.0 para aquellos registros con
--edad Desconocida
BEGIN;
UPDATE etl.tumores_pasto_transformado t1 SET esperanza_vida = t2.esperanza_vida
FROM etl.tab_aux_esperanzadevida t2 WHERE t1.edad_paciente = t2.edad;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 216 msec.
--COMMIT
--Query returned successfully in 1 secs 606 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--63. Campo avmp (años de vida saludable perdidos por muerte prematura)
--Crear el atributo avmp de tipo NUMERIC
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD avmp NUMERIC(4,1);
COMMIT;
--ALTER TABLE
--Query returned successfully in 94 msec.
--COMMIT
--Query returned successfully in 162 msec.
--Actualizar el atributo avmp con el calculo de los años acorde a la formula del indicador, la resta entre el valor
--del atributo esperanza_vida sumado el valor del atributo edad_paciente, y el valor del atributo edad_muerte para los
--casos (variable fi en 1) con estado_vital igual a 'MUERTO', incluyendo el valor 999 para edades DESCONOCIDAS y el
--valor de 997 para los registros con estado_vital igual a 'VIVO' y el valor de 998 para otros estados vitales
--('PERDIDO EN EL SEGUIMIENTO' y 'DESCONOCIDO'). Cabe resaltar que para el resto de registros se asigna un valor de
--0.0 que no aporta en nada al valor del indicador
BEGIN;
UPDATE etl.tumores_pasto_transformado SET avmp = CASE
WHEN fi = 1 AND estado_vital = 'MUERTO' THEN
(CASE WHEN edad_muerte = 999 OR esperanza_vida = 999 THEN 999 ELSE edad_paciente + esperanza_vida - edad_muerte END)
WHEN fi = 1 AND estado_vital = 'VIVO' THEN 997
WHEN fi = 1 AND estado_vital NOT IN ('VIVO','MUERTO') THEN 998
ELSE 0 END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 416 msec.
--COMMIT
--Query returned successfully in 1 secs 721 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--64. Campo oac (oportunidad de la atencion en cancer)
--Crear el atributo oac de tipo SMALLINT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD oac SMALLINT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 70 msec.
--COMMIT
--Query returned successfully in 109 msec.
--Actualizar el atributo oac con el calculo de los dias transcurridos entre la fecha de diagnostico y la fecha del
--primer tratamiento acorde a la formula del indicador, la resta entre la fecha del primer tratamiento y la fecha de
--diagnostico para los casos (variable fi en 1), incluyendo el valor de 0 no solo para cuando hayan 0 dias en el
--calculo si no tambien para aquellos registros donde no es posible hacer el calculo porque alguna de las dos fechas
--es totalmente desconocida en el respectivo formato (99-99-9999 fecha de diagnostico y 99999999 fecha de tratamiento)
BEGIN;
UPDATE etl.tumores_pasto_transformado SET oac = CASE
WHEN fi = 1 AND (fecha_diagnostico = '99-99-9999' OR fecha_tratamiento = '99999999') THEN 0
ELSE
	CASE
		WHEN fi = 1 AND (fecha_diagnostico LIKE '99-99-%' OR fecha_tratamiento LIKE '%9999') THEN (ano_tratamiento - ano_diagnostico)*365
		ELSE
			CASE
				WHEN fi = 1 AND (fecha_diagnostico LIKE '99-%' OR fecha_tratamiento LIKE '%99') THEN (ano_tratamiento - ano_diagnostico)*365 + (mes_tratamiento - mes_diagnostico)*30
				ELSE
					CASE
						WHEN fi = 1 THEN TO_DATE(CONCAT(dia_tratamiento,'-',mes_tratamiento,'-',ano_tratamiento), 'DD-MM-YYYY') - TO_DATE(fecha_diagnostico, 'DD-MM-YYYY')
						ELSE 0
					END
			END
		END
END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 2 secs 692 msec.
--COMMIT
--Query returned successfully in 3 secs 34 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--65. Complemento de transformacion de los campos dia_diagnostico y mes_diagnostico posterior al calculo de edad_muerte
--Modificar el tipo de dato a texto para el atributo dia_diagnostico
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN dia_diagnostico SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 841 msec.
--COMMIT
--Query returned successfully in 996 msec.
--Actualizar el atributo dia_diagnostico a DESCONOCIDO para los registros donde el atributo es igual a 99
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
dia_diagnostico = 'DESCONOCIDO' WHERE dia_diagnostico::INTEGER = 99;
COMMIT;
--UPDATE 1134
--Query returned successfully in 220 msec.
--COMMIT
--Query returned successfully in 139 msec.
--Modificar el tipo de dato a texto para el atributo mes_diagnostico
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN mes_diagnostico SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 801 msec.
--COMMIT
--Query returned successfully in 786 msec.
--Actualizar los valores del atributo mes_diagnostico por su descripcion acorde a la siguiente relacion:
--99 -> DESCONOCIDO
--1 -> ENERO
--2 -> FEBRERO
--3 -> MARZO
--4 -> ABRIL
--5 -> MAYO
--6 -> JUNIO
--7 -> JULIO
--8 -> AGOSTO
--9 -> SEPTIEMBRE
--10 -> OCTUBRE
--11 -> NOVIEMBRE
--12 -> DICIEMBRE
BEGIN;
UPDATE etl.tumores_pasto_transformado SET mes_diagnostico = CASE
WHEN mes_diagnostico = '99' THEN 'DESCONOCIDO'
WHEN mes_diagnostico = '1' THEN 'ENERO'
WHEN mes_diagnostico = '2' THEN 'FEBRERO'
WHEN mes_diagnostico = '3' THEN 'MARZO'
WHEN mes_diagnostico = '4' THEN 'ABRIL'
WHEN mes_diagnostico = '5' THEN 'MAYO'
WHEN mes_diagnostico = '6' THEN 'JUNIO'
WHEN mes_diagnostico = '7' THEN 'JULIO'
WHEN mes_diagnostico = '8' THEN 'AGOSTO'
WHEN mes_diagnostico = '9' THEN 'SEPTIEMBRE'
WHEN mes_diagnostico = '10' THEN 'OCTUBRE'
WHEN mes_diagnostico = '11' THEN 'NOVIEMBRE'
WHEN mes_diagnostico = '12' THEN 'DICIEMBRE'
ELSE 'DESCONOCIDO' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 288 msec.
--COMMIT
--Query returned successfully in 772 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--66. Complemento de transformacion de los campos dia_muerte, mes_muerte, dia_ultimo_contacto, mes_ultimo_contacto,
--ano_muerte y ano_ultimo_contacto posterior al calculo de edad_muerte
--Modificar el tipo de dato a texto para los atributos dia_muerte y dia_ultimo_contacto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN dia_muerte SET DATA TYPE TEXT;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN dia_ultimo_contacto SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 396 msec.
--COMMIT
--Query returned successfully in 1 secs 487 msec.
--Actualizar el atributo dia_muerte a DESCONOCIDO para los registros donde el atributo es igual a 99, a NO APLICA para
--los registros donde el atributo es igual a 0 y a SIN INFORMACIÓN para los registros donde el atributo es nulo, de lo
--contrario, conservar su valor
BEGIN;
UPDATE etl.tumores_pasto_transformado SET dia_muerte = CASE
WHEN dia_muerte ~ '^[0-9]+$' AND dia_muerte::INTEGER NOT IN (99,0) THEN dia_muerte
WHEN dia_muerte::INTEGER = 99 THEN 'DESCONOCIDO'
WHEN dia_muerte::INTEGER = 0 THEN 'NO APLICA'
ELSE 'SIN INFORMACIÓN' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 313 msec.
--COMMIT
--Query returned successfully in 987 msec.
--Actualizar el atributo dia_ultimo_contacto a DESCONOCIDO para los registros donde el atributo es igual a 99
BEGIN;
UPDATE etl.tumores_pasto_transformado SET dia_ultimo_contacto = 'DESCONOCIDO' WHERE dia_ultimo_contacto::INTEGER = 99;
COMMIT;
--UPDATE 4277
--Query returned successfully in 232 msec.
--COMMIT
--Query returned successfully in 295 msec.
--Modificar el tipo de dato a texto para los atributos mes_muerte y mes_ultimo_contacto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN mes_muerte SET DATA TYPE TEXT;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN mes_ultimo_contacto SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 605 msec.
--COMMIT
--Query returned successfully in 1 secs 556 msec.
--Actualizar los valores del atributo mes_muerte por su descripcion acorde a la siguiente relacion:
--99 -> DESCONOCIDO
--0 -> NO APLICA
--1 -> ENERO
--2 -> FEBRERO
--3 -> MARZO
--4 -> ABRIL
--5 -> MAYO
--6 -> JUNIO
--7 -> JULIO
--8 -> AGOSTO
--9 -> SEPTIEMBRE
--10 -> OCTUBRE
--11 -> NOVIEMBRE
--12 -> DICIEMBRE
--null -> SIN INFORMACIÓN
BEGIN;
UPDATE etl.tumores_pasto_transformado SET mes_muerte = CASE
WHEN mes_muerte = '99' THEN 'DESCONOCIDO'
WHEN mes_muerte = '0' THEN 'NO APLICA'
WHEN mes_muerte = '1' THEN 'ENERO'
WHEN mes_muerte = '2' THEN 'FEBRERO'
WHEN mes_muerte = '3' THEN 'MARZO'
WHEN mes_muerte = '4' THEN 'ABRIL'
WHEN mes_muerte = '5' THEN 'MAYO'
WHEN mes_muerte = '6' THEN 'JUNIO'
WHEN mes_muerte = '7' THEN 'JULIO'
WHEN mes_muerte = '8' THEN 'AGOSTO'
WHEN mes_muerte = '9' THEN 'SEPTIEMBRE'
WHEN mes_muerte = '10' THEN 'OCTUBRE'
WHEN mes_muerte = '11' THEN 'NOVIEMBRE'
WHEN mes_muerte = '12' THEN 'DICIEMBRE'
ELSE 'SIN INFORMACIÓN' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 355 msec.
--COMMIT
--Query returned successfully in 992 msec.
--Actualizar los valores del atributo mes_ultimo_contacto por su descripcion acorde a la siguiente relacion:
--99 -> DESCONOCIDO
--1 -> ENERO
--2 -> FEBRERO
--3 -> MARZO
--4 -> ABRIL
--5 -> MAYO
--6 -> JUNIO
--7 -> JULIO
--8 -> AGOSTO
--9 -> SEPTIEMBRE
--10 -> OCTUBRE
--11 -> NOVIEMBRE
--12 -> DICIEMBRE
BEGIN;
UPDATE etl.tumores_pasto_transformado SET mes_ultimo_contacto = CASE
WHEN mes_ultimo_contacto = '99' THEN 'DESCONOCIDO'
WHEN mes_ultimo_contacto = '1' THEN 'ENERO'
WHEN mes_ultimo_contacto = '2' THEN 'FEBRERO'
WHEN mes_ultimo_contacto = '3' THEN 'MARZO'
WHEN mes_ultimo_contacto = '4' THEN 'ABRIL'
WHEN mes_ultimo_contacto = '5' THEN 'MAYO'
WHEN mes_ultimo_contacto = '6' THEN 'JUNIO'
WHEN mes_ultimo_contacto = '7' THEN 'JULIO'
WHEN mes_ultimo_contacto = '8' THEN 'AGOSTO'
WHEN mes_ultimo_contacto = '9' THEN 'SEPTIEMBRE'
WHEN mes_ultimo_contacto = '10' THEN 'OCTUBRE'
WHEN mes_ultimo_contacto = '11' THEN 'NOVIEMBRE'
WHEN mes_ultimo_contacto = '12' THEN 'DICIEMBRE'
ELSE 'DESCONOCIDO' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 986 msec.
--COMMIT
--Query returned successfully in 973 msec.
--Modificar el tipo de dato a texto para los atributos ano_muerte y ano_ultimo_contacto
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN ano_muerte SET DATA TYPE TEXT;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN ano_ultimo_contacto SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 743 msec.
--COMMIT
--Query returned successfully in 1 secs 643 msec.
--Actualizar los valores 0, 9999 y nulos del atributo ano_muerte por su descripcion acorde a la siguiente relacion:
--0 -> NO APLICA
--9999 -> DESCONOCIDO
--null -> SIN INFORMACIÓN
BEGIN;
UPDATE etl.tumores_pasto_transformado SET ano_muerte = CASE
WHEN ano_muerte = '0' THEN 'NO APLICA'
WHEN ano_muerte = '9999' THEN 'DESCONOCIDO'
WHEN ano_muerte IS NULL THEN 'SIN INFORMACIÓN'
ELSE ano_muerte END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 267 msec.
--COMMIT
--Query returned successfully in 1 secs 140 msec.
--Actualizar los valores 9999 del atributo ano_ultimo_contacto a DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_transformado SET ano_ultimo_contacto = 'DESCONOCIDO'
WHERE ano_ultimo_contacto = '9999';
COMMIT;
--UPDATE 2941
--Query returned successfully in 219 msec.
--COMMIT
--Query returned successfully in 117 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--67. Complemento de transformacion de los campos dia_tratamiento, mes_tratamiento y ano_tratamiento posterior al
--calculo de oac
--Modificar el tipo de dato a texto para el atributo dia_tratamiento
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN dia_tratamiento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 199 msec.
--COMMIT
--Query returned successfully in 817 msec.
--Actualizar el atributo dia_tratamiento a DESCONOCIDO para los registros donde el atributo es igual a 99
BEGIN;
UPDATE etl.tumores_pasto_transformado SET
dia_tratamiento = 'DESCONOCIDO' WHERE dia_tratamiento::INTEGER = 99;
COMMIT;
--UPDATE 32542
--Query returned successfully in 1 secs 165 msec.
--COMMIT
--Query returned successfully in 1 secs 398 msec.
--Modificar el tipo de dato a texto para el atributo mes_tratamiento
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN mes_tratamiento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 809 msec.
--COMMIT
--Query returned successfully in 1 secs 377 msec.
--Actualizar los valores del atributo mes_tratamiento por su descripcion acorde a la siguiente relacion:
--99 -> DESCONOCIDO
--1 -> ENERO
--2 -> FEBRERO
--3 -> MARZO
--4 -> ABRIL
--5 -> MAYO
--6 -> JUNIO
--7 -> JULIO
--8 -> AGOSTO
--9 -> SEPTIEMBRE
--10 -> OCTUBRE
--11 -> NOVIEMBRE
--12 -> DICIEMBRE
BEGIN;
UPDATE etl.tumores_pasto_transformado SET mes_tratamiento = CASE
WHEN mes_tratamiento = '99' THEN 'DESCONOCIDO'
WHEN mes_tratamiento = '1' THEN 'ENERO'
WHEN mes_tratamiento = '2' THEN 'FEBRERO'
WHEN mes_tratamiento = '3' THEN 'MARZO'
WHEN mes_tratamiento = '4' THEN 'ABRIL'
WHEN mes_tratamiento = '5' THEN 'MAYO'
WHEN mes_tratamiento = '6' THEN 'JUNIO'
WHEN mes_tratamiento = '7' THEN 'JULIO'
WHEN mes_tratamiento = '8' THEN 'AGOSTO'
WHEN mes_tratamiento = '9' THEN 'SEPTIEMBRE'
WHEN mes_tratamiento = '10' THEN 'OCTUBRE'
WHEN mes_tratamiento = '11' THEN 'NOVIEMBRE'
WHEN mes_tratamiento = '12' THEN 'DICIEMBRE'
ELSE 'DESCONOCIDO' END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 264 msec.
--COMMIT
--Query returned successfully in 2 secs 934 msec.
--Modificar el tipo de dato a texto para el atributo ano_tratamiento
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ALTER COLUMN ano_tratamiento SET DATA TYPE TEXT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 1 secs 200 msec.
--COMMIT
--Query returned successfully in 1 secs 376 msec.
--Actualizar los valores 9999 del atributo ano_tratamiento a DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_transformado SET ano_tratamiento = 'DESCONOCIDO'
WHERE ano_tratamiento = '9999';
COMMIT;
--UPDATE 31654
--Query returned successfully in 1 secs 180 msec.
--COMMIT
--Query returned successfully in 1 secs 851 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--68. Campo cantidad_tumores
--Crear el atributo cantidad_tumores de tipo SMALLINT
BEGIN;
ALTER TABLE etl.tumores_pasto_transformado ADD cantidad_tumores SMALLINT;
COMMIT;
--ALTER TABLE
--Query returned successfully in 71 msec.
--COMMIT
--Query returned successfully in 1 secs 90 msec.
--Actualizar el atributo con la cantidad de tumores que tiene cada paciente
BEGIN;
UPDATE etl.tumores_pasto_transformado t1 SET cantidad_tumores = t2.cantidad_tumores FROM
(SELECT paciente,COUNT(*) cantidad_tumores FROM etl.tumores_pasto_transformado
WHERE fi = 1 GROUP BY paciente ORDER BY 1) t2 WHERE t1.paciente = t2.paciente;
COMMIT;
--UPDATE 41345
--Query returned successfully in 962 msec.
--COMMIT
--Query returned successfully in 907 msec.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--===================================================================================================================================================================================

--TABLA FINAL
--SELECT * FROM etl.tumores_pasto_transformado;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--===================================================================================================================================================================================

--Con el fin de calcular las Tasas de Incidencia, Especificas por Edad y Acumuladas es necesario Transformar la
--tabla que contiene los registros de Estadisticas de Proyecciones de Poblacion del DANE
--(etl.tab_dane_pobpasto_base)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Crear la tabla tab_dane_pobpasto a partir de la tabla tab_dane_pobpasto_base.
BEGIN;
CREATE TABLE etl.tab_dane_pobpasto AS SELECT * FROM etl.tab_dane_pobpasto_base;
COMMIT;
--SELECT 13311
--Query returned successfully in 412 msec.
--COMMIT
--Query returned successfully in 625 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--TRANSFORMACION DE LA TABLA DE PROYECCIONES DE POBLACION DEL DANE
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1. Se eliminan los registros totalizados por sexo y edad donde los campos sexo y/o edad toman el valor de 'X',
--con el fin de conservar solo los valores de proyeccion individuales por edad, sexo y año
BEGIN;
DELETE FROM etl.tab_dane_pobpasto WHERE sexo = 'X' OR edad = 'X';
COMMIT;
--DELETE 4539
--Query returned successfully in 222 msec.
--COMMIT
--Query returned successfully in 212 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Adicionar registros faltantes a la tabla etl.tab_dane_pobpasto
--Teniendo en cuenta que en los casos del RPCMP hay edades superiores a los 85 años y en las tablas de proyeccion
--de poblacion se registra la expresion '85 y mas', es necesario independizar los registros con los mismos valores
--asignados para el registro de '85 y mas' para los casos con edades superiores a los 85 años y bajo el respectivo
--sexo y año de diagnostico
BEGIN;
INSERT INTO etl.tab_dane_pobpasto (ano,sexo,edad,vr_cab_muni,vr_cent_pob_rural,vr_total)
SELECT DISTINCT ano_diagnostico ano,t1.sexo sexo,edad_paciente edad,vr_cab_muni,vr_cent_pob_rural,vr_total
FROM etl.tumores_pasto_transformado t1 LEFT JOIN etl.tab_dane_pobpasto t2 ON
ano_diagnostico = ano AND t1.sexo = t2.sexo AND t2.edad = '85 y más' WHERE edad_paciente > 85
ORDER BY ano_diagnostico,sexo,edad_paciente;
COMMIT;
--INSERT 0 394
--Query returned successfully in 310 msec.
--COMMIT
--Query returned successfully in 438 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3. Campo edad
--Actualizar los valores '85 y más' del atributo edad a 85
BEGIN;
UPDATE etl.tab_dane_pobpasto SET edad = '85' WHERE edad = '85 y más';
COMMIT;
--UPDATE 102
--Query returned successfully in 146 msec.
--COMMIT
--Query returned successfully in 111 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4. Campos de valores de proyeccion (vr_cab_muni, vr_cent_pob_rural y vr_total)
--Actualizar los valores de vr_cab_muni, vr_cent_pob_rural y vr_total a 0 para los registros donde la edad es
--desconocida (999)
BEGIN;
UPDATE etl.tab_dane_pobpasto SET vr_cab_muni = 0 WHERE edad = '999';
UPDATE etl.tab_dane_pobpasto SET vr_cent_pob_rural = 0 WHERE edad = '999';
UPDATE etl.tab_dane_pobpasto SET vr_total = 0 WHERE edad = '999';
COMMIT;
--UPDATE 4
--Query returned successfully in 187 msec.
--COMMIT
--Query returned successfully in 102 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5. Eliminar registros sobrantes de la tabla etl.tab_dane_pobpasto
--Teniendo en cuenta que en la tabla de proyecciones de poblacion del DANE se registran años para los que no se
--encuentran casos del RPCMP (años futuros por ejemplo), es necesario eliminar estos registros para evitar incluir
--estos valores en los calculos de proyecciones de poblacion
BEGIN;
DELETE FROM etl.tab_dane_pobpasto WHERE ano NOT IN
(SELECT DISTINCT(ano_diagnostico) FROM etl.tumores_pasto_transformado);
COMMIT;
--DELETE 2064
--Query returned successfully in 167 msec.
--COMMIT
--Query returned successfully in 171 msec.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--===================================================================================================================================================================================

--TABLA FINAL
SELECT * FROM etl.tab_dane_pobpasto;
