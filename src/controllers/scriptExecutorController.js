const fs = require('fs').promises
const path = require('path')
const sequelize = require('../config/db')

// Ruta base de los scripts SQL
const SCRIPTS_PATH = path.join(__dirname, '..', '..', 'public', 'scripts')

/**
 * Ejecuta un script SQL específico en la base de datos
 */
const executeScript = async (req, res) => {
  try {
    const { filename } = req.params
    
    // Validar que el filename sea seguro (prevenir path traversal)
    if (!filename || filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
      return res.status(400).json({
        success: false,
        message: 'Nombre de archivo inválido'
      })
    }
    
    // Validar que el archivo tenga extensión .sql
    if (!filename.endsWith('.sql')) {
      return res.status(400).json({
        success: false,
        message: 'Solo se permiten archivos con extensión .sql'
      })
    }
    
    const filePath = path.join(SCRIPTS_PATH, filename)
    
    // Verificar que el archivo existe
    try {
      await fs.access(filePath)
    } catch {
      return res.status(404).json({
        success: false,
        message: 'Script SQL no encontrado'
      })
    }
    
    // Leer el contenido del archivo SQL
    const sqlContent = await fs.readFile(filePath, 'utf-8')
    
    if (!sqlContent.trim()) {
      return res.status(400).json({
        success: false,
        message: 'El archivo SQL está vacío'
      })
    }
    
    console.log(`Ejecutando script: ${filename}`)
    const startTime = Date.now()
    
    let result
    let affectedRows = 0
    
    try {
      // Ejecutar el script SQL usando QueryTypes.RAW para obtener más información
      const [results, metadata] = await sequelize.query(sqlContent, {
        raw: true
      })
      
      const executionTime = Date.now() - startTime
      
      // Determinar el número de filas afectadas según el tipo de operación
      if (metadata && typeof metadata.rowCount !== 'undefined') {
        affectedRows = metadata.rowCount
      } else if (Array.isArray(results)) {
        affectedRows = results.length
      }
      
      res.status(200).json({
        success: true,
        message: `Script ${filename} ejecutado exitosamente`,
        data: {
          filename: filename,
          executionTime: `${executionTime}ms`,
          affectedRows: affectedRows,
          hasResults: Array.isArray(results) && results.length > 0,
          resultsCount: Array.isArray(results) ? results.length : 0,
          // Solo incluir resultados si son pocos para evitar respuestas muy grandes
          results: Array.isArray(results) && results.length <= 100 ? results : null,
          resultsTruncated: Array.isArray(results) && results.length > 100
        }
      })
      
    } catch (sqlError) {
      console.error(`Error ejecutando script ${filename}:`, sqlError)
      
      res.status(500).json({
        success: false,
        message: `Error al ejecutar el script ${filename}`,
        error: {
          type: 'SQL_EXECUTION_ERROR',
          details: sqlError.message,
          position: sqlError.position || null,
          hint: sqlError.hint || null,
          code: sqlError.code || null
        }
      })
    }
    
  } catch (error) {
    console.error('Error general al ejecutar script:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al ejecutar el script',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    })
  }
}

/**
 * Ejecuta todos los scripts SQL en orden secuencial
 */
const executeAllScripts = async (req, res) => {
  try {
    // Leer todos los archivos SQL del directorio
    const files = await fs.readdir(SCRIPTS_PATH)
    const sqlFiles = files.filter(file => file.endsWith('.sql')).sort()
    
    if (sqlFiles.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'No se encontraron scripts SQL para ejecutar'
      })
    }
    
    const executionResults = []
    const startTime = Date.now()
    
    console.log('Iniciando ejecución de todos los scripts...')
    
    // Ejecutar scripts uno por uno en orden
    for (const filename of sqlFiles) {
      try {
        const filePath = path.join(SCRIPTS_PATH, filename)
        const sqlContent = await fs.readFile(filePath, 'utf-8')
        
        if (!sqlContent.trim()) {
          executionResults.push({
            filename: filename,
            success: false,
            message: 'Archivo vacío',
            executionTime: '0ms'
          })
          continue
        }
        
        const scriptStartTime = Date.now()
        
        const [results, metadata] = await sequelize.query(sqlContent, {
          raw: true
        })
        
        const executionTime = Date.now() - scriptStartTime
        
        executionResults.push({
          filename: filename,
          success: true,
          message: 'Ejecutado exitosamente',
          executionTime: `${executionTime}ms`,
          affectedRows: metadata?.rowCount || (Array.isArray(results) ? results.length : 0)
        })
        
        console.log(`✓ Script ${filename} ejecutado exitosamente`)
        
      } catch (scriptError) {
        console.error(`✗ Error ejecutando script ${filename}:`, scriptError)
        
        executionResults.push({
          filename: filename,
          success: false,
          message: `Error: ${scriptError.message}`,
          executionTime: '0ms',
          error: {
            code: scriptError.code || null,
            hint: scriptError.hint || null
          }
        })
        
        // Opcional: detener la ejecución si hay un error
        // break;
      }
    }
    
    const totalExecutionTime = Date.now() - startTime
    const successCount = executionResults.filter(r => r.success).length
    const errorCount = executionResults.filter(r => !r.success).length
    
    res.status(200).json({
      success: errorCount === 0,
      message: `Ejecución de scripts completada. ${successCount} exitosos, ${errorCount} con errores`,
      data: {
        totalScripts: sqlFiles.length,
        successfulScripts: successCount,
        failedScripts: errorCount,
        totalExecutionTime: `${totalExecutionTime}ms`,
        results: executionResults
      }
    })
    
  } catch (error) {
    console.error('Error general al ejecutar todos los scripts:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al ejecutar los scripts',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    })
  }
}

module.exports = {
  executeScript,
  executeAllScripts
}