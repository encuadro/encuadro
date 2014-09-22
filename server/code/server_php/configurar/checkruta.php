<?
	$directorio=$_POST['ruta'];
	if(is_dir($directorio)) 
	{
		echo"1";  //si existe
	}
	else
	{
		echo"0"; //si no existe

	}


?>
