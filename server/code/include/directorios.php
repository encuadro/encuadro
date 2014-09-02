<?php

 function rrmdir2($dir) {
    $handle = opendir($dir);
    while ($file = readdir($handle)) {
        if (is_file($dir . $file)) {
            unlink($dir . $file);
        }
    }
}



function rrmdir($dir) {
    if (is_dir($dir)) {
        $objects = scandir($dir);
        foreach ($objects as $object) {
            if ($object != "." && $object != "..") {
                if (filetype($dir . "/" . $object) == "dir")
                    rrmdir($dir . "/" . $object); else
                    unlink($dir . "/" . $object);
            }
        }
        reset($objects);
        rmdir($dir);
    }
}

?>
