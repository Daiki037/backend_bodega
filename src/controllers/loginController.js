const pool = require('../config/db')
const jwt = require('jsonwebtoken')

const SECRET_KEY = 'your_secret_key' // Reemplaza esto con una clave secreta segura

module.exports.login = async (req, res) => {
  const { username, password } = req.body

  try {
    const result = await pool.query(
      'SELECT t.nom_usuario, p.id_rolusuario FROM usuarios.tab_usuariosistema t inner join usuarios.tab_infousuarios p ON t.id_infousuario= p.id_infousuario WHERE t.nom_usuario = :username AND t.clave = :password and activo= \'S\'',
      {
        replacements: { username: username, password: password },
        type: pool.QueryTypes.SELECT
      }
    )
    if (result.length > 0) {
      const token = jwt.sign(
        {
          username: result[0].nom_usuario,
          id_rolusuario: result[0].id_rolusuario,
          id_usuariosistema: result[0].id_usuariosistema
        },
        SECRET_KEY,
        {
          expiresIn: '2m'
        }
      )
      res.send({ token, id_rolusuario: result[0].id_rolusuario, id_usuariosistema: result[0].id_usuariosistema })
    } else {
      res.send({ message: 'Invalid credentials' })
    }
  } catch (error) {
    console.error('Database query error:', error)
    res.send(error)
  }
}
