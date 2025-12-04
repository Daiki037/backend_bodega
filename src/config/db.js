const { Sequelize } = require('sequelize');
require('dotenv').config();

// Crear la instancia de Sequelize usando las variables de entorno
const sequelize = new Sequelize(
  process.env.DB_NAME,   // Nombre de la base de datos
  process.env.DB_USER,   // Usuario de la base de datos
  process.env.DB_PASSWORD, // Contraseña de la base de datos
  {
    host: process.env.DB_HOST,   // Host de la base de datos
    port: process.env.DB_PORT,   // Puerto de la base de datos
    dialect: 'postgres',  
    logging: false       //// Desactiva los logs de las consultas SQL
  }
);

// Probar la conexión
sequelize.authenticate()
  .then(() => {
    console.log('Conexión Bd establecida');
  })
  .catch(err => {
    console.error('No se logró establecer conexión a la Bd', err);
  });

module.exports = sequelize;
