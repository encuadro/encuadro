<?php
$uploaddir = './';      //Uploading to same directory as PHP file
$file = basename($_FILES['userfile']['name']);
$uploadFile = $file;
//$randomNumber = rand(0, 99999); 
$newName = $uploadDir . $uploadFile;


if (is_uploaded_file($_FILES['userfile']['tmp_name'])) {
	echo "Temp file uploaded. \r\n";
} else {
	echo "Temp file not uploaded. \r\n";
}

if ($_FILES['userfile']['size']> 3000000) {
	exit("Your file is too large."); 
}

if (move_uploaded_file($_FILES['userfile']['tmp_name'], $newName)) {
    $postsize = ini_get('post_max_size');   //Not necessary, I was using these
    $canupload = ini_get('file_uploads');    //server variables to see what was 
    $tempdir = ini_get('upload_tmp_dir');   //going wrong.
    $maxsize = ini_get('upload_max_filesize');
    echo "http://192.168.1.109/{$file}" . "\r\n" . $_FILES['userfile']['size'] . "\r\n" . $_FILES['userfile']['type'] ;
}
?>
