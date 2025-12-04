const express = require('express')
const router = express.Router()

// Controladores disponibles
const { login } = require('../controllers/loginController')
const {
  forgotPassword,
  resetPassword,
  verifyResetToken,
} = require('../controllers/forgotPasswordController')
const usuarioController = require('../controllers/usuarioController')
const sqlScriptsController = require('../controllers/sqlScriptsController')
const powerBIController = require('../controllers/powerBIController')
const imagesController = require('../controllers/imagesController')
const scriptExecutorController = require('../controllers/scriptExecutorController')

// Rutas de autenticación
router.post('/login', login)

// Rutas para recuperación de contraseña
router.post('/forgot-password', forgotPassword) // Enviar email de recuperación
router.post('/reset-password', resetPassword) // Restablecer contraseña
router.get('/verify-reset-token/:token', verifyResetToken) // Verificar token de reset

// Rutas para el controlador de usuarios
router.get('/usuarios', usuarioController.getAllUsuarios)
router.get('/usuarios/:id', usuarioController.getUsuarioById)
router.delete('/usuarios/:id', usuarioController.deleteUsuario)
router.post('/usuarios', usuarioController.createUsuario)
router.put('/usuarios/:id', usuarioController.updateUsuario)
router.put('/usuarios/:id/activar', usuarioController.updateUsuarioActivo)

// Rutas para scripts SQL
router.get('/sql-scripts', sqlScriptsController.getScriptsList)
router.get('/sql-scripts/:filename', sqlScriptsController.getScriptContent)

// Rutas para archivos Power BI
router.get('/powerbi-files', powerBIController.getPowerBIFilesList)
router.get('/powerbi-files/:filename/download', powerBIController.downloadPowerBIFile)

// Rutas para imágenes
router.get('/images', imagesController.getImagesList)
router.get('/images/:filename', imagesController.getImage)

// Rutas para ejecutar scripts SQL
router.post('/execute-script/:filename', scriptExecutorController.executeScript)
router.post('/execute-all-scripts', scriptExecutorController.executeAllScripts)




module.exports = router
