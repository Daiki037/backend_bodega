class InfoUsuarioDTO {
    constructor(id_infousuario, id_rolusuario, tipo_identificacion, numident_usuario, nompersonal_usuario, ape_usuario, direccion_usuario, tele_usuario, email_usuario, habilitar) {
      this.id_infousuario = id_infousuario;
      this.id_rolusuario = id_rolusuario;
      this.tipo_identificacion = tipo_identificacion;
      this.numident_usuario = numident_usuario;
      this.nompersonal_usuario = nompersonal_usuario;
      this.ape_usuario = ape_usuario;
      this.direccion_usuario = direccion_usuario;
      this.tele_usuario = tele_usuario;
      this.email_usuario = email_usuario;
      this.habilitar = habilitar;
    }
  }
  
  module.exports = InfoUsuarioDTO;