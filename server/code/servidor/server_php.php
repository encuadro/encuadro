<?php

require_once("lib/nusoap.php");

include("usuario.php");
include("sala.php");
include("obra.php");
include("zona.php");
include("descriptor.php");

$ns = "http://10.0.2.109/server_php/";

$server = new soap_server();
$server->configureWSDL('comision', $ns);
$server->wsdl->schemaTargetNamespace = $ns;

//////usuario
$server->register('login', array('user' => 'xsd:string', 'pass' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('AltaUsuario', array('nombre' => 'xsd:string', 'apellido' => 'xsd:string', 'cedula' => 'xsd:string', 'email' => 'xsd:string', 'tipoUs' => 'xsd:int', 'nick' => 'xsd:string', 'pass' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('modificarUsuario', array('nombre' => 'xsd:string', 'apellido' => 'xsd:string', 'cedula' => 'xsd:string', 'email' => 'xsd:string', 'tipoUs' => 'xsd:int', 'nick' => 'xsd:string', 'pass' => 'xsd:string', 'idUsuario' => 'xsd:int'), array('return' =>
    'xsd:int'), $ns);

$server->register('borrarUsuario', array('idUsuario' => 'xsd:int'), array('return' =>
    'xsd:int'), $ns);

$server->register('passwd', array('nick' => 'xsd:string', 'pass' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('getUsuarios', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('getUsuariosAdmin', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('getUsuariosEmpleado', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('getDataUsuario', array('nick' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('tipoUsuario', array('nick' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

////////////////////////////////////////////////////////////////////////////////////// SALAS 

$server->register('getAllDataSalas', array(), array('return' => 'xsd:string'), $ns);


$server->register('AltaSala', array('nombre_sala' => 'xsd:string', 'descripcion_sala' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('agregarContenidoSala', array('id_sala' => 'xsd:int', 'tipo' => 'xsd:string', 'nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('borrarSala', array('id_sala' => 'xsd:int'), array('return' =>
    'xsd:int'), $ns);

$server->register('modificarSala', array('id_sala' => 'xsd:int', 'nombre_sala' => 'xsd:string', 'descripcion_sala' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('getSalas', array(), array('return' => 'xsd:string'), $ns);

$server->register('getNombreSalas', array(), array('return' => 'xsd:string'), $ns);

$server->register('getDataSalaId', array('id_sala' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('getDataSalaId2', array('id_sala' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('getDataSalaNombre', array('nombre' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

//------------------------------------------------NUEVO!!!!!!!

$server->register('getDataSalaNombreImagen', array('nombre' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
$server->register('getDataSalaIdImagen', array('id' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

//----------------------------------------------------------

$server->register('getContenidoSala', array('id' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);



$server->register('setQr', array('id_sala' => 'xsd:int', 'qr' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('existeSala', array('id' => 'xsd:int'), array('return' =>
    'xsd:int'), $ns);


/* OBRAS =================================================================================================== OBRAS */

$server->register('AltaObra', array('nombre_sala' => 'xsd:string', 'descripcion_sala' => 'xsd:string', 'imagen' => 'xsd:string', 'id_sala' => 'xsd:string', 'autor_obra' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('modificarObra', array('id_obra' => 'xsd:int', 'nombre_obra' => 'xsd:string', 'descripcion_obra' => 'xsd:string', 'id_sala' => 'xsd:int', 'autor_obra' => 'xsd:string'), array('return' => 'xsd:int'), $ns);

$server->register('borrarObra', array('id_obra' => 'xsd:int'), array('return' =>
    'xsd:int'), $ns);

$server->register('agregarContenidoObra', array('id_obra' => 'xsd:int', 'tipo' => 'xsd:string', 'nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('modificarContenidoObra', array('id_obra' => 'xsd:int', 'tipo' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('getContenidoObra', array('nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('getObraSala', array('id' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

$server->register('getDataObra', array('nombre_obra' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('getAllDataObraSala', array('id' => 'xsd:int'), array('return' => 'xsd:string'), $ns);


$server->register('getNombreObraApartirDelID', array('id_obra' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);
$server->register('getObrasl', array(), array('return' => 'xsd:string'), $ns);

/* ZONA ===================================================================================================== ZONA */

$server->register('AltaZona', array('largo' => 'xsd:int', 'ancho' => 'xsd:int', 'x' => 'xsd:int', 'y' => 'xsd:int', 'nombre_obra' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('modificarZona', array('id_zona' => 'xsd:int', 'largo' => 'xsd:int', 'ancho' => 'xsd:int', 'x' => 'xsd:int', 'y' => 'xsd:int'), array('return' => 'xsd:int'), $ns);

$server->register('borrarZona', array('id_zona' => 'xsd:int'), array('return' =>
    'xsd:int'), $ns);

$server->register('agregarContenidoZona', array('id_zona' => 'xsd:int', 'tipo' => 'xsd:string', 'nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('getContenidoZona', array('id_zona' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

$server->register('getZonaObra', array('nombre_obra' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

/* DESCRIPTORES ========================================================================================	DESCRIPTORES */

$server->register('getNombreObra', array('id_sala' => 'xsd:int', 'nombre_archivo' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);

$server->register('generarDescriptor', array('id_sala' => 'xsd:int', 'id_obra' => 'xsd:int', 'nombre_archivo' => 'xsd:string'), array('return' =>
    'xsd:int'), $ns);



//////////////////////////////////////////////////////////////////////////////////////////////


function getNombreObraApartirDelID($id_obra) {
    conectar();
    $u = "";
    $query = mysql_query("SELECT * FROM obra WHERE id_obra='$id_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {//no exite
        $u = $row['nombre_obra'];
    }
    return new soapval('return', 'xsd:string', $u);
}

function getNombreObra($id_sala, $nombre_archivo) {
    $u = fungetNombreObra($id_sala, $nombre_archivo);

    return new soapval('return', 'xsd:int', $u);
}

function generarDescriptor($id_sala, $id_obra, $nombre_archivo) {
   	$u =  fungenerarDescriptor ($id_sala,$id_obra,$nombre_archivo);
        return new soapval('return', 'xsd:int', $u);
   
}
////////////////funciones comunes

/**
 * Establece la conección con la base de datos
 */
function conectar() {
    $dbhost = 'localhost';
    $dbusername = 'root';
    $dbuserpass = '';
    $dbname = 'proyecto';
    mysql_connect($dbhost, $dbusername, $dbuserpass);
    mysql_select_db($dbname) or die('Cannot select database');
}

function rrmdir2($dir) {
    $handle = opendir($dir);
    while ($file = readdir($handle)) {
        if (is_file($dir . $file)) {
            unlink($dir . $file);
        }
    }
}

function rrmdir($dir) {
    if (is_dir($dir)) {
        $objects = scandir($dir);
        foreach ($objects as $object) {
            if ($object != "." && $object != "..") {
                if (filetype($dir . "/" . $object) == "dir")
                    rrmdir($dir . "/" . $object); else
                    unlink($dir . "/" . $object);
            }
        }
        reset($objects);
        rmdir($dir);
    }
}

//////////////////usuario
/**
 * Retorna el tipo de Usuario a partir de un nick determinado
 * @param  string $nick
 * @return int (  -1 error o no se encontro el usuario  , 1  Administrador , 2 Empleado)
 */
function tipoUsuario($nick) {
    conectar();
    $u = funtipoUsuario($nick);
    return new soapval('return', 'xsd:int', $u);
}

/**
 * Verifica la existencia en el sistema de un usuario con el nick y password pasados por parametros
 * @param  string $user,string $pass
 * @return int ( idUsuario encontrado, -1 error o no se encontro el usuario)
 */
function login($user, $pass) {
    conectar();
	$u = new Usuario;
    $log = $u->funlogin($user, $pass);
    return new soapval('return', 'xsd:int', $log);
}

/**
 * Ingresa un nuevo Usuario (solo si no existe otro usuario con el nick pasado por parametro) y genera un idAutonumerico
 * @param  string $nombre,string $apellido,string $cedula,string $email
 * @param  int $tipoUs, string  $nick, string $pass
 * @return int ( 0 ok, -1 error)
 */
function AltaUsuario($nombre, $apellido, $cedula, $email, $tipoUs, $nick, $pass) {
    conectar();
    $reg = funAltaUsuario($nombre, $apellido, $cedula, $email, $tipoUs, $nick, $pass);
    return new soapval('return', 'xsd:int', $reg);
}

/**
 * Modifica los datos de un usuario de un id Determinado 
 * @param  string $nombre,string $apellido,string $cedula,string $email
 * @param  int $tipoUs, string  $nick, string $pass, int $idUsuario
 * @return int ( 0 ok, -1 error)
 */
function modificarUsuario($nombre, $apellido, $cedula, $email, $tipoUs, $nick, $pass, $idUsuario) {
    conectar();
    $mod = funmodificarUsuario($nombre, $apellido, $cedula, $email, $tipoUs, $nick, $pass, $idUsuario);
    return new soapval('return', 'xsd:int', $mod);
}

/**
 * Elimina un usuario con un id determinado del sistema 
 * @param  string $idUsuario
 * @return int ( 0 ok, -1 error)
 */
function borrarUsuario($idUsuario) {
    conectar();
    $bor = funborrarUsuario($idUsuario);
    return new soapval('return', 'xsd:int', $bor);
}

/**
 * Retorna el nick de todos los usuarios  del sistema separados  por "=>"
 * @return string
 */
function getUsuarios() {
    conectar();
    $u = fungetUsuarios();
    return new soapval('return', 'xsd:string', $u);
}

/**
 * Retorna el nick de todos los usuarios  que son administradores del sistema separados  por "=>"
 * @return string
 */
function getUsuariosAdmin() {
    conectar();
    $u = fungetUsuariosAdmin();
    return new soapval('return', 'xsd:string', $u);
}

/**
 * Retorna el nick de todos los usuarios  que son empleados del sistema separados  por "=>"
 * @return string
 */
function getUsuariosEmpleado() {
    conectar();
    $u = fungetUsuariosEmpleado();
    return new soapval('return', 'xsd:string', $u);
}

/**
 * Retorna los datos de un usuario de un nick determinado separados por "=>"
 * @param  string $nick
 * @return string
 */
function getDataUsuario($nick) {
    conectar();
    $u = fungetDataUsuario($nick);
    return new soapval('return', 'xsd:string', $u);
}

function passwd($nick, $pass) {
    conectar();
    $u = funpasswd($nick, $pass);
    return new soapval('return', 'xsd:int', $u);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////// SALAS

/**
 * Ingresa una nueva sala ,  genera el id automaticamente
 * y crea  un nuevo registro para el contenido de las salas y crea los directorios donde se alojaran los recursos de esa sala
 * @param  string $nombre_sala, string $descripcion_sala
 * @return int (0 ok , -1 error)


 */
function getAllDataSalas() {
    conectar();
    $u = fungetAllDataSalas();
    return new soapval('return', 'xsd:string', $u);
}

function AltaSala($nombre_sala, $descripcion_sala) {
    conectar();
    $reg = funAltaSala($nombre_sala, $descripcion_sala);
    return new soapval('return', 'xsd:int', $reg);
}

/**

 * Elimina una sala de un id determinado , y sus  contenidos tanto de la base de datos como del disco duro
 * @param  int $id_sala 
 * @return int (0 ok , -1 error)
 */
function borrarSala($id_sala) {
    conectar();
    $bor = funborrarSala($id_sala);
    return new soapval('return', 'xsd:int', $bor);
}

/**
 * Modifica el nombre y la descripción de una sala a partir de su id 
 * @param  int $id_sala , string $nombre_sala  , $descripcion_sala
 * @return int (0 ok , -1 y -2 error)
 */
function modificarSala($id_sala, $nombre_sala, $descripcion_sala) {
    conectar();
    $mod = funmodificarSala($id_sala, $nombre_sala, $descripcion_sala);
    return new soapval('return', 'xsd:int', $mod);
}

/**
 * Actualiza el QR de una sala  
 * @param  int id_sala , string  qr
 * @return ( 0 ok ,  -1 y -2 error)
 */
function setQr($id_sala, $qr) {
    conectar();
    $mod = funsetQr($id_sala, $qr);
    return new soapval('return', 'xsd:string', $mod);
}

/**
 * Retorna el id y el nombre de todas las salas existentes en el sistema separados por "=>" 
 * @return string
 */
function getSalas() {
    conectar();
    $u = fungetSalas();
    return new soapval('return', 'xsd:string', $u);
}

/**
 * Retorna el nombre de todas las salas existentes en el sistema separados por "=>" 
 * @return string
 */
function getNombreSalas() {
    conectar();
    $u = fungetNombreSalas();
    return new soapval('return', 'xsd:string', $u);
}

/**
 * Retorna los datos de una sala (nombre y descripcióon ) separados por "=>" a partir de su id
 * @param  string nombre
 * @return string
 */
function getDataSalaId($id_sala) {
    conectar();
    $u = fungetDataSalaId($id_sala);
    return new soapval('return', 'xsd:string', $u);
}

function getDataSalaId2($id_sala) {
    conectar();
    $u = fungetDataSalaId2($id_sala);
    return new soapval('return', 'xsd:string', $u);
}

/**
 * Retorna los datos de una sala (id y descripci{on ) separados por "=>" a partir de su nombre
 * @param  string nombre
 * @return string
 */
function getDataSalaNombre($nombre) {
    conectar();
    $u = fungetDataSalaNombre($nombre);
    return new soapval('return', 'xsd:string', $u);
}

function getDataSalaNombreImagen($nombre) {
    conectar();
    $u = fungetDataSalaNombreImagen($nombre);
    return new soapval('return', 'xsd:string', $u);
}
function getDataSalaIdImagen($nombre) {
    conectar();
    $u = fungetDataSalaIdImagen($nombre);
    return new soapval('return', 'xsd:string', $u);
}

function agregarContenidoSala($id_sala, $tipo, $nombre) {
    conectar();
    $mod = funagregarContenidoSala($id_sala, $tipo, $nombre);
    return new soapval('return', 'xsd:string', $mod);
}

function agregarContenidoSala2($id_sala, $tipo, $nombre) {
    conectar();
    $mod = funagregarContenidoSala2($id_sala, $tipo, $nombre);
    return new soapval('return', 'xsd:int', $mod);
}

/**
 * Retorna los contenidos de una sala (audio,video , texto , modelo , imagen ) separados por "=>" a partir de su id
 * @param  int id
 * @return string
 */
function getContenidoSala($id) {
    conectar();
    $u = fungetContenidoSala($id);
    return new soapval('return', 'xsd:string', $u);
}

/**
 * Verifica si existe una sala en el sistema a partir de su id
 * @param  int id
 * @return int ( 0 no existe, 1 existe)
 */
function existeSala($id) {
    conectar();
    $u = funexisteSala($id);
    return new soapval('return', 'xsd:int', $u);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////// OBRAS

/**
 * Si no existe una obra con ese nombre , la ingresa al sistema
 * Y crea los directorios donde se alojaran los recursos ( idObra "/" Audio , idObra "/" texto ,idObra "/" video , idObra "/" imagen 
 * Tambien crear un nuevo registro en la tabla contenido_obra para posteriarmente ingresar los recursos de esa obra
 * @param  string $nombre_obra, string $descripcion_obra, string $imagen, int $id_sala
 * @return int ( 0 ok, -1 error)
 */
function AltaObra($nombre_obra, $descripcion_obra, $imagen, $id_sala, $autor_obra) {
    conectar();
    $reg = funAltaObra($nombre_obra, $descripcion_obra, $imagen, $id_sala, $autor_obra);
    return new soapval('return', 'xsd:int', $reg);
}

/**
 * Elimina una obra de  un id determinado
 * @param  int  id_obra 
 * @return int ( 0 ok, -1 error)
 */
function borrarObra($id_obra) {
    conectar();
    $bor = funborrarObra($id_obra);
    return new soapval('return', 'xsd:int', $bor);
}

/**
 * Modifica los datos de  una obra de  un id determinado
 * @param  int  id_obra , string  nombre_obra , string descripcion_obra,string descriptor ,string imagen ,string id_sala
 * @return int ( 0 ok, -2 y -1 error)
 */
function modificarObra($id_obra, $nombre_obra, $descripcion_obra, $id_sala, $autor_obra) {
    conectar();
    $mod = funmodificarObra($id_obra, $nombre_obra, $descripcion_obra, $id_sala, $autor_obra);
    return new soapval('return', 'xsd:int', $mod);
}

/**
 * Retorna los  nombres de todas las obras  separados por "=>" 
 * @return string
 */
function getObras() {
    conectar();
    $u = fungetObras();
    return new soapval('return', 'xsd:string', $u);
}
function getObrasl() {
    conectar();
    $u = fungetObrasl();
    return new soapval('return', 'xsd:string', $u);
}}

/**
 * Retorna los  datos de una obra ( id, nombre ,descripción , descriptor , imagen, id) separados por "=>" ,  a partir de  un nombre determinado
 * @param  string  nombre_obra
 * @return string
 */
function getDataObra($nombre_obra) {
    conectar();
    $u = fungetDataObra($nombre_obra);
    return new soapval('return', 'xsd:string', $u);
}

function agregarContenidoObra($id_obra, $tipo, $nombre) {
    conectar();
    $mod = funagregarContenidoObra($id_obra, $tipo, $nombre);
    return new soapval('return', 'xsd:string', $mod);
}

function modificarContenidoObra($id_obra, $tipo) {
    conectar();
    $mod = funmodificarContenidoObra($id_obra, $tipo);
    return new soapval('return', 'xsd:int', $mod);
}

/**
 * Retorna los  contenidos (audio ,video, texto ,modelo ,imagen) de una obra a partir de su id separados por "=>"
 * @param  int $id
 * @return string
 */
function getContenidoObra($nombre) {
    conectar();
    $u = fungetContenidoObra($nombre);
    return new soapval('return', 'xsd:string', $u);
}

function getObraSala($id) {
    conectar();
    $u = fungetObraSala($id);
    return new soapval('return', 'xsd:string', $u);
}

function getAllDataObraSala($id) {
    conectar();
    $u = fungetAllDataObraSala($id);
    return new soapval('return', 'xsd:string', $u);
}

/////////////////////////////////////ZONA/////////////////

function AltaZona($largo, $ancho, $x, $y, $nombre_obra) {
    conectar();
    $reg = funAltaZona($largo, $ancho, $x, $y, $nombre_obra);
    return new soapval('return', 'xsd:int', $reg);
}

function borrarZona($id_zona) {
    conectar();
    $bor = funborrarZona($id_zona);
    return new soapval('return', 'xsd:int', $bor);
}

function modificarZona($id_zona, $largo, $ancho, $x, $y) {
    conectar();
    $mod = funmodificarZona($id_zona, $largo, $ancho, $x, $y);
    return new soapval('return', 'xsd:int', $mod);
}

function agregarContenidoZona($id_zona, $tipo, $nombre) {
    conectar();
    $mod = funagregarContenidoZona($id_zona, $tipo, $nombre);
    return new soapval('return', 'xsd:string', $mod);
}

function getContenidoZona($id_zona) {
    conectar();
    $u = fungetContenidoZona($id_zona);
    return new soapval('return', 'xsd:string', $u);
}

function getZonaObra($nombre_obra) {
    conectar();
    $u = fungetZonaObra($nombre_obra);
    return new soapval('return', 'xsd:string', $u);
}

if (isset($HTTP_RAW_POST_DATA)) {
    $input = $HTTP_RAW_POST_DATA;
} else {
    $input = implode("\r\n", file('php://input'));
}
$server->service($input);
exit;
?>
