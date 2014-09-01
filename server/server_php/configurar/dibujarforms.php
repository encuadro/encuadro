
	
	<html>
	
	<head>
	
		 <style type="text/css" src="plantilla.css"></style>	
	<script type="text/javascript" src="./jquery-1.9.1.js"></script>
<script type="text/javascript" src="./jquery.validate.js"></script>


  <link href="estilo.css" rel="stylesheet" type="text/css" />

   <script type="text/javascript" src="./js/jquery-1.4.2.min.js"></script>  
  
  <script type="text/javascript" src="./js/jquery.alerts.js"></script>  
<link href="./js/jquery.alerts.css" rel="stylesheet" type="text/css" />  

<script type="text/javascript" src="./funciones.js"></script>	
	
	
	</head>
	<body>
	
	
		<table width="96%">
			<tr>
				<td width="33%">
								<div id="progreso">
									Configuracion de Usuario
								</div>
								
								<div id="progreso1">
									Configuracion de base de Datos
								</div>
								
								<div id="progreso2">
									Configuracion FTP
								</div>
								
								<div id="progreso3">
									Fin de Configuracion
								</div>
	
		
		
		
				</td>
				
				<td width="66%" valign="top">
						<table width="100%">
							<tr>
								<td>
										<div id="titulo">	
										
										</div>
								</td>	
							</tr>
							<tr>
								<td>
									
									<table width="100%">
									<tr>	
										<td width="50%" valign="top">
								
											<div id="comentario">
														zx<z<xzx
							
											</div>
								
										</td >
										<td width="50%">
										
												
	
													
											
										
										
										
										
												<div id="formulario">	
												
												
													<form id="configusuario" action="" method="post">
														
															<ul>
															<li><label>Nombre Admin</label>
															<input type="text"  class="texto" id="nombreadmin" name="nombreadmin" maxlength="50" /></li>
															<li><label>Password</label>
															<input type="password"  class="texto" id="passadminsitio" name="passadminsitio" maxlength="10" /></li>
															<li><label>Repetir Password</label>
															<input type="password"  class="texto" id="repassadminsitio" name="repassadminsitio" maxlength="10" /></li>
															
																<input type="submit" value="Crear Usuario" />
															</li>
															</ul>
													</form>

													<form id="formconfbd" action="" method="post">
															<ul>
															<li><label>Direccion Base de datos</label>
															<input type="text" class="texto" id="ipservidorbd" name="ipservidorbd" maxlength="100" /></li>
															
															<li><label>Base de Datos</label>
															<input type="text" class="texto" id="base" name="base" maxlength="50" /></li>
															
															<li><label>Administrador de base</label>
															<input type="text" class="texto" id="adminbase" name="adminbase" maxlength="50" /></li>
															<li><label>Pass Administrador</label>
															<input type="password" class="texto" id="passadmin" name="passadmin" maxlength="50" /></li>
															
																<input type="submit" id="botonbd" name="botonbd" value="Checar Base" />
															</li>
															</ul>
													</form>	
			
													
												
													<form id="formconf" action="" method="post">
															<ul>
															<li><label>Ruta directorio Zona</label>
															<input type="text"  class="texto" id="rutazona" name="rutazona" maxlength="50" /></li>
															<li><label>Ruta directorio Salas</label>
															<input type="text"  class="texto" id="rutasalas" name="rutasalas" maxlength="50" /></li>
															<li><label>Ruta directorio Obras</label>
															<input type="text"  class="texto" id="rutaobras" name="rutaobras" maxlength="50" /></li>
															<li><label>Ruta directorio Encuadro</label>
															<input type="text"  class="texto" id="rutaencuadro" name="rutaencuadro" maxlength="50" /></li>
															<li><label>Ruta directorio include</label>
															<input type="text"  class="texto" id="rutainclude" name="rutainclude" maxlength="50" /></li>
															
															<input type="submit" value="Check FTP" />
															</li>
															</ul>
													</form>
													
													
													<form id="ftpsalas" action="" method="post">
															<ul>
															<li><label>Direccion Servidor Ftp</label>
															<input type="text"  class="texto" id="ipservidorftpsala" name="ipservidorftpsala" maxlength="50" /></li>
															<li><label>Usuario</label>
															<input type="text"  class="texto" id="usuarioftpsala" name="usuarioftpsala" maxlength="50" /></li>
															<li><label>Password</label>
															<input type="password"  class="texto" id="passftpsala" name="passftpsala" maxlength="50" /></li>
															<input type="submit" value="Check FTP" />
															</li>
															</ul>
													</form>
													
													<form id="ftpobra" action="" method="post">
															<ul>
															<li><label>Direccion Servidor Ftp</label>
															<input type="text"  class="texto" id="ipservidorftpobra" name="ipservidorftpobra" maxlength="50" /></li>
															<li><label>Usuario</label>
															<input type="text"  class="texto" id="usuarioftpobra" name="usuarioftpobra" maxlength="50" /></li>
															<li><label>Password</label>
															<input type="password"  class="texto" id="passftpobra" name="passftpobra" maxlength="50" /></li>
															<input type="submit" value="Check FTP" />
															</li>
															</ul>
													</form>
													
													<form id="ftpzona" action="" method="post">
															<ul>
															<li><label>Direccion Servidor Ftp</label>
															<input type="text"  class="texto" id="ipservidorftpzona" name="ipservidorftpzona" maxlength="50" /></li>
															<li><label>Usuario</label>
															<input type="text"  class="texto" id="usuarioftpzona" name="usuarioftpzona" maxlength="50" /></li>
															<li><label>Password</label>
															<input type="password"  class="texto" id="passftpzona" name="passftpzona" maxlength="50" /></li>
															<input type="submit" value="Check FTP" />
															</li>
															</ul>
													</form>
													
													<form id="formfinal" action="" method="post">
														<p>
															El Servidor se configuro correctamente.
														</p>
															<input type="submit" value="terminar" />
													</form>
													
												</div>	
												
										
										
										</td>
									</tr>
									</table>
								
								
								</td>
							</tr>	
						</table>
		
				</td>
			</tr>
		</table>	
		
	</body>
	
</html>