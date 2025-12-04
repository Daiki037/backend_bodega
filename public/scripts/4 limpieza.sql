--===================================================================================================================================================================================
--BODEGA DE DATOS SISTEMA YACHAY - RPCMP
--REGISTRO POBLACIONAL DE CANCER DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================
--MARZO DE 2025
--LIMPIEZA DE DATOS A PARTIR DE LA TABLA DE EXTRACCION DE LOS TUMORES-FUENTE DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================

--Crear la tabla tumores_pasto_limpio a partir de la tabla tumores_pasto.
BEGIN;
CREATE TABLE etl.tumores_pasto_limpio AS SELECT * FROM etl.tumores_pasto;
COMMIT;
--SELECT 41345
--Query returned successfully in 247 msec.
--COMMIT
--Query returned successfully in 671 msec.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1. Campo sexo
--Reemplazar los valores Masculino por HOMBRE y Femenino por MUJER segun nomenclatura del RPCMP
BEGIN;
UPDATE etl.tumores_pasto_limpio SET sexo = 'HOMBRE' WHERE sexo = 'Masculino';
COMMIT;
--UPDATE 15755
--Query returned successfully in 486 msec.
--COMMIT
--Query returned successfully in 154 msec.
BEGIN;
UPDATE etl.tumores_pasto_limpio SET sexo = 'MUJER' WHERE sexo = 'Femenino';
COMMIT;
--UPDATE 25684
--Query returned successfully in 493 msec.
--COMMIT
--Query returned successfully in 156 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET sexo = TRIM(BOTH FROM sexo);
COMMIT;
--UPDATE 41345
--Query returned successfully in 901 msec.
--COMMIT
--Query returned successfully in 731 msec.
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET sexo = UPPER(sexo);
COMMIT;
--UPDATE 41345
--Query returned successfully in 542 msec.
--COMMIT
--Query returned successfully in 768 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2. Campo fecha_nacimiento
--Reemplazar las fechas nulas por fechas desconocidas bajo el formato 99-99-9999
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fecha_nacimiento = '99-99-9999' WHERE fecha_nacimiento IS NULL;
COMMIT;
--UPDATE 161
--Query returned successfully in 91 msec.
--COMMIT
--Query returned successfully in 133 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3. Campo cod_estado_vital
--Reemplazar los codigos nulos por codigo 9 asignado a Desconocido
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_estado_vital = '9' WHERE cod_estado_vital IS NULL;
COMMIT;
--UPDATE 39
--Query returned successfully in 173 msec.
--COMMIT
--Query returned successfully in 117 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--4. Campo estado_vital
--Reemplazar los estados vital nulos en DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET estado_vital = 'DESCONOCIDO' WHERE estado_vital IS NULL;
COMMIT;
--UPDATE 39
--Query returned successfully in 161 msec.
--COMMIT
--Query returned successfully in 116 msec.
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET estado_vital = UPPER(estado_vital);
COMMIT;
--UPDATE 41345
--Query returned successfully in 384 msec.
--COMMIT
--Query returned successfully in 716 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--5. Campo cod_localizacion
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_localizacion = TRIM(BOTH FROM cod_localizacion);
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 23 msec.
--COMMIT
--Query returned successfully in 758 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--6. Campo cod_cieo3_grupo
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_cieo3_grupo = TRIM(BOTH FROM cod_cieo3_grupo);
COMMIT;
--UPDATE 41345
--Query returned successfully in 764 msec.
--COMMIT
--Query returned successfully in 882 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--7. Campo no_cieo3_grupo
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET no_cieo3_grupo = TRIM(BOTH FROM no_cieo3_grupo);
COMMIT;
--UPDATE 41345
--Query returned successfully in 872 msec.
--COMMIT
--Query returned successfully in 670 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--8. Campo cod_cie10
--Eliminar X al final de codigos que en realidad son de 3 caracteres y eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_cie10 = CASE
WHEN RIGHT(TRIM(BOTH FROM cod_cie10),1) = 'X' THEN LEFT(cod_cie10,LENGTH(cod_cie10) - 1)
ELSE TRIM(BOTH FROM cod_cie10)
END;
COMMIT;
--UPDATE 41345
--Query returned successfully in 306 msec.
--COMMIT
--Query returned successfully in 771 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--9. Campo cod_cie10_grupo
--Reemplazar los codigos nulos por codigo 000 asignado a 'Tumores de comportamiento Benigno, Incierto e In situ'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_cie10_grupo = '000' WHERE cod_cie10_grupo IS NULL;
COMMIT;
--UPDATE 4254
--Query returned successfully in 453 msec.
--COMMIT
--Query returned successfully in 299 msec.
--Reemplazar los codigos C44 por el codigo EXC asignado a los casos con codigos de morfologia 8070 a 8078 y 8090 a 8098
--de cancer de piel excluidos de reportes y conteos
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_cie10_grupo = 'EXC' WHERE cod_cie10_grupo = 'C44' AND
(cod_morfologia BETWEEN '8070' AND '8078' OR cod_morfologia BETWEEN '8090' AND '8098');
COMMIT;
--UPDATE 4250
--Query returned successfully in 858 msec.
--COMMIT
--Query returned successfully in 389 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_cie10_grupo = TRIM(BOTH FROM cod_cie10_grupo);
COMMIT;
--UPDATE 41345
--Query returned successfully in 939 msec.
--COMMIT
--Query returned successfully in 862 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--10. Campo cie10_grupo
--Reemplazar los valores nulos por 'Tumores de comportamiento Benigno, Incierto e In situ' asociado al codigo 000 de
--cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cie10_grupo = 'Tumores de comportamiento Benigno, Incierto e In situ'
WHERE cie10_grupo IS NULL;
COMMIT;
--UPDATE 4254
--Query returned successfully in 328 msec.
--COMMIT
--Query returned successfully in 322 msec.
--Reemplazar los valores 'Otras neoplasias malignas de la piel' por 'Otras neoplasias malignas de la piel que agrupan
--los carcinomas de células basales y escamosas de la piel' asociado al codigo EXC de cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio SET
cie10_grupo = 'Otras neoplasias malignas de la piel que agrupan los carcinomas de células basales y escamosas de la piel'
WHERE cod_cie10_grupo = 'EXC';
COMMIT;
--UPDATE 4250
--Query returned successfully in 460 msec.
--COMMIT
--Query returned successfully in 481 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--11. Campo cie10_grupo_general
--Reemplazar los valores nulos por 'Tumores de comportamiento Benigno, Incierto e In situ' asociado al codigo 000 de
--cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cie10_grupo_general = 'Tumores de comportamiento Benigno, Incierto e In situ'
WHERE cie10_grupo_general IS NULL;
COMMIT;
--UPDATE 4254
--Query returned successfully in 410 msec.
--COMMIT
--Query returned successfully in 300 msec.
--Reemplazar los valores 'Todos los sitios' por 'Otras neoplasias malignas de la piel que agrupan los carcinomas de
--células basales y escamosas de la piel' asociado al codigo EXC de cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cie10_grupo_general = 'Otras neoplasias malignas de la piel que agrupan los carcinomas de células basales y escamosas de la piel'
WHERE cod_cie10_grupo = 'EXC';
COMMIT;
--UPDATE 4250
--Query returned successfully in 403 msec.
--COMMIT
--Query returned successfully in 403 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--12. Campo cie10_grupo_excepto_c44
--Reemplazar los valores nulos por 'Tumores de comportamiento Benigno, Incierto e In situ' asociado al codigo 000 de
--cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cie10_grupo_excepto_c44 = 'Tumores de comportamiento Benigno, Incierto e In situ'
WHERE cie10_grupo_excepto_c44 IS NULL;
COMMIT;
--UPDATE 4254
--Query returned successfully in 350 msec.
--COMMIT
--Query returned successfully in 285 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--13. Campo cod_grupo_cie10
--Reemplazar los valores nulos por 0 asociado al codigo 000 de cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_grupo_cie10 = 0 WHERE cod_grupo_cie10 IS NULL;
COMMIT;
--UPDATE 4254
--Query returned successfully in 567 msec.
--COMMIT
--Query returned successfully in 547 msec.
--Reemplazar los valores 26 por el maximo de este codigo + 1 creando un nuevo grupo para las morfologias excluidas de
--cancer de piel asociados al codigo EXC de cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_grupo_cie10 = (
SELECT MAX(cod_grupo_cie10) + 1 FROM etl.tumores_pasto_limpio
) WHERE cod_cie10_grupo = 'EXC';
COMMIT;
--UPDATE 4250
--Query returned successfully in 750 msec.
--COMMIT
--Query returned successfully in 964 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--14. Campo grupo_cie10
--Reemplazar los valores nulos por 'Tumores de comportamiento Benigno, Incierto e In situ' asociado al codigo 000 de
--cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio SET grupo_cie10 = 'Tumores de comportamiento Benigno, Incierto e In situ'
WHERE grupo_cie10 IS NULL;
COMMIT;
--UPDATE 4254
--Query returned successfully in 442 msec.
--COMMIT
--Query returned successfully in 670 msec.
--Reemplazar los valores 'Otras neoplasias de piel' por 'Otras neoplasias malignas de la piel que agrupan los carcinomas de células
--basales y escamosas de la piel' asociado al codigo EXC de cod_cie10_grupo
BEGIN;
UPDATE etl.tumores_pasto_limpio
SET grupo_cie10 = 'Otras neoplasias malignas de la piel que agrupan los carcinomas de células basales y escamosas de la piel'
WHERE cod_cie10_grupo = 'EXC';
COMMIT;
--UPDATE 4250
--Query returned successfully in 387 msec.
--COMMIT
--Query returned successfully in 372 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--15. Campo cod_lateralidad
--A partir de la tabla de lateralidad compartida por el RPCMP que identifica los codigos de cancer que deben tener
--registrado una lateralidad, se reemplaza los codigos de lateralidad nulos con el valor 4 que es No corresponde
--para aquellos registros con codigos cie10 que no aparecen en la tabla
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_lateralidad = 4 WHERE cod_lateralidad IS NULL
AND cod_cie10 NOT IN (
SELECT DISTINCT(cod_cie10) FROM etl.tumores_pasto
WHERE cod_cie10 BETWEEN 'C079' AND 'C081'
OR cod_cie10 BETWEEN 'C090' AND 'C091'
OR cod_cie10 BETWEEN 'C098' AND 'C099'
OR cod_cie10 BETWEEN 'C300' AND 'C301'
OR cod_cie10 BETWEEN 'C340' AND 'C349'
OR cod_cie10 BETWEEN 'C400' AND 'C403'
OR cod_cie10 BETWEEN 'C413' AND 'C414'
OR cod_cie10 BETWEEN 'C441' AND 'C443'
OR cod_cie10 BETWEEN 'C445' AND 'C447'
OR cod_cie10 BETWEEN 'C471' AND 'C472'
OR cod_cie10 BETWEEN 'C491' AND 'C492'
OR cod_cie10 BETWEEN 'C500' AND 'C509'
OR cod_cie10 BETWEEN 'C569' AND 'C570'
OR cod_cie10 BETWEEN 'C620' AND 'C631'
OR cod_cie10 BETWEEN 'C690' AND 'C699'
OR cod_cie10 BETWEEN 'C710' AND 'C714'
OR cod_cie10 BETWEEN 'C722' AND 'C725'
OR cod_cie10 BETWEEN 'C740' AND 'C749'
OR cod_cie10 IN
('C310','C312','C384','C649','C659','C669','C700','C754')
GROUP BY cod_cie10
);
COMMIT;
--UPDATE 10998
--Query returned successfully in 571 msec.
--COMMIT
--Query returned successfully in 1 secs 3 msec.
--Reemplazar los codigos de lateralidad nulos con el valor de 9 que es Desconocido para los codigos cie10 que
--corresponden con los listados en la tabla de lateralidad
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_lateralidad = 9 WHERE cod_lateralidad IS NULL
AND cod_cie10 IN (
SELECT DISTINCT(cod_cie10) FROM etl.tumores_pasto
WHERE cod_cie10 BETWEEN 'C079' AND 'C081'
OR cod_cie10 BETWEEN 'C090' AND 'C091'
OR cod_cie10 BETWEEN 'C098' AND 'C099'
OR cod_cie10 BETWEEN 'C300' AND 'C301'
OR cod_cie10 BETWEEN 'C340' AND 'C349'
OR cod_cie10 BETWEEN 'C400' AND 'C403'
OR cod_cie10 BETWEEN 'C413' AND 'C414'
OR cod_cie10 BETWEEN 'C441' AND 'C443'
OR cod_cie10 BETWEEN 'C445' AND 'C447'
OR cod_cie10 BETWEEN 'C471' AND 'C472'
OR cod_cie10 BETWEEN 'C491' AND 'C492'
OR cod_cie10 BETWEEN 'C500' AND 'C509'
OR cod_cie10 BETWEEN 'C569' AND 'C570'
OR cod_cie10 BETWEEN 'C620' AND 'C631'
OR cod_cie10 BETWEEN 'C690' AND 'C699'
OR cod_cie10 BETWEEN 'C710' AND 'C714'
OR cod_cie10 BETWEEN 'C722' AND 'C725'
OR cod_cie10 BETWEEN 'C740' AND 'C749'
OR cod_cie10 IN
('C310','C312','C384','C649','C659','C669','C700','C754')
GROUP BY cod_cie10
);
COMMIT;
--UPDATE 2479
--Query returned successfully in 598 msec.
--COMMIT
--Query returned successfully in 808 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--16. Campo lateralidad
--Acorde a la actualizacion anterior de los codigos de lateralidad es necesario asociar un nombre a la lateralidad
--de los registros actualizados entonces reemplazar los registros nulos de lateralidad y con codigos cie10 que no
--estan en la tabla de lateralidad por el valor asociado al codigo de lateralidad 4 (NO CORRESPONDE)
BEGIN;
UPDATE etl.tumores_pasto_limpio SET lateralidad =(
SELECT nom_lateralidad FROM tab_lateralidad WHERE cod_lateralidad = 4
) WHERE lateralidad IS NULL
AND cod_cie10 NOT IN (
SELECT DISTINCT(cod_cie10) FROM etl.tumores_pasto
WHERE cod_cie10 BETWEEN 'C079' AND 'C081'
OR cod_cie10 BETWEEN 'C090' AND 'C091'
OR cod_cie10 BETWEEN 'C098' AND 'C099'
OR cod_cie10 BETWEEN 'C300' AND 'C301'
OR cod_cie10 BETWEEN 'C340' AND 'C349'
OR cod_cie10 BETWEEN 'C400' AND 'C403'
OR cod_cie10 BETWEEN 'C413' AND 'C414'
OR cod_cie10 BETWEEN 'C441' AND 'C443'
OR cod_cie10 BETWEEN 'C445' AND 'C447'
OR cod_cie10 BETWEEN 'C471' AND 'C472'
OR cod_cie10 BETWEEN 'C491' AND 'C492'
OR cod_cie10 BETWEEN 'C500' AND 'C509'
OR cod_cie10 BETWEEN 'C569' AND 'C570'
OR cod_cie10 BETWEEN 'C620' AND 'C631'
OR cod_cie10 BETWEEN 'C690' AND 'C699'
OR cod_cie10 BETWEEN 'C710' AND 'C714'
OR cod_cie10 BETWEEN 'C722' AND 'C725'
OR cod_cie10 BETWEEN 'C740' AND 'C749'
OR cod_cie10 IN
('C310','C312','C384','C649','C659','C669','C700','C754')
GROUP BY cod_cie10
);
COMMIT;
--UPDATE 10998
--Query returned successfully in 718 msec.
--COMMIT
--Query returned successfully in 822 msec.
--Reemplazar los registros de lateralidad nulos con el valor de Desconocido correspondiente al codigo 9 de lateralidad
--para los codigos cie10 que corresponden con los listados en la tabla de lateralidad
BEGIN;
UPDATE etl.tumores_pasto_limpio SET lateralidad = (
SELECT nom_lateralidad FROM tab_lateralidad WHERE cod_lateralidad = 9
)
WHERE lateralidad IS NULL
AND cod_cie10 IN (
SELECT DISTINCT(cod_cie10) FROM etl.tumores_pasto
WHERE cod_cie10 BETWEEN 'C079' AND 'C081'
OR cod_cie10 BETWEEN 'C090' AND 'C091'
OR cod_cie10 BETWEEN 'C098' AND 'C099'
OR cod_cie10 BETWEEN 'C300' AND 'C301'
OR cod_cie10 BETWEEN 'C340' AND 'C349'
OR cod_cie10 BETWEEN 'C400' AND 'C403'
OR cod_cie10 BETWEEN 'C413' AND 'C414'
OR cod_cie10 BETWEEN 'C441' AND 'C443'
OR cod_cie10 BETWEEN 'C445' AND 'C447'
OR cod_cie10 BETWEEN 'C471' AND 'C472'
OR cod_cie10 BETWEEN 'C491' AND 'C492'
OR cod_cie10 BETWEEN 'C500' AND 'C509'
OR cod_cie10 BETWEEN 'C569' AND 'C570'
OR cod_cie10 BETWEEN 'C620' AND 'C631'
OR cod_cie10 BETWEEN 'C690' AND 'C699'
OR cod_cie10 BETWEEN 'C710' AND 'C714'
OR cod_cie10 BETWEEN 'C722' AND 'C725'
OR cod_cie10 BETWEEN 'C740' AND 'C749'
OR cod_cie10 IN
('C310','C312','C384','C649','C659','C669','C700','C754')
GROUP BY cod_cie10
);
COMMIT;
--UPDATE 2479
--Query returned successfully in 659 msec.
--COMMIT
--Query returned successfully in 734 msec.
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET lateralidad = UPPER(lateralidad);
COMMIT;
--UPDATE 41345
--Query returned successfully in 638 msec.
--COMMIT
--Query returned successfully in 982 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--17. Campo comportamiento
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET comportamiento = UPPER(comportamiento);
COMMIT;
--UPDATE 41345
--Query returned successfully in 362 msec.
--COMMIT
--Query returned successfully in 691 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--18. Campo cod_mencion_cancer
--Reemplazar los codigos de mencion de cancer por un nuevo codigo con valor 0 (NO APLICA) para tumores con estado
--vital 'VIVO'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_mencion_cancer = 0 WHERE estado_vital = 'VIVO';
COMMIT;
--UPDATE 19900
--Query returned successfully in 712 msec.
--COMMIT
--Query returned successfully in 387 msec.
--Reemplazar los codigos de mencion de cancer por el codigo 3 que corresponde a 'MUERE POR CAUSAS DESCONOCIDAS' para
--aquellos registros cuyo estado vital es MUERTO y la variable codigo mencion de cancer esta en blanco o se habia
--registrado como igual a 9 (Desconocido)
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_mencion_cancer = 3
WHERE estado_vital = 'MUERTO' AND (cod_mencion_cancer = 9 OR cod_mencion_cancer IS NULL);
COMMIT;
--UPDATE 4061
--Query returned successfully in 546 msec.
--COMMIT
--Query returned successfully in 120 msec.
--Reemplazar los codigos de mencion de cancer por el codigo 9 que corresponde a DESCONOCIDO para aquellos registros
--donde el estado vital es DESCONOCIDO o 'PERDIDO EN EL SEGUIMIENTO'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_mencion_cancer = 9
WHERE estado_vital = 'DESCONOCIDO' OR estado_vital = 'PERDIDO EN EL SEGUIMIENTO';
COMMIT;
--UPDATE 2526
--Query returned successfully in 426 msec.
--COMMIT
--Query returned successfully in 125 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--19. Campo mencion_cancer
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET mencion_cancer = UPPER(mencion_cancer);
COMMIT;
--UPDATE 41345
--Query returned successfully in 881 msec.
--COMMIT
--Query returned successfully in 1 secs 196 msec.
--Acorde a la actualizacion del campo cod_mencion_cancer es necesario asociar un nombre a la mencion de cancer de los
--registros actualizados entonces reemplazar el valor de mencion cancer por NO APLICA para tumores con estado vital
--'VIVO'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET mencion_cancer = 'NO APLICA' WHERE estado_vital = 'VIVO';
COMMIT;
--UPDATE 19900
--Query returned successfully in 594 msec.
--COMMIT
--Query returned successfully in 485 msec.
--Reemplazar la mencion de cancer por el valor MUERE POR CAUSAS DESCONOCIDAS para aquellos registros donde el estado
--vital es MUERTO y la variable mencion de cancer esta en blanco o habia sido registrada como 'DESCONOCIDO'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET mencion_cancer = 'MUERE POR CAUSAS DESCONOCIDAS'
WHERE estado_vital = 'MUERTO' AND (mencion_cancer = 'DESCONOCIDO' OR mencion_cancer IS NULL);
COMMIT;
--UPDATE 4061
--Query returned successfully in 465 msec.
--COMMIT
--Query returned successfully in 157 msec.
--Reemplazar la mencion de cancer por el valor DESCONOCIDO para aquellos registros donde el estado vital es
--DESCONOCIDO y PERDIDO EN EL SEGUIMIENTO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET mencion_cancer = 'DESCONOCIDO'
WHERE estado_vital = 'DESCONOCIDO' OR estado_vital = 'PERDIDO EN EL SEGUIMIENTO';
COMMIT;
--UPDATE 2526
--Query returned successfully in 465 msec.
--COMMIT
--Query returned successfully in 164 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--20. Campo cod_profesion_expedidor
--Reemplazar los valores del codigo de profesion expedidor por un nuevo codigo 0 (NO APLICA) para tumores con estado
--vital 'VIVO'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_profesion_expedidor = 0 WHERE estado_vital = 'VIVO';
COMMIT;
--UPDATE 19900
--Query returned successfully in 1 secs 190 msec.
--COMMIT
--Query returned successfully in 349 msec.
--Reemplazar los valores nulos o con valor Desconocido del codigo de profesion expedidor por el codigo 5 que corresponde
--a 'PROFESIÓN DEL EXPEDIDOR DESCONOCIDA' para aquellos registros donde el estado vital es MUERTO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_profesion_expedidor = 5
WHERE estado_vital = 'MUERTO' AND (cod_profesion_expedidor = 9 OR cod_profesion_expedidor IS NULL);
COMMIT;
--UPDATE 3159
--Query returned successfully in 496 msec.
--COMMIT
--Query returned successfully in 155 msec.
--Reemplazar los valores del codigo de profesion expedidor por el codigo 9 que corresponde a DESCONOCIDO para
--aquellos registros donde el estado vital es PERDIDO EN EL SEGUIMIENTO o DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_profesion_expedidor = 9
WHERE estado_vital = 'PERDIDO EN EL SEGUIMIENTO' OR estado_vital = 'DESCONOCIDO';
COMMIT;
--UPDATE 2526
--Query returned successfully in 428 msec.
--COMMIT
--Query returned successfully in 151 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--21. Campo profesion_expedidor
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET profesion_expedidor = UPPER(profesion_expedidor);
COMMIT;
--UPDATE 41345
--Query returned successfully in 881 msec.
--COMMIT
--Query returned successfully in 1 secs 344 msec.
--Acorde a la actualizacion del campo cod_profesion_expedidor es necesario asociar un nombre a la profesion del
--expedidor del certificado de defuncion de los registros actualizados entonces reemplazar el valor de profesion
--expedidor por el valor NO APLICA para tumores con estado vital 'VIVO'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET profesion_expedidor = 'NO APLICA' WHERE estado_vital = 'VIVO';
COMMIT;
--UPDATE 19900
--Query returned successfully in 680 msec.
--COMMIT
--Query returned successfully in 490 msec.
--Reemplazar los valores nulos y DESCONOCIDO del campo de profesion expedidor por el valor de 'PROFESIÓN DEL EXPEDIDOR
--DESCONOCIDA' para aquellos registros donde el estado vital es MUERTO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET profesion_expedidor = 'PROFESIÓN DEL EXPEDIDOR DESCONOCIDA'
WHERE estado_vital = 'MUERTO' AND (profesion_expedidor = 'DESCONOCIDO' OR profesion_expedidor IS NULL);
COMMIT;
--UPDATE 3159
--Query returned successfully in 519 msec.
--COMMIT
--Query returned successfully in 144 msec.
--Reemplazar los valores del campo de profesion expedidor por el valor de DESCONOCIDO para aquellos registros
--donde el estado vital es PERDIDO EN EL SEGUIMIENTO y DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET profesion_expedidor = 'DESCONOCIDO'
WHERE estado_vital = 'PERDIDO EN EL SEGUIMIENTO' OR estado_vital = 'DESCONOCIDO';
COMMIT;
--UPDATE 2526
--Query returned successfully in 498 msec.
--COMMIT
--Query returned successfully in 165 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET profesion_expedidor = TRIM(BOTH FROM profesion_expedidor)
WHERE profesion_expedidor != TRIM(BOTH FROM profesion_expedidor);
COMMIT;
--UPDATE 3694
--Query returned successfully in 499 msec.
--COMMIT
--Query returned successfully in 163 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--22. Campo fecha_ultimo_contacto
--Reemplazar las fechas nulas por fechas desconocidas bajo el formato 99-99-9999
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fecha_ultimo_contacto = '99-99-9999'
WHERE fecha_ultimo_contacto IS NULL;
COMMIT;
--UPDATE 2941
--Query returned successfully in 243 msec.
--COMMIT
--Query returned successfully in 180 msec.
--Corregir el valor anomalo 11-30-2012 por el valor correcto en el formato DD-MM-AAAA (30-11-2012)
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fecha_ultimo_contacto = '30-11-2012'
WHERE fecha_ultimo_contacto = '11-30-2012';
COMMIT;
--UPDATE 2
--Query returned successfully in 405 msec.
--COMMIT
--Query returned successfully in 102 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--23. Campo cod_fuente
--Reemplazar los codigos de fuente nulos por el valor de 999 que corresponde con el valor de DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_fuente = 999 WHERE cod_fuente IS NULL;
COMMIT;
--UPDATE 1238
--Query returned successfully in 170 msec.
--COMMIT
--Query returned successfully in 160 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_fuente = TRIM(BOTH FROM cod_fuente)
WHERE LENGTH(cod_fuente) < PG_COLUMN_SIZE(cod_fuente)-1;
COMMIT;
--UPDATE 41345
--Query returned successfully in 739 msec.
--COMMIT
--Query returned successfully in 921 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--24. Campo fuente
--Acorde a la actualizacion anterior del campo cod_fuente es necesario asociar un nombre a la fuente de los registros
--actualizados entonces reemplazar los valores nulos de fuente por el valor de DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fuente = 'DESCONOCIDO' WHERE fuente IS NULL;
COMMIT;
--UPDATE 1238
--Query returned successfully in 172 msec.
--COMMIT
--Query returned successfully in 165 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fuente = TRIM(BOTH FROM fuente) WHERE fuente != TRIM(BOTH FROM fuente);
COMMIT;
--UPDATE 18801
--Query returned successfully in 408 msec.
--COMMIT
--Query returned successfully in 255 msec.
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fuente = UPPER(fuente);
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 300 msec.
--COMMIT
--Query returned successfully in 868 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--25. Campo cod_tratamiento
--Reemplazar los codigos de tratamiento nulos por el valor de 99 que corresponde con el valor de DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_tratamiento = 99 WHERE cod_tratamiento IS NULL;
COMMIT;
--UPDATE 6456
--Query returned successfully in 801 msec.
--COMMIT
--Query returned successfully in 745 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--26. Campo tratamiento
--Actualizar los valores incorrectos de tratamiento que corresponden con el codigo tratamiento No. 16 de NO REGISTRA
--a CRIOTERAPIA
BEGIN;
UPDATE etl.tumores_pasto_limpio SET tratamiento = 'CRIOTERAPIA' WHERE
cod_tratamiento = 16 AND tratamiento = 'NO REGISTRA';
COMMIT;
--UPDATE 6
--Query returned successfully in 672 msec.
--COMMIT
--Query returned successfully in 682 msec.
--Acorde a la actualizacion anterior del campo cod_tratamiento es necesario asociar un nombre al tratamiento de los
--registros actualizados entonces reemplazar los valores nulos de tratamiento por el valor de DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET tratamiento = 'DESCONOCIDO' WHERE tratamiento IS NULL;
COMMIT;
--UPDATE 6456
--Query returned successfully in 840 msec.
--COMMIT
--Query returned successfully in 901 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET tratamiento = TRIM(BOTH FROM tratamiento)
WHERE tratamiento != TRIM(BOTH FROM tratamiento);
COMMIT;
--UPDATE 16369
--Query returned successfully in 1 secs 315 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--27. Campo cod_estado_enfermedad
--Reemplazar los codigos de estado de enfermedad nulos por el valor de 9 que corresponde con el valor de DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_estado_enfermedad = 9 WHERE cod_estado_enfermedad IS NULL;
COMMIT;
--UPDATE 26648
--Query returned successfully in 1 secs 163 msec.
--COMMIT
--Query returned successfully in 1 secs 112 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--28. Campo estado_enfermedad
--Acorde a la actualizacion anterior del campo cod_estado_enfermedad es necesario asociar un nombre al estado de
--enfermedad de los registros actualizados entonces reemplazar los valores nulos de estado_enfermedad por el valor de
--DESCONOCIDO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET estado_enfermedad = 'DESCONOCIDO' WHERE estado_enfermedad IS NULL;
COMMIT;
--UPDATE 26648
--Query returned successfully in 1 secs 842 msec.
--COMMIT
--Query returned successfully in 1 secs 925 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--29. Campo fecha_tratamiento
--Corregir registros anomalos de fechas de tratamiento asignando el valor de fecha desconocida (99999999)
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fecha_tratamiento = '99999999' WHERE fecha_tratamiento IN
('07070707','19050702','19709999','21200299','24','29/02929');
COMMIT;
--UPDATE 136
--Query returned successfully in 382 msec.
--COMMIT
--Query returned successfully in 356 msec.
--Reemplazar las fechas nulas por fechas desconocidas bajo el formato 99999999
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fecha_tratamiento = '99999999' WHERE fecha_tratamiento IS NULL;
COMMIT;
--UPDATE 26201
--Query returned successfully in 978 msec.
--COMMIT
--Query returned successfully in 992 msec.
--Corregir el valor anomalo 20143008 a fecha desconocida bajo el formato AAAAMMDD (99999999)
BEGIN;
UPDATE etl.tumores_pasto_limpio SET fecha_tratamiento = '99999999'
WHERE fecha_tratamiento = '20143008';
COMMIT;
--UPDATE 3
--Query returned successfully in 562 msec.
--COMMIT
--Query returned successfully in 603 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--30. Campo orden_tratamiento
--Reemplazar los registros nulos de orden_tratamiento por 0 (no hay un tratamiento asociado)
BEGIN;
UPDATE etl.tumores_pasto_limpio SET orden_tratamiento = 0 WHERE orden_tratamiento IS NULL;
COMMIT;
--UPDATE 6456
--Query returned successfully in 1 secs 160 msec.
--COMMIT
--Query returned successfully in 1 secs 101 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--31. Campo cod_departamento
--Reemplazar los valores de codigo de departamento de 99 por el valor de 52 porque luego del analisis esos registros
--de cancer corresponden al Municipio de Pasto
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_departamento = '52' WHERE cod_departamento = '99';
COMMIT;
--UPDATE 2422
--Query returned successfully in 170 msec.
--COMMIT
--Query returned successfully in 172 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_departamento = TRIM(BOTH FROM cod_departamento)
WHERE LENGTH(cod_departamento) < PG_COLUMN_SIZE(cod_departamento)-1;
COMMIT;
--UPDATE 41345
--Query returned successfully in 783 msec.
--COMMIT
--Query returned successfully in 647 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--32. Campo departamento
--Acorde a la actualizacion anterior del campo cod_departamento es necesario asociar un nombre al departamento de
--los registros actualizados entonces reemplazar el valor de departamento por el valor NARIÑO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET departamento = 'NARIÑO' WHERE departamento = 'DESCONOCIDO';
COMMIT;
--UPDATE 2422
--Query returned successfully in 94 msec.
--COMMIT
--Query returned successfully in 158 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--33. Campo cod_municipio
--Reemplazar los valores de codigo de municipio de 99999 por el valor de 52001 porque luego del analisis esos
--registros de cancer corresponden al Municipio de Pasto
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_municipio = '52001' WHERE cod_municipio = '99999';
COMMIT;
--UPDATE 2422
--Query returned successfully in 93 msec.
--COMMIT
--Query returned successfully in 208 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_municipio = TRIM(BOTH FROM cod_municipio)
WHERE LENGTH(cod_municipio) < PG_COLUMN_SIZE(cod_municipio)-1;
COMMIT;
--UPDATE 41345
--Query returned successfully in 621 msec.
--COMMIT
--Query returned successfully in 582 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--34. Campo municipio
--Acorde a la actualizacion anterior del campo cod_municipio es necesario asociar un nombre al municipio de los
--registros actualizados entonces reemplazar el valor de municipio por el valor PASTO
BEGIN;
UPDATE etl.tumores_pasto_limpio SET municipio = 'PASTO' WHERE municipio = 'DESCONOCIDO';
COMMIT;
--UPDATE 2422
--Query returned successfully in 101 msec.
--COMMIT
--Query returned successfully in 154 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--35. Campo zona
--Estandarizar el atributo a mayusculas
BEGIN;
UPDATE etl.tumores_pasto_limpio SET zona = UPPER(zona);
COMMIT;
--UPDATE 41345
--Query returned successfully in 498 msec.
--COMMIT
--Query returned successfully in 638 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--36. Campo cod_barrio_comuna
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_barrio_comuna = TRIM(BOTH FROM cod_barrio_comuna);
COMMIT;
--UPDATE 41345
--Query returned successfully in 627 msec.
--COMMIT
--Query returned successfully in 1 secs 276 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--37. Campo barrio_comuna
--Reemplazar el valor de barrio_comuna 'El Campanero' por 'El Campanero (Catambuco)'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET barrio_comuna = 'El Campanero (Catambuco)'
WHERE barrio_comuna = 'El Campanero';
COMMIT;
--UPDATE 28
--Query returned successfully in 681 msec.
--COMMIT
--Query returned successfully in 476 msec.
--Reemplazar el valor de barrio_comuna 'Rural desconocido' por 'Rural desconocido (Desconocido)'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET barrio_comuna = 'Rural desconocido (Desconocido)'
WHERE barrio_comuna = 'Rural desconocido';
COMMIT;
--UPDATE 93
--Query returned successfully in 622 msec.
--COMMIT
--Query returned successfully in 572 msec.
--Reemplazar el valor de barrio_comuna 'EL Socorro (No definido)' por 'El Socorro desconocido (El socorro)'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET barrio_comuna = 'El Socorro desconocido (El socorro)'
WHERE barrio_comuna = 'El Socorro (No definido)';
COMMIT;
--UPDATE 19
--Query returned successfully in 205 msec.
--COMMIT
--Query returned successfully in 159 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET barrio_comuna = TRIM(BOTH FROM barrio_comuna)
WHERE LENGTH(barrio_comuna) < PG_COLUMN_SIZE(barrio_comuna)-1;
COMMIT;
--UPDATE 5741
--Query returned successfully in 318 msec.
--COMMIT
--Query returned successfully in 289 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--38. Campo cod_comuna_corregimiento
--Actualizar el valor de cod_comuna_corregimiento a '17' para los registros actualizados el campo barrio_comuna a
--'El Socorro Desconocido (El socorro)'
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_comuna_corregimiento = '17'
WHERE barrio_comuna = 'El Socorro desconocido (El socorro)';
COMMIT;
--UPDATE 19
--Query returned successfully in 586 msec.
--COMMIT
--Query returned successfully in 320 msec.
--Eliminar espacios en blanco de relleno
BEGIN;
UPDATE etl.tumores_pasto_limpio SET cod_comuna_corregimiento = TRIM(BOTH FROM cod_comuna_corregimiento);
COMMIT;
--UPDATE 41345
--Query returned successfully in 1 secs 616 msec.
--COMMIT
--Query returned successfully in 1 secs 157 msec.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--===================================================================================================================================================================================

--TABLA FINAL
SELECT * FROM etl.tumores_pasto_limpio;
