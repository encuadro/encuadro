<?php

$servidorbd="localhost";
$adminbd="root";
$passbd="maximiliano";
$nombrebase="joomla";

	
			$respuesta = 0;
				$conexion = mysql_connect($servidorbd,$adminbd,$passbd);
				if (!$conexion){
					$respuesta = 1;
				}else{
					$dbresult=mysql_select_db($nombrebase, $conexion);
					if (!$dbresult){
						$respuesta = 1;
					}
				}	
				
echo $respuesta;







?>
