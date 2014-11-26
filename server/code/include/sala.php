<?php

//$ini_file = "/var/include/confi.ini";
//$ini_array = parse_ini_file($ini_file,true);
require_once("config.php");
mensaje_log('SALAS');
 
function fungetAllDataSalas() {	    
    global $ini_array;    
    $u = "-1";
	$json = array(array());
	$indice = 0;
    //$ini_array = parse_ini_file($ini_file, true);
    $usu = $ini_array['ftpsala']['usu'];
    $pass = $ini_array['ftpsala']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
    mensaje_log("QUERY TODOS LOS DATOS DE LAS SALAS");
    $query = mysql_query("SELECT * FROM sala,contenido_sala WHERE sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
    while ($row = mysql_fetch_assoc($query)) {
        if ($u == "-1")
            $u = "";
        $variable = "ftp://".$usu.":".$pass."@".$servidor."/" . $row['id_sala'] . "/imagen/";
        $u = $u . $row['id_sala'] . "=>" . $row['nombre_sala'] . "=>" . $row['descripcion_sala'] . "=>" .$variable.$row['imagen'] . "=>";
		$json[$indice++]= array('id_sala'=>$row['id_sala'], 'nombre_sala' =>utf8_encode($row['nombre_sala']),'descripcion'=>utf8_encode($row['descripcion_sala']),
				'imagen'=>utf8_encode($variable.$row['imagen']));
    }
    return tojson($json,2);
}
function fungetListImgSalas() {  
    $u = "-1";
	$json = array(array());
	$indice = 0;
    mensaje_log("QUERY LISTA DE IMAGENES DE SALA");
    $query = mysql_query("SELECT * FROM sala,contenido_sala WHERE sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
    while ($row = mysql_fetch_assoc($query)) {
        $u = $row['nombre_sala'] . "=>" .$row['imagen'] . "=>";
		$json[$indice++] = array('nombre_sala' => utf8_encode($row['nombre_sala']), 'imagen'=>utf8_encode($row['imagen']));
    }
    return tojson($json,2);
}

function funAltaSala($nombre_sala, $descripcion_sala) {
    global $ini_array;    
    mensaje_log("ALTA SALA");	  
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
            mensaje_log("SE CREO UNA NUEVA SALA DE NOMBRE=".$nombre_sala.", DESCRIPCION=".$descripcion_sala,1);
        } catch (Exception $e) {
                mensaje_log($e->getMessage(),3);                
                $reg = -1;
        }
    }
    
    return tojson($reg);
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
            mensaje_log("SE ELIMINO LA SALA:".$id_sala,1);
        } catch (Exception $e) {
            mensaje_log($e->getMessage(),3);
            $bor = -1;
        }
////////////////////borra obras de la sala
        try {
            mensaje_log("ELIMINANDO TODAS LAS OBRAS DE LA SALA ".$id_sala." ...",1);
            $query2 = mysql_query("SELECT * FROM obra WHERE id_sala='$id_sala'") or die(mysql_error());

            while ($res = mysql_fetch_assoc($query2)) {
                $id_obra = $res['id_obra'];
                $nombre_obra = $res['nombre_obra'];

                $query = mysql_query("DELETE FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
                $query = mysql_query("DELETE FROM contenido_obra WHERE id_obra = '$id_obra'") or die(mysql_error());
                mensaje_log("SE ELIMINO LA OBRA".$id_obra,2);

                $dir = $dirobra . $id_obra;
                rrmdir($dir);
/////borra zonas de la obra
                $query3 = mysql_query("SELECT * FROM zona WHERE nombre_obra='$nombre_obra'") or die(mysql_error());
                mensaje_log("ELIMINANDO TODAS LAS ZONAS DE LA OBRA ".$id_obra." ...",1);
                while ($res2 = mysql_fetch_assoc($query3)) {
                    $id_zona = $res2['id_zona'];
                    $query = mysql_query("DELETE FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
                    $query = mysql_query("DELETE FROM contenido_zona WHERE id_zona = '$id_zona'") or die(mysql_error());

                    $dir = $dirzona . $id_zona;
                    rrmdir($dir);
                    mensaje_log("ELIMINANDO ZONA ".$id_zona,2);
                }
            }
        } catch (Exception $e) {
            mensaje_log($e->getMessage(),3);
            $bor = -2;
        }
    }
    return tojson($bor);
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
            mensaje_log("SE MODIFICARON LOS DATOS DE LA SALA DE ID=".$id_sala." NUEVO NOMBRE=".$nombre_sala.", NUEVA DESCRIPCION=".$descripcion_sala,1);
        } catch (Exception $e) {
            mensaje_log($e->getMessage(),3);
            $mod = -1;
        }
    }
    return tojson($mod);
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
            mensaje_log("SE LE ASIGNO UN NUEVO QR A LA SALA=".$id_sala,1);
        } catch (Exception $e) {
            mensaje_log($e->getMessage(),3);
            $mod = -1;
        }
    }
    return tojson($mod);
}

function fungetSalas() {
    
    mensaje_log("FUNCION GET SALAS (SALA)");    
    $u = "";
	$json = array(array());
	$indice = 0;
    $query = mysql_query("SELECT * FROM sala") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        $query2 = mysql_query("SELECT * FROM sala") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['id_sala'] . "=>";
            $u = $u . $res['nombre_sala'] . "=>";
			$json[$indice++]=array('id_sala' => $res['id_sala'], 'nombre_sala' => utf8_encode($res['nombre_sala']));
        }
    }
    return tojson($json,2);
}

function fungetNombreSalas() {
     ;
    mensaje_log("FUNCION GET NOMBRE SALAS (SALA)");    
    $u = "";
    $json = array(array());
	$indice = 0;
    $query = mysql_query("SELECT nombre_sala FROM sala") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $query2 = mysql_query("SELECT nombre_sala FROM sala") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_sala'] . "=>";
			$json[$indice++]=array('nombre_sala' => utf8_encode($res['nombre_sala']));
        }
    }
    return tojson($json,2);
}

function fungetDataSalaId($id_sala) {
    
    mensaje_log("FUNCION GET DATA SALA ID (SALA)");
    $u = "";
	$json = array();
    $query = mysql_query("SELECT * FROM sala WHERE id_sala='$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['nombre_sala'] . "=>" . $row['descripcion_sala'] . "=>";
        mensaje_log("RETORNANDO DATOS DE SALA DE ID=".$id_sala,1);
		$json = array('nombre_sala' => utf8_encode($row['nombre_sala']), 'descripcion_sala'=>utf8_encode($row['descripcion_sala']));
    }
    return tojson($json,1);
}


function fungetDataSalaId2($id_sala){   
    global $ini_array;
    mensaje_log("FUNCION GET DATA SALA ID2 (SALA)");    
    mensaje_log("INFORMACION DE LA SALA:".$id_sala);
    $u = "-1";
	$json = array();
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
		$json = array('nombre_sala'=> utf8_encode($row['nombre_sala']), 'descripcion'=>utf8_encode($row['descripcion_sala']), 'imagen'=>"");
        mensaje_log("RETORNANDO DATOS DE SALA DE ID=".$id_sala,1);
      }
     $query = mysql_query("SELECT * FROM contenido_sala WHERE id_sala='$id_sala'") or die(mysql_error());
     $row = mysql_fetch_array($query);
     if ($row != NULL) {
	if($u=="-1")
	     $u="";
         $variable = "ftp://".$usu.":".$pass."@".$servidor."/" .$id_sala . "/imagen/";
        $u = $u.$variable.$row['imagen']."=>"; 
		$json['imagen']= utf8_encode($variable);
      }
    return tojson($json,1);     
 }

function fungetDataSalaNombre($nombre) {
     
    mensaje_log("FUNCION GET DATA SALA NOMBRE (SALA)");
    $u = "";
	$json = array();
    $query = mysql_query("SELECT * FROM sala WHERE nombre_sala='$nombre'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['id_sala'] . "=>" . $row['descripcion_sala'] . "=>";
		$json = array('id_sala'=> $row['id_sala'], 'descripcion'=>utf8_encode($row['descripcion_sala']));
        mensaje_log("RETORNANDO DATOS DE SALA DE NOMBRE=".$nombre,1);
    }
    return tojson($json,1);
}

function fungetDataSalaNombreImagen($nombre){
     //conectar();
     ;
    mensaje_log("FUNCION GET DATA SALA NOMBRE IMAGEN (SALA)");
     $u = "";
	 $json = array();
	try{
	    $query = mysql_query("SELECT sala.id_sala, sala.nombre_sala, sala.descripcion_sala, contenido_sala.imagen FROM sala, contenido_sala WHERE  sala.nombre_sala='$nombre' AND sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
     	    $row = mysql_fetch_array($query);
            if ($row != NULL) {
                $u = $row['id_sala']."=>".$row['nombre_sala']."=>".$row['descripcion_sala']."=>".$row['imagen']."=>"; 
				$json = array('id_sala' => $row['id_sala'], 'nombre_sala'=> utf8_encode($row['nombre_sala']), 
								'descripcion'=>utf8_encode($row['descripcion_sala']), 'imagen' => utf8_encode($row['imagen']));
                mensaje_log("RETORNANDO DATOS DE SALA DE NOMBRE=".$nombre,1);       
            }
	} catch (Exception $e) {
            mensaje_log($e->getMessage(),3);
            $u = "PHP se la come=>";
        }

    return tojson($json,1);     
 }

function fungetDataSalaIdImagen($id){
     //conectar();
    
    mensaje_log("FUNCION GET DATA SALA ID IMAGEN (SALA)");
    $u = "";
	$json = array();
	try{
	    $query = mysql_query("SELECT sala.id_sala, sala.nombre_sala, sala.descripcion_sala, contenido_sala.imagen FROM sala, contenido_sala WHERE  sala.id_sala='$id' AND sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
     	    $row = mysql_fetch_array($query);
            if ($row != NULL) {
                $u = $row['id_sala']."=>".$row['nombre_sala']."=>".$row['descripcion_sala']."=>".$row['imagen']."=>"; 
				$json = array('id_sala' => $row['id_sala'], 'nombre_sala'=> utf8_encode($row['nombre_sala']), 
				'descripcion'=>utf8_encode($row['descripcion_sala']), 'imagen' => utf8_encode($row['imagen']));
                mensaje_log("RETORNANDO DATOS DE SALA ID=".$id,1);
            }
	} catch (Exception $e) {
            mensaje_log($e->getMessage(),3);
            $u = "PHP se la come=>".$e;
        }

    return tojson($json,1);     
 }
function fungetVideoSalaId($id){
     //conectar();
     
    mensaje_log("FUNCION GET VIDEO SALA ID (SALA)");
     $u = "0";
	 $json = array();
	try{
	    $query = mysql_query("SELECT contenido_sala.video FROM sala, contenido_sala WHERE  sala.id_sala='$id' AND sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
     	    $row = mysql_fetch_array($query);
            if ($row != NULL) {
                $u = $row['video']; 
				$json = array(utf8_encode($row['video']));
                mensaje_log("RETORNANDO VIDEO DE SALA ID=".$id,1);
            }
	} catch (Exception $e) {
          mensaje_log($e->getMessage(),3);  
          $u = "-1".$e;
        }

    return tojson($json,1);     
 }
//-----------------------------------------------------NUEVO----------------------------
function fungetSalasl($nombre) {
     
    mensaje_log("FUNCION GET SALAS LIKE (SALA)");
	$json = array(array());
	$indice = 0;
	$u = "";
        $query2 = mysql_query("SELECT nombre_sala FROM sala WHERE nombre_sala LIKE '$nombre%'") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_sala'] . "=>";
			$json[$indice++] = array('nombre_sala'=> $res['nombre_sala']);
        }
    mensaje_log("SALAS ENCONTRADAS= ".$u,1);    

    return tojson($json,2);

}

//-----------------------------------------------------NUEVO----------------------------
function funagregarContenidoSala($id_sala, $tipo, $nombre) {
    global $ini_array;
    mensaje_log("FUNCION AGREGAR CONTENIDO SALA (SALA)");    
    //$ini_array = parse_ini_file("/var/include/confi.ini", true);
    $usu = $ini_array['ftpsala']['usu'];
    $pass = $ini_array['ftpsala']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
	$json = array();
    $mod = "-2";
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $id = $row['id_sala'];
            $variable = $nombre;
            
            $query = mysql_query("UPDATE contenido_sala SET $tipo = '$variable' WHERE id_sala = '$id'") or die(mysql_error());
            mensaje_log("AGREGANDO CONTENIDO A LA SALA ID=".$id_sala." ".$tipo." = ".$nombre,1);
	    if ($tipo != "texto") {
                $variable = "ftp://".$usu.":".$pass."@".$servidor."/" . $id . "/" . $tipo . "/" . $nombre;
            }
            if ($tipo == "texto") {
				$json = array('ret' => "1");
                $mod = "1";
            } else {
                $mod = $variable;
				$json = array('ret' => utf8_encode($variable));				
            }
        } catch (Exception $e) {
           mensaje_log($e->getMessage(),3);
           $mod = "-1";
		   $json = array('ret' => "-1");
        }
            
    }
    return tojson($json,1);
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
            mensaje_log("AGREGANDO CONTENIDO A LA SALA ID=".$id_sala." ".$tipo." = ".$nombre,1);
            $mod = 0;
        } catch (Exception $e) {
            mensaje_log($e->getMessage(),3);
            $mod = -1;
        }
    }
    return tojson($mod);
}

function fungetContenidoSala($id) {
    global $ini_array;
    mensaje_log("FUNCION GET CONTENIDO SALA (SALA)");    
    //$ini_array = parse_ini_file("/var/include/confi.ini", true);
    $usu = $ini_array['ftpsala']['usu'];
    $pass = $ini_array['ftpsala']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
    $variable = "ftp://".$usu.":".$pass."@".$servidor."/" . $id . "/";
	$json = array();
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
	$json = array('audio'=> $audio, 'video' => $video, 'texto'=> $texto, 'modelo' => $modelo, 'imagen'=> 'imagen');
    }
    mensaje_log("RETORNANDO EL CONTENIDO DE LA SALA ID=".$id,1);    
    return tojson($json,1);
}

function funexisteSala($id) {
    
    mensaje_log("FUNCION EXISTE SALA (SALA)");
    $u = 0;
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala='$id'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = 1;
        mensaje_log("LA SALA DE ID =".$id." EXISTE",1);
    }else {mensaje_log("LA SALA DE ID =".$id." NO EXISTE",1);}
    return tojson($u);
}

?>
