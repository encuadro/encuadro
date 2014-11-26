<?php

$ini_array = parse_ini_file("/var/www/include/confi.ini", true);
$ruta = $ini_array['RUTA']['include'];
require_once($ruta."lib/nusoap.php");

require_once($ruta."config.php");

require_once($ruta."Juego.php");
require_once($ruta."usuario.php");
require_once($ruta."sala.php");
require_once($ruta."obra.php");
require_once($ruta."zona.php");
require_once($ruta."descriptor.php");
require_once($ruta."directorios.php");



$gbdhost = $ini_array['BD']['servidor'];
$gdbusername = $ini_array['BD']['usuario'];
$gdbuserpass = $ini_array['BD']['passbd'];
$gdbname = $ini_array['BD']['nombase'];

$ns = $ini_array['ns']['ns'];//"http://10.0.2.109/server_php/";

$server = new soap_server();
$server->configureWSDL('comision', $ns);
$server->wsdl->schemaTargetNamespace = $ns;


//JUEGO

$server->register('pruebaEscribir', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('BusquedaPista', array('id_Obra' => 'xsd:int','id_Juego' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

$server->register('ModificarPista', array('id_Obra' => 'xsd:int','id_Juego' => 'xsd:int','Pista' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('AltaJuego', array('nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('CantidadObrasJuego', array('id_juego' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

$server->register('AgregarPista', array('nomObra' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
//, 'id_juego' => 'xsd:int', 'nomProxima' => 'xsd:string', 'pista' => 'xsd:string'

$server->register('ObraPerteneceAJuego', array('id_Obra' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

$server->register('getalgo', array('nombre' => 'xsd:string', 'nomProx' => 'xsd:string','idjuego' => 'xsd:int','pista' => 'xsd:string'), array('return' =>'xsd:string'), $ns);

$server->register('convertirvideo', array('id_obra' => 'xsd:int'), array('return' => 'xsd:string'), $ns);
$server->register('convertirimagen', array('id_obra' => 'xsd:int'), array('return' => 'xsd:string'), $ns);
$server->register('gethora', array(), array('return' => 'xsd:string'), $ns);
$server->register('getpuntaje', array('id_visitante' => 'xsd:int', 'id_juego' => 'xsd:int'), array('return' => 'xsd:string'), $ns);
$server->register('getpuntajes', array(), array('return' => 'xsd:string'), $ns);
$server->register('getposicion', array('id_visitante' => 'xsd:int'), array('return' => 'xsd:string'), $ns);
$server->register('finJuego', array('id_visitante' => 'xsd:int', 'id_juego' => 'xsd:int', 'puntajes' => 'xsd:int', 'nick_name' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
//////////////////////////////////////////////////////////////////////

//////usuario
$server->register('login', array('user' => 'xsd:string', 'pass' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('AltaUsuario', array('nombre' => 'xsd:string', 'apellido' => 'xsd:string', 'cedula' => 'xsd:string', 'email' => 'xsd:string', 'tipoUs' => 'xsd:int', 'nick' => 'xsd:string', 'pass' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('modificarUsuario', array('nombre' => 'xsd:string', 'apellido' => 'xsd:string', 'cedula' => 'xsd:string', 'email' => 'xsd:string', 'tipoUs' => 'xsd:int', 'nick' => 'xsd:string', 'pass' => 'xsd:string', 'idUsuario' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

$server->register('borrarUsuario', array('idUsuario' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('passwd', array('nick' => 'xsd:string', 'pass' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('getUsuarios', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('getUsuariosAdmin', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('getUsuariosEmpleado', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('getDataUsuario', array('nick' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('tipoUsuario', array('nick' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('temporal', array('nick' => 'xsd:string'), array('return' => // borrameeeeeeeeeeeee
    'xsd:string'), $ns);

////////////////////////////////////////////////////////////////////////////////////// SALAS 

$server->register('getAllDataSalas', array(), array('return' => 'xsd:string'), $ns);


$server->register('AltaSala', array('nombre_sala' => 'xsd:string', 'descripcion_sala' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('agregarContenidoSala', array('id_sala' => 'xsd:int', 'tipo' => 'xsd:string', 'nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('borrarSala', array('id_sala' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('modificarSala', array('id_sala' => 'xsd:int', 'nombre_sala' => 'xsd:string', 'descripcion_sala' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('getSalas', array(), array('return' => 'xsd:string'), $ns);

$server->register('getNombreSalas', array(), array('return' => 'xsd:string'), $ns);

$server->register('getDataSalaId', array('id_sala' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('getDataSalaId2', array('id_sala' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('getDataSalaNombre', array('nombre' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

//---------------------------------------------------------------NUEVO!!! --------------------------------------------------------
$server->register('getDataSalaNombreImagen', array('nombre' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
$server->register('getDataSalaIdImagen', array('id' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
$server->register('getVideoSalaId', array('id' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
$server->register('Altavisita', array('nacionalidad' => 'xsd:string', 'sexo' => 'xsd:string', 'tipo_visita' => 'xsd:string', 'rango_edad' => 'xsd:string'), array('return' =>'xsd:string'), $ns);
$server->register('getSalasl', array('nombre_sala' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
$server->register('getListImgSalas()', array(), array('return' => 'xsd:string'), $ns);
$server->register('getDatosVisita', array(), array('return' => 'xsd:string'), $ns);
//--------------------------------------------------------------------------

$server->register('getContenidoSala', array('id' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('getContenidoSalaNombre', array('nombre' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('setQr', array('id_sala' => 'xsd:int', 'qr' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('existeSala', array('id' => 'xsd:int'), array('return' => 'xsd:string'), $ns);


/* OBRAS =================================================================================================== OBRAS */

$server->register('AltaObra', array('nombre_sala' => 'xsd:string', 'descripcion_sala' => 'xsd:string', 'imagen' => 'xsd:string', 'id_sala' => 'xsd:string', 'autor_obra' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('modificarObra', array('id_obra' => 'xsd:int', 'nombre_obra' => 'xsd:string', 'descripcion_obra' => 'xsd:string', 'id_sala' => 'xsd:int', 'autor_obra' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('borrarObra', array('id_obra' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('agregarContenidoObra', array('id_obra' => 'xsd:int', 'tipo' => 'xsd:string', 'nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('modificarContenidoObra', array('id_obra' => 'xsd:int', 'tipo' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('getContenidoObra', array('nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('getObraSala', array('id' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

$server->register('getDataObra', array('nombre_obra' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

//test json
$server->register('getDataObra2', array('nombre_obra' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);
//-------------------------------------------NUEVO------------------------------------------
$server->register('resp', array('id' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);
$server->register('respcerrada', array('id' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);


$server->register('getDataObraId', array('id_obra' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('getDataObraLike', array('nombre_obra' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('getNombreObraLike', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('getZonas', array(), array('return' =>
    'xsd:string'), $ns);
//------------------------------------------------------------------------------------------d

$server->register('getAllDataObraSala', array('id' => 'xsd:int'), array('return' => 'xsd:string'), $ns);


$server->register('getNombreObraApartirDelID', array('id_obra' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

		//NUEVO 2013
$server->register('getObras', array(), array('return' => 'xsd:string'), $ns);
$server->register('getObrasl', array('nombre_obra' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

/* ZONA ===================================================================================================== ZONA */

$server->register('AltaZona', array('largo' => 'xsd:int', 'ancho' => 'xsd:int', 'x' => 'xsd:int', 'y' => 'xsd:int', 'nombre_obra' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('modificarZona', array('id_zona' => 'xsd:int', 'largo' => 'xsd:int', 'ancho' => 'xsd:int', 'x' => 'xsd:int', 'y' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('borrarZona', array('id_zona' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('agregarContenidoZona', array('id_zona' => 'xsd:int', 'tipo' => 'xsd:string', 'nombre' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

$server->register('getContenidoZona', array('id_zona' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);
$server->register('getContenidoZonaNombre', array('nombre_zona' => 'xsd:int'), array('return' =>
    'xsd:string'), $ns);

$server->register('getZonaObra', array('nombre_obra' => 'xsd:string'), array('return' =>
    'xsd:string'), $ns);

/* DESCRIPTORES ========================================================================================	DESCRIPTORES */

$server->register('getNombreObra', array('id_sala' => 'xsd:int', 'nombre_archivo' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
$server->register('getNombreObra2', array('nombre_archivo' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('generarDescriptor', array('id_sala' => 'xsd:int', 'id_obra' => 'xsd:int', 'nombre_archivo' => 'xsd:string'), array('return' => 'xsd:string'), $ns);



//////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////NUEVAS JUEGO Y CUESTIONARIO
$server->register('PrimeraDeJuego', array('id_juego' => 'xsd:int', 'nom_obra' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('getJuegos', array(), array('return' =>'xsd:string'), $ns);


$server->register('AgregarCuestionario', array('nombre' => 'xsd:string', 'descripcion' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('ActivarJuego', array('id_juego' => 'xsd:int'), array('return' => 'xsd:string'), $ns);


$server->register('RecorridoJuego', array('id_juego' => 'xsd:int', 'recorrido' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('SetJuegoBorrado', array('id_juego' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetObrasDeJuego', array('id_juego' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('SetJuego', array('id_juego' => 'xsd:int', 'nombre' => 'xsd:string','recorrido' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetPistas', array('id_juego' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetNombreJuegoActivo', array(), array('return' =>
    'xsd:string'), $ns);

$server->register('AgregarCuestionarioo', array('nombre' => 'xsd:string', 'descripcion' => 'xsd:string' , 'fecha_creacion' => 'xsd:string', 'id_creador' => 'xsd:int'), array('return' => 'xsd:string'), $ns);


$server->register('AgregarValorOpcion', array('descripcion' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('AgregarPregunta', array('descripcion' => 'xsd:string', 'tipo' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('AsociarPreguntaConOpcion', array('id_preg' => 'xsd:int', 'id_op' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('AsociarPreguntaConCuestionario', array('id_preg' => 'xsd:int', 'id_cuest' => 'xsd:int', 'indice' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetCuestionarios', array(), array('return' => 'xsd:string'), $ns);

$server->register('GetPreguntas', array('id_cuest' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

//27/03/14
$server->register('setCuestionarioVisitante', array('id_visitante' => 'xsd:int', 'result' => 'xsd:string'), array('return' => 'xsd:string'), $ns);
$server->register('getfrutamadre', array(), array('return' => 'xsd:string'), $ns);

//01/04
$server->register('GetTextPreguntas', array('id_cuest' => 'xsd:int'), array('return' => 'xsd:string'),$ns);

$server->register('GetRespPreguntas', array('id_preg' => 'xsd:int'), array('return' => 'xsd:string'),$ns);

$server->register('SetOpcion', array('descripcion' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('AsociarOpcionesConValores', array('id_opc' => 'xsd:int', 'valor' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('AgregarPregunta2', array('descripcion' => 'xsd:string', 'tipo' => 'xsd:int', 'id_opciones' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetOpciones', array(), array('return' => 'xsd:string'), $ns);

$server->register('GetValoresDeOpcion', array('id_opcion' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetValoresDeOpciones', array(), array('return' => 'xsd:string'), $ns);
$server->register('SetValorOpcc', array('id_val' => 'xsd:string', 'descripcion' => 'xsd:string' ), array('return' => 'xsd:string'), $ns);


$server->register('IsValorAsociadoAOpcion', array('id_valor' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('BorrarValorOpc', array('idValor' => 'xsd:int'), array('return' => 'xsd:string'), $ns);


$server->register('IsGrupoOpcAsociadoAPreguntas', array('id_grupo' => 'xsd:string'), array('return' => 'xsd:string'), $ns);


$server->register('SetOpcionn', array('id_opc' => 'xsd:string', 'descripcion' => 'xsd:string' ), array('return' => 'xsd:string'), $ns);

$server->register('BorrarOpcion', array('idOpcion' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('IsPreguntaAsociadaACuestionario', array('id_preg' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('BorrarPregunta', array('idpreg' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetDatosPregunta', array('id_cuest' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('SetCuestionariio', array('id_cuest' => 'xsd:int', 'nombre' => 'xsd:string', 'descripcion' => 'xsd:string' ), array('return' => 'xsd:string'), $ns);
$server->register('BorrarRelacionPreguntasCuestionario', array('idCuest' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('IsCuestionarioEnUso', array('id_cuest' => 'xsd:string'), array('return' => 'xsd:string'), $ns);

$server->register('BorrarCuestionario', array('idCuest' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetDatosOpcion', array('id_opcion' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('BorrarRelacionOpcionesValor', array('idOpc' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('GetDataPregunta', array('id_preg' => 'xsd:int'), array('return' => 'xsd:string'), $ns);

$server->register('SetPregunta', array('id_preg' => 'xsd:int', 'id_op' => 'xsd:int', 'descripcion' => 'xsd:string' ), array('return' => 'xsd:string'), $ns);
$server->register('GetTextAllPreguntas', array(), array('return' => 'xsd:string'),$ns);

$server->register('GetOpcPregunta', array('id_preg' => 'xsd:int'), array('return' => 'xsd:string'), $ns);


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//----------------------------------------JUEGO---------------------------------------------

function pruebaEscribir() {

    $u = "hola nan \n";
    return new soapval('return', 'xsd:string', $u);
}

function BusquedaPista($idObra,$idJuego) {
conectar();
    $u = funBusquedaPista($idObra,$idJuego);

    return new soapval('return', 'xsd:string', $u);
}

function ModificarPista($id_Obra,$id_Juego,$Pista) {
conectar();
    $u = funModificarPista($id_Obra,$id_Juego,$Pista);

    return new soapval('return', 'xsd:string', $u);
}


function AltaJuego($nombre) {
conectar();
    $u = funAltaJuego($nombre);

    return new soapval('return', 'xsd:string', $u);
}

function CantidadObrasJuego($id_juego) {
conectar();
    $u = funCantidadObrasJuego($id_juego);

    return new soapval('return', 'xsd:string', $u);
}

function AgregarPista($nomObra) {
    conectar();
    $reg = funAgregarPista($nomObra, $id_juego, $nomProxima, $pista);
    return new soapval('return', 'xsd:string', $reg);
}

//, $id_juego, $nomProxima, $pista

function ObraPerteneceAJuego($idObra) {
conectar();
    $u = funObraPerteneceAJuego($idObra);

    return new soapval('return', 'xsd:string', $u);
}

function getalgo($nombre,$nomProx,$idjuego,$pista) {
    conectar();
    $u = fungetalgo($nombre,$nomProx,$idjuego,$pista);
    return new soapval('return', 'xsd:string', $u);
}

function convertirvideo($id_obra) {
conectar();
    $u = funconvertirvideo($id_obra);

    return new soapval('return', 'xsd:string', $u);
}
function convertirimagen($id_obra) {
conectar();
    $u = funconvertirimagen($id_obra);

    return new soapval('return', 'xsd:string', $u);
}

function gethora() {
conectar();
    $u = fungethora();

    return new soapval('return', 'xsd:string', $u);
}

function getpuntaje($id_visitante,$id_juego) {
conectar();
    $u = fungetpuntaje($id_visitante,$id_juego);

    return new soapval('return', 'xsd:string', $u);
}

function getpuntajes() {
conectar();
    $u = fungetpuntajes();

    return new soapval('return', 'xsd:string', $u);
}

function getposicion($id_visitante) {
conectar();
    $u = fungetposicion($id_visitante);

    return new soapval('return', 'xsd:string', $u);
}

function finJuego($id_visitante,$id_juego,$puntajes,$nick_name){
	conectar();
	$u =funfinJuego($id_visitante,$id_juego,$puntajes,$nick_name);
	return new soapval('return', 'xsd:string', $u);
}

/////////////////////////////////////////////////////////////////////////////////////////////////

////////////////NUEVAS JUEGO Y CUESTIONARIO
function PrimeraDeJuego($id_juego, $nom_obra) {
conectar();
    $u = funPrimeraDeJuego($id_juego, $nom_obra);

    return new soapval('return', 'xsd:string', $u);
}

function getJuegos() {
    conectar();
    $u = fungetJuegos();
    return new soapval('return', 'xsd:string', $u);
}
function resp($id) {
    conectar();
    $u = funresp($id);
    return new soapval('return', 'xsd:string', $u);
}

function respcerrada($id) {
    conectar();
    $u = funrespcerrada($id);
    return new soapval('return', 'xsd:string', $u);
}


function AgregarCuestionario($nombre, $descripcion) {
conectar();
    $u = funAgregarCuestionario($nombre, $descripcion);

    return new soapval('return', 'xsd:string', $u);
}


function ActivarJuego($id_juego) {
conectar();
    $u = funActivarJuego($id_juego);

    return new soapval('return', 'xsd:string', $u);
}


function RecorridoJuego($id_juego, $recorrido){
conectar();
    $u = funRecorridoJuego($id_juego, $recorrido);

    return new soapval('return', 'xsd:string', $u);
}

function SetJuegoBorrado($id_juego){
conectar();
    $u = funSetJuegoBorrado($id_juego);

    return new soapval('return', 'xsd:string', $u);
}

function GetObrasDeJuego($id_juego){
conectar();
    $u = funGetObrasDeJuego($id_juego);

    return new soapval('return', 'xsd:string', $u);
}


function SetJuego($id_juego, $nombre,$recorrido){
conectar();
    $u = funSetJuego($id_juego, $nombre,$recorrido);

    return new soapval('return', 'xsd:string', $u);
}

function GetPistas($id_juego){
conectar();
    $u = funGetPistas($id_juego);

    return new soapval('return', 'xsd:string', $u);
}

function GetNombreJuegoActivo(){
    conectar();
    $u = funGetNombreJuegoActivo();
    return new soapval('return', 'xsd:string', $u);
}

function AgregarCuestionarioo($nombre, $descripcion, $fecha_creacion, $id_creador) {
conectar();
    $u = funAgregarCuestionarioo($nombre, $descripcion, $fecha_creacion, $id_creador);

    return new soapval('return', 'xsd:string', $u);
}

function AgregarValorOpcion($descripcion) {
conectar();
    $u = funAgregarValorOpcion($descripcion);

    return new soapval('return', 'xsd:string', $u);
}

function AgregarPregunta($descripcion, $tipo) {
conectar();
    $u = funAgregarPregunta($descripcion, $tipo);

    return new soapval('return', 'xsd:string', $u);
}


function AsociarPreguntaConOpcion($id_preg, $id_op) {
conectar();
    $u = funAsociarPreguntaConOpcion($id_preg, $id_op);

    return new soapval('return', 'xsd:string', $u);
}

function AsociarPreguntaConCuestionario($id_preg, $id_cuest, $indice){
conectar();
    $u = funAsociarPreguntaConCuestionario($id_preg, $id_cuest, $indice);

    return new soapval('return', 'xsd:string', $u);
}

function GetCuestionarios(){
conectar();
    $u = funGetCuestionarios();

    return new soapval('return', 'xsd:string', $u);
}


function GetPreguntas($id_cuest){
conectar();
    $u = funGetPreguntas($id_cuest);

    return new soapval('return', 'xsd:string', $u);
}

function getfrutamadre(){
conectar();
    $u = frutamadre();

    return new soapval('return', 'xsd:string', $u);
}
function setCuestionarioVisitante($id_visitante,$result){
conectar();
    $u = funsetCuestionarioVisitante($id_visitante,$result);

    return new soapval('return', 'xsd:string', $u);
}

function GetTextPreguntas($id_cuest){
conectar();
    $u = funGetTextPreguntas($id_cuest);

    return new soapval('return', 'xsd:string', $u);
}

function GetRespPreguntas($id_preg){
conectar();
    $u = funGetRespPreguntas($id_preg);

    return new soapval('return', 'xsd:string', $u);
}

function SetOpcion($descripcion) {
conectar();
    $u = funSetOpcion($descripcion);

    return new soapval('return', 'xsd:string', $u);
}

function AsociarOpcionesConValores($id_opc, $id_valor){
conectar();
    $u = funAsociarOpcionesConValores($id_opc, $id_valor);

    return new soapval('return', 'xsd:string', $u);
}

function AgregarPregunta2($descripcion, $tipo, $id_opciones) {
conectar();
    $u = funAgregarPregunta2($descripcion, $tipo, $id_opciones);

    return new soapval('return', 'xsd:string', $u);
}

function GetOpciones(){
conectar();
    $u = funGetOpciones();

    return new soapval('return', 'xsd:string', $u);
}

function GetValoresDeOpcion($id_opcion){
conectar();
    $u = funGetValoresDeOpcion($id_opcion);

    return new soapval('return', 'xsd:string', $u);
}

function GetValoresDeOpciones(){
conectar();
    $u = funGetValoresDeOpciones();

    return new soapval('return', 'xsd:string', $u);
}

function SetValorOpcc($id_val, $descripcion){
conectar();
    $u = funSetValorOpcc($id_val, $descripcion);

    return new soapval('return', 'xsd:string', $u);
}

function IsValorAsociadoAOpcion($id_valor){
conectar();
    $u = funIsValorAsociadoAOpcion($id_valor);

    return new soapval('return', 'xsd:string', $u);
}

function BorrarValorOpc($idValor) {
    conectar();
    $bor = funBorrarValorOpc($idValor);
    return new soapval('return', 'xsd:string', $bor);
}

function SetOpcionn($id_opc, $descripcion){
conectar();
    $u = funSetOpcionn($id_opc, $descripcion);

    return new soapval('return', 'xsd:string', $u);
}


function IsGrupoOpcAsociadoAPreguntas($id_grupo){
conectar();
    $u = funIsGrupoOpcAsociadoAPreguntas($id_grupo);

    return new soapval('return', 'xsd:string', $u);
}

function BorrarOpcion($idOpcion) {
    conectar();
    $bor = funBorrarOpcion($idOpcion);
    return new soapval('return', 'xsd:string', $bor);
}

function IsPreguntaAsociadaACuestionario($id_preg){
conectar();
    $u = funIsPreguntaAsociadaACuestionario($id_preg);

    return new soapval('return', 'xsd:string', $u);
}

function BorrarPregunta($idPreg) {
    conectar();
    $bor = funBorrarPregunta($idPreg);
    return new soapval('return', 'xsd:string', $bor);
}


function GetDatosPregunta($id_cuest){
conectar();
    $u = funGetDatosPregunta($id_cuest);

    return new soapval('return', 'xsd:string', $u);
}

function SetCuestionariio($id_cuest, $nombre, $descripcion){
conectar();
    $u = funSetCuestionariio($id_cuest, $nombre, $descripcion);

    return new soapval('return', 'xsd:string', $u);
}

function BorrarRelacionPreguntasCuestionario($idCuest) {
    conectar();
    $bor = funBorrarRelacionPreguntasCuestionario($idCuest);
    return new soapval('return', 'xsd:string', $bor);
}

function IsCuestionarioEnUso($id_cuest){
conectar();
    $u = funIsCuestionarioEnUso($id_cuest);

    return new soapval('return', 'xsd:string', $u);
}

function BorrarCuestionario($idCuest) {
    conectar();
    $bor = funBorrarCuestionario($idCuest);
    return new soapval('return', 'xsd:string', $bor);
}

function GetDatosOpcion($id_opcion){
conectar();
    $u = funGetDatosOpcion($id_opcion);

    return new soapval('return', 'xsd:string', $u);
}



function BorrarRelacionOpcionesValor($idOpc) {
    conectar();
    $bor = funBorrarRelacionOpcionesValor($idOpc);
    return new soapval('return', 'xsd:string', $bor);
}


function GetDataPregunta($id_preg){
conectar();
    $u = funGetDataPregunta($id_preg);

    return new soapval('return', 'xsd:string', $u);
}

function SetPregunta($id_preg, $id_op, $descripcion){
conectar();
    $u = funSetPregunta($id_preg, $id_op, $descripcion);

    return new soapval('return', 'xsd:string', $u);
}

function GetTextAllPreguntas(){
conectar();
    $u = funGetTextAllPreguntas();

    return new soapval('return', 'xsd:string', $u);
}

function GetOpcPregunta($id_preg){
conectar();
    $u = funGetOpcPregunta($id_preg);

    return new soapval('return', 'xsd:string', $u);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

function getNombreObraApartirDelID($id_obra) {
    conectar();
    $u = "";
    $query = mysql_query("SELECT * FROM obra WHERE id_obra='$id_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {//no exited
        $u = $row['nombre_obra'];
    }
    return new soapval('return', 'xsd:string', $u);
}

function getNombreObra($id_sala, $nombre_archivo) {
    mensaje_log("FUNCION GET NOMBRE OBRA DE SERVER PHP");
    $u = fungetNombreObra($id_sala, $nombre_archivo);

    return new soapval('return', 'xsd:string', $u);
}
//--------------------------- nuevo--------------
function getNombreObra2($nombre_archivo) {
    $u = fungetNombreObra2($nombre_archivo);

    return new soapval('return', 'xsd:string', $u);
}

//-------------------------------NUEVO-------------------------------------------------
function getDataObraLike($nombre_obra) {
    conectar();
    $u = fungetDataObra($nombre_obra);
    return new soapval('return', 'xsd:string', $u);
}

function getNombreObraLike() {
    conectar();
    $u = fungetNombreObraLike();
    return new soapval('return', 'xsd:string', $u);
}
function Altavisita($nacionalidad, $sexo, $tipo_visita, $rango_edad) {
    conectar();
    $reg = funAltavisita($nacionalidad, $sexo, $tipo_visita, $rango_edad);
    return new soapval('return', 'xsd:string', $reg);
}
//-------------------------------------------------------------------------------------

function generarDescriptor($id_sala, $id_obra, $nombre_archivo) {
   	$u =  fungenerarDescriptor ($id_sala,$id_obra,$nombre_archivo);
        return new soapval('return', 'xsd:string', $u);
   
}
////////////////funciones comunes

/**
 * Establece la conección con la base de datos
 */
function conectar() {
    global $gbdhost,  $gdbusername,  $gdbuserpass ,  $gdbname;    
    mysql_connect($gbdhost, $gdbusername, $gdbuserpass);    
    mysql_select_db($gdbname) or die('Cannot select database');
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
    return new soapval('return', 'xsd:string', $u);
}
function temporal($nick) {
    conectar();
    $u = funtipoUsuario($nick);
    return new soapval('return', 'xsd:string', $u);
}

/**
 * Verifica la existencia en el sistema de un usuario con el nick y password pasados por parametros
 * @param  string $user,string $pass
 * @return int ( idUsuario encontrado, -1 error o no se encontro el usuario)
 */
function login($user, $pass) {
    conectar();
    $log = funlogin($user, $pass);
    return new soapval('return', 'xsd:string', $log);
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
    return new soapval('return', 'xsd:string', $reg);
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
    return new soapval('return', 'xsd:string', $mod);
}

/**
 * Elimina un usuario con un id determinado del sistema 
 * @param  string $idUsuario
 * @return int ( 0 ok, -1 error)
 */
function borrarUsuario($idUsuario) {
    conectar();
    $bor = funborrarUsuario($idUsuario);
    return new soapval('return', 'xsd:string', $bor);
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
    return new soapval('return', 'xsd:string', $u);
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
    return new soapval('return', 'xsd:string', $reg);
}

/**

 * Elimina una sala de un id determinado , y sus  contenidos tanto de la base de datos como del disco duro
 * @param  int $id_sala 
 * @return int (0 ok , -1 error)
 */
function borrarSala($id_sala) {
    conectar();
    $bor = funborrarSala($id_sala);
    return new soapval('return', 'xsd:string', $bor);
}

/**
 * Modifica el nombre y la descripción de una sala a partir de su id 
 * @param  int $id_sala , string $nombre_sala  , $descripcion_sala
 * @return int (0 ok , -1 y -2 error)
 */
function modificarSala($id_sala, $nombre_sala, $descripcion_sala) {
    conectar();
    $mod = funmodificarSala($id_sala, $nombre_sala, $descripcion_sala);
    return new soapval('return', 'xsd:string', $mod);
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

//------------------------------------------------------Nuevo
function getDataSalaNombreImagen($nombre) {
    conectar();
    $u = fungetDataSalaNombreImagen($nombre);
    return new soapval('return', 'xsd:string', $u);
}

function getDataSalaIdImagen($id) {
    conectar();
    $u = fungetDataSalaIdImagen($id);
    return new soapval('return', 'xsd:string', $u);
}
function getVideoSalaId($id) {
    conectar();
    $u = fungetVideoSalaId($id);
    return new soapval('return', 'xsd:string', $u);
}
function getListImgSalas(){
    conectar();
    $u = fungetListImgSalas();
    return new soapval('return', 'xsd:string', $u);
}

//---------------------------------------------------------------
function getSalasl($nombre) {
    conectar();
    $u = fungetSalasl($nombre);
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
    return new soapval('return', 'xsd:string', $mod);
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
function getContenidoSalaNombre($nombre) {
    conectar();
    $u = fungetContenidoSalaNombre($nombre);
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
    return new soapval('return', 'xsd:string', $u);
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
    return new soapval('return', 'xsd:string', $reg);
}

/**
 * Elimina una obra de  un id determinado
 * @param  int  id_obra 
 * @return int ( 0 ok, -1 error)
 */
function borrarObra($id_obra) {
    conectar();
    $bor = funborrarObra($id_obra);
    return new soapval('return', 'xsd:string', $bor);
}

/**
 * Modifica los datos de  una obra de  un id determinado
 * @param  int  id_obra , string  nombre_obra , string descripcion_obra,string descriptor ,string imagen ,string id_sala
 * @return int ( 0 ok, -2 y -1 error)
 */
function modificarObra($id_obra, $nombre_obra, $descripcion_obra, $id_sala, $autor_obra) {
    conectar();
    $mod = funmodificarObra($id_obra, $nombre_obra, $descripcion_obra, $id_sala, $autor_obra);
    return new soapval('return', 'xsd:string', $mod);
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
//funcion prueba json
function getDataObra2($nombre_obra) {
    conectar();
    $u = fungetDataObra2($nombre_obra);
    return new soapval('return', 'xsd:string', $u);
}
//---------------------------------NUEVO-----------------------------

function getObrasl($nombre) {
    conectar();
    $u = fungetObrasl($nombre);
    return new soapval('return', 'xsd:string', $u);
}


function getDataObraId($id_obra) {
    conectar();
    $u = fungetDataObraId($id_obra);
    return new soapval('return', 'xsd:string', $u);
}
//-------------------------------------------------------------

function agregarContenidoObra($id_obra, $tipo, $nombre) {
    conectar();
    $mod = funagregarContenidoObra($id_obra, $tipo, $nombre);
    return new soapval('return', 'xsd:string', $mod);
}

function modificarContenidoObra($id_obra, $tipo) {
    conectar();
    $mod = funmodificarContenidoObra($id_obra, $tipo);
    return new soapval('return', 'xsd:string', $mod);
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

function getDatosVisita() {
    conectar();
    $u = fungetDatosVisita();
    return new soapval('return', 'xsd:string', $u);
}

/////////////////////////////////////ZONA/////////////////

function AltaZona($largo, $ancho, $x, $y, $nombre_obra) {
    conectar();
    $reg = funAltaZona($largo, $ancho, $x, $y, $nombre_obra);
    return new soapval('return', 'xsd:string', $reg);
}

function borrarZona($id_zona) {
    conectar();
    $bor = funborrarZona($id_zona);
    return new soapval('return', 'xsd:string', $bor);
}

function modificarZona($id_zona, $largo, $ancho, $x, $y) {
    conectar();
    $mod = funmodificarZona($id_zona, $largo, $ancho, $x, $y);
    return new soapval('return', 'xsd:string', $mod);
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

function getContenidoZonaNombre($nombre_zona) {
    conectar();
    $u = fungetContenidoZonaNombre($nombre_zona);
    return new soapval('return', 'xsd:string', $u);
}

function getZonaObra($nombre_obra) {
    conectar();
    $u = fungetZonaObra($nombre_obra);
    return new soapval('return', 'xsd:string', $u);
}

function getZonas() {
    conectar();
    $u = fungetZonas();
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
