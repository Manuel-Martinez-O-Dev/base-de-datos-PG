const { Pool } = require('pg')

const pool = new Pool({
  user: 'postgres',
  password: 'melody2025sql',
  database: 'app_data',
  port: '5432',
  host: 'localhost'
});

// funcion para agregar un nuevo cliente a la base de datos

const nuevoCliente = async function ( nombre, apellido, nombre_usuario, correo_electronico, activo, fecha_registro ) {
  
  const query = {
    text: 'INSERT INTO cliente(nombre, apellido, nombre_usuario, correo_electronico, activo, fecha_registro) VALUES ($1, $2, $3, $4, $5, $6)',
    values: [nombre, apellido, nombre_usuario, correo_electronico, activo, fecha_registro]
  }

  try {
    const res = await pool.query( query );
    console.log('NUEVO CLIENTE AGREGADO:', res);
  }
  catch ( err ) {
    console.log('ERROR AL INSERTAR CLIENTE:', err);
  }

}

// funcion para actualizar el nombre del cliente

const editarNombreCliente = async function ( nuevoNombre, id_cliente ) {
  const query = {
    text: 'UPDATE cliente SET nombre=$1 WHERE id_cliente=$2',
    values: [ nuevoNombre, id_cliente ]
  }
  
  try {
    const res = await pool.query( query );
    console.log('DATO ACTUALIZADO:', res)
  }
  catch ( err ) {
    console.log( err );
  }
}

module.exports = {
  nuevoCliente,
  editarNombreCliente
}




// const coneccion = async function () {

//   try {
//     const connection = await pool.connect();
//     console.log( 'BIENVENIDO A POSTGRES:', connection.database );
//   }
//   catch ( err ) {
//     console.log( 'ERROR EN LA CONECCION:', err );
//   }

// }

// nuevoCliente(['alex','mertinez','che','che@gmail.com',true,'1/1/1999'])





// pool.connect()
//   .then(res => console.log('CONECTADO A POSTGRES:', res.database, res.port))
//   .catch(err => console.log('ERROR AL CONETAR A POSTGRES: ', err.hostname));

// async function insert(valor) {

//   const query = ({
//     text: 'INSERT INTO clasificacion(clasificacion) VALUES($1)',
//     values: [valor]
//   });

//   try {
//     const res = await pool.query(query);
//     console.log('SE INSERTO UN DATO CORRECTAMENTE: ', res.command);
//   }
//   catch (err) {
//     console.log('ERROR AL INSERTAR:', err.severity, err.detail);
//   }

// }