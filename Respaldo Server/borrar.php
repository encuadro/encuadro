<?php
$var1 = $_POST['borrado'];
shell_exec('rm '. $var1);
$output1 = shell_exec(ls);
echo "<pre>$output1</pre>";
?>
