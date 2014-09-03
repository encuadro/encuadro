<?php
require_once("config.php");//$ini_array = parse_ini_file("/var/include/confi.ini", true);
$ruta = $ini_array['RUTA']['include'];
//include($ruta."funciones.php");

//-----------------------------------JUEGO------------------------------------
function funAltaJuego($nombre) {
     
    mensaje_log("FUNCION ALTA JUEGO (USUARIO)");
    $reg = -1;
	try {
		$query = mysql_query("INSERT INTO Juego(nombre) VALUES ('$nombre')") or die(mysql_error());
		$query2 = mysql_query("SELECT idjuego from Juego where nombre='$nombre'") or die(mysql_error());
		$res = mysql_fetch_array($query2);
		$reg=$res['idjuego'];
	} catch (Exception $e) {
		$reg = -1;
	}
    return $reg;
}

function funCantidadObrasJuego($id_juego) {
	$u = 0;
	try {
		$query = mysql_query("SELECT COUNT(*) as total  from Pista where id_juego='$id_juego'") or die(mysql_error());
		$res = mysql_fetch_array($query);
		$u=$res['total'];
	} catch (Exception $e) {
		$reg = -1;
	}
    return $u;
}

function funBusquedaPista($idObra,$idjuego) {
    $u = "0";
 	try {
		$query = mysql_query("SELECT id_proxima, pista FROM Pista WHERE id_juego='$idjuego' and id_obra='$idObra'") or die(mysql_error());
		$res = mysql_fetch_assoc($query);
		if ($res != NULL) {
		    $u = $res['id_proxima'] . "=>". $res['pista'] . "=>";
		}
	} catch (Exception $e) {
            $reg = -1;
        }
    return $u;
}


function funObraPerteneceAJuego($idObra) {
	//MODIFICADA EL 24/03/14
	$query = mysql_query("SELECT idjuego FROM Juego WHERE activo=1 AND id_obra1='$idObra' AND borrado=0  AND ciclico=0") or die(mysql_error());
	//$query = mysql_query("SELECT idjuego, pista, id_proxima FROM Juego, Pista WHERE Juego.id_obra1='$idObra' and Juego.id_obra1=Pista.id_obra") or die(mysql_error());
	$res = mysql_fetch_assoc($query);
	if ($res != NULL) {
      	$u = $res['idjuego'] ;
    }
	else {	//AGREGADO EL 24/03/14
		$query2 = mysql_query("SELECT idjuego FROM Juego, Pista WHERE id_juego= idjuego AND activo=1  AND borrado=0 AND ciclico=1 AND id_obra='$idObra' GROUP BY idjuego") or die(mysql_error());
		$res2 = mysql_fetch_assoc($query2);
		if ($res2 != NULL) {
	      	$u = $res2['idjuego'] ;
		}
		else{
		  $u="0";
		}
	}
    return $u;
}
function funAgregarPista($nomObra) {
    //$reg = -1;
    $res1 ='nada';
    //$query = mysql_query("SELECT o1.id_obra, o2.id_obra FROM obra as o1, obra as o2 WHERE o1.nombre_obra = '$nomObra' AND o2.nombre_obra='$nomProx' ") or die(mysql_error());
    //$row = mysql_fetch_array($query);
	//$reg2 = $row['o1.id_obra'];
    //$reg3 = $row['o2.id_obra'];
   	
	$query1 = mysql_query("SELECT nombre_obra FROM obra WHERE nombre_obra = 'Candombe'")or die(mysql_error());
	//$query2 = mysql_query("SELECT id_obra FROM obra WHERE nombre_obra = '$nomProx'")or die(mysql_error());
	
	//try {
	$r1 = mysql_fetch_array($query1);
	//$r2 = mysql_fetch_array($query2);
	$res1 = $r1['nombre_obra'];
       	//$res2 = $r2['id_obra'];
 	//} catch (Exception $e) {
       //     $res1 = 'ja';
       // }
	//if ($r1 != NULL and $r2 != NULL) {
        //try {
         //  $query2 = mysql_query("INSERT INTO Pista (id_obra, id_juego, id_proxima, pista) VALUES ('$res1','$idJuego','$','$pista')") or die(mysql_error());
           // $reg = 0;
       // } catch (Exception $e) {
            //$reg = -1;
       // }
   // }
    return $res1;
}

/*
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

*/

/*
$query = mysql_query("INSERT INTO Pista (id_obra, id_juego, id_proxima, pista) VALUES ($row['o1.id_obra'],'$idJuego',$row['o2.id_obra'],'$pista')") or die(mysql_error());
*/

function funGetPistas($id_juego) {
    $u = "";
    $query2 = mysql_query("select p.id_obra as ido, o1.nombre_obra as ob, pista, o2.nombre_obra as obr from obra o1, Pista p, obra o2 where id_juego = $id_juego and p.id_obra = o1.id_obra and p.id_proxima = o2.id_obra") or die (mysql_error());
	while ($row = mysql_fetch_assoc($query2)) {
		$u = $u . $row['ido'] . "=>". $row['ob'] . "=>". $row['pista'] . "=>". $row['obr'] . "=>";
	}
    return $u;
}

function funModificarPista($id_Obra,$id_Juego,$Pista) {
    $u = "";
	$mod = -2;
    $query = mysql_query("SELECT id_juego,id_obra FROM Pista WHERE id_obra = '$id_Obra' and id_juego='$id_Juego'") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
        try {
            $query = mysql_query("UPDATE Pista SET pista='$Pista' WHERE id_obra='$id_Obra' and id_juego='$id_Juego'") or die(mysql_error());
            $mod = 0;
        } catch (Exception $e) {
            $mod = -1;
        }
    }
    return $mod;
}

function funGetNombreJuegoActivo() {
    $u = -2;
	$query1 = mysql_query("SELECT nombre FROM Juego WHERE activo = 1")
				or die(mysql_error());
    $row2 = mysql_fetch_assoc($query1);
	$r2=$row2['nombre'];
	return $r2;
}

function funAgregarCuestionarioo($nombre, $descripcion, $fecha_creacion, $id_creador) {
    $reg = -1;
    try {
		$query = mysql_query("INSERT INTO cuestionario(nom_cuestionario, descripcion, fecha_creacion, usuario_creador) VALUES ('$nombre', '$descripcion', '$fecha_creacion', '$id_creador')") or die(mysql_error());
		$query2 = mysql_query("SELECT id_cuestionario from cuestionario where 		  			nom_cuestionario='$nombre'") or die(mysql_error());
		$res = mysql_fetch_array($query2);
		$reg=$res['id_cuestionario'];
        } catch (Exception $e) {
            $reg = -1;
        }
    return $reg;
}

function funAgregarValorOpcion($descripcion) {
//funcion modificada POSIBLEMENTE LA TENES QUE BORRAR MAS ARRIBA...
    $reg = -2;
        try {
			$query2 = mysql_query("SELECT id_val_op from valor_opcion where 		  			descripcion='$descripcion'") or die(mysql_error());
			$res = mysql_fetch_array($query2);
			if ($res == null){
					$query = mysql_query("INSERT INTO valor_opcion(descripcion) VALUES 					('$descripcion')") or die(mysql_error());
					$query2 = mysql_query("SELECT id_val_op from valor_opcion where 		  			descripcion='$descripcion'") or die(mysql_error());
					$res = mysql_fetch_array($query2);
			}
			$reg=$res['id_val_op'];
        } catch (Exception $e) {
            $reg = -1;
        }
    return $reg;
}

function funAgregarPregunta($descripcion, $tipo) {
    $reg = -2;
    try {
		$query = mysql_query("INSERT INTO preguntas(descripcion, tipo) VALUES 					('$descripcion', $tipo)") or die(mysql_error());
		$query2 = mysql_query("SELECT id_pregunta from preguntas where 		  					descripcion='$descripcion'") or die(mysql_error());
		$res = mysql_fetch_array($query2);
		$reg=$res['id_pregunta'];
        } catch (Exception $e) {
            $reg = -1;
        }
    return $reg;
}

function funAsociarPreguntaConOpcion($id_preg, $id_op) {
    $reg = -2;
    try {
		$query = mysql_query("INSERT INTO opciones(id_pregunta, id_valor_opcion) VALUES 			('$id_preg', '$id_op')") or die(mysql_error());
		$reg = 0;
        } catch (Exception $e) {
            $reg = -1;
        }
    return $reg;
}

function funAsociarPreguntaConCuestionario($id_preg, $id_cuest, $indice) {
    $reg = -2;
	try {
		$query = mysql_query("INSERT INTO cuest_pregunta(id_pregunta, id_cuestionario, indice_preg) 			VALUES	($id_preg, $id_cuest, $indice)") or die(mysql_error());
		$reg = 0;
        } catch (Exception $e) {
            $reg = -1;
        }
    return $reg;
}

function funGetCuestionarios() {
    $u = "";
    $query2 = mysql_query("SELECT cuestionario.*, nick FROM usuario, cuestionario WHERE id_usuario=usuario_creador") or die (mysql_error());
    while ($row = mysql_fetch_assoc($query2)) {
            $u = $u . $row['id_cuestionario'] . "=>". $row['nom_cuestionario'] . "=>". 				$row ['descripcion'] . "=>" . $row['nick'] . "=>". $row['fecha_creacion'] . 			"=>" . $row['fecha_desactivacion'] . "=>";
        }
    return $u;
}

function funGetPreguntas($id_cuest) {
    $u = "";
    $query2 = mysql_query("SELECT cp.id_cuestionario AS idcuest, p.id_pregunta AS idpreg, 
	cp.indice_preg AS indice, p.descripcion AS txtpreg, vo.descripcion AS txtopc
	FROM preguntas p, cuest_pregunta cp, opciones o, valor_opcion vo
	WHERE p.id_pregunta = cp.id_pregunta
	AND cp.id_pregunta = o.id_pregunta
	AND o.id_valor_opcion = vo.id_val_op
	AND cp.id_cuestionario = $id_cuest ") or die (mysql_error());
	while ($row = mysql_fetch_assoc($query2)) {
		$u = $u . $row['idcuest'] . "=>". $row['idpreg'] . "=>". $row ['indice'] . "=>" . 
		$row['txtpreg'] . "=>". $row['txtopc'] . "=>" ;
	}
    return $u;
}

//AGREGADO 25/03/14  registro de respuestas desde movil
function funSetPreguntas($id_cuest) {
    $u = "";
    //FRUTA AL AIRE
    $query = mysql_query("INSERT INTO preguntas p, cuest_pregunta cp, opciones o, valor_opcion vo(cp.id_cuestionario, p.id_pregunta, cp.indice_preg) VALUES ()") or die (mysql_error());
    //DE REFERENCIA, BORRAR LUEGo
    $query2 = mysql_query("SELECT cp.id_cuestionario AS idcuest, p.id_pregunta AS idpreg, 
	cp.indice_preg AS indice, p.descripcion AS txtpreg, vo.descripcion AS txtopc
	FROM preguntas p, cuest_pregunta cp, opciones o, valor_opcion vo
	WHERE p.id_pregunta = cp.id_pregunta
	AND cp.id_pregunta = o.id_pregunta
	AND o.id_valor_opcion = vo.id_val_op
	AND cp.id_cuestionario = $id_cuest ") or die (mysql_error());
    return $u;
}


function frutamadre(){
	$u = "";

$query = mysql_query("SELECT p.id_pregunta AS Id_Pregunta, p.descripcion AS Contenido_Pregunta, vo.id_val_op AS ID_Opcion, vo.descripcion AS 				Contenido_Respuesta, cp.indice_preg AS Indice_Preg
			FROM cuestionario AS c, cuest_pregunta AS cp, preguntas AS p, opciones AS o, opciones_valorOpc AS ovo, valor_opcion AS vo
			WHERE c.activo =1
			AND p.tipo=1
			AND c.id_cuestionario = cp.id_cuestionario
			AND p.id_pregunta = cp.id_pregunta
			AND o.id_opcion = p.id_opciones
			AND o.id_opcion = ovo.id_opcion
			AND ovo.id_valorOpcion = vo.id_val_op
			ORDER BY cp.indice_preg ASC 
			LIMIT 0 , 30") or die (mysql_error());
/*
	$query = mysql_query("SELECT p.id_pregunta as Id_Pregunta, p.descripcion as Contenido_Pregunta, vo.id_val_op as ID_Opcion, 
	vo.descripcion as Contenido_Respuesta, cp.indice_preg AS Indice_Preg
	FROM cuestionario as c, cuest_pregunta as cp, preguntas as p, opciones as o, valor_opcion as vo 
	WHERE c.activo = 1 and  c.id_cuestionario = cp.id_cuestionario and p.id_pregunta = cp.id_pregunta and 
	o.id_pregunta = p.id_pregunta and o.id_valor_opcion=vo.id_val_op ORDER BY `cp`.`indice_preg` ASC") or die (mysql_error());
	*/
	$query2 = mysql_query("SELECT p.id_pregunta AS Id_Pregunta, cp.indice_preg AS Indice_Preg, p.descripcion as Contenido_Pregunta
	FROM cuestionario AS c, cuest_pregunta AS cp, preguntas AS p
	WHERE c.activo = 1 AND p.tipo=0 AND c.id_cuestionario = cp.id_cuestionario AND p.id_pregunta = cp.id_pregunta") or die (mysql_error());
	
	$idpregunta="";
	$posicion="";
	
	while ($row = mysql_fetch_assoc($query)) {
		$posicion=$row['Indice_Preg'];
		while ($row2 = mysql_fetch_assoc($query2)) {
			if($posicion>$row2['Indice_Preg']){
				$u=$u. $row2['Id_Pregunta'] . "=>". $row2['Contenido_Pregunta'] . "=>0=>texto=>";
			}	
		}
		$u=$u. $row['Id_Pregunta'] . "=>". $row['Contenido_Pregunta'] . "=>". $row['ID_Opcion']. "=>". $row['Contenido_Respuesta']. "=>";
	}
	return $u;	
}

/*esta no es correcta
function funAgregarValorOpcion($descripcion) {
    $reg = -2;
        try {
            $query = mysql_query("INSERT INTO valor_opcion(descripcion) VALUES 			('$descripcion')") or die(mysql_error());
  	   $query2 = mysql_query("SELECT id_val_op from valor_opcion where 		  			descripcion='$descripcion'") or die(mysql_error());
	 $res = mysql_fetch_array($query2);
	 $reg=$res['id_val_op'];

        } catch (Exception $e) {
            $reg = -1;
        }
    
    return $reg;
}
*/
/////////////////////////////////////////////////////////////

function funGetTextPreguntas($id_cuest) {
    $u = "";
    $query2 = mysql_query("SELECT cp.id_cuestionario AS idcuest, 
		cp.indice_preg AS indice, 
		p.id_pregunta as idpreg,
		p.descripcion as txtpreg,
		p.tipo as tipop 
		FROM preguntas p, cuest_pregunta cp
		WHERE p.id_pregunta = cp.id_pregunta
		AND cp.id_cuestionario = $id_cuest ") or die (mysql_error());
    
        while ($row = mysql_fetch_assoc($query2)) {
            $u = $u . $row['idcuest'] . "=>". $row['idpreg'] . "=>". $row ['indice'] . "=>" . 
		$row['txtpreg'] . "=>". $row['tipop'] . "=>" ;
        }

    return $u;
}


function funGetRespPreguntas($id_preg) {
    $u = "-1";
    $query2 = mysql_query("SELECT vo.descripcion 
	FROM opciones o, valor_opcion vo, opciones_valorOpc ovo, preguntas p 
	WHERE p.id_pregunta = $id_preg	and
        ovo.id_valorOpcion = vo.id_val_op and
        p.id_opciones=o.id_opcion and 
	o.id_opcion=ovo.id_opcion") or die (mysql_error());

	$row = mysql_fetch_assoc($query2);
    	
	if ($row !=null){
		$u="";
		$u = $u . $row['descripcion'] . "=>" ;
	}
        while ($row = mysql_fetch_assoc($query2)) {
            $u = $u . $row['descripcion'] . "=>" ;
        }

    return $u;
}


//crea un grupo de opciones de respuesta
function funSetOpcion($descripcion) {
    $reg = -2;
        try {
            $query = mysql_query("INSERT INTO opciones(descripcion) VALUES 			('$descripcion')") or die(mysql_error());
		
		$reg = 0;

		$query2 = mysql_query("SELECT id_opcion from opciones where 		  					descripcion='$descripcion'") or die(mysql_error());
		$res = mysql_fetch_array($query2);

	 $reg=$res['id_opcion'];

        } catch (Exception $e) {
            $reg = -1;
        }
    
    return $reg;
}

function funAsociarOpcionesConValores($id_opc,$id_valor) {
    $reg = -2;
        try {
            $query = mysql_query("INSERT INTO opciones_valorOpc(id_opcion, id_valorOpcion) 			VALUES	($id_opc, $id_valor)") or die(mysql_error());
		
		$reg = 0;
  	   

        } catch (Exception $e) {
            $reg = -1;
        }
    
    return $reg;
}

function funAgregarPregunta2($descripcion, $tipo, $id_opciones){
    $reg = -2;
        try {
            
		$query = mysql_query("INSERT INTO preguntas(descripcion, tipo, id_opciones) VALUES 					('$descripcion', $tipo, $id_opciones)") or die(mysql_error());
			
			$query2 = mysql_query("SELECT id_pregunta from preguntas where 		  					descripcion='$descripcion'") or die(mysql_error());
		$res = mysql_fetch_array($query2);

	 $reg=$res['id_pregunta'];

        } catch (Exception $e) {
            $reg = -1;
        }
    
    return $reg;
}

function funGetOpciones() {
    $u = "";
    $query2 = mysql_query("select id_opcion, descripcion from opciones") or die (mysql_error());
    
        while ($row = mysql_fetch_assoc($query2)) {
            $u = $u . $row['id_opcion'] . "=>" . $row['descripcion'] . "=>" ;
        }

    return $u;
}


function funGetValoresDeOpcion($id_opcion) {
    $u = "";
    $query2 = mysql_query("select id_val_op, descripcion from valor_opcion, opciones_valorOpc
		where id_opcion=$id_opcion and 
		id_val_op=id_valorOpcion") or die (mysql_error());
    
        while ($row = mysql_fetch_assoc($query2)) {
            $u = $u . $row['id_val_op'] . "=>" . $row['descripcion'] . "=>" ;
        }

    return $u;
}

function funGetValoresDeOpciones() {
    $u = "";
    $query2 = mysql_query("select id_val_op, descripcion from valor_opcion") or die (mysql_error());
    
        while ($row = mysql_fetch_assoc($query2)) {
            $u = $u . $row['id_val_op'] . "=>" . $row['descripcion'] . "=>" ;
        }

    return $u;
}


function fungethora() {
	//$h="hola";
	$hora= date("H:i:s");
	return $hora;
}

function fungetalgo($nombre,$nomProx,$idjuego,$pista) {
	$query1 = mysql_query("SELECT id_obra FROM obra WHERE nombre_obra = '$nombre'")or die(mysql_error());
	$query2 = mysql_query("SELECT id_obra FROM obra WHERE nombre_obra = '$nomProx'")or die(mysql_error());
	//$query1 = mysql_query("SELECT O1.id_obra, O2.id_obra FROM obra as O1, obra as O2 WHERE O1.nombre_obra = '$nombre' and O2.nombre_obra = '$nomProx'")or die(mysql_error());   //Aguante mi consulta
	//$idjuego=11;
	//$pista='sabeeeeeeee';
	$row = mysql_fetch_assoc($query1);
    $row2 = mysql_fetch_assoc($query2);
	$r2=$row2['id_obra'];
	$r1=$row['id_obra'];
	//$reg = 'error';
    if ($r1 != NULL and $r2!= NULL) {
		$query2 = mysql_query("INSERT INTO Pista (id_obra, id_juego, id_proxima, pista) VALUES ($r1,$idjuego,$r2,'$pista')") or die(mysql_error());
		$reg = 'insertado todo';
	}
	return $r2.$r1;
}

function fungetPuntaje($id_visitante,$idjuego) {
    $u = "0";
	$query = mysql_query("SELECT puntaje FROM Juego_visitante WHERE id_juego='$idjuego' and id_visitante='$id_visitante'") or die(mysql_error());
	$res = mysql_fetch_assoc($query);
	if ($res != NULL) {
		$u = $res['puntaje'];
	}
    return $u;
}

function fungetPuntajes() {
    $u = "";
	try{
		$query = mysql_query("SELECT puntaje, nick_name FROM Juego_visitante order by puntaje desc") or die(mysql_error());
		//$res = mysql_fetch_assoc($query);
		
		while ($res = mysql_fetch_assoc($query)) {
            		$u = $u . $res['puntaje'] . "=>". $res['nick_name'] . "=>";
       		}
	}catch(Exception $e){
		$u="-1";
	}
    return $u;
}
function funfinJuego($id_visitante,$id_juego,$puntajes,$nick_name) {

    $u = "1";
 	try{
		$query = mysql_query("INSERT INTO Juego_visitante (id_visitante, id_juego, puntaje, nick_name) VALUES ($id_visitante,$id_juego,$puntajes,'$nick_name')") or die(mysql_error());

	}catch(Exception $e){
		$u="-1";
	}
		
    return $u;
}
/*
function fungetJuegos() {

    $u = "0";
 	
		$query = mysql_query("SELECT nombre FROM Juego") or die(mysql_error());
		$res = mysql_fetch_assoc($query);
		if ($res != NULL) {
		    $u = $res['nombre'];
        	}
    return $u;
}
*/
function fungetPosicion($id_visitante) {

    $u = "0";
 	
		$query = mysql_query("SELECT count(puntajes.puntaje) as Posicion
FROM Juego_visitante AS puntajes
WHERE puntajes.puntaje > ( Select max(mi_puntaje.puntaje)
From Juego_visitante AS mi_puntaje
where mi_puntaje.id_visitante =$id_visitante)") or die(mysql_error());
		$res = mysql_fetch_assoc($query);
		if ($res != NULL) {
		    $u = $res['Posicion'];
        	}
    return $u;
}




//----------------------------------------------------------------------------

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
function funAltavisita($nacionalidad, $sexo, $tipo_visita, $rango_edad) {

	$fecha= date('D-M-Y');
	$fechahora=date('D-M-Y h:I:S');
    	$reg = "0";
        try {
            	$query = mysql_query("INSERT INTO visitante_museo(nacionalidad, sexo, tipo_visita, rango_edad,Fecha,FechaHora) VALUES ('$nacionalidad','$sexo','$tipo_visita','$rango_edad','$fecha','$fechahora')") or die(mysql_error());
		$reg = mysql_insert_id();
        } catch (Exception $e) {
            $reg = "-1";
        }
    return $reg;
}

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

//----------------------------- nuevo----------------

function fungetDatosVisita() {
    $u = "";
    $querym = mysql_query("SELECT COUNT(*) as Masculino FROM visitante_museo where sexo='Masculino' GROUP BY sexo" ) or die(mysql_error());
$queryf = mysql_query("SELECT COUNT(*) as Femenino FROM visitante_museo where sexo='Femenino' GROUP BY sexo" ) or die(mysql_error());
$queryn = mysql_query("SELECT COUNT(*) as Uruguaya FROM visitante_museo where nacionalidad='Uruguaya' GROUP BY nacionalidad" ) or die(mysql_error());$querye = mysql_query("SELECT COUNT(*) as Extranjera FROM visitante_museo where nacionalidad='Extranjera' GROUP BY nacionalidad" ) or die(mysql_error());
$query12 = mysql_query("SELECT COUNT(*) as 0a12 FROM visitante_museo where rango_edad='0 a 12' GROUP BY rango_edad" ) or die(mysql_error());
$query15 = mysql_query("SELECT COUNT(*) as 13a15 FROM visitante_museo where rango_edad='13 a 15' GROUP BY rango_edad" ) or die(mysql_error());
$query18 = mysql_query("SELECT COUNT(*) as 16a18 FROM visitante_museo where rango_edad='16 a 18' GROUP BY rango_edad" ) or die(mysql_error());
$query18m = mysql_query("SELECT COUNT(*) as de18 FROM visitante_museo where rango_edad='+ de 18' GROUP BY rango_edad" ) or die(mysql_error());

   
$row1 = mysql_fetch_array($querym);
$row2 = mysql_fetch_array($queryf);
$row3 = mysql_fetch_array($queryn);
$row4 = mysql_fetch_array($querye);
$row5 = mysql_fetch_array($query12);
$row6 = mysql_fetch_array($query15);
$row7 = mysql_fetch_array($query18);
$row8 = mysql_fetch_array($query18m);

	if ($row1 == NULL ) { 
	$row1['Masculino']='0';
	}
	if ($row2 == NULL ) { 
	$row2['Femenino']='0';
	}
	if ($row3 == NULL ) { 
	$row3['Uruguaya']='0';
	}
	if ($row4 == NULL ) { 
	$row4['Extranjera']='0';
	}
	if ($row5 == NULL ) { 
	$row5['0a12']='0';
	}
	if ($row6 == NULL ) { 
	$row6['13a15']='0';
	}

	if ($row7 == NULL ) { 
	$row7['16a18']='0';
	}
	if ($row8 == NULL ) { 
	$row8['de18']='0';
	}


	
	$u = $row1['Masculino'] . "=>" . $row2['Femenino'] . "=>". $row3['Uruguaya'] . "=>". $row4['Extranjera'] . "=>". $row5['0a12'] . "=>". $row6['13a15'] . "=>". $row7['16a18'] . "=>". $row8['de18'] . "=>";




    return $u;
}

//////////////////////NUEVAS JUEGO Y CUESTIONARIO


function funsetCuestionarioVisitante($id_visitante,$string_result){
	
	$u="1";
	
	try{
		$separated = explode("=>",$string_result);
		$query1 = mysql_query("Select id_cuestionario from cuestionario where activo=1") or die(mysql_error());
		if($row = mysql_fetch_array($query1)){
			
			$id_cuest=$row["id_cuestionario"];
			
			for($i=3;$i<=count($separated)-1;$i=$i+3){
				
				$id_preg = $separated[$i];
				$id_o_text_respuesta = $separated[$i+1];
				$tipo = $separated[$i+2]; //0 para texto - 1 para multiple opcion
				
				if($tipo=="0"){
					$query2 = mysql_query("INSERT INTO  `proyecto`.`cuestionario_visitante` (`id_visitante` ,`id_cuestionario` ,`id_pregunta` ,`respuesta_cerrada` ,`respuesta_abierta`)VALUES ('$id_visitante', '$id_cuest' ,  '$id_preg',  '',  '$id_o_text_respuesta')") or die(mysql_error());  	   
				}else{
					$query3 = mysql_query("INSERT INTO  `proyecto`.`cuestionario_visitante` (`id_visitante` ,`id_cuestionario` ,`id_pregunta` ,`respuesta_cerrada` ,`respuesta_abierta`)VALUES ('$id_visitante', '$id_cuest' ,  '$id_preg',  '$id_o_text_respuesta', '')") or die(mysql_error());  	   
				}
			}
		}
	}catch (Exception $e){
		$u="0";
	}
	return $u;
}

function funPrimeraDeJuego($id_juego, $nom_obra) {
    $u = -2;

	$query1 = mysql_query("SELECT id_obra FROM obra WHERE nombre_obra = '$nom_obra'")
				or die(mysql_error());

   $row2 = mysql_fetch_assoc($query1);
   
	$r2=$row2['id_obra'];
    
        try {
            $query = mysql_query("UPDATE Juego SET id_obra1=$r2 WHERE idjuego = $id_juego")
 					or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }
    return $u;
}

function fungetJuegos() {
    $u = "";
    $query = mysql_query("SELECT nombre, idjuego, nombre_obra, activo,ciclico FROM Juego, obra where id_obra1 = id_obra and borrado = 0") or die (mysql_error());
    
    
        while ($row = mysql_fetch_assoc($query)) {
            $u = $u . $row['idjuego'] . "=>" . $row['nombre'] . "=>" .  $row['nombre_obra'] . "=>"
			.  $row['activo'] . "=>".  $row['ciclico'] . "=>";
        }

    return $u;
}


function funresp($id) {
    $u = "";
    $query = mysql_query("SELECT respuesta_abierta from cuestionario_visitante where id_pregunta= '$id'") or die (mysql_error());
    
        while ($row = mysql_fetch_assoc($query)) {
            $u = $u . $row['respuesta_abierta'] . "=>";
        }
    return $u;
}

function funrespcerrada($id) {
    $u = "";
    $query = mysql_query("SELECT descripcion from cuestionario_visitante as cv,valor_opcion as vo where vo.id_val_op=cv.respuesta_cerrada and cv.id_pregunta= '$id'") or die (mysql_error());
    
        while ($row = mysql_fetch_assoc($query)) {
            $u = $u . $row['descripcion'] . "=>";
        }
    return $u;
}

function funAgregarCuestionario($nombre, $descripcion) {
    $reg = -1;
        try {
            $query = mysql_query("INSERT INTO cuestionario(nom_cuestionario, descripcion) VALUES ('$nombre', '$descripcion')") or die(mysql_error());
  	   $query2 = mysql_query("SELECT id_cuestionario from cuestionario where nom_cuestionario='$nombre'") or die(mysql_error());
	 $res = mysql_fetch_array($query2);
	 $reg=$res['id_cuestionario'];

        } catch (Exception $e) {
            $reg = -1;
        }
    
    return $reg;
}

function funActivarJuego($id_juego) {
    $u = -2;
        try {
            $query = mysql_query("UPDATE Juego SET activo = 0 where activo = 1")
 					or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }
	
	try {
            $query2 = mysql_query("UPDATE Juego SET activo = 1 where idjuego = $id_juego")
 					or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }	

    return $u;
}


function funRecorridoJuego($id_juego, $recorrido) {
//recorrido es uno cuando es ciclico o cero cuando es lineal
    $u = -2;
	
	try {
            $query2 = mysql_query("UPDATE Juego SET ciclico = $recorrido where idjuego = $id_juego")
 					or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }	

    return $u;
}

function funSetJuegoBorrado($id_juego) {
//recorrido es uno cuando es ciclico o cero cuando es lineal
    $u = -2;
	
	try {
            $query2 = mysql_query("UPDATE Juego SET borrado = 1 where idjuego = $id_juego")
 					or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }	

    return $u;
}

function funGetObrasDeJuego($id_juego) {
    $u = "";
    $query = mysql_query("SELECT nombre_obra FROM obra o, Pista p where o.id_obra = p.id_obra and id_juego=$id_juego") or die (mysql_error());
    
    
        while ($row = mysql_fetch_assoc($query)) {
            $u = $u . $row['nombre_obra'] . "=>";
        }

    return $u;
}

function funSetJuego($id_juego, $nombre,$recorrido) {
//recorrido es uno cuando es ciclico o cero cuando es lineal
    $u = -2;
	
	try {
            $query2 = mysql_query("UPDATE Juego SET ciclico = $recorrido, nombre='$nombre' where idjuego = $id_juego")
 					or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }	

    return $u;
}

function funSetValorOpcc($id_val, $descripcion) {
    $u = -2;
	
	try {
            $query2 = mysql_query("UPDATE valor_opcion SET descripcion = '$descripcion' where 
id_val_op = $id_val") or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }	

    return $u;
}

function funIsValorAsociadoAOpcion($id_valor) {
    $u = 9999;
    $query2 = mysql_query("select count(*) from opciones_valorOpc where id_valorOpcion=$id_valor") or die (mysql_error());
    
        $row = mysql_fetch_assoc($query2);
        
	$u = $row['count(*)'] ;
        
    return $u;
}

function funBorrarValorOpc($idValor) {
    $bor = -1;
        try {
            $query = mysql_query("DELETE FROM valor_opcion WHERE id_val_op= '$idValor'") or die(mysql_error());
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    return $bor;
}


function funSetOpcionn($id_opc, $descripcion) {
    $u = -2;
	
	try {
            $query2 = mysql_query("UPDATE opciones SET descripcion = '$descripcion' where 
id_opcion = $id_opc") or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }	

    return $u;
}

function funIsGrupoOpcAsociadoAPreguntas($id_grupo) {
    $u = 9999;
    $query2 = mysql_query("select count(*) from preguntas where id_opciones=$id_grupo") or die (mysql_error());
    
        $row = mysql_fetch_assoc($query2);
        
	$u = $row['count(*)'] ;
        
    return $u;
}


function funBorrarOpcion($idOpcion) {
    $bor = -1;
        try {
            $query = mysql_query("DELETE FROM opciones WHERE id_opcion= '$idOpcion'") or die(mysql_error());
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    return $bor;
}

function funIsPreguntaAsociadaACuestionario($id_preg) {
    $u = 9999;
    $query2 = mysql_query("select count(*) from cuest_pregunta where id_pregunta=$id_preg") or die (mysql_error());
    
        $row = mysql_fetch_assoc($query2);
        
	$u = $row['count(*)'] ;
        
    return $u;
}

function funBorrarPregunta($idPreg) {
    $bor = -1;
        try {
            $query = mysql_query("DELETE FROM preguntas WHERE id_pregunta= '$idPreg'") or die(mysql_error());
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    return $bor;
}


function funGetDatosPregunta($id_cuest) {
    $u = 9999;
    $query2 = mysql_query("select nom_cuestionario, descripcion from cuestionario where id_cuestionario=$id_cuest") or die (mysql_error());
    
        $row = mysql_fetch_assoc($query2);
        
	$u = $row['nom_cuestionario']. "=>". $row['descripcion'] ;
        
    return $u;
}



function funSetCuestionariio($id_cuest, $nombre, $descripcion) {
    $u = -2;
	
	try {
            $query2 = mysql_query("UPDATE cuestionario SET descripcion = '$descripcion', nom_cuestionario='$nombre' where 
id_cuestionario = $id_cuest") or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }	

    return $u;
}

function funBorrarRelacionPreguntasCuestionario($idCuest) {
    $bor = -1;
        try {
            $query = mysql_query("DELETE FROM cuest_pregunta WHERE id_cuestionario= '$idCuest'") or die(mysql_error());
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    return $bor;
}

function funIsCuestionarioEnUso($id_cuest) {
    $u = 9999;
    $query2 = mysql_query("select count(*) from cuest_pregunta where id_cuestionario=$id_cuest") or die (mysql_error());
    
        $row = mysql_fetch_assoc($query2);
        
	$u = $row['count(*)'] ;
        
    return $u;
}

function funBorrarCuestionario($idCuest) {
    $bor = -1;
        try {
            $query = mysql_query("DELETE FROM cuestionario WHERE id_cuestionario= '$idCuest'") or die(mysql_error());
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    return $bor;
}


function funGetDatosOpcion($id_opcion) {
    $u = "";
    $query2 = mysql_query("SELECT id_val_op as id, descripcion as descr 

		FROM valor_opcion vo, opciones_valorOpc ovo

		where vo.id_val_op=ovo.id_valorOpcion and ovo.id_opcion=$id_opcion") 

or die (mysql_error());
    
        while ($row = mysql_fetch_assoc($query2)) {
            $u = $u . $row['id'] . "=>". $row['descr'] . "=>";
        }

    return $u;
}

function funBorrarRelacionOpcionesValor($idOpc) {
    $bor = -1;
        try {
            $query = mysql_query("DELETE FROM opciones_valorOpc WHERE id_opcion= '$idOpc'") or die(mysql_error());
            $bor = 0;
        } catch (Exception $e) {
            $bor = -1;
        }
    return $bor;
}

function funGetDataPregunta($id_preg) {
    $u = 9999;
    $query2 = mysql_query("select id_pregunta, descripcion, tipo, id_opciones from preguntas where id_pregunta=$id_preg") or die (mysql_error());
    
        $row = mysql_fetch_assoc($query2);
        
	$u = $row['id_pregunta']. "=>". $row['descripcion'] . "=>". $row['tipo'] . "=>". $row['id_opciones'] ;
        

    return $u;
}

function funSetPregunta($id_preg, $id_op, $descripcion) {
    $u = -2;
	
	try {
            $query2 = mysql_query("UPDATE preguntas SET descripcion = '$descripcion', id_opciones=$id_op where id_pregunta = $id_preg") or die(mysql_error());
            $u = 0;
        } catch (Exception $e) {
            $u = -1;
        }	

    return $u;
}

function funGetTextAllPreguntas() {
    $u = "";
    $query2 = mysql_query("SELECT p.id_pregunta as idpreg,

		p.descripcion as txtpreg,

		p.tipo as tipop 

		FROM preguntas p") or die (mysql_error());
    
        while ($row = mysql_fetch_assoc($query2)) {
            $u = $u . $row['idpreg'] . "=>". $row['idpreg'] . "=>". $row ['idpreg']. "=>" . 
		$row['txtpreg'] . "=>". $row['tipop'] . "=>" ;
        }

    return $u;
}

function funGetOpcPregunta($id_preg) {
    $u = "-1";
    $query2 = mysql_query("SELECT o.descripcion 

	FROM opciones o, preguntas p 

	WHERE p.id_pregunta = $id_preg	and
      
        p.id_opciones=o.id_opcion") or die (mysql_error());

	$row = mysql_fetch_assoc($query2);
    	
	if ($row !=null){
		$u = $row['descripcion'];
	}

    return $u;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*function fungetDatosVisita() {
    $u = "";
    $query = mysql_query("SELECT COUNT(*) as Femenino FROM visitante_museo where sexo='Femenino' GROUP BY sexo") or die(mysql_error());
    $row = mysql_fetch_array($query);
    if ($row != NULL) {
         $u = $u = $row['Femenino'];
    }
    return $u;
}*/
/*
function fungetDatosVisita() {
 $u = "";
$querym = mysql_query("SELECT COUNT(*) as Masculino FROM visitante_museo where sexo='Masculino' GROUP BY sexo" ) or die(mysql_error());
$queryf = mysql_query("SELECT COUNT(*) as Femenino FROM visitante_museo where sexo='Femenino' GROUP BY sexo" ) or die(mysql_error());
$queryn = mysql_query("SELECT COUNT(*) as Uruguaya FROM visitante_museo where nacionalidad='Uruguaya' GROUP BY nacionalidad" ) or die(mysql_error());$querye = mysql_query("SELECT COUNT(*) as Extranjera FROM visitante_museo where nacionalidad='Extranjera' GROUP BY nacionalidad" ) or die(mysql_error());
$query12 = mysql_query("SELECT COUNT(*) as 0a12 FROM visitante_museo where rango_edad='0 a 12' GROUP BY rango_edad" ) or die(mysql_error());
$query15 = mysql_query("SELECT COUNT(*) as 13a15 FROM visitante_museo where rango_edad='13 a 15' GROUP BY rango_edad" ) or die(mysql_error());
$query18 = mysql_query("SELECT COUNT(*) as 16a18 FROM visitante_museo where rango_edad='16 a 18' GROUP BY rango_edad" ) or die(mysql_error());
$query18m = mysql_query("SELECT COUNT(*) as de18 FROM visitante_museo where rango_edad='+ de 18' GROUP BY rango_edad" ) or die(mysql_error());

   
$row1 = mysql_fetch_array($querym);
$row2 = mysql_fetch_array($queryf);
$row3 = mysql_fetch_array($queryn);
$row4 = mysql_fetch_array($querye);
$row5 = mysql_fetch_array($query12);
$row6 = mysql_fetch_array($query15);
$row7 = mysql_fetch_array($query18);
$row8 = mysql_fetch_array($query18m);

    if ($row1 != NULL) {
	$masculino=$row['Masculino'];
	}
	else
	{
	$masculino=0;
	}

    if ($row2 != NULL) {
	$femenino=$row['Femenino'];
	}
	else
	{
	$femenino=0;
	}
    if ($row3 != NULL) {
	$uruguaya=$row['Uruguaya'];
	}
	else
	{
	$uruguaya=0;
	}
    if ($row4 != NULL) {
	$extranjera=$row['Extranjera'];
	}
	else
	{
	$extranjera=0;
	}
     if ($row5 != NULL) {
	$ceroAdoce=$row['0a12'];
	}
	else
	{
	$ceroAdoce=0;
	}
     if ($row6 != NULL) {
	$treceAquince=$row['13a15'];
	}
	else
	{
	$treceAquince=0;
	}
      if ($row7 != NULL) {
	$dieciseisAdieciocho=$row['16a18'];
	}
	else
	{
	$dieciseisAdieciocho=0;
	}

       if ($row8 != NULL) {
	$masDEdieciocho=$row['de18'];
	}
	else
	{
	$masDEdieciocho=0;
	}





       $u = $u = $row['masculino'] . "=>" . $row['femenino'] . "=>" . $row['uruguaya'] . "=>" . $row['extranjera'] . "=>" . $row['ceroAdoce'] . "=>" . $row['treceAquince'] . "=>" .$row['dieciseisAdieciocho'] . "=>" . $row['masDEdieciocho'] . "=>";
    }
    return $u;
}
*/


//--------------------------- -------------------------


	
?>
