-- =============================================================
-- LIMPIEZA GENERAL DE TABLAS INTERMEDIAS Y DW
-- Proceso completo RPCMP - Sistema Yachay
-- =============================================================

-- 1. Tablas intermedias del proceso ETL
TRUNCATE TABLE etl.tumores_pasto CASCADE;
TRUNCATE TABLE etl.tumores_pasto_limpio CASCADE;

-- 2. Tabla de hechos (primero porque tiene FKs a las dimensiones)
TRUNCATE TABLE dw.fact_rpcmp CASCADE;

-- 3. Dimensiones
TRUNCATE TABLE dw.dim_tumores CASCADE;
TRUNCATE TABLE dw.dim_edades CASCADE;
TRUNCATE TABLE dw.dim_pacientes CASCADE;
TRUNCATE TABLE dw.dim_localizaciones CASCADE;
TRUNCATE TABLE dw.dim_morfologias CASCADE;
TRUNCATE TABLE dw.dim_cie10 CASCADE;
TRUNCATE TABLE dw.dim_fuentes CASCADE;
TRUNCATE TABLE dw.dim_lugares CASCADE;
TRUNCATE TABLE dw.dim_zonas CASCADE;
TRUNCATE TABLE dw.dim_tiempo_diagnostico CASCADE;
TRUNCATE TABLE dw.dim_tiempo_muerte CASCADE;
TRUNCATE TABLE dw.dim_tiempo_ultimo_contacto CASCADE;
TRUNCATE TABLE dw.dim_tiempo_tratamiento CASCADE;
