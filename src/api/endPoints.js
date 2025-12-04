const express = require('express')
const router = express.Router()

const sqlScriptsController = require('../controllers/sqlScriptsController')
const powerBIController = require('../controllers/powerBIController')
const imagesController = require('../controllers/imagesController')
const scriptExecutorController = require('../controllers/scriptExecutorController')


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
