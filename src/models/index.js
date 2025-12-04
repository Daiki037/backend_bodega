// models/index.js
const Sequelize = require('sequelize');
const sequelize = require('../config/db');

const models = {
  RolUsuario: require('./rolUsuario')(sequelize, Sequelize.DataTypes),
  InfoUsuario: require('./infoUsuario')(sequelize, Sequelize.DataTypes),
  UsuarioSistema: require('./usuarioSistema')(sequelize, Sequelize.DataTypes)
};

Object.keys(models).forEach(modelName => {
  if (models[modelName].associate) {
    models[modelName].associate(models);
  }
});

models.sequelize = sequelize;
models.Sequelize = Sequelize;

module.exports = models;