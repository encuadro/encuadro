<?php
# conexión con el servidor FTP


$direccion=$_POST['ipservidorftp'];
$usuario=$_POST['usuario'];
$pass=$_POST['pass'];



if($x=@ftp_connect ($direccion,21)){
    //echo "Conexión FTP activada<br>";
	$respuesta=0;
	
}else{
   // echo "No se activo lo conexión FTP<br>";
	$respuesta=1;
   
  }
# registro de usuario
if(@ftp_login($x,$usuario,$pass)){
    //echo "El login y la password han sido aceptados";

	$respuesta=0;
	
	}else{
    //echo "Error en login o password";
	$respuesta=1;
	
	}
#desconexión
ftp_quit($x);

echo $respuesta;
?>