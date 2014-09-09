<?php

//$ini_file = "/var/include/confi.ini";
//$ini_array = parse_ini_file($ini_file,true);
require_once("config.php");
mensaje_log('SALAS');
 
function fungetAllDataSalas() {	    
    global $ini_array;    
    $u = "-1";
    //$ini_array = parse_ini_file($ini_file, true);
    $usu = $ini_array['ftpsala']['usu'];
    $pass = $ini_array['ftpsala']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
    
    $query = mysql_query("SELECT * FROM sala,contenido_sala WHERE sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
    while ($row = mysql_fetch_assoc($query)) {
        if ($u == "-1")
            $u = "";
        $variable = "ftp://".$usu.":".$pass."@".$servidor."/" . $row['id_sala'] . "/imagen/";
        $u = $u . $row['id_sala'] . "=>" . $row['nombre_sala'] . "=>" . $row['descripcion_sala'] . "=>" .$variable.$row['imagen'] . "=>";
    }
    return $u;
}
function fungetListImgSalas() {  
    $u = "-1";
    $query = mysql_query("SELECT * FROM sala,contenido_sala WHERE sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
    while ($row = mysql_fetch_assoc($query)) {
        $u = $row['nombre_sala'] . "=>" .$row['imagen'] . "=>";
    }
    return $u;
}

function funAltaSala($nombre_sala, $descripcion_sala) {
    global $ini_array;    
    mensaje_log("FUNCION ALTA SALA");	  
    //$ini_array = parse_ini_file($ini_file, true);
    $reg = -1;   
    $directorio = $ini_array['RUTA']['sala'];//"/home/server/proyecto/salas/";
    $query = mysql_query("SELECT * FROM sala WHERE nombre_sala = '$nombre_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row == NULL) {
        try {
            $query = mysql_query("INSERT INTO sala (nombre_sala,descripcion_sala) VALUES ('$nombre_sala','$descripcion_sala')") or die(mysql_error());
            $query2 = mysql_query("SELECT * FROM sala WHERE nombre_sala = '$nombre_sala'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            $id = $row2['id_sala'];
            $query2 = mysql_query("INSERT INTO contenido_sala (id_sala) VALUES ('$id')") or die(mysql_error());
            $dir = $directorio . $row2['id_sala'];
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_sala'] . '/audio';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_sala'] . '/video';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_sala'] . '/modelo';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_sala'] . '/imagen';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);                     
            $reg = $row2['id_sala'];
        } catch (Exception $e) {
            $reg = -1;
        }
    }
    return $reg;
}

function funborrarSala($id_sala) {
    global $ini_array;
    mensaje_log("FUNCION BORRAR SALA (SALA)");    
    //$ini_array = parse_ini_file("/var/include/confi.ini", true);
    $dirsala = $ini_array['RUTA']['sala'];
    $dirobra = $ini_array['RUTA']['obra'];
    $dirzona = $ini_array['RUTA']['zona'];
    $bor = -1;
    $id_obra = -1;
    $query = mysql_query("SELECT nombre_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("DELETE FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
            $query = mysql_query("DELETE FROM contenido_sala WHERE id_sala = '$id_sala'") or die(mysql_error());
            $dir = $dirsala . $id_sala;
            rrmdir($dir);
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
////////////////////borra obras de la sala
        try {
            $query2 = mysql_query("SELECT * FROM obra WHERE id_sala='$id_sala'") or die(mysql_error());

            while ($res = mysql_fetch_assoc($query2)) {
                $id_obra = $res['id_obra'];
                $nombre_obra = $res['nombre_obra'];

                $query = mysql_query("DELETE FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
                $query = mysql_query("DELETE FROM contenido_obra WHERE id_obra = '$id_obra'") or die(mysql_error());

                $dir = $dirobra . $id_obra;
                rrmdir($dir);
/////borra zonas de la obra
                $query3 = mysql_query("SELECT * FROM zona WHERE nombre_obra='$nombre_obra'") or die(mysql_error());

                while ($res2 = mysql_fetch_assoc($query3)) {
                    $id_zona = $res2['id_zona'];
                    $query = mysql_query("DELETE FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
                    $query = mysql_query("DELETE FROM contenido_zona WHERE id_zona = '$id_zona'") or die(mysql_error());

                    $dir = $dirzona . $id_zona;
                    rrmdir($dir);
                }
            }
        } catch (Exception $e) {
            $bor = -2;
        }
    }
    return $bor;
}

function funmodificarSala($id_sala, $nombre_sala, $descripcion_sala) {
    
    mensaje_log("FUNCION MODIFICAR SALA (SALA)");
    $mod = -2;
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("UPDATE sala SET nombre_sala='$nombre_sala', descripcion_sala='$descripcion_sala' WHERE id_sala='$id_sala'") or die(mysql_error());
            $mod = 0;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function funsetQr($id_sala, $qr) {
    global $ini_array,$enable_log;
    mensaje_log("FUNCION SET QR (SALA)");    
    //$ini_array = parse_ini_file("/var/include/confi.ini", true);
    $usu = $ini_array['ftpsala']['usu'];
    $pass = $ini_array['ftpsala']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
    $mod = -2;
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("UPDATE sala SET qr='$qr' WHERE id_sala='$id_sala'") or die(mysql_error());
            $mod = "ftp://".$usu.":".$pass."@".$servidor."/". $id_sala . "/imagen/" . $qr;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function fungetSalas() {
    
    mensaje_log("FUNCION GET SALAS (SALA)");    
    $u = "";
    $query = mysql_query("SELECT * FROM sala") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        $query2 = mysql_query("SELECT * FROM sala") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['id_sala'] . "=>";
            $u = $u . $res['nombre_sala'] . "=>";
        }
    }
    return $u;
}

function fungetNombreSalas() {
     ;
    mensaje_log("FUNCION GET NOMBRE SALAS (SALA)");    
    $u = "";
    $query = mysql_query("SELECT nombre_sala FROM sala") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $query2 = mysql_query("SELECT nombre_sala FROM sala") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_sala'] . "=>";
        }
    }
    return $u;
}

function fungetDataSalaId($id_sala) {
    
    mensaje_log("FUNCION GET DATA SALA ID (SALA)");
    $u = "";
    $query = mysql_query("SELECT * FROM sala WHERE id_sala='$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['nombre_sala'] . "=>" . $row['descripcion_sala'] . "=>";
    }
    return $u;
}


function fungetDataSalaId2($id_sala){   
    global $ini_array;
    mensaje_log("FUNCION GET DATA SALA ID2 (SALA)");    
    $u = "-1";
	//$ini_array = parse_ini_file("/var/include/confi.ini", true);
    $usu = $ini_array['ftpsala']['usu'];
    $pass = $ini_array['ftpsala']['pass'];
    $servidor = $ini_array['ftp']['servidor'];

     $query = mysql_query("SELECT * FROM sala WHERE id_sala='$id_sala'") or die(mysql_error());
     $row = mysql_fetch_array($query);
     if ($row != NULL) {
	if($u=="-1")
	    $u="";
        $u = $row['nombre_sala']."=>".$row['descripcion_sala']."=>"; 
      }
     $query = mysql_query("SELECT * FROM contenido_sala WHERE id_sala='$id_sala'") or die(mysql_error());
     $row = mysql_fetch_array($query);
     if ($row != NULL) {
	if($u=="-1")
	     $u="";
         $variable = "ftp://".$usu.":".$pass."@".$servidor."/" .$id_sala . "/imagen/";
        $u = $u.$variable.$row['imagen']."=>"; 
      }
    return $u;     
 }

function fungetDataSalaNombre($nombre) {
     
    mensaje_log("FUNCION GET DATA SALA NOMBRE (SALA)");
    $u = "";
    $query = mysql_query("SELECT * FROM sala WHERE nombre_sala='$nombre'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['id_sala'] . "=>" . $row['descripcion_sala'] . "=>";
    }
    return $u;
}

function fungetDataSalaNombreImagen($nombre){
     //conectar();
     ;
    mensaje_log("FUNCION GET DATA SALA NOMBRE IMAGEN (SALA)");
     $u = "";
	try{
	    $query = mysql_query("SELECT sala.id_sala, sala.nombre_sala, sala.descripcion_sala, contenido_sala.imagen FROM sala, contenido_sala WHERE  sala.nombre_sala='$nombre' AND sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
     	    $row = mysql_fetch_array($query);
            if ($row != NULL) {
                $u = $row['id_sala']."=>".$row['nombre_sala']."=>".$row['descripcion_sala']."=>".$row['imagen']."=>"; 
            }
	} catch (Exception $e) {
            $u = "PHP se la come=>";
        }

    return $u;     
 }

function fungetDataSalaIdImagen($id){
     //conectar();
    
    mensaje_log("FUNCION GET DATA SALA ID IMAGEN (SALA)");
     $u = "";
	try{
	    $query = mysql_query("SELECT sala.id_sala, sala.nombre_sala, sala.descripcion_sala, contenido_sala.imagen FROM sala, contenido_sala WHERE  sala.id_sala='$id' AND sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
     	    $row = mysql_fetch_array($query);
            if ($row != NULL) {
                $u = $row['id_sala']."=>".$row['nombre_sala']."=>".$row['descripcion_sala']."=>".$row['imagen']."=>"; 
            }
	} catch (Exception $e) {
            $u = "PHP se la come=>".$e;
        }

    return $u;     
 }
function fungetVideoSalaId($id){
     //conectar();
     
    mensaje_log("FUNCION GET VIDEO SALA ID (SALA)");
     $u = "0";
	try{
	    $query = mysql_query("SELECT contenido_sala.video FROM sala, contenido_sala WHERE  sala.id_sala='$id' AND sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
     	    $row = mysql_fetch_array($query);
            if ($row != NULL) {
                $u = $row['video']; 
            }
	} catch (Exception $e) {
            $u = "-1".$e;
        }

    return $u;     
 }
//-----------------------------------------------------NUEVO----------------------------
function fungetSalasl($nombre) {
     
    mensaje_log("FUNCION GET SALAS LIKE (SALA)");

	$u = "";
        $query2 = mysql_query("SELECT nombre_sala FROM sala WHERE nombre_sala LIKE '$nombre%'") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_sala'] . "=>";
        }

    return $u;

}

//-----------------------------------------------------NUEVO----------------------------
function funagregarContenidoSala($id_sala, $tipo, $nombre) {
    global $ini_array;
    mensaje_log("FUNCION AGREGAR CONTENIDO SALA");    
    //$ini_array = parse_ini_file("/var/include/confi.ini", true);
    $usu = $ini_array['ftpsala']['usu'];
    $pass = $ini_array['ftpsala']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
    $mod = "-2";
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $id = $row['id_sala'];
            $variable = $nombre;
            
            $query = mysql_query("UPDATE contenido_sala SET $tipo = '$variable' WHERE id_sala = '$id'") or die(mysql_error());
	    if ($tipo != "texto") {
                $variable = "ftp://".$usu.":".$pass."@".$servidor."/" . $id . "/" . $tipo . "/" . $nombre;
            }
            if ($tipo == "texto") {
                $mod = "1";
            } else {
                $mod = $variable;
            }
        } catch (Exception $e) {
            $mod = "-1";
        }
    }
    return $mod;
}

function funagregarContenidoSala2($id_sala, $tipo, $nombre) {
    
    mensaje_log("FUNCION AGREGAR CONTENIDO SALA 2 (SALA)");
    $mod = -2;
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $id = $row['id_sala'];
            $variable = $nombre;
            $query = mysql_query("UPDATE contenido_sala SET $tipo = '$variable' WHERE id_sala = '$id'") or die(mysql_error());
            $mod = 0;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function fungetContenidoSala($id) {
    global $ini_array;
    mensaje_log("FUNCION GET CONTENIDO SALA SALA (SALA)");    
    //$ini_array = parse_ini_file("/var/include/confi.ini", true);
    $usu = $ini_array['ftpsala']['usu'];
    $pass = $ini_array['ftpsala']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
    $variable = "ftp://".$usu.":".$pass."@".$servidor."/" . $id . "/";
    $u = "";
    $query = mysql_query("SELECT * FROM contenido_sala WHERE id_sala='$id'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
		if($row['audio'] != 'null')
			$audio = $variable."audio/". $row['audio'];
		else
			$audio = $row['audio'];
		
		if($row['video'] != 'null')
			$video = $variable."video/". $row['video'];
		else
			$video = $row['video'];

		if ($row['modelo']!='null')
			$modelo = $variable."modelo/". $row['modelo'];
		else
			$modelo = $row['modelo'];

		if ($row['imagen']!='null')
			$imagen = $variable."imagen/". $row['imagen'];
		else
			$imagen = $row['imagen'];
	$u = $audio . "=>" .$video . "=>" . $row['texto'] . "=>" .$modelo. "=>" .$imagen. "=>";

    }
    return $u;
}

function funexisteSala($id) {
    
    mensaje_log("FUNCION EXISTE SALA (SALA)");
    $u = 0;
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala='$id'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = 1;
    }
    return $u;
}

?>
