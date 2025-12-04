const pool = require('../config/db');
const nodemailer = require('nodemailer');
const jwt = require('jsonwebtoken');

// Usar claves más seguras y consistentes
const SECRET_KEY = process.env.JWT_SECRET || 'udenar_backend_secret_key_2024';
const EMAIL_SECRET = process.env.EMAIL_SECRET || 'udenar_email_reset_secret_key_2024';

// Función para crear el transporter basado en la configuración
const createEmailTransporter = () => {
  const emailService = process.env.EMAIL_SERVICE || 'gmail';
  
  const configs = {
    gmail: {
      host: 'smtp.gmail.com',
      port: 465,
      secure: true,
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    },
    outlook: {
      service: 'outlook',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    },
    hotmail: {
      service: 'hotmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    },
    mailtrap: {
      host: process.env.EMAIL_HOST || 'sandbox.smtp.mailtrap.io',
      port: process.env.EMAIL_PORT || 2525,
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    },
    custom: {
      host: process.env.EMAIL_HOST,
      port: process.env.EMAIL_PORT || 587,
      secure: process.env.EMAIL_SECURE === 'true',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    }
  };

  return nodemailer.createTransport(configs[emailService] || configs.gmail);
};

// Configuración del transportador de email con manejo de errores mejorado
let transporter;

try {
  if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS) {
    console.warn('⚠️  ADVERTENCIA: EMAIL_USER o EMAIL_PASS no están configuradas en .env');
    console.log('\n📧 GUÍA RÁPIDA DE CONFIGURACIÓN:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('Para Gmail:');
    console.log('1. Activa 2FA: https://myaccount.google.com/security');
    console.log('2. Genera contraseña de app: https://myaccount.google.com/apppasswords');
    console.log('3. En .env: EMAIL_USER=tu@gmail.com y EMAIL_PASS=contraseña16caracteres');
    console.log('\nPara Outlook (más fácil):');
    console.log('1. En .env: EMAIL_SERVICE=outlook');
    console.log('2. EMAIL_USER=tu@outlook.com y EMAIL_PASS=tu_contraseña_normal');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  } else {
    transporter = createEmailTransporter();
    
    // Verificar la configuración del transporter
    transporter.verify((error, success) => {
      if (error) {
        console.error('❌ Error en configuración de email:', error.message);
        console.log('\n💡 SOLUCIONES:');
        console.log('1. Para Gmail: Usa contraseña de aplicación (16 caracteres)');
        console.log('2. Para Outlook: Agrega EMAIL_SERVICE=outlook al .env');
        console.log('3. Verifica que EMAIL_USER sea el email completo');
        console.log('4. Para desarrollo: Usa Mailtrap (EMAIL_SERVICE=mailtrap)');
      } else {
        const service = process.env.EMAIL_SERVICE || 'gmail';
        console.log(`✅ Servidor de email (${service}) configurado correctamente`);
      }
    });
  }
} catch (error) {
  console.error('❌ Error al configurar el transportador de email:', error);
}

// Función para enviar email de recuperación
const forgotPassword = async (req, res) => {
  const { email } = req.body;

  try {
    // Verificar que el transporter esté configurado
    if (!transporter) {
      return res.status(500).json({
        success: false,
        message: 'Servicio de email no configurado. Contacta al administrador.'
      });
    }

    // Verificar que las credenciales estén configuradas
    if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS) {
      return res.status(500).json({
        success: false,
        message: 'Credenciales de email no configuradas. Contacta al administrador.'
      });
    }

    // Buscar el usuario por email en la tabla tab_infousuarios
    const userResult = await pool.query(
      `SELECT iu.*, us.nom_usuario, us.id_usuariosistema 
       FROM tab_infousuarios iu 
       INNER JOIN tab_usuariosistema us ON iu.id_infousuario = us.id_infousuario 
       WHERE iu.email_usuario = :email AND us.activo = 'S'`,
      {
        replacements: { email: email },
        type: pool.QueryTypes.SELECT
      }
    );

    if (userResult.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'No se encontró un usuario con este email o el usuario está inactivo.'
      });
    }

    const user = userResult[0];

    // Crear token de recuperación con expiración de 1 hora
    const resetToken = jwt.sign(
      {
        userId: user.id_usuariosistema,
        email: user.email_usuario,
        purpose: 'password_reset',
        timestamp: Date.now() // Agregar timestamp para debugging
      },
      EMAIL_SECRET,
      { expiresIn: '1h' }
    );

    console.log('🔐 Token generado para usuario:', user.email_usuario);
    console.log('🔐 User ID:', user.id_usuariosistema);

    // URL de reset
    const resetURL = `${process.env.FRONTEND_URL || 'http://localhost:3000'}/reset-password?token=${resetToken}`;

    // Configurar el email
    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: email,
      subject: 'Recuperación de Contraseña - UDENAR Backend',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">Recuperación de Contraseña</h2>
          <p>Hola <strong>${user.nompersonal_usuario} ${user.ape_usuario}</strong>,</p>
          <p>Hemos recibido una solicitud para restablecer la contraseña de tu cuenta.</p>
          <p>Para restablecer tu contraseña, haz clic en el siguiente enlace:</p>
          <div style="text-align: center; margin: 30px 0;">
            <a href="${resetURL}" 
               style="background-color: #007bff; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
              Restablecer Contraseña
            </a>
          </div>
          <p><strong>Este enlace expirará en 1 hora.</strong></p>
          <p>Si no solicitaste este cambio, puedes ignorar este email de forma segura.</p>
          <hr style="margin: 30px 0; border: none; border-top: 1px solid #eee;">
          <p style="color: #666; font-size: 12px;">
            Este es un email automático, por favor no respondas a este mensaje.
          </p>
        </div>
      `
    };

    // Enviar el email
    await transporter.sendMail(mailOptions);

    console.log(`📧 Email de recuperación enviado a: ${email}`);

    res.status(200).json({
      success: true,
      message: 'Se ha enviado un enlace de recuperación a tu correo electrónico.'
    });

  } catch (error) {
    console.error('Error en forgot password:', error);
    
    // Manejo específico de errores de autenticación
    if (error.code === 'EAUTH') {
      console.log('\n🔧 SOLUCIÓN RÁPIDA:');
      console.log('1. Para Gmail: Usa EMAIL_SERVICE=gmail y contraseña de aplicación');
      console.log('2. Para Outlook: Cambia a EMAIL_SERVICE=outlook');
      console.log('3. Para desarrollo: Usa EMAIL_SERVICE=mailtrap\n');
      
      return res.status(500).json({
        success: false,
        message: 'Error de autenticación del email. Verifica las credenciales en el servidor.'
      });
    }
    
    if (error.code === 'ECONNECTION') {
      return res.status(500).json({
        success: false,
        message: 'Error de conexión al servidor de email. Intenta más tarde.'
      });
    }
    
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor. Intenta de nuevo más tarde.'
    });
  }
};

// Función para verificar token y permitir reset de contraseña
const resetPassword = async (req, res) => {
  const { token, newPassword } = req.body;

  try {
    // Verificar el token
    const decoded = jwt.verify(token, EMAIL_SECRET);
    
    if (decoded.purpose !== 'password_reset') {
      return res.status(400).json({
        success: false,
        message: 'Token inválido.'
      });
    }

    // Actualizar la contraseña en la base de datos
    const updateResult = await pool.query(
      'UPDATE tab_usuariosistema SET clave = :newPassword WHERE id_usuariosistema = :userId',
      {
        replacements: { 
          newPassword: newPassword,
          userId: decoded.userId 
        },
        type: pool.QueryTypes.UPDATE
      }
    );

    console.log(`🔐 Contraseña actualizada para usuario ID: ${decoded.userId}`);

    res.status(200).json({
      success: true,
      message: 'Contraseña actualizada exitosamente.'
    });

  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(400).json({
        success: false,
        message: 'Token inválido.'
      });
    }
    
    if (error.name === 'TokenExpiredError') {
      return res.status(400).json({
        success: false,
        message: 'El enlace de recuperación ha expirado. Solicita uno nuevo.'
      });
    }

    console.error('Error en reset password:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor.'
    });
  }
};

// Función para verificar si un token es válido
const verifyResetToken = async (req, res) => {
  const { token } = req.params;

  try {
    const decoded = jwt.verify(token, EMAIL_SECRET);
    
    if (decoded.purpose !== 'password_reset') {
      return res.status(400).json({
        success: false,
        message: 'Token inválido.'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Token válido.',
      email: decoded.email
    });

  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(400).json({
        success: false,
        message: 'Token inválido.'
      });
    }
    
    if (error.name === 'TokenExpiredError') {
      return res.status(400).json({
        success: false,
        message: 'El enlace de recuperación ha expirado.'
      });
    }

    res.status(500).json({
      success: false,
      message: 'Error interno del servidor.'
    });
  }
};

module.exports = {
  forgotPassword,
  resetPassword,
  verifyResetToken
};
