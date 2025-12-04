// services/usuarioService.js
const { UsuarioSistema, InfoUsuario, RolUsuario } = require('../models/index');
const UsuarioSistemaDTO = require('../dtos/usuarioSistema.dto');

class UsuarioService {
 
  async getAllUsuarios() {
    const usuarios = await UsuarioSistema.findAll({include: [{model: InfoUsuario,include: [RolUsuario]}]});
    return usuarios.map(usuario => ({
      id_usuariosistema: usuario.id_usuariosistema,
      nom_usuario: usuario.nom_usuario,
      clave: usuario.clave,
      fecha_registro: usuario.fecha_registro,
      id_infousuario: usuario.InfoUsuario.id_infousuario,
      tipo_identificacion: usuario.InfoUsuario.tipo_identificacion,
      numident_usuario: usuario.InfoUsuario.numident_usuario,
      nompersonal_usuario: usuario.InfoUsuario.nompersonal_usuario,
      ape_usuario: usuario.InfoUsuario.ape_usuario,
      direccion_usuario: usuario.InfoUsuario.direccion_usuario,
      tele_usuario: usuario.InfoUsuario.tele_usuario,
      email_usuario: usuario.InfoUsuario.email_usuario,
      habilitar: usuario.InfoUsuario.habilitar,
      id_rolusuario: usuario.InfoUsuario.RolUsuario.id_rolusuario,
      nom_rolusuario: usuario.InfoUsuario.RolUsuario.nom_rolusuario,
      activo: usuario.activo
    }));
  }

  async getUsuarioById(id) {
    const usuario = await UsuarioSistema.findByPk(id, {include: [{model: InfoUsuario,include: [RolUsuario]}]});
    if (!usuario) throw new Error('Usuario not found');
    return {
      id_usuariosistema: usuario.id_usuariosistema,
      nom_usuario: usuario.nom_usuario,
      clave: usuario.clave,
      fecha_registro: usuario.fecha_registro,
      id_infousuario: usuario.InfoUsuario.id_infousuario,
      tipo_identificacion: usuario.InfoUsuario.tipo_identificacion,
      numident_usuario: usuario.InfoUsuario.numident_usuario,
      nompersonal_usuario: usuario.InfoUsuario.nompersonal_usuario,
      ape_usuario: usuario.InfoUsuario.ape_usuario,
      direccion_usuario: usuario.InfoUsuario.direccion_usuario,
      tele_usuario: usuario.InfoUsuario.tele_usuario,
      email_usuario: usuario.InfoUsuario.email_usuario,
      habilitar: usuario.InfoUsuario.habilitar,
      id_rolusuario: usuario.InfoUsuario.RolUsuario.id_rolusuario,
      nom_rolusuario: usuario.InfoUsuario.RolUsuario.nom_rolusuario,
      activo: usuario.activo
    };
  }


  async deleteUsuario(id) {
    const usuario = await UsuarioSistema.findByPk(id);
    if (!usuario) throw new Error('Usuario not found');

    // Eliminar el registro en tab_usuariosistema
    await usuario.destroy();

    // Eliminar el registro en tab_infousuarios
    await InfoUsuario.destroy({ where: { id_infousuario: usuario.id_infousuario } });
  }
 
  async createUsuario(usuarioDTO, infoUsuarioDTO) {
    // Crear el registro en tab_infousuarios
    const infoUsuario = await InfoUsuario.create({
      id_rolusuario: infoUsuarioDTO.id_rolusuario,
      tipo_identificacion: infoUsuarioDTO.tipo_identificacion,
      numident_usuario: infoUsuarioDTO.numident_usuario,
      nompersonal_usuario: infoUsuarioDTO.nompersonal_usuario,
      ape_usuario: infoUsuarioDTO.ape_usuario,
      direccion_usuario: infoUsuarioDTO.direccion_usuario,
      tele_usuario: infoUsuarioDTO.tele_usuario,
      email_usuario: infoUsuarioDTO.email_usuario,
      habilitar: infoUsuarioDTO.habilitar
    });
  
    // Crear el registro en tab_usuariosistema
    const usuario = await UsuarioSistema.create({
      id_infousuario: infoUsuario.id_infousuario,
      nom_usuario: usuarioDTO.nom_usuario,
      clave: usuarioDTO.clave,
      fecha_registro: usuarioDTO.fecha_registro
    });
  
    return new UsuarioSistemaDTO(
      usuario.id_usuariosistema,
      usuario.id_infousuario,
      usuario.nom_usuario,
      usuario.clave,
      usuario.fecha_registro
    );
  }






  async updateUsuario(id, usuarioDTO, infoUsuarioDTO) {
    const usuario = await UsuarioSistema.findByPk(id, {
      include: [InfoUsuario]
    });
    if (!usuario) throw new Error('Usuario not found');

    // Actualizar los datos en tab_infousuarios
    const infoUsuario = await InfoUsuario.findByPk(usuario.id_infousuario);
    if (!infoUsuario) throw new Error('InfoUsuario not found');

    infoUsuario.tipo_identificacion = infoUsuarioDTO.tipo_identificacion;
    infoUsuario.numident_usuario = infoUsuarioDTO.numident_usuario;
    infoUsuario.nompersonal_usuario = infoUsuarioDTO.nompersonal_usuario;
    infoUsuario.ape_usuario = infoUsuarioDTO.ape_usuario;
    infoUsuario.direccion_usuario = infoUsuarioDTO.direccion_usuario;
    infoUsuario.tele_usuario = infoUsuarioDTO.tele_usuario;
    infoUsuario.email_usuario = infoUsuarioDTO.email_usuario;
    infoUsuario.habilitar = infoUsuarioDTO.habilitar;
    infoUsuario.id_rolusuario = infoUsuarioDTO.id_rolusuario;

    await infoUsuario.save();

    // Actualizar los datos en tab_usuariosistema
    usuario.nom_usuario = usuarioDTO.nom_usuario;
    usuario.clave = usuarioDTO.clave;
    usuario.fecha_registro = usuarioDTO.fecha_registro;

    await usuario.save();

    return new UsuarioSistemaDTO(
      usuario.id_usuariosistema,
      usuario.id_infousuario,
      usuario.nom_usuario,
      usuario.clave,
      usuario.fecha_registro
    );
  }




  async updateUsuarioActivo(id, activo) {
    const usuario = await UsuarioSistema.findByPk(id);
    if (!usuario) throw new Error('Usuario not found');
  
    // Actualizar el campo activo en tab_usuariosistema
    usuario.activo = activo;
    await usuario.save();
  }




}

module.exports = new UsuarioService();