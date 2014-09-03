<?php

error_log("OBRAS");
////////////////////////////////////////////////////////////Juego/////////////////////////////////

/*
function funAltaJuego($nombre){
	$u = ""; 
 	try 	{
		$query = mysql_query("INSERT INTO Juego (nombre) VALUES ('$nombre')") or die(mysql_error());
	    	$u=1;
	} catch (Exception $e) {
            $u = -1;
        }
    	return $u;

}*/

/*function funAltaJuego($nombre) {
    $reg = -1;
        try {
            $query = mysql_query("INSERT INTO Juego (nombre) VALUES ('$nombre')") or die(mysql_error());
            $reg = 0;
        } catch (Exception $e) {
            $reg = -1;
        }
    return $reg;
}*/










//////////////////////////////////////////////////////////////////////////////////////////////////


require_once("config.php");

function funAltaObra($nombre_obra, $descripcion_obra, $imagen, $id_sala, $autor_obra) {
    global $ini_array;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
    mensaje_log("FUNCION ALTA OBRA (OBRA)");
    $reg = -1;
    $directorio = $ini_array['RUTA']['obra'];
    $query = mysql_query("SELECT nombre_obra FROM obra WHERE nombre_obra = '$nombre_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row == NULL) {
        try {
            $query = mysql_query("INSERT INTO obra (nombre_obra,descripcion_obra,imagen,id_sala,autor) VALUES ('$nombre_obra','$descripcion_obra', '$imagen', '$id_sala', '$autor_obra')") or die(mysql_error());
            $query2 = mysql_query("SELECT id_obra FROM obra WHERE nombre_obra = '$nombre_obra'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            $id = $row2['id_obra'];
            $dir = $directorio . $row2['id_obra'];
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_obra'] . '/audio';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_obra'] . '/video';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_obra'] . '/modelo';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_obra'] . '/imagen';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_obra'] . '/animacion';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $reg = $row2['id_obra'];
            $query3 = mysql_query("INSERT INTO contenido_obra (id_obra) VALUES ('$id')") or die(mysql_error());
        } catch (Exception $e) {
            $reg = -1;
        }
    }
    return $reg;
}

function funborrarObra($id_obra) {
    //$ini_array = parse_ini_file("/var/include/confi.ini", true);
    global $ini_array;
    mensaje_log("FUNCION BORRAR OBRA (OBRA)");    
    $bor = -1;
    $query = mysql_query("SELECT * FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    $nombre_obra = $row['nombre_obra'];
    if ($row != NULL) {
        try {
            $query = mysql_query("DELETE FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
            $query = mysql_query("DELETE FROM contenido_obra WHERE id_obra = '$id_obra'") or die(mysql_error());
		$query = mysql_query("DELETE FROM descriptor WHERE id_obra = '$id_obra'") or die(mysql_error());

            $dir = $ini_array['RUTA']['obra']. $id_obra;
            rrmdir($dir);
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
        $query2 = mysql_query("SELECT * FROM zona WHERE nombre_obra='$nombre_obra'") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $id_zona = $res['id_zona'];
            $query = mysql_query("DELETE FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
            $query = mysql_query("DELETE FROM contenido_zona WHERE id_zona = '$id_zona'") or die(mysql_error());

            $dir = $ini_array['RUTA']['zona']. $id_zona;function fungetObrasl($nombre) {

$u = "";
    $query = mysql_query("SELECT nombre_obra FROM obra LIMIT 1") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $query2 = mysql_query("SELECT * FROM obra WHERE nombre_obra LIKE '$nombre%'") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_obra'] . "=>";
        }
    }
    return $u;

}

            rrmdir($dir);
        }
    }
    return $bor;
}

function funmodificarObra($id_obra, $nombre_obra, $descripcion_obra, $id_sala, $autor_obra) {
    
    mensaje_log("FUNCION MODIFICAR OBRA (OBRA)");    
    $mod = -2;
    $query = mysql_query("SELECT id_obra FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("UPDATE obra SET nombre_obra ='$nombre_obra', descripcion_obra='$descripcion_obra', id_sala='$id_sala', autor='$autor_obra' WHERE id_obra='$id_obra'") or die(mysql_error());
            $mod = 0;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}


function fungetObrasl($nombre) {
    
    mensaje_log("FUNCION GET NOMBRE OBRAS (OBRA)");
	$u = "";
        $query2 = mysql_query("SELECT nombre_obra FROM obra WHERE nombre_obra LIKE '$nombre%'") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_obra'] . "=>";
        }
    return $u;

}


function fungetObras() {
    
    mensaje_log("FUNCION GET OBRAS (OBRA)");    
    $u = "";
    $query = mysql_query("SELECT nombre_obra FROM obra LIMIT 1") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $query2 = mysql_query("SELECT nombre_obra FROM obra") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_obra'] . "=>";
        }
    }
    return $u;
}


function fungetDataObra($nombre_obra) {
    global $ini_array;
    mensaje_log("FUNCION GET DATA OBRA (OBRA)");    
    $u = "";
    
    $query = mysql_query("SELECT * FROM obra WHERE nombre_obra='$nombre_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
	 //$ini_array = parse_ini_file("/var/include/confi.ini", true);
        $usu = $ini_array['ftpobra']['usu'];
        $pass = $ini_array['ftpobra']['pass'];
        $servidor = $ini_array['ftp']['servidor'];
	   $variable = "ftp://".$usu.":".$pass."@".$servidor."/" .$row['id_obra'] . "/imagen/";

        $u = $row['id_obra'] . "=>" . $row['nombre_obra'] . "=>" . $row['descripcion_obra'] . "=>" . $row['descriptor'] . "=>" .  $variable. $row['imagen'] . "=>" . $row['id_sala'] . "=>" . $row['autor'] . "=>";
    }
    return $u;
}
function fungetDataObraId($id) {
    
    mensaje_log("FUNCION GET DATA OBRA ID (OBRA)");    
    $u = "";
    $query = mysql_query("SELECT * FROM obra WHERE id_obra='$id'") or die(mysql_error());

    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['id_obra'] . "=>" . $row['nombre_obra'] . "=>" . $row['descripcion_obra'] . "=>" . $row['descriptor'] . "=>" . $row['imagen'] . "=>" . $row['id_sala'] . "=>" . $row['autor'] . "=>";
    }
    return $u;
}
function funagregarContenidoObra($id_obra,$tipo,$nombre){ 
        global $ini_array ;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
        mensaje_log("FUNCION AGREGAR CONTENIDO OBRA (OBRA)");        
        $usu = $ini_array['ftpobra']['usu'];
        $pass = $ini_array['ftpobra']['pass'];
        $servidor = $ini_array['ftp']['servidor'];
	$mod = -2;   
	 $query = mysql_query("SELECT * FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
	 $row = mysql_fetch_array($query);
	 if($row != NULL)
	 {
		try{
			$id= $row['id_obra'];
			$variable = $nombre;		       
			if($tipo != "imagen")
				$query = mysql_query("UPDATE contenido_obra SET $tipo = '$variable' WHERE id_obra = '$id'") or die(mysql_error());
			else
			{	$query = mysql_query("UPDATE contenido_obra SET $tipo = '$variable' WHERE id_obra = '$id'") or die(mysql_error());
				$query = mysql_query("UPDATE obra SET $tipo = '$variable' WHERE id_obra = '$id'") or die(mysql_error());
			}
		        if ($tipo == "texto"){
				$mod = "1";
			}
			else
				if ($tipo == "animacion")
				{
				$v = explode("=>",$nombre);
				for($i=0;$i<5;$i++){
					$r[$i] = "ftp://".$usu.":".$pass."@".$servidor."/".$id_obra."/".$tipo."/".$v[$i]."=>";
				}
				$mod = $r[0].$r[1].$r[2].$r[3].$r[4];
			
			}			
			else{
				$mod  = "ftp://".$usu.":".$pass."@".$servidor."/".$id_obra."/".$tipo."/".$variable;
				funconvertirvideo($id_obra);
			}
		}
		catch(Exception $e){
			$mod = -1;
		}
	 }
	
	//funconvertirvideo($id_obra);
	 return $mod; 
}

// nuevo 2013 convertir imagen y video---------------------------------------------------------------------------------------------
function funconvertirvideo($id_obra)
{		
	//$id_obra=180;
	global $ini_array;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
    mensaje_log("FUNCION CONVERTIR VIDEO (OBRA)");	
     $dir = $ini_array['RUTA']['obra'] . $id_obra .'/'. "video" . '/';
	
	$query = mysql_query("SELECT * FROM contenido_obra WHERE id_obra = '$id_obra'") or die(mysql_error());
	$res = mysql_fetch_array($query);
	$u = $dir.$res['video'];
	$temp=strpos($u,".");
	
	//$extension=substr($u,$temp);//$u[$temp];
	$rutasinext=substr($u,0,$temp);
	

		
	$salida=$rutasinext.'.mp4';
	$salida2=$rutasinext.'.mov';
	

		
	//echo "Starting ffmpeg...\n\n";
	shell_exec("ffmpeg -i $u -s 640x480 -acodec aac -ac 2 -strict experimental -vcodec libx264 -level 30 -ab 128k $salida");
	shell_exec("ffmpeg -i $u -s 640x480 -acodec aac -ac 2 -strict experimental -vcodec libx264 -level 30 -ab 128k $salida2");
	
	//echo "Done.\n";
	return $id_obra;
}

function funconvertirimagen($id_obra)
{
    global $ini_array ;
    mensaje_log("FUNCION CONVERTIR IMAGEN (OBRA)");
	$dir = $ini_array['RUTA']['obra'] . $id_obra . '/' . "imagen" . '/';
	$query = mysql_query("SELECT imagen FROM contenido_obra WHERE id_obra = $id_obra") or die(mysql_error());
	$res = mysql_fetch_assoc($query);
	$u = $dir.$res['imagen'];
	$temp=strpos($u,".");
	$rutasinext=substr($u,0,$temp);	
	$salida=$rutasinext.'-mini'.'.jpg';
	shell_exec("convert $u -resize 50x50 $salida");
	return $id_obra;
}



function funmodificarContenidoObra($id_obra, $tipo) {
    global $ini_array;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
    mensaje_log("FUNCION MODIFICAR CONTENIDO OBRA (OBRA)");    
    $mod = -2;
    $query = mysql_query("SELECT * FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $id = $row['id_obra'];
            $dir = $ini_array['RUTA']['obra'] . $id . '/' . $tipo . '/';
            rrmdir2($dir);
            $mod = 0;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function fungetContenidoObra($nombre) {
    global $ini_array;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
    mensaje_log("FUNCION GET CONTENIDO OBRA (OBRA)");    
    $usu = $ini_array['ftpobra']['usu'];
    $pass = $ini_array['ftpobra']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
   
    $u = "";
    $query = mysql_query("SELECT * FROM obra WHERE nombre_obra = '$nombre'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        try {
            $id = $row['id_obra'];
	    $variable = "ftp://".$usu.":".$pass."@".$servidor."/" . $id . "/";
            $descripcion = $row['descripcion_obra'];
            $autor = $row['autor'];
            $query2 = mysql_query("SELECT * FROM contenido_obra WHERE id_obra='$id'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            if ($row2 != NULL) {
		
		if ($row2['animacion'] != 'null=>null=>null=>null=>null=>'){
			$v = explode("=>",$row2['animacion'] );			
			for($i=0;$i<5;$i++){
				$r[$i] = "ftp://".$usu.":".$pass."@".$servidor."/".$id."/animacion/".$v[$i]."=>";
			}
			$anim = $r[0].$r[1].$r[2].$r[3].$r[4];	        
		}else
		     $anim= $row2['animacion'];
		if($row2['audio'] != 'null')
			$audio = $variable."audio/". $row2['audio'];
		else
			$audio = $row2['audio'];
		
		if($row2['video'] != 'null')
			$video = $variable."video/". $row2['video'];
		else
			$video = $row2['video'];
		if ($row2['modelo']!='null')
			$modelo = $variable."modelo/". $row2['modelo'];
		else
			$modelo = $row2['modelo'];
		if ($row2['imagen']!='null')
			$imagen = $variable."imagen/". $row2['imagen'];
		else
			$imagen = $row2['imagen'];
			
                $u = $id . "=>" .$audio . "=>" .$video . "=>" . $row2['texto'] . "=>" .$modelo. "=>" .$imagen. "=>" . $descripcion . "=>" . $autor . "=>" .$anim;
            }
        } catch (Exception $e) {
            $u = -1;
        }
    }
    return $u;
}

function fungetObraSala($id) {
    
    mensaje_log("FUNCION GET OBRA SALA (OBRA)");    
    $u = "";    
    $query = mysql_query("SELECT * FROM obra WHERE id_sala='$id'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        $query2 = mysql_query("SELECT * FROM obra WHERE id_sala='$id'") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_obra'] . "=>";
        }
    }
    return $u;
}

function fungetAllDataObraSala($id) {
    global $ini_array ;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
    mensaje_log("FUNCION GET ALL DATA OBRA SALA (OBRA)");    
    $usu = $ini_array['ftpobra']['usu'];
    $pass = $ini_array['ftpobra']['pass'];
    $servidor = $ini_array['ftp']['servidor'];   
    $u = "-1";
    $query = mysql_query("SELECT * FROM obra,contenido_obra WHERE obra.id_obra=contenido_obra.id_obra and obra.id_sala='$id'") or die(mysql_error());
    while ($row = mysql_fetch_assoc($query)) {
        if ($u == "-1")
            $u = "";
	 if($row['imagen'] != 'null')
		 $variable = "ftp://".$usu.":".$pass."@".$servidor."/" .$row['id_obra'] . "/imagen/". $row['imagen'] ;
	else
		$variable = $row['imagen']; 
        $u = $u . $row['id_obra'] . "=>" . $row['nombre_obra'] . "=>" . $row['autor'] . "=>" . $row['descripcion_obra'] . "=>" . $variable . "=>";
    }

    return $u;
}



?>
