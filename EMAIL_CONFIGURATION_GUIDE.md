# Guía para Configurar Email de Recuperación de Contraseña

## Problema Actual
El error `Invalid login: 535-5.7.8 Username and Password not accepted` indica que las credenciales de Gmail no son válidas.

## Solución 1: Configurar Gmail Correctamente

### Paso 1: Activar Autenticación de 2 Factores
1. Ve a https://myaccount.google.com/security
2. En "Iniciar sesión en Google", activa la "Verificación en 2 pasos"

### Paso 2: Generar Contraseña de Aplicación
1. Ve a https://myaccount.google.com/apppasswords
2. Selecciona "Correo" como aplicación
3. Selecciona tu dispositivo
4. Copia la contraseña de 16 caracteres que aparece

### Paso 3: Actualizar .env
```env
EMAIL_USER=tu_email_completo@gmail.com
EMAIL_PASS=abcd efgh ijkl mnop  # (la contraseña de 16 caracteres, sin espacios)
```

## Solución 2: Usar Outlook/Hotmail (Alternativa)

Si Gmail sigue dando problemas, puedes usar Outlook:

```env
EMAIL_USER=tu_email@outlook.com
EMAIL_PASS=tu_contraseña_normal
EMAIL_SERVICE=outlook
```

Y modifica el transporter en forgotPasswordController.js:

```javascript
transporter = nodemailer.createTransport({
  service: 'outlook', // o 'hotmail'
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});
```

## Solución 3: Usar SMTP Personalizado

Para cualquier otro proveedor:

```javascript
transporter = nodemailer.createTransport({
  host: 'smtp.tu-proveedor.com',
  port: 587,
  secure: false,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});
```

## Solución 4: Configuración para Desarrollo (Mailtrap)

Para desarrollo/testing, puedes usar Mailtrap:

1. Regístrate en https://mailtrap.io
2. Crea un inbox
3. Usa las credenciales SMTP:

```env
EMAIL_USER=tu_usuario_mailtrap
EMAIL_PASS=tu_contraseña_mailtrap
EMAIL_HOST=sandbox.smtp.mailtrap.io
EMAIL_PORT=2525
```

```javascript
transporter = nodemailer.createTransport({
  host: process.env.EMAIL_HOST,
  port: process.env.EMAIL_PORT,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});
```

## Verificar Configuración

Después de configurar, reinicia el servidor. Deberías ver en la consola:
- ✅ Servidor de email configurado correctamente

Si ves errores, revisa:
1. Que EMAIL_USER sea el email completo
2. Que EMAIL_PASS sea la contraseña de aplicación (no la normal)
3. Que tengas 2FA activado en Gmail

## Comando para Probar

Una vez configurado, puedes probar con:

```bash
curl -X POST http://localhost:3002/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"email":"email_de_prueba@dominio.com"}'
```

## ¿Qué Hacer Ahora?

1. **Opción 1 (Recomendada)**: Configura Gmail siguiendo los pasos exactos arriba
2. **Opción 2**: Cambia a Outlook/Hotmail que es más permisivo
3. **Opción 3**: Usa Mailtrap para desarrollo y Gmail para producción
