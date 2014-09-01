<?php
	
	$url=$_POST['ipftp'];
	
	$url="http://".$url."/server_php/";
	
		$handle = @fopen($url, "r");

		   if ($handle == false){
			echo"0";
			}
			else
			{	
		   fclose($handle);
		   
			echo $url;
			}

?>