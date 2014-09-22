
<?php
	
	function conectarbase($servidorbd,$adminbd,$passbd,$nombrebase){
	
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
				
			return respuesta;
	}
	
	
	function existearchivo($nombreruta){
		
		if (file_exists($nombreruta)){ 
				echo "El directorio Existe."; 
				//$reffichero = fopen("mifichero.txt", "a"); 
		}else
		{ 
			echo "El Directorio no existe."; 
			//$reffichero = fopen($nombreruta, "w+");           crea un archivo y lo abre
		} 

	}	


?>
