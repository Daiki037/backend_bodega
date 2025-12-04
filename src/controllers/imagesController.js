const fs = require('fs').promises
const path = require('path')

// Ruta base de las imágenes
const IMAGES_PATH = path.join(__dirname, '..', '..', 'public', 'imagenes')

/**
 * Obtiene la lista de imágenes disponibles
 */
const getImagesList = async (req, res) => {
  try {
    // Leer el contenido del directorio de imágenes
    const files = await fs.readdir(IMAGES_PATH)
    
    // Filtrar solo archivos de imagen (png, jpg, jpeg, gif, svg)
    const imageFiles = files.filter(file => 
      /\.(png|jpg|jpeg|gif|svg)$/i.test(file)
    )
    
    // Obtener información adicional de cada archivo
    const filesInfo = await Promise.all(
      imageFiles.map(async (file) => {
        const filePath = path.join(IMAGES_PATH, file)
        const stats = await fs.stat(filePath)
        
        return {
          name: file,
          size: stats.size,
          lastModified: stats.mtime,
          imageUrl: `/api/images/${encodeURIComponent(file)}`
        }
      })
    )
    
    // Ordenar por nombre
    filesInfo.sort((a, b) => a.name.localeCompare(b.name))
    
    res.status(200).json({
      success: true,
      message: 'Lista de imágenes obtenida exitosamente',
      data: {
        totalImages: filesInfo.length,
        images: filesInfo
      }
    })
    
  } catch (error) {
    console.error('Error al obtener lista de imágenes:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor al obtener la lista de imágenes',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    })
  }
}

/**
 * Sirve una imagen específica
 */
const getImage = async (req, res) => {
  try {
    const { filename } = req.params
    
    // Validar que el filename sea seguro (prevenir path traversal)
    if (!filename || filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
      return res.status(400).json({
        success: false,
        message: 'Nombre de archivo inválido'
      })
    }
    
    // Validar que el archivo tenga extensión de imagen
    if (!/\.(png|jpg|jpeg|gif|svg)$/i.test(filename)) {
      return res.status(400).json({
        success: false,
        message: 'Solo se permiten archivos de imagen (png, jpg, jpeg, gif, svg)'
      })
    }
    
    const filePath = path.join(IMAGES_PATH, filename)
    
    // Verificar que el archivo existe
    try {
      await fs.access(filePath)
    } catch {
      return res.status(404).json({
        success: false,
        message: 'Imagen no encontrada'
      })
    }
    
    // Obtener información del archivo
    const stats = await fs.stat(filePath)
    
    // Determinar el tipo MIME basado en la extensión
    const ext = path.extname(filename).toLowerCase()
    let mimeType = 'application/octet-stream'
    
    switch (ext) {
      case '.png':
        mimeType = 'image/png'
        break
      case '.jpg':
      case '.jpeg':
        mimeType = 'image/jpeg'
        break
      case '.gif':
        mimeType = 'image/gif'
        break
      case '.svg':
        mimeType = 'image/svg+xml'
        break
    }
    
    // Configurar headers para mostrar la imagen
    res.setHeader('Content-Type', mimeType)
    res.setHeader('Content-Length', stats.size)
    res.setHeader('Cache-Control', 'public, max-age=3600') // Cache por 1 hora
    
    // Crear stream de lectura y enviarlo como respuesta
    const fileStream = require('fs').createReadStream(filePath)
    
    fileStream.on('error', (error) => {
      console.error('Error al leer imagen:', error)
      if (!res.headersSent) {
        res.status(500).json({
          success: false,
          message: 'Error al leer la imagen'
        })
      }
    })
    
    fileStream.pipe(res)
    
  } catch (error) {
    console.error('Error al servir imagen:', error)
    if (!res.headersSent) {
      res.status(500).json({
        success: false,
        message: 'Error interno del servidor al servir la imagen',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      })
    }
  }
}

module.exports = {
  getImagesList,
  getImage
}