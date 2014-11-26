<?php
require_once("config.php");
 mensaje_log("ZONA");

function funAltaZona($largo, $ancho, $x, $y, $nombre_obra) {
    global $ini_array ;// = parse_ini_file("/var/include/confi.ini", true);
    mensaje_log("FUNCION ALTA ZONA (ZONA)");
    $reg = -1;
    $directorio = $ini_array['RUTA']['zona'];
    
    $query = mysql_query("SELECT nombre_obra FROM obra WHERE nombre_obra = '$nombre_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("INSERT INTO zona (largo,ancho,x,y,nombre_obra) VALUES ('$largo','$ancho', '$x', '$y', '$nombre_obra')") or die(mysql_error());
            $query2 = mysql_query("SELECT id_zona FROM zona WHERE x = '$x' AND y = '$y' AND nombre_obra ='$nombre_obra' AND largo = '$largo' AND ancho ='$ancho'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            $id = $row2['id_zona'];
            $dir = $directorio . $row2['id_zona'];
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_zona'] . '/audio';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);            
            $dir = $directorio . $row2['id_zona'] . '/video';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_zona'] . '/modelo';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_zona'] . '/imagen';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $reg = $row2['id_zona'];
            $query3 = mysql_query("INSERT INTO contenido_zona (id_zona) VALUES ('$id')") or die(mysql_error());
            
        } catch (Exception $e) {
            $reg = -1;
        }
    }
    return json_encode(array('id_zona'=>$reg);
}

function funborrarZona($id_zona) {
 	global $ini_array;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
	mensaje_log("FUNCION BORRAR ZONA (ZONA)");    
	$bor = -1;
    $query = mysql_query("SELECT id_zona FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    $id = $row['id_zona'];
    if ($row != NULL) {
        try {
            $query = mysql_query("DELETE FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
            $query = mysql_query("DELETE FROM contenido_zona WHERE id_zona = '$id_zona'") or die(mysql_error());

            $dir = $ini_array['RUTA']['zona']. $id_zona;
            rrmdir($dir);
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    }
    return json_encode(array('id_zona'=>$bor);
}

function funmodificarZona($id_zona, $largo, $ancho, $x, $y) {
	
	mensaje_log("FUNCION MODIFICAR ZONA (ZONA)");    
	$mod = -2;
    $query = mysql_query("SELECT id_zona FROM zona WHERE id_zona='$id_zona'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    $id = $row['id_zona'];
    if ($row != NULL) {
        try {
            $query = mysql_query("UPDATE zona SET largo='$largo', ancho='$ancho', x='$x', y='$y' WHERE id_zona='$id'") or die(mysql_error());
            $mod = 0;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return json_encode(array('id_zona'=>$mod);
}

function funagregarContenidoZona($id_zona, $tipo, $nombre) {
    global $ini_array;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
	mensaje_log("FUNCION AGREGAR CONTENIDO ZONA (ZONA)");
	$usu = $ini_array['ftpzona']['usu'];
	$pass = $ini_array['ftpzona']['pass'];
	$servidor = $ini_array['ftp']['servidor'];
    $mod = -2;
    $query = mysql_query("SELECT * FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $id = $row['id_zona'];
            $variable = $nombre;           
            $query = mysql_query("UPDATE contenido_zona SET $tipo = '$variable' WHERE id_zona = '$id'") or die(mysql_error());
            if ($tipo == "texto") {
                $mod = "1";
            } else {
                $mod = "ftp://".$usu.":".$pass."@".$servidor."/".$id_zona."/".$tipo."/".$variable;
            }
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return json_encode(array('contenido_zona'=>utf8_encode($mod));
}

function fungetContenidoZona($id_zona) {
    global $ini_array ;//$ini_array = parse_ini_file("/var/include/confi.ini", true);
	mensaje_log("FUNCION GET CONTENIDO ZONA");
	$usu = $ini_array['ftpzona']['usu'];
    $pass = $ini_array['ftpzona']['pass'];
    $servidor = $ini_array['ftp']['servidor'];
    $variable = "ftp://".$usu.":".$pass."@".$servidor."/" . $id_zona . "/";
    $u = "";
    $query = mysql_query("SELECT * FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

	$json = array();
        try {
            $id = $row['id_zona'];
            $query2 = mysql_query("SELECT * FROM contenido_zona WHERE id_zona='$id'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            if ($row2 != NULL) {
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

		
                
                $u = $id . "=>" .$audio . "=>" .$video . "=>" . $row2['texto'] . "=>" .$modelo. "=>" .$imagen. "=>" . $row['largo'] . "=>" . $row['ancho'] . "=>" . $row['x'] . "=>" . $row['y'] . "=>";
            
			$josn=array('id'=>$id,'audio'=>$audio,'video'=>$video,'texto'=>utf8_encode($row2['texto']),'modelo'=>utf8_encode($modelo),'imagen' => utf8_encode($imagen),
						'largo' => $row['largo'],'ancho' => $row['ancho'], 'x'=>$row['x'],'y'=>$row['y']);
			}
        } catch (Exception $e) {
            $u = -1;
        }
    }
    return json_encode($json);
}

function fungetContenidoZonaNombre($nombre) {
	
	mensaje_log("FUNCION GET CONTENIDO ZONA POR NOMBRE (ZONA)");        
	$u = "";
	$json = array();
	try {
            $query = mysql_query("SELECT * FROM zona, contenido_zona WHERE zona.id_zona=contenido_zona.id_zona AND zona.nombre_zona='$nombre'") or die(mysql_error());
            $row = mysql_fetch_array($query2);

            if ($row != NULL) {
                $u = $row["audio"] . "=>" .$row["video"] . "=>" .$row["modelo"]. "=>" .$row["imagen"]. "=>";
				$json = array('audio'=>utf8_encode($row["audio"]),'video'=>utf8_encode($row["video"]),
								'modelo'=>utf8_encode($row["modelo"]),'imagen' => utf8_encode($row["imagen"]));
            }
        } catch (Exception $e) {
            $u = -1;
        }
    return json_encode($json);
}

function fungetZonaObra($nombre_obra) {
    $u = "";
    $query = mysql_query("SELECT * FROM zona WHERE nombre_obra='$nombre_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
	$json = array(array());
	$indice = 0;
    if ($row != NULL) {

        $query2 = mysql_query("SELECT * FROM zona WHERE nombre_obra='$nombre_obra'") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['id_zona'] . "=>";
			$json[$indice++]=array('id_zona'=>$res['id_zona']);
        }
    }
    return json_encode($json);
}

//---------------------------------------------------NUEVO-------------------------------------------------------------
function fungetZonas() {
	
	mensaje_log("FUNCION GET ZONAS (ZONA)");    
	$u = "";
	$json = array(array());
	$indice = 0;    
    $query = mysql_query("SELECT nombre_zona FROM zona") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query)) {
            $u = $u . $res['nombre_zona'] . "=>";
			$json[$indice++]=array('nombre_zona'=>utf8_encode($res['nombre_zona']));
        }

    return json_encode($json);
}
//---------------------------------------------------NUEVO---------------------------------------------------------------
?>
