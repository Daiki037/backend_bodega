module.exports = (sequelize, DataTypes) => {
    const InfoUsuario = sequelize.define('InfoUsuario', {
      id_infousuario: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },
      id_rolusuario: {
        type: DataTypes.INTEGER,
        allowNull: false
      },
      tipo_identificacion: {
        type: DataTypes.SMALLINT,
        allowNull: true
      },
      numident_usuario: {
        type: DataTypes.DECIMAL(14, 0),
        allowNull: false
      },
      nompersonal_usuario: {
        type: DataTypes.STRING(50),
        allowNull: false
      },
      ape_usuario: {
        type: DataTypes.STRING(50),
        allowNull: false
      },
      direccion_usuario: {
        type: DataTypes.STRING,
        allowNull: false
      },
      tele_usuario: {
        type: DataTypes.STRING(15),
        allowNull: false
      },
      email_usuario: {
        type: DataTypes.STRING(50),
        allowNull: false
      },
      habilitar: {
        type: DataTypes.SMALLINT,
        allowNull: true
      }
    }, {
      tableName: 'tab_infousuarios',
      timestamps: false
    });
  
    InfoUsuario.associate = function(models) {
      InfoUsuario.belongsTo(models.RolUsuario, { foreignKey: 'id_rolusuario' });
      InfoUsuario.hasMany(models.UsuarioSistema, { foreignKey: 'id_infousuario' });
    };
  
    return InfoUsuario;
  };