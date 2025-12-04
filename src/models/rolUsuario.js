module.exports = (sequelize, DataTypes) => {
    const RolUsuario = sequelize.define('RolUsuario', {
      id_rolusuario: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },
      nom_rolusuario: {
        type: DataTypes.STRING(30),
        allowNull: false
      }
    }, {
      tableName: 'tab_rolusuario',
      timestamps: false
    });
  
    RolUsuario.associate = function(models) {
      RolUsuario.hasMany(models.InfoUsuario, { foreignKey: 'id_rolusuario' });
    };
  
    return RolUsuario;
  };