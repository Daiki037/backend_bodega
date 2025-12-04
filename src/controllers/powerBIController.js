const fs = require('fs').promises
const path = require('path')

// Ruta base de los archivos Power BI
const POWERBI_PATH = path.join(__dirname, '..', '..', 'public', 'PowerBI')

/**
 * Obtiene la lista de archivos Power BI disponibles
 */
const getPowerBIFilesList = async (req, res) => {
  try {
    // Leer el contenido del directorio de Power BI
    const files = await fs.readdir(POWERBI_PATH)
    
    // Filtrar solo archivos .pbix
    const pbixFiles = files.filter(file => file.endsWith('.pbix'))
    
    // Obtener información adicional de cada archivo
    const filesInfo = await Promise.all(
      pbixFiles.map(async (file) => {
        const filePath = path.join(POWERBI_PATH, file)
        const stats = await fs.stat(filePath)
        
        return {
          name: file,
          size: stats.size,
          lastModified: stats.mtime,
          downloadUrl: `/api/powerbi-files/${encodeURIComponent(file)}/download`
        }
      })
    )
    
    // Ordenar por nombre
    filesInfo.sort((a, b) => a.name.localeCompare(b.name))
    
    res.status(200).json({
      success: true,
      message: 'Lista de archivos Power BI obtenida exitosamente',
      data: {
        totalFiles: filesInfo.length,
        files: filesInfo
      }
    })
    
  } catch (error) {
    console.error('Error al obtener lista de archivos Power BI:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al obtener la lista de archivos Power BI',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    })
  }
}

/**
 * Descarga un archivo Power BI específico
 */
const downloadPowerBIFile = async (req, res) => {
  try {
    const { filename } = req.params
    
    // Validar que el filename sea seguro (prevenir path traversal)
    if (!filename || filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
      return res.status(400).json({
        success: false,
        message: 'Nombre de archivo inválido'
      })
    }
    
    // Validar que el archivo tenga extensión .pbix
    if (!filename.endsWith('.pbix')) {
      return res.status(400).json({
        success: false,
        message: 'Solo se permiten archivos con extensión .pbix'
      })
    }
    
    const filePath = path.join(POWERBI_PATH, filename)
    
    // Verificar que el archivo existe
    try {
      await fs.access(filePath)
    } catch {
      return res.status(404).json({
        success: false,
        message: 'Archivo Power BI no encontrado'
      })
    }
    
    // Obtener información del archivo
    const stats = await fs.stat(filePath)
    
    // Configurar headers para descarga
    res.setHeader('Content-Type', 'application/octet-stream')
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`)
    res.setHeader('Content-Length', stats.size)
    
    // Crear stream de lectura y enviarlo como respuesta
    const fileStream = require('fs').createReadStream(filePath)
    
    fileStream.on('error', (error) => {
      console.error('Error al leer archivo Power BI:', error)
      if (!res.headersSent) {
        res.status(500).json({
          success: false,
          message: 'Error al leer el archivo'
        })
      }
    })
    
    fileStream.pipe(res)
    
  } catch (error) {
    console.error('Error al descargar archivo Power BI:', error)
    if (!res.headersSent) {
      res.status(500).json({
        success: false,
        message: 'Error interno del servidor al descargar el archivo',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      })
    }
  }
}

module.exports = {
  getPowerBIFilesList,
  downloadPowerBIFile
}