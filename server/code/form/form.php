<!DOCTYPE html><!--PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CONFIGURACION</title>
<link rel="stylesheet" type="text/css" href="view.css" media="all">
<script type="text/javascript" src="view.js"></script>
 
</head>
<body id="main_body" style="background: #BAD7D4;">

<?php
	$error = 0;
	
	
	function error_ruta($var){
		global $error;
		if($_GET["l"])
		
		if (!file_exists($var)){  
			echo '<img src="x.jpg"  width="3%" height="3%" style="padding-left: 3%;padding-right: 2%;"><b>Ruta invalida!</b></img>';
			$error = 1;
		}
	}  

	function error_ftp($ftp_server){
		global $error;
		if($_GET["l"])
		if(!ftp_connect($ftp_server,21,2)){
			echo '<img src="x.jpg"  width="3%" height="3%" style="padding-left: 3%;padding-right: 2%;"><b style="font-size: 103.5%";>Error Servidor!</b></img>';
			$error = 1;
		}
		
	}
	
	function login_ftp($user,$pass){
		global $error;
		if($_GET["l"])
		{
			$conn_id = ftp_connect($_POST["element_13"],21,2);
			if(!ftp_login($conn_id, $user, $pass)){
				echo '<div><img src="x.jpg"  width="3%" height="3%" style="padding-left: 56.3%;padding-right: 2%;"><b style="font-size: 102%;">Error Login!</b></img></div>';	
			$error = 1;}
		}
	}
		

	function error_mysql(){
		global $error;
if($_GET["l"])
		{
		
		   	if($_POST["element_2"] and $_POST["element_3"] and $_POST["element_4"] and $_POST["element_5"]){  
		     		if(mysql_connect($_POST["element_2"], $_POST["element_4"],$_POST["element_5"]))
    		      			if (mysql_select_db($_POST["element_3"]))
						{}//echo 'anduvo base de datos';
					else{
						echo '<div><img src="x.jpg"  width="3%" height="3%" style="padding-left: 60.8%;padding-right: 1%;"><b style="font-size: 102%;">Error Conexión!</b></img></div>';
						$error = 1;
					    }

				else{	echo '<div><img src="x.jpg"  width="3%" height="3%" style="padding-left: 60.8%;padding-right: 1%;"><b style="font-size: 102%;">Error Conexión!</b></img></div>';
					$error = 1;
					
				    }					
			}else $error =1;

		}		   

	 }

	function error($var){
		global $error;
		if($_GET["l"])
		{  if(!$var){
			echo '<img src="x.jpg"  width="3%" height="3%" style="padding-left: 3%;padding-right: 2%;"><b>Campo vacio!</b></img>';
			$error = 1;				
			}
		   
			
		}
	}

 

 function rellenar(){
	$ini_array = parse_ini_file("/var/include/confi.ini", true);
	
	$host = $ini_array['BD']['servidor'];
	$user = $ini_array['BD']['usuario'];
	$pass = $ini_array['BD']['passbd'];
	$name = $ini_array['BD']['nombase'];

	$ruta_obra = $ini_array['RUTA']['obra'];
	$ruta_sala = $ini_array['RUTA']['sala'];
	$ruta_zona = $ini_array['RUTA']['zona'];
	$ruta_encuadro = $ini_array['RUTA']['encuadro'];
	$ruta_include = $ini_array['RUTA']['include'];
	
	$ftp = $ini_array['ftp']['servidor'];
	
	$usu_sala = $ini_array['ftpsala']['usu'];
	$pass_sala = $ini_array['ftpsala']['pass'];

	$usu_zona = $ini_array['ftpzona']['usu'];
	$pass_zona = $ini_array['ftpzona']['pass'];

	$usu_obra = $ini_array['ftpobra']['usu'];
	$pass_obra = $ini_array['ftpobra']['pass'];

	$ns = $ini_array['ns']['ns'];
	

?>
	
	<img id="top" src="top.png" alt="">
	<div id="form_container">
	
		<h1><a>CONFIGURACION</a></h1>
		<form id="form_620205" class="appnitro"  method="post" action="form.php?l=1">
					<div class="form_description" >
			<h2>CONFIGURACION</h2>
			<p>Configuración del servidor.</p>
		</div>						
			<ul>
			
					<li class="section_break">
			<div style="float:left"><h3><b>Base de Datos</b></h3></div><? error_mysql();?>
			<p></p>
		</li>		<li id="li_2" >
		<label class="description" for="element_2">Servidor </label>
		<div>
			<input id="element_2" name="element_2" class="element text medium" type="text" maxlength="255" value="<?echo $host?>"><?error($_POST["element_2"]);?></input>
		
			
		</div> 
		</li>		<li id="li_3" >
		<label class="description" for="element_3">Nombre base de datos
 </label>
		<div>
			<input id="element_3" name="element_3" class="element text medium" type="text" maxlength="255" value="<?echo $name?>"><?error($_POST["element_3"]);?></input> 
		</div> 
		</li>		<li id="li_4" >
		<label class="description" for="element_4">Usuario </label>
		<div>
			<input id="element_4" name="element_4" class="element text medium" type="text" maxlength="255" value="<?echo $user?>"><?error($_POST["element_4"]);?></input> 
		</div> 
		</li>		<li id="li_5" >
		<label class="description" for="element_5">Contraseña </label>
		<div>
			<input id="element_5" name="element_5" class="element text medium" type="text" maxlength="255" value="<?echo $pass?>"><?error($_POST["element_5"]);?></input> 
		</div> 
		</li>		<li class="section_break">
			<div style="float:left"><h3><b>Directorios</b></h3></div>
			<p></p>
		</li>		<li id="li_7" >
		<label class="description" for="element_7">Salas </label>
		<div>
			<input id="element_7" name="element_7" class="element text medium" type="text" maxlength="255" value="<?echo $ruta_sala?>"><?error($_POST["element_7"]); error_ruta($_POST["element_7"]);?></input> 
		</div> 
		</li>		<li id="li_8" >
		<label class="description" for="element_8">Obras </label>
		<div>
			<input id="element_8" name="element_8" class="element text medium" type="text" maxlength="255" value="<?echo $ruta_obra?>"><?error($_POST["element_8"]);error_ruta($_POST["element_8"]);?></input> 
		</div> <link href="/twitter-bootstrap/twitter-bootstrap-v2/docs/assets/css/bootstrap.css" rel="stylesheet">  
		</li>		<li id="li_9" >
		<label class="description" for="element_9">Zonas </label>
		<div>
			<input id="element_9" name="element_9" class="element text medium" type="text" maxlength="255" value="<?echo $ruta_zona?>"><?error($_POST["element_9"]);error_ruta($_POST["element_9"]);?></input>
		</div> 
		</li>		<li id="li_10" >
		<label class="description" for="element_10">Encuadro Sift </label>
		<div>
			<input id="element_10" name="element_10" class="element text medium" type="text" maxlength="255" value="<?echo $ruta_encuadro?>"><?error($_POST["element_10"]);error_ruta($_POST["element_10"]);?></input> 
		</div> 
		</li>		<li id="li_11" >
		<label class="description" for="element_11">Include </label>
		<div>
			<input id="element_11" name="element_11" class="element text medium" type="text" maxlength="255" value="<?echo $ruta_include?>"><?error($_POST["element_11"]);error_ruta($_POST["element_11"]);?></input> 
		</div> 
		</li>		<li class="section_break">
			<div style="float:left"><h3><b>Ftp</b></h3></div>
			<p></p>
		</li>		<li id="li_13" >
		<label class="description" for="element_13">Servidor </label>
		<div>
			<input id="element_13" name="element_13" class="element text medium" type="text" maxlength="255" value="<?echo $ftp?>"><?error($_POST["element_13"]);error_ftp($_POST["element_13"]);?></input>
		</div> 
		</li>		<li class="section_break">
			<div style="float:left">
			<h3><b>Usuario Ftp Salas</b></h3>
			</div>	<? login_ftp($_POST["element_15"],$_POST["element_16"])?>
			<p></p>
		</li>		<li id="li_15" >
		<label class="description" for="element_15">Usuario </label>
		<div>
			<input id="element_15" name="element_15" class="element text medium" type="text" maxlength="255" value="<?echo $usu_sala?>"><?error($_POST["element_15"]);?></input> 
		</div> 
		</li>		<li id="li_16" >
		<label class="description" for="element_16">Contraseña </label>
		<div>
			<input id="element_16" name="element_16" class="element text medium" type="text" maxlength="255" value="<?echo $pass_sala?>"><?error($_POST["element_16"]);?></input> 
		</div> 
		</li>		<li class="section_break">
			<div style="float:left">
			<h3><b>Usuario Ftp Obras</b></h3>
			</div>			
			<? login_ftp($_POST["element_18"],$_POST["element_19"])?>
			<p></p>
		</li>		<li id="li_18" >
		<label class="description" for="element_18">Usuario </label>
		<div>
			<input id="element_18" name="element_18" class="element text medium" type="text" maxlength="255" value="<?echo $usu_obra?>"><?error($_POST["element_18"]);?></input> 
		</div> 
		</li>		<li id="li_19" >
		<label class="description" for="element_19">Contraseña </label>
		<div>
			<input id="element_19" name="element_19" class="element text medium" type="text" maxlength="255" value="<?echo $pass_obra?>"><?error($_POST["element_19"]);?></input> 
		</div> 
		</li>				<li class="section_break">
			<div style="float:left">
			<h3><b>Usuario Ftp Zonas</b></h3>
			</div>	<? login_ftp($_POST["element_22"],$_POST["element_23"])?>
			<p></p>
		</li>		<li id="li_22" >
		<label class="description" for="element_22">Usuario </label>
		<div>
			<input id="element_22" name="element_22" class="element text medium" type="text" maxlength="255" value="<?echo $usu_zona?>"><?error($_POST["element_22"]);?></input>
		</div> 
		</li>		<li id="li_23" >
		<label class="description" for="element_23">Contraseña </label>
		<div>
			<input id="element_23" name="element_23" class="element text medium" type="text" maxlength="255" value="<?echo $pass_zona?>"><?error($_POST["element_23"]);?></input> 
		</div> 
		</li>		<li class="section_break">
			<div style="float:left"><h3><b>Namespace</b></h3></div>
			<p></p>
		</li>		<li id="li_25" >
		<label class="description" for="element_25">Nombre </label>
		<div>
			<input id="element_25" name="element_25" class="element text medium" type="text" maxlength="255" value="<?echo $ns?>"><?error($_POST["element_25"]);?></input>
		</div> 
		</li>
			
					<li class="buttons">
			    <input type="hidden" name="form_id" value="620205" />
				<?probar_boton();?>
			      
				
		</li>
			</ul>
		</form>	
		<div id="footer">
			Generated by <a href="http://tecnoinf.0fees.net/" target="_blank" >TIP</a>
		</div>
	</div>
	<img id="bottom" src="bottom.png" alt="">
<?php 	
	}

		function probar_boton(){
?><link href="bootstrap.css" rel="stylesheet"> 
<input id="saveForm" style="width:20%;margin-left:1%;" class="btn btn-success" type="submit" name="submit" value="Guardar" />
			<?
		}

function escribe_ini($matriz, $archivo, $multi_secciones = true, $modo = 'w') {
	
     $salida = '';
 
     # saltos de lnea (usar "\r\n" para Windows)
     define('SALTO', "\n");
 
     if (!is_array(current($matriz))) {
         $tmp = $matriz;
         $matriz['tmp'] = $tmp; # no importa el nombre de la seccin, no se usar
         unset($tmp);
     }
 
     foreach($matriz as $clave => $matriz_interior) {
         if ($multi_secciones) {
             $salida .= '['.$clave.']'.SALTO;
         }
 
         foreach($matriz_interior as $clave2 => $valor)
             $salida .= $clave2.' = "'.$valor.'"'.SALTO;
 
         if ($multi_secciones) {
             $salida .= SALTO;
         }
     }
 
     $puntero_archivo = fopen($archivo, $modo);
 
     if ($puntero_archivo !== false) {
         $escribo = fwrite($puntero_archivo, $salida);
 
         if ($escribo === false) {
             $devolver = -2;
         } else {
             $devolver = $escribo;
         }
 
         fclose($puntero_archivo);
     } else {
         $devolver = -1;
     }
 
     return $devolver;
 }	
	if($_GET["e"]){?>
		<link href="bootstrap.css" rel="stylesheet"> 
			<div class="modal">
  <div class="modal-header">
    <a type="button" class="close" href="form.php" data-dismiss="modal" aria-hidden="false">&times;</a>
    <h3>Enhorabuena!!</h3>
  </div>
  <div class="modal-body">
    <p>El archivo se guardo correctamente.</p>
  </div>
  <div class="modal-footer">
    <!!<a href="form.php" class="btn" Volver</a>
    <a href="form.php" class="btn btn-success">Volver</a>
  </div>
</div>
	<?}
	
	else
	if($_GET["l"]){
		if (ningunovacio()){
		rellenar();
			//echo $error;
			if($error==0){
                $array['BD']['servidor'] = $_POST["element_2"];
                $array['BD']['nombase'] = $_POST["element_3"];
                $array['BD']['usuario'] = $_POST["element_4"];
                $array['BD']['passbd'] = $_POST["element_5"];
                $array['RUTA']['zona'] = $_POST["element_9"];
                $array['RUTA']['obra'] = $_POST["element_8"];
                $array['RUTA']['sala'] = $_POST["element_7"];
                $array['RUTA']['encuadro'] = $_POST["element_10"];
                $array['RUTA']['include'] = $_POST["element_11"];
                $array['ftp']['servidor'] = $_POST["element_13"];
                $array['ftpsala']['usu'] = $_POST["element_15"];
                $array['ftpsala']['pass'] = $_POST["element_16"];
                $array['ftpzona']['usu'] = $_POST["element_22"];
                $array['ftpzona']['pass'] = $_POST["element_23"];
                $array['ftpobra']['usu'] = $_POST["element_18"];
                $array['ftpobra']['pass'] = $_POST["element_19"];
                $array['ns']['ns'] = $_POST["element_25"];
               	if(escribe_ini($array,"/var/include/confi.ini")!=-1)
			{?>


<script>
window.location.replace("form.php?e=1");
</script>


			<?  
			}
                   
                    }else  {}                          
			//rellenar();
                        
                           }
		else{
		
 			rellenar();}		
	
	}else
	{
	
	  rellenar();
		
	}    	

	function ningunovacio(){
		if($_POST["element_2"] and $_POST["element_3"] and $_POST["element_4"] and $_POST["element_5"] and 
		 	$_POST["element_7"] and $_POST["element_8"] and $_POST["element_9"] and $_POST["element_10"] and $_POST["element_11"] and 
			$_POST["element_13"] and $_POST["element_15"] and $_POST["element_16"] and $_POST["element_18"] and $_POST["element_19"] and 
			$_POST["element_22"] and $_POST["element_23"] and $_POST["element_25"])
			return true;
		else
			return false;
	}

?>



	</body>
</html>
