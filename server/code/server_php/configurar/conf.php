<?php

function escribe_ini($matriz, $archivo, $multi_secciones = true, $modo = 'w') {
     $salida = '';
 
     # saltos de lnea (usar "\r\n" para Windows)
     define('SALTO', "\n");
 
     if (!is_array(current($matriz))) {
         $tmp = $matriz;
         $matriz['tmp'] = $tmp; # no importa el nombre de la seccin, no se usar
         unset($tmp);
     }
 
     foreach($matriz as $clave => $matriz_interior) {
         if ($multi_secciones) {
             $salida .= '['.$clave.']'.SALTO;
         }
 
         foreach($matriz_interior as $clave2 => $valor)
             $salida .= $clave2.' = "'.$valor.'"'.SALTO;
 
         if ($multi_secciones) {
             $salida .= SALTO;
         }
     }
 
     $puntero_archivo = fopen($archivo, $modo);
 
     if ($puntero_archivo !== false) {
         $escribo = fwrite($puntero_archivo, $salida);
 
         if ($escribo === false) {
             $devolver = -2;
         } else {
             $devolver = $escribo;
         }
 
         fclose($puntero_archivo);
     } else {
         $devolver = -1;
     }
 
     return $devolver;
 } 
 
 

 $array['BD']['servidor'] = $_POST["ipservidor"];
	$array['BD']['nombase'] = $_POST["bd"];
	$array['BD']['usuario'] = $_POST["adminbase"];
	$array['BD']['passbd']= $_POST["passbase"];

	 $array['RUTA']['zona'] = $_POST["rzona"];
	$array['RUTA']['obra'] = $_POST["robra"];
	$array['RUTA']['sala'] = $_POST["rsala"];
	
	
	$rutaencuadro="./encuadroSift";
	$encuadro=$_POST["rencuadro"];
	$encuadro=$encuadro.$rutaencuadro;
	
	$array['RUTA']['encuadro']= $encuadro;
	
	
	
	
	$array['RUTA']['include']= $_POST["rinclude"];
	
	$array['ftp']['servidor']= $_POST["sftp"];
	
	$array['ftpsala']['usu']= $_POST["ussala"];
	$array['ftpsala']['pass']= $_POST["psala"];
	
	$array['ftpzona']['usu']= $_POST["uszona"];
	$array['ftpzona']['pass']= $_POST["pzona"];
	
	$array['ftpobra']['usu']= $_POST["usobra"];
	$array['ftpobra']['pass']= $_POST["pobra"];

	$array['ns']['ns']= $_POST["ns"];
	
	escribe_ini($array,"C:\\prueba\\confi.ini");
	
	echo "1";
?>