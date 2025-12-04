@echo off
setlocal enabledelayedexpansion

set FECHA=%1
set NOTEBOOK_ENTRADA="C:\Users\Udenar\Desktop\udenar desarrollo\YACHAY_LABORATORIOS\OrquestadorLabs.ipynb"
set NOTEBOOK_SALIDA="C:\Users\Udenar\Desktop\udenar desarrollo\YACHAY_LABORATORIOS\OrquestadorLabs_salida.ipynb"

echo [INFO] Iniciando ejecucion del notebook...
echo [INFO] Fecha: %FECHA%
echo [INFO] Notebook entrada: %NOTEBOOK_ENTRADA%
echo [INFO] Notebook salida: %NOTEBOOK_SALIDA%

REM Verificar si el archivo de entrada existe
if not exist %NOTEBOOK_ENTRADA% (
    echo [ERROR] El archivo de entrada no existe: %NOTEBOOK_ENTRADA%
    exit /b 1
)

REM Ejecutar papermill con timeout y kernel específico
echo [INFO] Ejecutando papermill...
papermill %NOTEBOOK_ENTRADA% %NOTEBOOK_SALIDA% ^
    -k python3 ^
    --execution-timeout 300 ^
    --start-timeout 60 ^
    -p fecha %FECHA%

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Papermill falló con código de error: %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)

echo [SUCCESS] Notebook ejecutado correctamente
echo [INFO] Archivo de salida: %NOTEBOOK_SALIDA%