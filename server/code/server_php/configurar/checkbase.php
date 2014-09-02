<?php

$servidorbd=$_POST["ipservidorbd"];
$nombrebase=$_POST["bd"];
$adminbd=$_POST["adminbase"];
$passbd=$_POST["passbase"];

	
			$respuesta = 1;
				$conexion = mysql_connect($servidorbd,$adminbd,$passbd);
				if (!$conexion){
					$respuesta = 0;
				}else{
					$dbresult=mysql_select_db($nombrebase, $conexion);
					if (!$dbresult){
						$respuesta = 0;
					}
					else
					{
						$respuesta=1;
						mysql_close($conexion);
					}
				}	
				
echo $respuesta;




?>