<?php


function fungetNombreObra ($id_sala, $nombre_archivo)
{
//-------------------------------------NUEVO------------------------------------------
//exec("convert -scale 15% /home/server/proyecto/obras/".$nombre_archivo." /home/server/proyecto/obras/".$nombre_archivo.".pgm");
 exec("convert /home/server/proyecto/obras/".$nombre_archivo." /home/server/proyecto/obras/".$nombre_archivo.".pgm");
  $u=-1;
$u = exec("/home/server/proyecto/prueba_binario/./encuadroSift /home/server/proyecto/obras/".$nombre_archivo.".pgm ".$id_sala);	
exec("rm /home/server/proyecto/obras/".$nombre_archivo." /home/server/proyecto/obras/".$nombre_archivo.".pgm");
return $u;

}


function fungenerarDescriptor ($id_sala,$id_obra,$nombre_archivo)
{
$nombre_archivo2 = $nombre_archivo;
$recortado = substr($nombre_archivo2,0,strpos($nombre_archivo2,'.')-strlen($nombre_archivo2));
exec("convert /home/server/proyecto/obras/".$id_obra."/imagen/".$nombre_archivo." /home/server/proyecto/obras/".$id_obra."/imagen/".$recortado.".pgm");
$res = -1;
$res=exec("/home/server/proyecto/prueba_binario/./encuadroSift /home/server/proyecto/obras/".$id_obra."/imagen/".$recortado.".pgm ".$id_obra." generar");


	return $res;


}




?>
