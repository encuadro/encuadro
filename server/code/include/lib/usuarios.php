<?php

function conectar(){
    
     $dbhost = 'localhost';
     $dbusername = 'root';
     $dbuserpass = 'root';
     $dbname = 'proyecto';
     session_start();
	 // Conectar a la base de datos
     mysql_connect($dbhost, $dbusername, $dbuserpass);
     mysql_select_db($dbname) or die('Cannot select database');

 }

function login($user, $pass){
	
	 $log = -1;
	 conectar();
	 $query = mysql_query("SELECT id_usuario,pass FROM usuario WHERE nick LIKE BINARY '$user'") or die(mysql_error());
	 $row = mysql_fetch_array($query);
	 if($row == NULL)
		$log = -1;
	 else
		if ($row['pass'] != $pass) {
            $log=-1;
		} 
		else
		{
			$log = $row['id_usuario'];
		}
	 return $log;
}

$r = login('pepe', 'pepe');

echo 'log dio'.$r;



?>
