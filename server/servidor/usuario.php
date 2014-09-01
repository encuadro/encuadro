<?php
class Usuario {
function funlogin($user, $pass) {
    $log = -1;
    $query = mysql_query("SELECT id_usuario,pass FROM usuario WHERE nick LIKE BINARY '$user'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row == NULL)
        $log = -1;
    else
    if ($row['pass'] != $pass) {
        $log = -1;
    } else {
        $log = $row['id_usuario'];
    }
    return $log;
}

function funAltaUsuario($nombre, $apellido, $cedula, $email, $tipoUs, $nick, $pass) {
    $reg = -1;
    $query = mysql_query("SELECT nick FROM usuario WHERE nick = '$nick'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row == NULL) {
        try {
            $query = mysql_query("INSERT INTO usuario (nombre,apellido,cedula,email,tipoUs,nick,pass) VALUES ('$nombre','$apellido','$cedula','$email','$tipoUs','$nick','$pass')") or die(mysql_error());
            $reg = 0;
        } catch (Exception $e) {
            $reg = -1;
        }
    }
    return $reg;
}

/*
function funAltavisita($nombre, $sexo) {
    $reg = -1;
        try {
            $query = mysql_query("INSERT INTO visitante_museo (nombre,sexo) VALUES ('$nombre','$sexo')") or die(mysql_error());
            $reg = 0;
        } catch (Exception $e) {
            $reg = -1;
        }
    return $reg;
}*/

function funmodificarUsuario($nombre, $apellido, $cedula, $email, $tipoUs, $nick, $pass, $idUsuario) {
    $mod = -2;
    $query = mysql_query("SELECT * FROM usuario WHERE id_usuario = '$idUsuario'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    $query3 = mysql_query("SELECT nick FROM usuario WHERE nick = '$nick'") or die(mysql_error());
    $row2 = mysql_fetch_array($query);
    if (($row != NULL) && ($row2 == NULL || $row['nick'] == $nick )) {
        try {
            $query = mysql_query("UPDATE usuario SET nombre='$nombre', apellido='$apellido', cedula='$cedula', email='$email', tipoUs='$tipoUs', nick='$nick', pass='$pass' WHERE id_usuario = '$idUsuario'") or die(mysql_error());
            $mod = 0;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function funborrarUsuario($idUsuario) {
    $bor = -1;
    $query = mysql_query("SELECT nick FROM usuario WHERE id_usuario = '$idUsuario'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("DELETE FROM usuario WHERE id_usuario= '$idUsuario'") or die(mysql_error());
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    }
    return $bor;
}

function fungetUsuarios() {
    $u = "";
    $query = mysql_query("SELECT nick FROM usuario") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        $query2 = mysql_query("SELECT nick FROM usuario") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nick'] . "=>";
        }
    }
    return $u;
}

function fungetUsuariosAdmin() {
    $u = "";
    $query = mysql_query("SELECT nick FROM usuario WHERE tipoUs= 2") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        $query2 = mysql_query("SELECT nick FROM usuario WHERE tipoUs= 2") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nick'] . "=>";
        }
    }
    return $u;
}

function fungetUsuariosEmpleado() {
    $u = "";
    $query = mysql_query("SELECT nick FROM usuario WHERE tipoUs= 1") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {

        $query2 = mysql_query("SELECT nick FROM usuario WHERE tipoUs= 1") or die(mysql_error());

        while ($res = mysql_fetch_assoc($query2)) {
            $u = $u . $res['nick'] . "=>";
        }
    }
    return $u;
}

function fungetDataUsuario($nick) {
    $u = "";
    $query = mysql_query("SELECT * FROM usuario WHERE nick='$nick'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        $u = $row['nombre'] . "=>" . $row['apellido'] . "=>" . $row['cedula'] . "=>" . $row['email'] . "=>" . $row['tipoUs'] . "=>" . $row['nick'] . "=>" . $row['pass'] . "=>" . $row['id_usuario'] . "=>";
    }
    return $u;
}

function funpasswd($nick, $pass) {
    $u = -2;
    $query3 = mysql_query("SELECT nick FROM usuario WHERE nick = '$nick'") or die(mysql_error());
    $row2 = mysql_fetch_array($query3);
    if (($row2 != NULL)) {
        try {
            $query = mysql_query("UPDATE usuario SET pass='$pass'WHERE nick = '$nick'") or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }
    }
    return $u;
}

function funtipoUsuario($nick) {
    $u = -1;
    $query = mysql_query("SELECT tipoUs FROM usuario WHERE nick='$nick'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {//no exite
        $u = $row['tipoUs'];
    }
    return $u;
}

	}
?>
