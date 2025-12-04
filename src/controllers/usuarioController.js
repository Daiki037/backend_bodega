const usuarioService = require('../services/usuarioService');
const UsuarioSistemaDTO = require('../dtos/usuarioSistema.dto');
const InfoUsuarioDTO = require('../dtos/infoUsuario.dto');
const RolUsuarioDTO = require('../dtos/rolUsuario.dto');

class UsuarioController {

  async getAllUsuarios(req, res, next) {
    try {
      const usuarios = await usuarioService.getAllUsuarios();
      res.status(200).json({ data: usuarios });
    } catch (error) {
      next(error);
    }
  }

  async getUsuarioById(req, res, next) {
    try {
      const usuario = await usuarioService.getUsuarioById(req.params.id);
      if (!usuario) {
        return res.status(404).json({ message: 'Usuario no encontrado' });
      }
      res.status(200).json({ data: usuario });
    } catch (error) {
      next(error);
    }
  }

  
  async deleteUsuario(req, res, next) {
    try {
      await usuarioService.deleteUsuario(req.params.id);
      res.status(200).json({ message: 'Usuario eliminado con éxito' });
    } catch (error) {
      next(error);
    }
  } 


  async createUsuario(req, res, next) {
    try {
      const { usuario, infoUsuario } = req.body;
      const usuarioDTO = new UsuarioSistemaDTO(
        null,
        null,
        usuario.nom_usuario,
        usuario.clave,
        usuario.fecha_registro
      );
      const infoUsuarioDTO = new InfoUsuarioDTO(
        null,
        infoUsuario.id_rolusuario,
        infoUsuario.tipo_identificacion,
        infoUsuario.numident_usuario,
        infoUsuario.nompersonal_usuario,
        infoUsuario.ape_usuario,
        infoUsuario.direccion_usuario,
        infoUsuario.tele_usuario,
        infoUsuario.email_usuario,
        infoUsuario.habilitar
      );

      const createdUsuario = await usuarioService.createUsuario(usuarioDTO, infoUsuarioDTO);
      res.status(201).json({ message: 'Usuario creado con éxito', data: createdUsuario });
    } catch (error) {
      next(error);
    }
  }




  async updateUsuario(req, res, next) {
    try {
      const { usuario, infoUsuario } = req.body;
      const usuarioDTO = new UsuarioSistemaDTO(
        req.params.id,
        null,
        usuario.nom_usuario,
        usuario.clave,
        usuario.fecha_registro
      );
      const infoUsuarioDTO = new InfoUsuarioDTO(
        null,
        infoUsuario.id_rolusuario,
        infoUsuario.tipo_identificacion,
        infoUsuario.numident_usuario,
        infoUsuario.nompersonal_usuario,
        infoUsuario.ape_usuario,
        infoUsuario.direccion_usuario,
        infoUsuario.tele_usuario,
        infoUsuario.email_usuario,
        infoUsuario.habilitar
      );

      const updatedUsuario = await usuarioService.updateUsuario(req.params.id, usuarioDTO, infoUsuarioDTO);
      if (!updatedUsuario) {
        return res.status(404).json({ message: 'Usuario no encontrado' });
      }
      res.status(200).json({ message: 'Usuario actualizado con éxito', data: updatedUsuario });
    } catch (error) {
      next(error);
    }
  }




  async updateUsuarioActivo(req, res, next) {
    try {
      const { id, activo } = req.body;
      await usuarioService.updateUsuarioActivo(id, activo);
      res.status(200).json({ message: 'Usuario actualizado correctamente' });
    } catch (error) {
      console.error('Error al actualizar el usuario:', error);
      next(error);
    }
  }

  
  
}

module.exports = new UsuarioController();