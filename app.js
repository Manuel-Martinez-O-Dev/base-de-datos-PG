
const express = require('express');
const { Pool } = require('pg');
const bodyParser = require('body-parser');

const app = express();
const port = 5000;

app.use(bodyParser.json());

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'app_data',
    password: 'melody2025sql',
    port: 5432,
  });

app.get('/', (req, res) => {
  res.sendFile('./index.html', {
    root: __dirname
  })
});

app.post('/guardar-idioma', async (req, res) => {
  const { idioma } = req.body;
  try {
      const result = await pool.query('INSERT INTO idiomas (idioma) VALUES ($1) RETURNING *', [idioma]);
      res.status(201).json(result.rows[0]);
  } catch (error) {
      console.error('Error saving idioma:', error);
      res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/register', async (req, res) => {
  const { nombre, apellido, nombre_usuario, correo_electronico } = req.body;
  const fecha_registro = new Date();

  try {
      const result = await pool.query(
          'INSERT INTO cliente (nombre, apellido, nombre_usuario, correo_electronico, activo, fecha_registro) VALUES ($1, $2, $3, $4, true, $5) RETURNING *',
          [nombre, apellido, nombre_usuario, correo_electronico, fecha_registro]
      );
      res.status(201).json(result.rows[0]);
  } catch (error) {
      console.error('Error registering user:', error);
      res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/login', async (req, res) => {
  const { nombre_usuario, correo_electronico } = req.body;

  try {
      const result = await pool.query(
          'SELECT * FROM cliente WHERE nombre_usuario = $1 AND correo_electronico = $2',
          [nombre_usuario, correo_electronico]
      );

      if (result.rows.length > 0) {
          res.status(200).json({ success: true });
      } else {
          res.status(401).json({ success: false, message: 'Invalid credentials' });
      }
  } catch (error) {
      console.error('Error logging in:', error);
      res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
    console.log(`Servidor escuchando en http://localhost:${port}`);
});

// index.html obtener datos desde el input

