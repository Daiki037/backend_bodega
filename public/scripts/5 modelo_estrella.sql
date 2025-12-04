--===================================================================================================================================================================================
--BODEGA DE DATOS SISTEMA YACHAY - RPCMP
--REGISTRO POBLACIONAL DE CANCER DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================
--MAYO DE 2025
--MODELO MULTIDIMENSIONAL DE LOS TUMORES-FUENTE DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================

--===================================================================================================================================================================================
--DEFINICION DEL MODELO EN ESTRELLA
--===================================================================================================================================================================================

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION TUMORES
CREATE TABLE dw.dim_tumores(
id_dimtumor SERIAL NOT NULL PRIMARY KEY,
cod_tumor INT,
fecha_incidencia TEXT,
comportamiento TEXT,
lateralidad TEXT,
grado_diferenciacion TEXT,
base_diagnostico TEXT,
tratamiento TEXT,
estado_enfermedad TEXT);
--CREATE TABLE
--Query returned successfully in 118 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION EDAD
CREATE TABLE dw.dim_edades(
id_dimedad SERIAL NOT NULL PRIMARY KEY,
edad SMALLINT,
descripcion_edad TEXT,
cod_grupo_etario1 SMALLINT,
grupo_etario1 TEXT,
cod_grupo_etario2 SMALLINT,
grupo_etario2 TEXT,
proy_poblacion_mundial_estandar INT);
--CREATE TABLE
--Query returned successfully in 140 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION PACIENTES
CREATE TABLE dw.dim_pacientes(
id_dimpaciente SERIAL NOT NULL PRIMARY KEY,
cod_paciente INT,
sexo TEXT,
estado_vital TEXT,
mencion_cancer TEXT,
profesion_expedidor TEXT,
edad_muerte SMALLINT,
cantidad_tumores SMALLINT);
--CREATE TABLE
--Query returned successfully in 140 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION LOCALIZACIONES
CREATE TABLE dw.dim_localizaciones(
id_dimlocalizacion SERIAL NOT NULL PRIMARY KEY,
cod_localizacion TEXT,
nombre_localizacion TEXT,
cod_cieo3 TEXT,
cod_cieo3_grupo TEXT,
cod_grupo TEXT,
nombre_grupo TEXT);
--CREATE TABLE
--Query returned successfully in 153 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION MORFOLOGIAS
CREATE TABLE dw.dim_morfologias(
id_dimmorfologia SERIAL NOT NULL PRIMARY KEY,
cod_morfologia TEXT,
nombre_morfologia TEXT);
--CREATE TABLE
--Query returned successfully in 124 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION CIE10
CREATE TABLE dw.dim_cie10(
id_dimcie10 SERIAL NOT NULL PRIMARY KEY,
cod_cie10 TEXT,
nombre_cie10 TEXT,
cod_cie10_grupo TEXT,
nombre_cie10_grupo TEXT,
grupo_general TEXT,
grupo_excepto_c44 TEXT,
cod_grupo TEXT,
nombre_grupo TEXT);
--CREATE TABLE
--Query returned successfully in 125 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION FUENTES
CREATE TABLE dw.dim_fuentes(
id_dimfuente SERIAL NOT NULL PRIMARY KEY,
cod_fuente TEXT,
nombre_fuente TEXT);
--CREATE TABLE
--Query returned successfully in 96 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION LUGARES
CREATE TABLE dw.dim_lugares(
id_dimlugar SERIAL NOT NULL PRIMARY KEY,
cod_departamento TEXT,
nombre_departamento TEXT,
cod_municipio TEXT,
nombre_municipio TEXT);
--CREATE TABLE
--Query returned successfully in 148 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION ZONAS
CREATE TABLE dw.dim_zonas(
id_dimzona SERIAL NOT NULL PRIMARY KEY,
zona TEXT,
nombre_comuna_corregimiento TEXT,
nombre_barrio_vereda TEXT);
--CREATE TABLE
--Query returned successfully in 117 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION TIEMPO DE DIAGNOSTICO
CREATE TABLE dw.dim_tiempo_diagnostico(
id_dimtiempo_diagnostico SERIAL NOT NULL PRIMARY KEY,
ano_diagnostico TEXT,
semestre_diagnostico TEXT,
trimestre_diagnostico TEXT,
cod_mes_diagnostico SMALLINT,
mes_diagnostico TEXT,
cod_dia_diagnostico SMALLINT,
dia_diagnostico TEXT);
--CREATE TABLE
--Query returned successfully in 186 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION TIEMPO DE MUERTE
CREATE TABLE dw.dim_tiempo_muerte(
id_dimtiempo_muerte SERIAL NOT NULL PRIMARY KEY,
ano_muerte TEXT,
semestre_muerte TEXT,
trimestre_muerte TEXT,
cod_mes_muerte SMALLINT,
mes_muerte TEXT,
cod_dia_muerte SMALLINT,
dia_muerte TEXT);
--CREATE TABLE
--Query returned successfully in 125 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION TIEMPO DE ULTIMO CONTACTO
CREATE TABLE dw.dim_tiempo_ultimo_contacto(
id_dimtiempo_ultimo_contacto SERIAL NOT NULL PRIMARY KEY,
ano_ultimo_contacto TEXT,
semestre_ultimo_contacto TEXT,
trimestre_ultimo_contacto TEXT,
cod_mes_ultimo_contacto SMALLINT,
mes_ultimo_contacto TEXT,
cod_dia_ultimo_contacto SMALLINT,
dia_ultimo_contacto TEXT);
--CREATE TABLE
--Query returned successfully in 192 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DIMENSION TIEMPO DE TRATAMIENTO
CREATE TABLE dw.dim_tiempo_tratamiento(
id_dimtiempo_tratamiento SERIAL NOT NULL PRIMARY KEY,
ano_tratamiento TEXT,
semestre_tratamiento TEXT,
trimestre_tratamiento TEXT,
cod_mes_tratamiento SMALLINT,
mes_tratamiento TEXT,
cod_dia_tratamiento SMALLINT,
dia_tratamiento TEXT);
--CREATE TABLE
--Query returned successfully in 143 msec.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TABLA DE HECHOS (dw.fact_rpcmp)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE dw.fact_rpcmp(
id_tumor INTEGER NOT NULL REFERENCES dw.dim_tumores(id_dimtumor),
id_edad INTEGER NOT NULL REFERENCES dw.dim_edades(id_dimedad),
id_tiempo_diagnostico INTEGER NOT NULL REFERENCES dw.dim_tiempo_diagnostico(id_dimtiempo_diagnostico),
id_tiempo_tratamiento INTEGER NOT NULL REFERENCES dw.dim_tiempo_tratamiento(id_dimtiempo_tratamiento),
id_paciente INTEGER NOT NULL REFERENCES dw.dim_pacientes(id_dimpaciente),
id_tiempo_ultimo_contacto INTEGER NOT NULL REFERENCES dw.dim_tiempo_ultimo_contacto(id_dimtiempo_ultimo_contacto),
id_tiempo_muerte INTEGER NOT NULL REFERENCES dw.dim_tiempo_muerte(id_dimtiempo_muerte),
id_localizacion INTEGER NOT NULL REFERENCES dw.dim_localizaciones(id_dimlocalizacion),
id_morfologia INTEGER NOT NULL REFERENCES dw.dim_morfologias(id_dimmorfologia),
id_cie10 INTEGER NOT NULL REFERENCES dw.dim_cie10(id_dimcie10),
id_fuente INTEGER NOT NULL REFERENCES dw.dim_fuentes(id_dimfuente),
id_lugar INTEGER NOT NULL REFERENCES dw.dim_lugares(id_dimlugar),
id_zona INTEGER NOT NULL REFERENCES dw.dim_zonas(id_dimzona),
fi INTEGER,
cantidad_pacientes INTEGER,
cantidad_caso_fuente INTEGER,
cdmv INTEGER,
cscd INTEGER,
mccpm INTEGER,
ccopd INTEGER,
mcopm INTEGER,
esperanza_vida NUMERIC(4,1),
avmp NUMERIC(4,1),
oac INTEGER,
PRIMARY KEY (id_tumor,id_edad,id_tiempo_diagnostico,id_tiempo_tratamiento,id_paciente,
id_tiempo_ultimo_contacto,id_tiempo_muerte,id_localizacion,id_morfologia,id_cie10,id_fuente,id_lugar,id_zona));
--CREATE TABLE
--Query returned successfully in 125 msec.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--===================================================================================================================================================================================
