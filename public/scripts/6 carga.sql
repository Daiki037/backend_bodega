--===================================================================================================================================================================================
--BODEGA DE DATOS SISTEMA YACHAY - RPCMP
--REGISTRO POBLACIONAL DE CANCER DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================
--MAYO DE 2025
--CARGA DE DATOS A PARTIR DE LOS DATOS TRANSFORMADOS DE LOS TUMORES-FUENTE DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION TUMORES
INSERT INTO dw.dim_tumores
(cod_tumor,fecha_incidencia,comportamiento,lateralidad,grado_diferenciacion,base_diagnostico,tratamiento,
estado_enfermedad)
SELECT DISTINCT tumor,fecha_diagnostico,comportamiento,lateralidad,grado_diferenciacion,
base_diagnostico,tratamiento,estado_enfermedad
FROM etl.tumores_pasto_transformado ORDER BY 1;
--INSERT 0 19619
--Query returned successfully in 504 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION EDADES
INSERT INTO dw.dim_edades
(edad,descripcion_edad,cod_grupo_etario1,grupo_etario1,cod_grupo_etario2,grupo_etario2,
proy_poblacion_mundial_estandar)
SELECT DISTINCT edad_paciente,descripcion_edad,cod_grupo_etario1,grupo_etario1,cod_grupo_etario2,grupo_etario2,
proy_poblacion_mundial_estandar
FROM etl.tumores_pasto_transformado ORDER BY 1;
--INSERT 0 104
--Query returned successfully in 239 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION PACIENTES
INSERT INTO dw.dim_pacientes
(cod_paciente,sexo,estado_vital,mencion_cancer,profesion_expedidor,edad_muerte,cantidad_tumores)
SELECT DISTINCT paciente,sexo,estado_vital,mencion_cancer,profesion_expedidor,edad_muerte,cantidad_tumores
FROM etl.tumores_pasto_transformado ORDER BY 1;
--INSERT 0 18430
--Query returned successfully in 498 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION LOCALIZACIONES
INSERT INTO dw.dim_localizaciones
(cod_localizacion,nombre_localizacion,cod_cieo3,cod_cieo3_grupo,cod_grupo,nombre_grupo)
SELECT DISTINCT cod_localizacion,localizacion,cod_cieo3,cod_cieo3_grupo,no_cieo3_grupo,cieo3_grupo
FROM etl.tumores_pasto_transformado ORDER BY 1;
--INSERT 0 231
--Query returned successfully in 314 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION MORFOLOGIAS
INSERT INTO dw.dim_morfologias (cod_morfologia,nombre_morfologia)
SELECT DISTINCT cod_morfologia,morfologia
FROM etl.tumores_pasto_transformado ORDER BY 1;
--INSERT 0 339
--Query returned successfully in 288 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION CIE10
INSERT INTO dw.dim_cie10
(cod_cie10,nombre_cie10,cod_cie10_grupo,nombre_cie10_grupo,grupo_general,grupo_excepto_c44,cod_grupo,nombre_grupo)
SELECT DISTINCT cod_cie10,cie10,cod_cie10_grupo,cie10_grupo,cie10_grupo_general,cie10_grupo_excepto_c44,cod_grupo_cie10,grupo_cie10
FROM etl.tumores_pasto_transformado ORDER BY 1;
--INSERT 0 390
--Query returned successfully in 243 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION FUENTES
INSERT INTO dw.dim_fuentes (cod_fuente,nombre_fuente)
SELECT DISTINCT cod_fuente,fuente
FROM etl.tumores_pasto_transformado ORDER BY 1;
--INSERT 0 135
--Query returned successfully in 149 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION LUGARES
INSERT INTO dw.dim_lugares (cod_departamento,nombre_departamento,cod_municipio,nombre_municipio)
SELECT DISTINCT cod_departamento,departamento,cod_municipio,municipio
FROM etl.tumores_pasto_transformado ORDER BY 1,3;
--INSERT 0 1
--Query returned successfully in 269 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION ZONAS
INSERT INTO dw.dim_zonas (zona,nombre_comuna_corregimiento,nombre_barrio_vereda)
SELECT DISTINCT zona,comuna_corregimiento,barrio_vereda
FROM etl.tumores_pasto_transformado ORDER BY 1,2;
--INSERT 0 521
--Query returned successfully in 468 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION TIEMPO DE DIAGNOSTICO
INSERT INTO dw.dim_tiempo_diagnostico
(ano_diagnostico,mes_diagnostico,cod_mes_diagnostico,semestre_diagnostico,trimestre_diagnostico,
dia_diagnostico,cod_dia_diagnostico)
SELECT * FROM
(SELECT DISTINCT(ano_diagnostico::TEXT) FROM etl.tumores_pasto_transformado)
CROSS JOIN
(SELECT DISTINCT(mes_diagnostico),cod_mes_diagnostico,semestre_diagnostico,trimestre_diagnostico
FROM etl.tumores_pasto_transformado)
CROSS JOIN
(SELECT DISTINCT(dia_diagnostico),cod_dia_diagnostico FROM etl.tumores_pasto_transformado)
ORDER BY ano_diagnostico,semestre_diagnostico,trimestre_diagnostico,cod_mes_diagnostico,cod_dia_diagnostico;
--INSERT 0 20384
--Query returned successfully in 464 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION TIEMPO DE MUERTE
INSERT INTO dw.dim_tiempo_muerte
(ano_muerte,mes_muerte,cod_mes_muerte,semestre_muerte,trimestre_muerte,dia_muerte,cod_dia_muerte)
SELECT * FROM
(SELECT DISTINCT(ano_muerte) FROM etl.tumores_pasto_transformado)
CROSS JOIN
(SELECT DISTINCT(mes_muerte),cod_mes_muerte,semestre_muerte,trimestre_muerte FROM etl.tumores_pasto_transformado)
CROSS JOIN
(SELECT DISTINCT(dia_muerte),cod_dia_muerte FROM etl.tumores_pasto_transformado)
ORDER BY ano_muerte,semestre_muerte,trimestre_muerte,cod_mes_muerte,cod_dia_muerte;
--INSERT 0 15300
--Query returned successfully in 417 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION TIEMPO DE ULTIMO CONTACTO
INSERT INTO dw.dim_tiempo_ultimo_contacto
(ano_ultimo_contacto,mes_ultimo_contacto,cod_mes_ultimo_contacto,semestre_ultimo_contacto,trimestre_ultimo_contacto,
dia_ultimo_contacto,cod_dia_ultimo_contacto)
SELECT * FROM
(SELECT DISTINCT(ano_ultimo_contacto) FROM etl.tumores_pasto_transformado)
CROSS JOIN
(SELECT DISTINCT(mes_ultimo_contacto),cod_mes_ultimo_contacto,semestre_ultimo_contacto,trimestre_ultimo_contacto
FROM etl.tumores_pasto_transformado)
CROSS JOIN
(SELECT DISTINCT(dia_ultimo_contacto),cod_dia_ultimo_contacto FROM etl.tumores_pasto_transformado)
ORDER BY ano_ultimo_contacto,semestre_ultimo_contacto,trimestre_ultimo_contacto,cod_mes_ultimo_contacto,
cod_dia_ultimo_contacto;
--INSERT 0 11648
--Query returned successfully in 417 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE DIMENSION TIEMPO DE TRATAMIENTO
INSERT INTO dw.dim_tiempo_tratamiento
(ano_tratamiento,mes_tratamiento,cod_mes_tratamiento,semestre_tratamiento,trimestre_tratamiento,dia_tratamiento,
cod_dia_tratamiento)
SELECT * FROM
(SELECT DISTINCT(ano_tratamiento) FROM etl.tumores_pasto_transformado)
CROSS JOIN
(SELECT DISTINCT(mes_tratamiento),cod_mes_tratamiento,semestre_tratamiento,trimestre_tratamiento FROM
etl.tumores_pasto_transformado)
CROSS JOIN
(SELECT DISTINCT(dia_tratamiento),cod_dia_tratamiento FROM etl.tumores_pasto_transformado)
ORDER BY ano_tratamiento,semestre_tratamiento,trimestre_tratamiento,cod_mes_tratamiento,cod_dia_tratamiento;
--INSERT 0 12480
--Query returned successfully in 348 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CARGA DE TABLA DE HECHOS (dw.fact_rpcmp)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO dw.fact_rpcmp (id_tumor,id_edad,id_tiempo_diagnostico,id_tiempo_tratamiento,id_paciente,
id_tiempo_ultimo_contacto,id_tiempo_muerte,id_localizacion,id_morfologia,id_cie10,id_fuente,id_lugar,id_zona,fi,
cantidad_pacientes,cantidad_caso_fuente,cdmv,cscd,mccpm,ccopd,mcopm,esperanza_vida,avmp,oac)
SELECT t2.id_dimtumor,t3.id_dimedad,t4.id_dimtiempo_diagnostico,t5.id_dimtiempo_tratamiento,
t6.id_dimpaciente,t7.id_dimtiempo_ultimo_contacto,t8.id_dimtiempo_muerte,t9.id_dimlocalizacion,
t10.id_dimmorfologia,t11.id_dimcie10,t12.id_dimfuente,t13.id_dimlugar,t14.id_dimzona,
t1.fi,t1.cantidad_pacientes,t1.cantidad_caso_fuente,t1.cdmv,t1.cscd,t1.mccpm,t1.ccopd,t1.mcopm,t1.esperanza_vida,
t1.avmp,t1.oac
FROM (
(SELECT * FROM etl.tumores_pasto_transformado) t1
LEFT JOIN
(SELECT * FROM dw.dim_tumores) t2
ON
(t1.tumor,t1.fecha_diagnostico,t1.comportamiento,t1.lateralidad,t1.grado_diferenciacion,t1.base_diagnostico,
t1.tratamiento,t1.estado_enfermedad) =
(t2.cod_tumor,t2.fecha_incidencia,t2.comportamiento,t2.lateralidad,t2.grado_diferenciacion,t2.base_diagnostico,
t2.tratamiento,t2.estado_enfermedad)
LEFT JOIN
(SELECT * FROM dw.dim_edades) t3
ON
(t1.edad_paciente,t1.descripcion_edad,t1.cod_grupo_etario1,t1.grupo_etario1,t1.cod_grupo_etario2,t1.grupo_etario2,
t1.proy_poblacion_mundial_estandar) =
(t3.edad,t3.descripcion_edad,t3.cod_grupo_etario1,t3.grupo_etario1,t3.cod_grupo_etario2,t3.grupo_etario2,
t3.proy_poblacion_mundial_estandar)
LEFT JOIN
(SELECT * FROM dw.dim_tiempo_diagnostico) t4
ON
(t1.ano_diagnostico::TEXT,t1.semestre_diagnostico,t1.trimestre_diagnostico,t1.mes_diagnostico,t1.dia_diagnostico) =
(t4.ano_diagnostico,t4.semestre_diagnostico,t4.trimestre_diagnostico,t4.mes_diagnostico,t4.dia_diagnostico)
LEFT JOIN
(SELECT * FROM dw.dim_tiempo_tratamiento) t5
USING (ano_tratamiento,semestre_tratamiento,trimestre_tratamiento,mes_tratamiento,dia_tratamiento)
LEFT JOIN
(SELECT * FROM dw.dim_pacientes) t6
ON
(t1.paciente,t1.sexo,t1.estado_vital,t1.mencion_cancer,t1.profesion_expedidor,t1.edad_muerte,t1.cantidad_tumores) =
(t6.cod_paciente,t6.sexo,t6.estado_vital,t6.mencion_cancer,t6.profesion_expedidor,t6.edad_muerte,t6.cantidad_tumores)
LEFT JOIN
(SELECT * FROM dw.dim_tiempo_ultimo_contacto) t7
USING (ano_ultimo_contacto,semestre_ultimo_contacto,trimestre_ultimo_contacto,mes_ultimo_contacto,dia_ultimo_contacto)
LEFT JOIN
(SELECT * FROM dw.dim_tiempo_muerte) t8
USING (ano_muerte,semestre_muerte,trimestre_muerte,mes_muerte,dia_muerte)
LEFT JOIN
(SELECT * FROM dw.dim_localizaciones) t9
ON
(t1.cod_localizacion,t1.localizacion,t1.cod_cieo3,t1.cod_cieo3_grupo,t1.no_cieo3_grupo,t1.cieo3_grupo) =
(t9.cod_localizacion,t9.nombre_localizacion,t9.cod_cieo3,t9.cod_cieo3_grupo,t9.cod_grupo,t9.nombre_grupo)
LEFT JOIN
(SELECT * FROM dw.dim_morfologias) t10
ON
(t1.cod_morfologia,t1.morfologia) = (t10.cod_morfologia,t10.nombre_morfologia)
LEFT JOIN
(SELECT * FROM dw.dim_cie10) t11
ON
(t1.cod_cie10,t1.cie10,t1.cod_cie10_grupo,t1.cie10_grupo,t1.cie10_grupo_general,t1.cie10_grupo_excepto_c44,t1.cod_grupo_cie10,t1.grupo_cie10) =
(t11.cod_cie10,t11.nombre_cie10,t11.cod_cie10_grupo,t11.nombre_cie10_grupo,t11.grupo_general,t11.grupo_excepto_c44,t11.cod_grupo,t11.nombre_grupo)
LEFT JOIN
(SELECT * FROM dw.dim_fuentes) t12
ON
(t1.cod_fuente,t1.fuente) = (t12.cod_fuente,t12.nombre_fuente)
LEFT JOIN
(SELECT * FROM dw.dim_lugares) t13
ON
(t1.cod_departamento,t1.departamento,t1.cod_municipio,t1.municipio) =
(t13.cod_departamento,t13.nombre_departamento,t13.cod_municipio,t13.nombre_municipio)
LEFT JOIN
(SELECT * FROM dw.dim_zonas) t14
ON
(t1.zona,t1.comuna_corregimiento,t1.barrio_vereda) =
(t14.zona,t14.nombre_comuna_corregimiento,t14.nombre_barrio_vereda)
) ORDER BY id_dimtumor;
--INSERT 0 41345
--Query returned successfully in 17 secs 473 msec.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--===================================================================================================================================================================================
