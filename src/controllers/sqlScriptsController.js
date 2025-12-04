const fs = require('fs').promises
const path = require('path')

// Ruta base de los scripts SQL
const SCRIPTS_PATH = path.join(__dirname, '..', '..', 'public', 'scripts')

/**
 * Obtiene la lista de archivos SQL disponibles
 */
const getScriptsList = async (req, res) => {
  try {
    // Leer el contenido del directorio de scripts
    const files = await fs.readdir(SCRIPTS_PATH)
    
    // Filtrar solo archivos .sql
    const sqlFiles = files.filter(file => file.endsWith('.sql'))
    
    // Obtener información adicional de cada archivo
    const filesInfo = await Promise.all(
      sqlFiles.map(async (file) => {
        const filePath = path.join(SCRIPTS_PATH, file)
        const stats = await fs.stat(filePath)
        const content = await fs.readFile(filePath, 'utf-8')
        
        return {
          name: file,
          lastModified: stats.mtime,
          descripcion: content
        }
      })
    )
    
    // Ordenar por nombre
    filesInfo.sort((a, b) => a.name.localeCompare(b.name))
    
    res.status(200).json({
      success: true,
      message: 'Lista de scripts SQL obtenida exitosamente',
      data: {
        totalFiles: filesInfo.length,
        files: filesInfo
      }
    })
    
  } catch (error) {
    console.error('Error al obtener lista de scripts SQL:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al obtener la lista de scripts',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    })
  }
}

/**
 * Obtiene el contenido de un archivo SQL específico
 */
const getScriptContent = async (req, res) => {
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
        message: 'Archivo SQL no encontrado'
      })
    }
    
    // Leer el contenido del archivo
    const content = await fs.readFile(filePath, 'utf-8')
    const stats = await fs.stat(filePath)
    
    res.status(200).json({
      success: true,
      message: 'Contenido del script SQL obtenido exitosamente',
      data: {
        filename: filename,
        content: content,
        lastModified: stats.mtime
      }
    })
    
  } catch (error) {
    console.error('Error al leer script SQL:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al leer el script',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    })
  }
}

module.exports = {
  getScriptsList,
  getScriptContent
}