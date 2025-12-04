// models/usuarioSistema.js
module.exports = (sequelize, DataTypes) => {
    const UsuarioSistema = sequelize.define('UsuarioSistema', {
      id_usuariosistema: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },
      id_infousuario: {
        type: DataTypes.INTEGER,
        allowNull: false
      },
      nom_usuario: {
        type: DataTypes.STRING(30),
        allowNull: true
      },
      clave: {
        type: DataTypes.STRING,
        allowNull: true
      },
      fecha_registro: {
        type: DataTypes.DATE,
        allowNull: true
      },
      activo: {
        type: DataTypes.STRING,
        allowNull: true
      },
    }, {
      tableName: 'tab_usuariosistema',
      timestamps: false
    });
  
    UsuarioSistema.associate = function(models) {
      UsuarioSistema.belongsTo(models.InfoUsuario, { foreignKey: 'id_infousuario' });
    };
  
    return UsuarioSistema;
  };