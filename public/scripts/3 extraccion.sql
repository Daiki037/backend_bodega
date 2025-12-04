--===================================================================================================================================================================================
--BODEGA DE DATOS SISTEMA YACHAY - RPCMP
--REGISTRO POBLACIONAL DE CANCER DEL MUNICIPIO DE PASTO
--===================================================================================================================================================================================
--EXTRACCIÓN DE DATOS PARA CONSTRUCCIÓN DEL DATA WAREHOUSE
--A PARTIR DE LA BASE DE DATOS DEL SISTEMA YACHAY DEL PROYECTO 82288 (Solo casos del Municipio de Pasto)
--===================================================================================================================================================================================

SELECT tab_fichas.id_paciente AS paciente,
	   tab_pacientes.cod_sexo AS cod_sexo,
	   tab_sexo.nom_sexo AS sexo,
	   tab_pacientes.fenaci_paciente AS fecha_nacimiento,
	   tab_fichas.edad_paciente AS edad_paciente,
	   tab_pacientes.cod_estadovital AS cod_estado_vital,
	   tab_estadovital.nom_estadovital AS estado_vital,
	   tab_fichas.id_ficha AS tumor,
	   tab_fichas.fe_diagnostico AS fecha_diagnostico,
	   tab_fichas.cod_metododiagnostico AS cod_base_diagnostico,
	   tab_metododiagnostico.nom_metododiagnostico AS base_diagnostico,
	   tab_fichas.cod_localizacion AS cod_localizacion,
	   tab_localizacion.nom_localizacion AS localizacion,
	   SUBSTRING(tab_localizacion.nom_localizacion FROM 1 FOR POSITION(' ' IN tab_localizacion.nom_localizacion) - 1) AS cod_cieo3,
	   SUBSTRING(tab_localizacion.nom_localizacion FROM 1 FOR POSITION('.' IN tab_localizacion.nom_localizacion) - 1)::CHAR(4) AS cod_cieo3_grupo,
	   REGEXP_REPLACE(SUBSTRING(tab_localizacion.nom_localizacion FROM 1 FOR POSITION('.' IN tab_localizacion.nom_localizacion) - 1),'[^\d]','','g')::CHAR(4) AS no_cieo3_grupo,
	   tab_localizacion_grupo.nom_localizacion AS cieo3_grupo,
	   tab_fichas.cod_morfologia AS cod_morfologia,
	   tab_morfologias.nom_morfologias AS morfologia,
	   tab_fichas.cod_cie10 AS cod_cie10,
	   tab_cie10.nom_cie10 AS cie10,
	   etl.tab_aux_grupocie10.cod_cie10 AS cod_cie10_grupo,
	   etl.tab_aux_grupocie10.nom_cie10_es AS cie10_grupo,
	   etl.tab_aux_grupocie10.nom_todos_sitios AS cie10_grupo_general,
	   etl.tab_aux_grupocie10.nom_excepto_C44 AS cie10_grupo_excepto_c44,
	   etl.tab_aux_grupocie10.cod_grupo_cie10 AS cod_grupo_cie10,
	   etl.tab_aux_grupocie10.nom_grupo_cie10_es AS grupo_cie10,
	   tab_fichas.cod_lateralidad AS cod_lateralidad,
	   tab_lateralidad.nom_lateralidad AS lateralidad,
	   tab_fichas.cod_comportamiento AS cod_comportamiento,
	   tab_comportamiento.nom_comportamiento AS comportamiento,
	   tab_fichas.cod_gradodiferenciacion AS cod_grado_diferenciacion,
	   tab_gradodiferenciacion.nom_gradodiferenciacion AS grado_diferenciacion,
	   tab_certidefuncion.cod_mencioncancer AS cod_mencion_cancer,
	   tab_mencioncancerdefuncion.nom_mencioncancerdefuncion AS mencion_cancer,
	   tab_certidefuncion.cod_profesionexpedidor AS cod_profesion_expedidor,
	   tab_profesionexpedidor.nom_profesionexpedidor AS profesion_expedidor,
	   tab_pacientes.fecha_ultimocontacto AS fecha_ultimo_contacto,
	   subtab_historias.cod_fuentes AS cod_fuente,
	   tab_fuentes.nom_fuentes AS fuente,
	   subtab_tratamientosficha.cod_tratamientos AS cod_tratamiento,
	   tab_tratamientos.nom_tratamientos AS tratamiento,
	   subtab_tratamientosficha.cod_estadoenfermedad AS cod_estado_enfermedad,
	   tab_estadoenfermedad.nom_estadoenfermedad AS estado_enfermedad,
	   subtab_tratamientosficha.fe_tratamiento AS fecha_tratamiento,
	   subtab_tratamientosficha.orden_tratamiento AS orden_tratamiento,
	   tab_municipios.cod_departamentos AS cod_departamento,
	   tab_departamentos.nom_departamentos AS departamento,
	   tab_municipios.cod_municipios AS cod_municipio,
	   tab_municipios.nom_municipios AS municipio,
	   tab_barrios.cod_zona AS cod_zona,
	   tab_zona.nom_zona AS zona,
	   subtab_direcciontumor.barriocomuna AS cod_barrio_comuna,
	   tab_barrios.nom_barrios AS barrio_comuna,
	   tab_barrios.cod_comunas AS cod_comuna_corregimiento,
	   tab_barrios.cod_barriovereda AS cod_barrio_vereda
INTO etl.tumores_pasto
FROM tab_fichas
INNER JOIN tab_pacientes ON tab_fichas.id_paciente = tab_pacientes.id_paciente
LEFT JOIN tab_sexo USING (cod_sexo)
LEFT JOIN tab_estadovital USING (cod_estadovital)
LEFT JOIN tab_metododiagnostico USING (cod_metododiagnostico)
LEFT JOIN tab_localizacion USING (cod_localizacion)
LEFT JOIN tab_localizacion tab_localizacion_grupo ON
(REGEXP_REPLACE(SUBSTRING(tab_localizacion.nom_localizacion FROM 1 FOR POSITION('.' IN tab_localizacion.nom_localizacion) - 1),'[^\d]','','g')::CHAR(4)) = tab_localizacion_grupo.cod_localizacion
LEFT JOIN tab_morfologias ON tab_fichas.cod_morfologia = tab_morfologias.cod_morfologias
LEFT JOIN tab_cie10 USING (cod_cie10)
LEFT JOIN etl.tab_aux_grupocie10 ON
SUBSTRING(tab_fichas.cod_cie10 FROM 1 FOR 3) = etl.tab_aux_grupocie10.cod_cie10
LEFT JOIN tab_lateralidad USING (cod_lateralidad)
LEFT JOIN tab_comportamiento USING (cod_comportamiento)
LEFT JOIN tab_gradodiferenciacion USING (cod_gradodiferenciacion)
LEFT JOIN tab_certidefuncion ON tab_fichas.id_paciente = tab_certidefuncion.id_paciente
LEFT JOIN tab_mencioncancerdefuncion ON tab_certidefuncion.cod_mencioncancer = tab_mencioncancerdefuncion.cod_mencioncancerdefuncion
LEFT JOIN tab_profesionexpedidor USING (cod_profesionexpedidor)
LEFT JOIN
(SELECT DISTINCT id_ficha,cod_fuentes FROM tab_historias ORDER BY id_ficha) subtab_historias
USING (id_ficha)
LEFT JOIN tab_fuentes USING (cod_fuentes)
LEFT JOIN
(SELECT DISTINCT ON (id_ficha) *
FROM tab_tratamientosficha
ORDER BY id_ficha, orden_tratamiento ASC) subtab_tratamientosficha
USING (id_ficha)
LEFT JOIN tab_tratamientos USING (cod_tratamientos)
LEFT JOIN tab_estadoenfermedad USING (cod_estadoenfermedad)
LEFT JOIN
(SELECT * FROM tab_direcciontumor
WHERE id_ficha BETWEEN 1 AND
(SELECT MAX(id_ficha) FROM tab_fichas) AND orden_registro='1') subtab_direcciontumor
USING (id_ficha)
LEFT JOIN tab_barrios ON subtab_direcciontumor.barriocomuna = tab_barrios.cod_barrios
LEFT JOIN tab_municipios USING (cod_municipios)
LEFT JOIN tab_departamentos USING (cod_departamentos)
LEFT JOIN tab_zona USING (cod_zona)
WHERE tab_fichas.id_ficha BETWEEN 1 AND (SELECT MAX(id_ficha) FROM tab_fichas)
AND (tab_municipios.cod_departamentos = '52' AND tab_barrios.cod_municipios = '52001')
OR subtab_direcciontumor.barriocomuna = '999999'
ORDER BY tumor,paciente; --41345