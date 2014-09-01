<?php

function funAltaObra($nombre_obra, $descripcion_obra, $imagen, $id_sala, $autor_obra) {
    $reg = -1;
    $descriptor = "descriptor";
    $directorio = "/home/server/proyecto/obras/";
    $query = mysql_query("SELECT nombre_obra FROM obra WHERE nombre_obra = '$nombre_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row == NULL) {
        try {
            $query = mysql_query("INSERT INTO obra (nombre_obra,descripcion_obra,descriptor,imagen,id_sala,autor) VALUES ('$nombre_obra','$descripcion_obra', '$descriptor', '$imagen', '$id_sala', '$autor_obra')") or die(mysql_error());
            $query2 = mysql_query("SELECT id_obra FROM obra WHERE nombre_obra = '$nombre_obra'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            $id = $row2['id_obra'];
            $dir = $directorio . $row2['id_obra'];
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_obra'] . '/audio';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = $directorio . $row2['id_obra'] . '/texto';
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
    $bor = -1;
    $query = mysql_query("SELECT * FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    $nombre_obra = $row['nombre_obra'];
    if ($row != NULL) {
        try {
            $query = mysql_query("DELETE FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
            $query = mysql_query("DELETE FROM contenido_obra WHERE id_obra = '$id_obra'") or die(mysql_error());

            $dir = '/home/server/proyecto/obras/' . $id_obra;
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

            $dir = '/home/server/proyecto/zonas/' . $id_zona;
            rrmdir($dir);
        }
    }
    return $bor;
}

function funmodificarObra($id_obra, $nombre_obra, $descripcion_obra, $id_sala, $autor_obra) {
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

function fungetObras() {
    $u = "";
    $query = mysql_query("SELECT nombre_obra FROM obra LIMIT 1") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $query2 = mysql_query("SELECT nombre_obra FROM obra where nombre_obra='Candombe'") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_obra'] . "=>";
        }
    }
    return $u;
}
function fungetObrasl() {
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
    $u = "";
    $query = mysql_query("SELECT * FROM obra WHERE nombre_obra='$nombre_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['id_obra'] . "=>" . $row['nombre_obra'] . "=>" . $row['descripcion_obra'] . "=>" . $row['descriptor'] . "=>" . $row['imagen'] . "=>" . $row['id_sala'] . "=>" . $row['autor'] . "=>";
    }
    return $u;
}

function fungetDataObraId($id) {
    $u = "";
    $query = mysql_query("SELECT * FROM obra WHERE id_obra='$id'") or die(mysql_error());

    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['id_obra'] . "=>" . $row['nombre_obra'] . "=>" . $row['descripcion_obra'] . "=>" . $row['descriptor'] . "=>" . $row['imagen'] . "=>" . $row['id_sala'] . "=>" . $row['autor'] . "=>";
    }
    return $u;
}

function funagregarContenidoObra($id_obra,$tipo,$nombre){ 
	$mod = -2;   
	 // fijarse si la obra existe
	 $query = mysql_query("SELECT * FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
	 $row = mysql_fetch_array($query);
	 if($row != NULL)
	 {
		try{
			$id= $row['id_obra'];
			//if($tipo=="texto")
			 $variable = $nombre;			
			//else
			// $variable = "C:/Proyecto/Obras/".$row['id_obra']."/".$tipo."/".$nombre;
		        if ($tipo != "texto" && $tipo != "animacion"){
				$variable = "ftp://obras:12345678@10.0.2.109/".$id_obra."/".$tipo."/".$nombre;
			}
			if($tipo == "animacion"){
				$v = explode("=>",$nombre);
				for($i=0;$i<5;$i++){
					$r[$i] = "ftp://obras:12345678@10.0.2.109/".$id_obra."/".$tipo."/".$v[$i]."=>";
				}
				$variable = $r[0].$r[1].$r[2].$r[3].$r[4];
			}
			if($tipo != "imagen")
				$query = mysql_query("UPDATE contenido_obra SET $tipo = '$variable' WHERE id_obra = '$id'") or die(mysql_error());
			else
			{	$query = mysql_query("UPDATE contenido_obra SET $tipo = '$variable' WHERE id_obra = '$id'") or die(mysql_error());
				$query = mysql_query("UPDATE obra SET $tipo = '$variable' WHERE id_obra = '$id'") or die(mysql_error());
			}
		        if ($tipo == "texto"){
				$mod = "1";
			}else{
				$mod  = $variable;
			}
		}
		catch(Exception $e){
			$mod = -1;
		}
	 }
	 return $mod; 
}


function funmodificarContenidoObra($id_obra, $tipo) {
    $mod = -2;
    $query = mysql_query("SELECT * FROM obra WHERE id_obra = '$id_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $id = $row['id_obra'];
            $dir = '/home/server/proyecto/obras/' . $id . '/' . $tipo . '/';
            rrmdir2($dir);
            $mod = 0;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function fungetContenidoObra($nombre) {
    $u = "";
    $query = mysql_query("SELECT * FROM obra WHERE nombre_obra = '$nombre'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        try {
            $id = $row['id_obra'];
            $descripcion = $row['descripcion_obra'];
            $autor = $row['autor'];
            $query2 = mysql_query("SELECT * FROM contenido_obra WHERE id_obra='$id'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            if ($row2 != NULL) {
                $u = $id . "=>" . $row2['audio'] . "=>" . $row2['video'] . "=>" . $row2['texto'] . "=>" . $row2['modelo'] . "=>" . $row2['imagen'] . "=>" . $descripcion . "=>" . $autor . "=>" . $row2['animacion'];
            }
        } catch (Exception $e) {
            $u = -1;
        }
    }
    return $u;
}

//---------------------------------------------------------NUEVO----------------------------------------------
function fungetContenidoObraLike($nombre) {
    $u = "";
    $query = mysql_query("SELECT * FROM obra WHERE nombre_obra LIKE '$nombre%'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        try {
            $id = $row['id_obra'];
            $descripcion = $row['descripcion_obra'];
            $autor = $row['autor'];
            $query2 = mysql_query("SELECT * FROM contenido_obra WHERE id_obra='$id'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            if ($row2 != NULL) {
                $u = $id . "=>" . $row2['audio'] . "=>" . $row2['video'] . "=>" . $row2['texto'] . "=>" . $row2['modelo'] . "=>" . $row2['imagen'] . "=>" . $descripcion . "=>" . $autor . "=>" . $row2['animacion'];
            }
        } catch (Exception $e) {
            $u = -1;
        }
    }
    return $u;
}

/*function fungetNombreObraLike($nombre) {
    $u = "";

    try {
    	$query = mysql_query("SELECT * FROM obra WHERE nombre_obra LIKE '$nombre%'") or die(mysql_error());
    	$row = mysql_fetch_array($query);
    	while($row ==mysql_fetch_assoc($query)) {
        	$u = $row['nombre_obra']."=>";
    	}
    } catch (Exception $e) {
            $u = "puto_error=>";
    }
    return $u;
}


function fungetNombreObraLike() {
        $query2 = mysql_query("SELECT * FROM obra WHERE nombre_obra='Candombe'") or die(mysql_error());
        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nombre_obra'] . "=>";
        }
    
    return $u;
}
*/
//-----------------------------------------------------------------------------------------------------------

function fungetObraSala($id) {
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
    $u = "-1";
    $query = mysql_query("SELECT * FROM obra,contenido_obra WHERE obra.id_obra=contenido_obra.id_obra and obra.id_sala='$id'") or die(mysql_error());
    while ($row = mysql_fetch_assoc($query)) {
        if ($u == "-1")
            $u = "";
        $u = $u . $row['id_obra'] . "=>" . $row['nombre_obra'] . "=>" . $row['autor'] . "=>" . $row['descripcion_obra'] . "=>" . $row['imagen'] . "=>";
    }

    return $u;
}

?>
