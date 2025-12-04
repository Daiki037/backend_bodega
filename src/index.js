const express = require('express');
const fileUpload = require('express-fileupload');
const cors = require('cors');
const dotenv = require('dotenv'); // Para usar variables de entorno
const routes = require('./api/endPoints');
const sequelize = require('./config/db'); // Si estás usando Sequelize para la DB

dotenv.config(); // Cargar variables de entorno desde un archivo .env

const app = express();
const port = process.env.PORT;

// Configuración de límites aumentados (50MB como ejemplo)
const payloadSizeLimit = '50mb';

// Middlewares
app.use(express.json({ limit: payloadSizeLimit }));
app.use(express.urlencoded({ extended: true }));
app.use(fileUpload());
app.use(cors({
    origin: ['http://localhost:3000'], // Puedes agregar más dominios aquí si necesitas
    methods: ['GET', 'POST', 'DELETE', 'PUT'],
}));

// Rutas
app.use('/', routes);

// Middleware para manejo de errores globales
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send({
        status: 'error',
        message: 'Algo salió mal!',
        error: err.message
    });
});

// Sincronización de la base de datos y levantamiento del servidor
sequelize.sync()
    .then(() => {
        app.listen(port, () => {
            console.log(`Aplicación correindo en http://localhost:${port}`);
        });
    })
    .catch((error) => {
        console.error('No se pudo conectar a la base de datos:', error);
    });
