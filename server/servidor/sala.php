<?php

function fungetAllDataSalas() {
    $u = "-1";
    $query = mysql_query("SELECT * FROM sala,contenido_sala WHERE sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
    while ($row = mysql_fetch_assoc($query)) {
        if ($u == "-1")
            $u = "";
        $u = $u . $row['id_sala'] . "=>" . $row['nombre_sala'] . "=>" . $row['descripcion_sala'] . "=>" . $row['imagen'] . "=>";
    }
    return $u;
}

function funAltaSala($nombre_sala, $descripcion_sala) {
    $reg = -1;
    $directorio = "/home/server/proyecto/salas/";
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
            $dir = $directorio . $row2['id_sala'] . '/texto';
            mkdir($dir, 0777, true);
            chmod($dir, 0777);
            $dir = "/home/server/proyecto/sift/descriptores/" . $row2['id_sala'];
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
    $bor = -1;
    $id_obra = -1;
    $query = mysql_query("SELECT nombre_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("DELETE FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
            $query = mysql_query("DELETE FROM contenido_sala WHERE id_sala = '$id_sala'") or die(mysql_error());
            $dir = '/home/server/proyecto/salas/' . $id_sala;
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

                $dir = '/home/server/proyecto/obras/' . $id_obra;
                rrmdir($dir);
/////borra zonas de la obra
                $query3 = mysql_query("SELECT * FROM zona WHERE nombre_obra='$nombre_obra'") or die(mysql_error());

                while ($res2 = mysql_fetch_assoc($query3)) {
                    $id_zona = $res2['id_zona'];
                    $query = mysql_query("DELETE FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
                    $query = mysql_query("DELETE FROM contenido_zona WHERE id_zona = '$id_zona'") or die(mysql_error());

                    $dir = '/home/server/proyecto/zonas/' . $id_zona;
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
    $mod = -2;
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("UPDATE sala SET qr='$qr' WHERE id_sala='$id_sala'") or die(mysql_error());
            $mod = "ftp://salas:12345678@10.0.2.109/" . $id_sala . "/imagen/" . $qr;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function fungetSalas() {
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
    $u = "";
    $query = mysql_query("SELECT * FROM sala WHERE id_sala='$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['nombre_sala'] . "=>" . $row['descripcion_sala'] . "=>";
    }
    return $u;
}


function fungetDataSalaId2($id_sala){   
     $u = "-1";
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
        $u = $u.$row['imagen']."=>"; 
      }
    return $u;     
 }

function fungetDataSalaNombre($nombre) {
    $u = "";
    $query = mysql_query("SELECT * FROM sala WHERE nombre_sala='$nombre'") or die(mysql_error());
    $row = mysql_fetch_array($query);

$query2 = mysql_query("SELECT contenido_sala.imagen FROM sala, contenido_sala WHERE sala.nombre_sala='$nombre' AND  sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
$row2 = mysql_fetch_array($query2);

    if ($row != NULL) {
        $u = $row['id_sala'] . "=>" . $row['descripcion_sala'] . "=>" . $row2['imagen']. "=>";
    }
    return $u;
}

//------------------------------------------------------------------------- NUEVO!!!!!
function fungetDataSalaNombreImagen($nombre){
     //conectar();
     $u = "";
	try{
	    $query = mysql_query("SELECT sala.id_sala, sala.nombre_sala, sala.descripcion_sala, contenido_sala.imagen FROM sala, contenido_sala WHERE  sala.nombre_sala='$nombre' AND sala.id_sala=contenido_sala.id_sala") or die(mysql_error());
     	    $row = mysql_fetch_array($query);
            if ($row != NULL) {
                $u = $row['id_sala']."=>".$row['nombre_sala']."=>".$row['descripcion_sala']."=>".$row['imagen']."=>"; 
            }
	} catch (Exception $e) {
            $u = "PHP se la come=>".$e;
        }

    return $u;     
 }

function fungetDataSalaIdImagen($id){
     //conectar();
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

//--------------------------------------------------------------------------------------------

function funagregarContenidoSala($id_sala, $tipo, $nombre) {
    $mod = "-2";
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala = '$id_sala'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $id = $row['id_sala'];
            $variable = $nombre;
            if ($tipo != "texto") {
                $variable = "ftp://salas:12345678@10.0.2.109/" . $id . "/" . $tipo . "/" . $nombre;
            }
            $query = mysql_query("UPDATE contenido_sala SET $tipo = '$variable' WHERE id_sala = '$id'") or die(mysql_error());

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
    $u = "";
    $query = mysql_query("SELECT * FROM contenido_sala WHERE id_sala='$id'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['audio'] . "=>" . $row['video'] . "=>" . $row['texto'] . "=>" . $row['modelo'] . "=>" . $row['imagen'] . "=>";
    }
    return $u;
}

function fungetContenidoSalaNombre($nombre) {
    $u = "";
    $query = mysql_query("SELECT * FROM contenido_sala, sala WHERE sala.id_sala=contenido_sala.id_sala and nombre_sala='$nombre'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['audio'] . "=>" . $row['video'] . "=>" . $row['texto'] . "=>" . $row['modelo'] . "=>" . $row['imagen'] . "=>";
    }
    return $u;
}

function funexisteSala($id) {
    $u = 0;
    $query = mysql_query("SELECT id_sala FROM sala WHERE id_sala='$id'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = 1;
    }
    return $u;
}

?>
