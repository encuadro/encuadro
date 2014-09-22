


<?php




$ini_array = parse_ini_file("C:\\prueba\\confi.ini", true);
 
$servidorbd=$ini_array['BD']['servidor'];
$nombrebase=$ini_array['BD']['nombase'];
$nombreusuariobd=$ini_array['BD']['usuario'];
$passbd=$ini_array['BD']['passbd'];


$rutazona=$ini_array['RUTA']['zona'];
$rutaobra=$ini_array['RUTA']['obra'];
$rutasala=$ini_array['RUTA']['sala'];
$rutaencuadro=$ini_array['RUTA']['encuadro'];
$rutainclude=$ini_array['RUTA']['include'];

$servidorftp=$ini_array['ftp']['servidor'];

$usuftpsala=$ini_array['ftpsala']['usu'];
$passftpsala=$ini_array['ftpsala']['pass'];

$usuftpzona=$ini_array['ftpzona']['usu'];
$passftpzona=$ini_array['ftpzona']['pass'];

$usuftpobra=$ini_array['ftpobra']['usu'];
$passftpobra=$ini_array['ftpobra']['pass'];

$rutaencuadro=substr($rutaencuadro,0,-14);

			echo"
						<script type='text/javascript' src='./funciones.js'></script>	

			<div id='formularioini'>

					<form id='formconfini' action='' method='post'>
								<ul>
								<li><label>Ruta directorio Zona</label>
								<input type='text'  class='texto' id='rutazonas' value=$rutazona    name='rutazonas' maxlength='50' /></li>
								<li><label>Ruta directorio Salas</label>
								<input type='text'  class='texto' id='rutasalas' value=$rutasala name='rutasalas' maxlength='50' /></li>
								<li><label>Ruta directorio Obras</label>
								<input type='text'  class='texto' id='rutaobras' value=$rutaobra name='rutaobras' maxlength='50' /></li>
								<li><label>Ruta directorio Encuadro</label>
								<input type='text'  class='texto' id='rutaencuadro' value=$rutaencuadro name='rutaencuadro' maxlength='50' /></li>
								<li><label>Ruta directorio include</label>
								<input type='text'  class='texto' id='rutainclude' value=$rutainclude name='rutainclude' maxlength='50' /></li>
								
								<input name='botonconfini' id='botonconfini' type='submit' value='Check FTP' />
								</li>
								</ul>
						</form>

				</div>	

		
				
				<div id='formftpsalaini'>	

					
					
					<form id='ftptotal' action='' method='post'>
							<ul>
							
							<li><label>Direccion Servidor Ftp</label>
							<input type='text'  class='texto' id='ipservidorftp' value=$servidorftp name='ipservidorftp' maxlength='50' /></li>
							<li><label>FTP Sala</label></li>
							<li><label>Usuario</label>
							<input type='text'  class='texto' id='usuarioftpsala' value=$usuftpsala name='usuarioftpsala' maxlength='50' /></li>
							<li><label>Password</label>
							<input type='text'  class='texto' id='passftpsala' value=$passftpsala name='passftpsala' maxlength='50' /></li>
							
							<li><label>FTP Obra</label></li>
							<li><label>Usuario</label>
							<input type='text'  class='texto' id='usuarioftpobra' value=$usuftpobra name='usuarioftpobra' maxlength='50' /></li>
							<li><label>Password</label>
							<input type='text'  class='texto' id='passftpobra' value=$passftpobra name='passftpobra' maxlength='50' /></li>
							
							<li><label>FTP Zona</label></li>
							<li><label>Usuario</label>
							<input type='text'  class='texto' id='usuarioftpzona' value=$usuftpzona name='usuarioftpzona' maxlength='50' /></li>
							<li><label>Password</label>
							<input type='text'  class='texto' id='passftpzona' value=$passftpzona name='passftpzona' maxlength='50' /></li>
							
							
							<input type='submit' value='Check FTP' /> 
							</li>
							</ul>
					</form>
					
				</div>	
				
				
				
				<div id='formulariobdini'>
	
					<form id='formconfbdini' action='' method='post'>
							<ul>
							<li><label>Direccion Base de datos</label>
							<input type='text' class='texto' id='ipservidorbd' value=$servidorbd name='ipservidorbd' maxlength='100' /></li>
							
							<li><label>Base de Datos</label>
							<input type='text' class='texto' id='base' value=$nombrebase name='base' maxlength='50' /></li>
							
							<li><label>Administrador de base</label>
							<input type='text' class='texto' id='adminbase' value=$nombreusuariobd name='adminbase' maxlength='50' /></li>
							<li><label>Pass Administrador</label>
							<input type='text' class='texto' id='passadmin' value=$passbd  name='passadmin' maxlength='50' /></li>
							
								<input type='submit' id='botonbd' name='botonbd' value='Checar Base' />
							</li>
							</ul>
					</form>
				
				
				
				
				</div>

				
				<div id='mensajitoini'>
						<p> Por seguridad guarde todos los formularios y luego podra grabar los cambios de su
							configuracion </p>
				
						<form id='finalini'>
							<input type='submit' id='guardarcambios' name='guardarcambios' value='Guardar Cambios' />
						</form>
				
				</div>

";				
?>