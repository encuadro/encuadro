<?php
$var1 = $_POST['sumando1'];
$var2 = $_POST['sumando2'];
$output1 = shell_exec('./suma '. $var1 . ' ' . $var2);
echo "<pre>$output1</pre>";
?>
