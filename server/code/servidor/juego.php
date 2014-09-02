<?php

//$ini_array = parse_ini_file("/var/include/confi.ini", true);
//$ruta = $ini_array['RUTA']['include'];
//include($ruta."funciones.php");
/*
funBuscarPista($idObra){
	$u = ""; 
	$query = mysql_query("SELECT * FROM Pista WHERE id_obra='$idObra'") or die(mysql_error());
    	$row = mysql_fetch_array($query);
    	if ($row != NULL) {
       	 	$u = $row['id_juego']. "=>". $row['id_proxima']. "=>". $row['pista']. "=>";
    	}
    	return $u;
}*/


/*
funSetFinJuego($idJuego,$finalizado,$idVisitante){
	$u = ""; 
 	try 	{
		$query = mysql_query("UPDATE  Juego_visitante SET  Finalizado =  '$finalizado' WHERE  id_visitante = '$idVisitante'AND  id_juego ='$idJuego'") or die(mysql_error());
	    	$u=1;
	} catch (Exception $e) {
            $u = -1;
        }
    	return $u;
}

funGetJuegos(){
	$u = ""; 
	$query = mysql_query("SELECT * FROM Juego") or die(mysql_error());
    	$row = mysql_fetch_array($query);
    	if ($row != NULL) {
       	 	$u = $row['idjuego']. "=>". $row['pista']. "=>";
    	}
    	return $u;
}

funAltaJuego($nombre){
	$u = ""; 
 	try 	{
		$query = mysql_query("INSERT INTO Juego (nombre) VALUES ($nombre)") or die(mysql_error());
	    	$u=1;
	} catch (Exception $e) {
            $u = -1;
        }
    	return $u;
}
*/

?>
