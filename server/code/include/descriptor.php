<?php
require_once("config.php");
$sift = $ini_array["RUTA"]["encuadro"];
$obras = $ini_array["RUTA"]["obra"];
function fungetNombreObra ($id_sala, $nombre_archivo)
{
global $ini_array ,$obras, $sift;
mensaje_log("FUNCION GET NOMBRE OBRA (DESCRIPTORES)");
$host = $ini_array['BD']['servidor'];
$username = $ini_array['BD']['usuario'];
$userpass = $ini_array['BD']['passbd'];
$name = $ini_array['BD']['nombase'];
exec("convert -scale 100% ".$obras.$nombre_archivo." ".$obras.$nombre_archivo.".pgm");
mensaje_log("CONVERT FILE OK");
//exec("convert -scale 100% /var/www/obras/".$nombre_archivo." /var/www/obras/".$nombre_archivo.".pgm");
//exec("convert /home/server/proyecto/obras/".$nombre_archivo." /home/server/proyecto/obras/".$nombre_archivo.".pgm");
$u=-1;
//$u = exec("/home/encuadro/proyecto/prueba_binario/./encuadroSift /var/www/obras/".$nombre_archivo.".pgm ".$id_sala." ".$host." ".$username." ".$userpass." ".$name);
mensaje_log($sift." ".$obras.$nombre_archivo.".pgm ".$id_sala." ".$host." ".$username." ".$userpass." ".$name);
$u = exec($sift." ".$obras.$nombre_archivo.".pgm ".$id_sala." ".$host." ".$username." ".$userpass." ".$name);	

//exec("rm /var/www/obras/".$nombre_archivo." /var/www/obras/".$nombre_archivo.".pgm");
//exec("rm ".$obras.$nombre_archivo." ".$obras.$nombre_archivo.".pgm");
return $u;//return tojson($u);

}


function fungenerarDescriptor ($id_sala,$id_obra,$nombre_archivo)
{
global $ini_array,$sift,$obras;
//$ini_array = parse_ini_file("/var/include/confi.ini", true);

$host = $ini_array['BD']['servidor'];
$username = $ini_array['BD']['usuario'];
$userpass = $ini_array['BD']['passbd'];
$name = $ini_array['BD']['nombase'];

mensaje_log("FUNCION GENERAR DESCRIPTOR (DESCRIPTORES)");


$nombre_archivo2 = $nombre_archivo;
$recortado = substr($nombre_archivo2,0,strpos($nombre_archivo2,'.')-strlen($nombre_archivo2));
//exec("convert /var/www/obras/".$id_obra."/imagen/".$nombre_archivo." /var/www/obras/".$id_obra."/imagen/".$recortado.".pgm");
exec("convert ".$obras.$id_obra."/imagen/".$nombre_archivo." ".$obras.$id_obra."/imagen/".$recortado.".pgm");
$res = -1;
//$res=exec("/home/encuadro/proyecto/prueba_binario/encuadroSift /var/www/obras/".$id_obra."/imagen/".$recortado.".pgm ".$id_obra." ".$host." ".$username." ".$userpass." ".$name." generar");
$res=exec($sift." ".$obras.$id_obra."/imagen/".$recortado.".pgm ".$id_obra." ".$host." ".$username." ".$userpass." ".$name." generar");

	return $u;//return tojson($res);


}




?>
