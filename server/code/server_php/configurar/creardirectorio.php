<?php

	$ruta=$_POST['ruta'];

	if(!mkdir($ruta, 0, true))
	{
		die('0');
	}
	else
	{
		echo"1";
	}

?>