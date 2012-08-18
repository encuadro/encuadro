<html>
 <head>
  <title>Ejemplo PHP</title>
 </head>
 <body>
 <?php echo '<p>Hola Mundo</p>'; ?> 
<form action="accion.php" method="post">
 <p>Su nombre: <input type="text" name="nombre" /></p>
 <p>Su edad: <input type="text" name="edad" /></p>
 <p><input type="submit" /></p>
</form>
<form action="suma.php" method="post">
 <p>Primer sumando: <input type="text" name="sumando1" /></p>
 <p>Seundo sumando: <input type="text" name="sumando2" /></p>
 <p><input type="submit" /></p>
</form>
</form>
<form action="borrar.php" method="post">
 <p>Nombre de la imagen a borrar: <input type="text" name="borrado" /></p>
 <p><input type="submit" /></p>
</form>
 </body>
</html>
