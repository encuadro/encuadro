<?php
	echo "Convirtiendo ffmpeg...\n\n";
	echo shell_exec("ffmpeg -i /var/www/video/vid.mpg /var/www/video/salida.avi &");
	echo "ya ta.\n";
?>



