# Configuración de Recuperación de Contraseña

## Funcionalidad Implementada

Se ha implementado la funcionalidad de "Olvidé mi contraseña" que incluye:

1. **Envío de email de recuperación** (`/forgot-password`)
2. **Verificación de token** (`/verify-reset-token/:token`)
3. **Restablecimiento de contraseña** (`/reset-password`)

## Endpoints Creados

### 1. POST `/forgot-password`
Envía un email de recuperación al usuario.

**Request Body:**
```json
{
  "email": "usuario@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Se ha enviado un enlace de recuperación a tu correo electrónico."
}
```

### 2. GET `/verify-reset-token/:token`
Verifica si un token de reset es válido.

**Response:**
```json
{
  "success": true,
  "message": "Token válido.",
  "email": "usuario@example.com"
}
```

### 3. POST `/reset-password`
Restablece la contraseña del usuario.

**Request Body:**
```json
{
  "token": "jwt_token_here",
  "newPassword": "nueva_contraseña"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Contraseña actualizada exitosamente."
}
```

## Configuración Necesaria

### 1. Variables de Entorno
Debes configurar las siguientes variables en tu archivo `.env`:

```env
# Configuración para emails de recuperación de contraseña
EMAIL_USER=tu_email@gmail.com
EMAIL_PASS=tu_contraseña_de_aplicacion
FRONTEND_URL=http://localhost:3000
```

### 2. Configuración de Gmail
Para usar Gmail como proveedor de email:

1. Ve a tu cuenta de Google
2. Activa la autenticación de 2 factores
3. Genera una "Contraseña de aplicación" específica
4. Usa esa contraseña en `EMAIL_PASS`

### 3. Otros Proveedores de Email
Si usas otro proveedor, modifica la configuración en `forgotPasswordController.js`:

```javascript
const transporter = nodemailer.createTransport({
  host: 'smtp.tu-proveedor.com',
  port: 587,
  secure: false,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});
```

## Flujo de Trabajo

1. El usuario ingresa su email en el frontend
2. El frontend envía POST a `/forgot-password`
3. El backend busca el usuario por email en `tab_infousuarios`
4. Si existe, genera un JWT token con expiración de 1 hora
5. Envía un email con el link de recuperación
6. El usuario hace clic en el link del email
7. El frontend verifica el token con `/verify-reset-token/:token`
8. Si es válido, muestra el formulario de nueva contraseña
9. El frontend envía la nueva contraseña a `/reset-password`
10. El backend actualiza la contraseña en `tab_usuariosistema`

## Seguridad

- Los tokens expiran en 1 hora
- Se verifica que el usuario esté activo (`activo = 'S'`)
- Se usa un secret key diferente para los tokens de reset
- El email incluye el nombre completo del usuario para verificación

## Frontend - Componente para Reset de Contraseña

Necesitarás crear un componente para manejar el reset de contraseña:

```javascript
// ResetPassword.js
import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';

const ResetPassword = () => {
  const [searchParams] = useSearchParams();
  const [token, setToken] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isValidToken, setIsValidToken] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const tokenFromUrl = searchParams.get('token');
    if (tokenFromUrl) {
      setToken(tokenFromUrl);
      verifyToken(tokenFromUrl);
    }
  }, [searchParams]);

  const verifyToken = async (token) => {
    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL}/verify-reset-token/${token}`);
      const data = await response.json();
      
      if (data.success) {
        setIsValidToken(true);
      } else {
        setIsValidToken(false);
      }
    } catch (error) {
      setIsValidToken(false);
    } finally {
      setLoading(false);
    }
  };

  const handleResetPassword = async (e) => {
    e.preventDefault();
    
    if (newPassword !== confirmPassword) {
      alert('Las contraseñas no coinciden');
      return;
    }

    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL}/reset-password`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ token, newPassword }),
      });

      const data = await response.json();

      if (data.success) {
        alert('Contraseña actualizada exitosamente');
        // Redirigir al login
      } else {
        alert(data.message);
      }
    } catch (error) {
      alert('Error al actualizar la contraseña');
    }
  };

  if (loading) return <div>Verificando token...</div>;
  if (!isValidToken) return <div>Token inválido o expirado</div>;

  return (
    <form onSubmit={handleResetPassword}>
      <input
        type="password"
        placeholder="Nueva contraseña"
        value={newPassword}
        onChange={(e) => setNewPassword(e.target.value)}
        required
      />
      <input
        type="password"
        placeholder="Confirmar contraseña"
        value={confirmPassword}
        onChange={(e) => setConfirmPassword(e.target.value)}
        required
      />
      <button type="submit">Actualizar Contraseña</button>
    </form>
  );
};

export default ResetPassword;
```

## Nota Importante

**¡IMPORTANTE!** Debes:
1. Configurar las credenciales de email en el archivo `.env`
2. Crear el componente frontend para manejar el reset
3. Agregar la ruta `/reset-password` en tu router del frontend
4. Actualizar `FRONTEND_URL` con tu dominio en producción
