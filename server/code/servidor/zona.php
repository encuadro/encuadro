<?php

function funAltaZona($largo, $ancho, $x, $y, $nombre_obra) {
    $reg = -1;
    $descriptor = "descriptor";
    $directorio = "/home/server/proyecto/zonas/";
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
            $dir = $directorio . $row2['id_zona'] . '/texto';
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
    return $reg;
}

function funborrarZona($id_zona) {
    $bor = -1;
    $query = mysql_query("SELECT id_zona FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    $id = $row['id_zona'];
    if ($row != NULL) {
        try {
            $query = mysql_query("DELETE FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
            $query = mysql_query("DELETE FROM contenido_zona WHERE id_zona = '$id_zona'") or die(mysql_error());

            $dir = '/home/server/proyecto/zonas/' . $id_zona;
            rrmdir($dir);
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    }
    return $bor;
}

function funmodificarZona($id_zona, $largo, $ancho, $x, $y) {
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
    return $mod;
}

function funagregarContenidoZona($id_zona, $tipo, $nombre) {
    $mod = -2;
    $query = mysql_query("SELECT * FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $id = $row['id_zona'];
            $variable = $nombre;
            if ($tipo != "texto") {
                $variable = "ftp://zonas:12345678@10.0.2.109/" . $id_zona . "/" . $tipo . "/" . $nombre;
            }
            $query = mysql_query("UPDATE contenido_zona SET $tipo = '$variable' WHERE id_zona = '$id'") or die(mysql_error());
            if ($tipo == "texto") {
                $mod = "1";
            } else {
                $mod = $variable;
            }
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function fungetContenidoZona($id_zona) {
    $u = "";
    $query = mysql_query("SELECT * FROM zona WHERE id_zona = '$id_zona'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        try {
            $id = $row['id_zona'];
            $query2 = mysql_query("SELECT * FROM contenido_zona WHERE id_zona='$id'") or die(mysql_error());
            $row2 = mysql_fetch_array($query2);
            if ($row2 != NULL) {
                $u = $id . "=>" . $row2['audio'] . "=>" . $row2['video'] . "=>" . $row2['texto'] . "=>" . $row2['modelo'] . "=>" . $row2['imagen'] . "=>" . $row['largo'] . "=>" . $row['ancho'] . "=>" . $row['x'] . "=>" . $row['y'] . "=>";
            }
        } catch (Exception $e) {
            $u = -1;
        }
    }
    return $u;
}

function fungetZonaObra($nombre_obra) {
    $u = "";
    $query = mysql_query("SELECT * FROM zona WHERE nombre_obra='$nombre_obra'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        $query2 = mysql_query("SELECT * FROM zona WHERE nombre_obra='$nombre_obra'") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['id_zona'] . "=>";
        }
    }
    return $u;
}

?>