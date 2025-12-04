class UsuarioSistemaDTO {
    constructor(id_usuariosistema, id_infousuario, nom_usuario, clave, fecha_registro, activo) {
      this.id_usuariosistema = id_usuariosistema;
      this.id_infousuario = id_infousuario;
      this.nom_usuario = nom_usuario;
      this.clave = clave;
      this.fecha_registro = fecha_registro;
      this.activo = activo;
    }
  }
  
  module.exports = UsuarioSistemaDTO;