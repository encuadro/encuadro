<?php
$ini_array = parse_ini_file("/var/www/include/confi.ini", true);
$enable_log = $ini_array["general"]["enable_log"];

function mensaje_log($mensaje, $nivel=0)
{
    global $enable_log;
    if($enable_log>=$nivel) error_log($mensaje);
    return;
}
?>
