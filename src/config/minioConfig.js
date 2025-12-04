// filepath: f:\udenar - desarrollo\udenar_backend\src\config\minioConfig.js
const Minio = require('minio')
require('dotenv').config()

console.log('MINIO_ENDPOINT:', process.env.MINIO_ENDPOINT);
console.log('MINIO_PORT:', process.env.MINIO_PORT);
console.log('MINIO_USE_SSL:', process.env.MINIO_USE_SSL);
console.log('MINIO_ACCESS_KEY:', process.env.MINIO_ACCESS_KEY);
console.log('MINIO_SECRET_KEY:', process.env.MINIO_SECRET_KEY);

// Configuración del cliente de MinIO
const minioClient = new Minio.Client({
  endPoint: process.env.MINIO_ENDPOINT || '127.0.0.1', // Cambia esto por tu endpoint de MinIO
  port: parseInt(process.env.MINIO_PORT, 10) || 9000, // Cambia esto por tu puerto de MinIO
  useSSL: process.env.MINIO_USE_SSL === 'true', // Cambia esto según tu configuración de MinIO
  accessKey: process.env.MINIO_ACCESS_KEY || 'minioadmin', // Reemplaza con tu Access Key
  secretKey: process.env.MINIO_SECRET_KEY || 'minioadmin' // Reemplaza con tu Secret Key
})

module.exports = minioClient
