$(document).ready(function(){  
	$("#formconfbd").css("display", "none");
	$("#formconf").css("display", "none");
	$("#ftpsalas").css("display", "none");
	$("#ftpobra").css("display", "none");
	$("#ftpzona").css("display", "none");
	
	$("#ftpsalas").css("display", "none");
	$("#formfinal").css("display", "none");
	
	
	 $('#guardarcambios').css("display", "none");;
	
	$('#titulo').html('<p> CREACION DE CUENTA DE USUARIO</p>');
	$('#comentario').html('<p> esto es una fucking prueba</p>');
	

	var prueba=0;	
	
	
	 function checkftp()
	{
		
	
		var rutasalas = $('input#rutasalas').val();
		var rutaobras = $('input#rutaobras').val();
		var rutazona = $('input#rutazona').val();
		var rutainclude = $('input#rutainclude').val();
		var rutaencuadro = $('input#rutaencuadro').val();
		
		
		
						$.post("checkruta.php",{ruta:rutazona},function(respuesta){
								if(respuesta==1)
								{
									
									//aca existe la ruta
									pintarcajitaverde('#rutazona');
									
									$.post("checkruta.php",{ruta:rutasalas},function(respuesta){
										if(respuesta==1)
										{
										pintarcajitaverde('#rutasalas');
											//encuentra salas
											
											$.post("checkruta.php",{ruta:rutaobras},function(respuesta){
												if(respuesta==1)
												{
													pintarcajitaverde('#rutaobras');
													
													
													$.post("checkruta.php",{ruta:rutaencuadro},function(respuesta){
														if(respuesta==1)
														{
															pintarcajitaverde('#rutaencuadro');
														
														
															$.post("checkruta.php",{ruta:rutainclude},function(respuesta){
																if(respuesta==1)
																{
																	pintarcajitaverde('#rutainclude');
																		
																		alert("Rutas Ingresadas Satisfactoriamente");
																		
																		$("#formconf").css("display", "none");
																		$("#ftpzona").css("display", "block");
																		
																		$('#titulo').html('<p> CONFIGURACION FTP ZONAS </p>');
																		$('#comentario').html('<p> esto es una fucking prueba</p>');	
																		
																		
																		//hacer aparecer el proximo formulario
																		//formulario ftp zona
																	
															
																}
																else
																{
																	alert("El directorio que eligió para Include no existe");
																	$('input#rutainclude').val("");
																	$('#rutainclude').focus();
																	pintarcajita('#rutainclude');
																
																}
														
															});
														
														}
														else
														{
															alert("El directorio que eligió para Encuadro no existe");
															$('input#rutaencuadro').val("");
															$('#rutaencuadro').focus();
															pintarcajita('#rutaencuadro');
														
														}
													});
													
												}	
												else	
												{	
														alert("El directorio que eligió para Obras no existe");
														$('input#rutaobras').val("");
														$('#rutaobras').focus();
														pintarcajita('#rutaobras');
														
												

												}	
											});	
										
											
										}
										else
										{
										
										
												alert("El directorio que eligió para Salas no existe");
												$('input#rutasalas').val("");
												$('#rutasalas').focus();
												pintarcajita('#rutasalas');
											
									
										}
									});
								
								}
								else
								{
									alert("El directorio que eligió para Zonas no existe");
									pintarcajita('#rutazona');
									$('input#rutazona').focus();
							
							
								}
							});
						}
						

	function checkbase()
	{
		var ipservidorbd = $('input#ipservidorbd').val();
		var adminbase = $('input#adminbase').val();
		var passbase = $('input#passadmin').val();
		var nombrebase = $('input#base').val();
		
		
		var usuario= $("input#nombreadmin").val();
		var passusuario=$("input#passadminsitio").val();
		
		
		$.post("checkbase.php",{ipservidor:ipservidorbd, bd:nombrebase, adminbase:adminbase, passbase:passbase},function(respuesta){
		//alert(respuesta);
				
				
				
				if(respuesta==1)
				{
					despintarcajita("#ipservidorbd");		
					despintarcajita("#adminbase");		
					despintarcajita("#passadmin");
					despintarcajita("#base");
					
							
							// $.post("conf.php",{ipservidor:ipservidorbd,bd:nombrebase,adminbase:adminbase, passbase:passbase,usuario:usuario,passusuario:passusuario},function(respuesta){
								alert("Guardado Base de datos Correcto");  
								$('#ipservidorbd').attr('disabled','disabled');
								pintarcajitaverde('#ipservidorbd');
								$('#adminbase').attr('disabled','disabled');
								$('#base').attr('disabled','disabled');
								pintarcajitaverde('#base');	
								
								pintarcajitaverde('#adminbase');		
								$('#passadmin').attr('disabled','disabled');
								pintarcajitaverde('#passadmin');
								$('#botonbd').attr('disabled','disabled');
								
								
								$("#formconfbd").css("display", "none");
								$("#formconf").css("display", "block");
										
										
								$('#titulo').html('<p> CONFIGURACION DE RUTAS DE DIRECTORIO</p>');
								$('#comentario').html('<p> esto es una fucking prueba</p>');		
					
															
								
							//}
							//);
			
								
				}
				else
				{
					pintarcajita("#ipservidorbd");		
					pintarcajita("#adminbase");		
					pintarcajita("#passadmin");
					pintarcajita("#base");
					$("#ipservidorbd").focus();
					
					alert("Verifique los datos de conexion a la base");
				}	
			}
		);
	}
	
	function pintarcajita(cajita)
	{
		    $(cajita).css("background","red");
			$(cajita).css("color","white");
	}
	
	function pintarcajitaverde(cajita)
	{
		    $(cajita).css("background","#00CC00");
			$(cajita).css("color","white");
	}
	
	function despintarcajita(cajita)
	{
		$(cajita).css("background","#ffffff");
		$(cajita).css("color","black");
		
	}
	
	$("#formconfbd").submit(function () {  
 
	
		
		if($("#ipservidorbd").val().length <= 6) {  
            alert("El servidor debe de tener más de 6 caracteres");  
			$("#ipservidorbd").focus();
			
			pintarcajita("#ipservidorbd");
			
            return false;  
        }  
		else
		{
		
			despintarcajita("#ipservidorbd");
			$("#base").focus();
			
				if($("#base").val().length == "" ) {  
					alert("El nombre de la Base de datos debe de tener un caracter como minimo");  
					$("#base").focus();	

					pintarcajita("#base");	
				   return false;
				   
				}  
				else
				{
					 despintarcajita("#base");		
					
						$("#adminbase").focus();
			
					if($("#adminbase").val().length == "" ) {  
						alert("El Admin de la BD debe de tener un caracter como minimo");  
						$("#adminbase").focus();	

						pintarcajita("#adminbase");	
						return false;
				   
					}  
					else
					{
					 despintarcajita("#adminbase");		
					
						if($("#passadmin").val().length == "" ) {
							alert("Ingrese el Password del Administrador");
							$("#passadmin").focus();
					
					
							pintarcajita("#passadmin");
							return false;
						}
						else
						{
							despintarcajita("#passadmin");
							checkbase();	
						}
					
					}
					
				}	
		}
		
			
        return false;  
    }); 
	
	
	
	
	

    $("#formconf").submit(function () {  
 
									
					
					
								if($("#rutazona").val().length == "") {  
									alert("La ruta al directorio Zona debe de tener al menos un caracter");  
									$("#rutazona").focus();
									
									pintarcajita("#rutazona");	
									return false;  
									
								}  
								else
								{
								
									despintarcajita("#rutazona");	
									
									
									if($("#rutasalas").val().length == "") {  
											alert("La ruta al directorio Salas debe de tener al menos un caracter");  
											$("#rutasalas").focus();
											
											pintarcajita("#rutasalas");	
											return false;  
											
										}  
										else
										{
											despintarcajita("#rutasalas");		
												
											
											
											if($("#rutaobras").val().length == "") {  
												alert("La ruta al directorio Obras debe de tener al menos un caracter");  
												$("#rutaobras").focus();
												
												pintarcajita("#rutaobras");	
												return false;  
												
											}  
											else
											{
												despintarcajita("#rutaobras");		
													
												
												if($("#rutaencuadro").val().length == "") {  
													alert("La ruta al directorio Encuadro debe de tener al menos un caracter");  
													$("#rutaencuadro").focus();
													
													pintarcajita("#rutaencuadro");	
													return false;  
													
												}  
												else
												{
													despintarcajita("#rutaencuadro");		
														
													if($("#rutainclude").val().length == "") {  
														alert("La ruta al directorio Include debe de tener al menos un caracter");  
														$("#rutainclude").focus();
														
														pintarcajita("#rutainclude");	
														return false;  
														
													}  
													else
													{
															checkftp();
													}
												}
													
											}
												
										}
								
								}
			
        return false;  
    }); 
	
	
	$("#configusuario").submit(function () {  
	
		if($("#nombreadmin").val().length != "" ) {
			pintarcajitaverde("#nombreadmin");
		
			
			if($("#passadminsitio").val().length != "" ){
				pintarcajitaverde("#passadminsitio");
			
				if($("#repassadminsitio").val().length !=""){
			
			
								if($("#passadminsitio").val()== $("#repassadminsitio").val()){
								
									pintarcajitaverde("#repassadminsitio");
									
										//aca paso al formulario de la base de datos
									
									$('#nombreadmin').attr('disabled','disabled');
									$('#passadminsitio').attr('disabled','disabled');
									$('#repassadminsitio').attr('disabled','disabled');
									
									$("#configusuario").css("display", "none");
									$("#formconfbd").css("display", "block");
									
									
									
									$('#titulo').html('<p> CONFIGURACION DE BASE DE DATOS </p>');
									$('#comentario').html('<p> esto es una fucking prueba</p>');
									
									
								}
								else
								{
									alert("Los Passwords no son iguales");
									pintarcajita("#passadminsitio");
									pintarcajita("#repassadminsitio");
									$("input#passadminsitio").val("");
									$("input#repassadminsitio").val("");
									$("#passadminsitio").focus();
								}
			
				}
				else
				{
					alert("Por favor repita su password");
				$("#repassadminsitio").focus();
				pintarcajita("#repassadminsitio");
				}
			}
			else
			{
				alert("Por favor por seguridad, ingrese un password");
				$("#passadminsitio").focus();
				pintarcajita("#passadminsitio");
		
			}
		
		}
		else
		{
			alert("Por favor ingrese Administrador");
			pintarcajita("#nombreadmin");
					$("#nombreadmin").focus();

		}
			
			
	return false;
	});
	
	
	
	
	$("#ftpzona").submit(function () {  
	
		if($("#ipservidorftpzona").val().length != "" ) {
			pintarcajitaverde("#ipservidorftp");
		
			
			if($("#usuarioftpzona").val().length != "" ){
				pintarcajitaverde("#usuarioftpzona");
			
				if($("#passftpzona").val().length !=""){
					pintarcajitaverde("#passftpzona");
						//chequear conexion
								var ipservidorftp=$("input#ipservidorftpzona").val();
								var usuario= $("input#usuarioftpzona").val();
								var pass=$("input#passftpzona").val();
								
								$.post("checkftp.php",{ipservidorftp:ipservidorftp, usuario:usuario, pass:pass},function(respuesta){
									if(respuesta==0)	
									{
											alert("Conecta al Servidor FTP");
											
											// dar valor a los otros formularios
											
											$("#ipservidorftpobra").val(ipservidorftp);
											$("#ipservidorftpsala").val(ipservidorftp);
											
											$('#ipservidorftpobra').attr('disabled','disabled');
											$('#ipservidorftpsala').attr('disabled','disabled');
											
											pintarcajitaverde("#ipservidorftpsala");
											pintarcajitaverde("#ipservidorftpobra");
											
											$("#ftpzona").css("display", "none");
											$("#ftpsalas").css("display", "block");
											
											
											
											
									}
									else
									{
										alert("No conecta al Servidor FTP");
									}
								});
			
				}
				else
				{
					alert("Por favor Ingrese su Password");
				$("#passftpzona").focus();
				pintarcajita("#passftpzona");
				}
			}
			else
			{
				alert("Por favor ingrese su usuario");
				$("#usuarioftpzona").focus();
				pintarcajita("#usuarioftpzona");	
			}
		}
		else
		{
			alert("Por favor ingrese Direccion del Servidor FTP");
			pintarcajita("#ipservidorftp");
					$("#ipservidorftp").focus();
		}
			
	return false;
	});
	
	
	
	
	$("#ftpsalas").submit(function () {  
			
			if($("#usuarioftpsala").val().length != "" ){
				pintarcajitaverde("#usuarioftpsala");
			
				if($("#passftpsala").val().length !=""){
					pintarcajitaverde("#passftpsala");
						//chequear conexion
								var ipservidorftp=$("input#ipservidorftpsala").val();
								var usuario= $("input#usuarioftpsala").val();
								var pass=$("input#passftpsala").val();
								
								$.post("checkftp.php",{ipservidorftp:ipservidorftp, usuario:usuario, pass:pass},function(respuesta){
									if(respuesta==0)	
									{
											alert("Conecta al Servidor FTP");
											
											$("#ftpsalas").css("display", "none");
											$("#ftpobra").css("display", "block");
											
											$('#titulo').html('<p> CONFIGURACION FTP OBRAS </p>');
											$('#comentario').html('<p> esto es una fucking prueba</p>');
											
											//desde aca paso al formulario ftp obras
									}
									else
									{
										alert("No conecta al Servidor FTP");
									}
								});
			
				}
				else
				{
					alert("Por favor Ingrese su Password");
				$("#passftpsala").focus();
				pintarcajita("#passftpsala");
				}
			}
			else
			{
				alert("Por favor ingrese su usuario");
				$("#usuarioftpsala").focus();
				pintarcajita("#usuarioftpsala");	
			}
		
	
	return false;
	});
	
	
	$("#ftpobra").submit(function () {  
		
			
			if($("#usuarioftpobra").val().length != "" ){
				pintarcajitaverde("#usuarioftpobra");
			
				if($("#passftpobra").val().length !=""){
					pintarcajitaverde("#passftpobra");
						//chequear conexion
								var ipservidorftpobra=$("input#ipservidorftpobra").val();
								var usuario= $("input#usuarioftpobra").val();
								var pass=$("input#passftpobra").val();
								
								$.post("checkftp.php",{ipservidorftp:ipservidorftpobra, usuario:usuario, pass:pass},function(respuesta){
									if(respuesta==0)	
									{
											alert("Conecta al Servidor FTP");
											$("#ftpobra").css("display", "none");
											$("#formfinal").css("display", "block");
											
											$('#titulo').html('<p>FINALIZANDO CONFIGURACION</p>');
											$('#comentario').html('<p> esto es una fucking prueba</p>');
											
									}
									else
									{
										alert("No conecta al Servidor FTP");
									}
								});
			
				}
				else
				{
					alert("Por favor Ingrese su Password");
				$("#passftpzona").focus();
				pintarcajita("#passftpzona");
				}
			}
			else
			{
				alert("Por favor ingrese su usuario");
				$("#usuarioftpzona").focus();
				pintarcajita("#usuarioftpzona");	
			}
	
		
		
	return false;
	});
	
	
	
	
	$("#formfinal").submit(function () {  
	
		var ipftp=$("input#ipservidorftpzona").val();
			
			
		$.post("checkrutans.php",{ipftp:ipftp},function(respuesta4){
									if(respuesta4 != 0)	
									{
											alert("existe");
											
											// aca guardo todos los campos
											
											
											var ipservidorbd = $('input#ipservidorbd').val();
											var adminbase = $('input#adminbase').val();
											var passbase = $('input#passadmin').val();
											var nombrebase = $('input#base').val();
		
											var rsala = $('input#rutasalas').val();
											var robra = $('input#rutaobras').val();
											var rzona = $('input#rutazona').val();
											var rinclude = $('input#rutainclude').val();
											var rencuadro = $('input#rutaencuadro').val();
											
											var usobra= $('input#usuarioftpobra').val();
											var pobra=$('input#passftpobra').val();
											
											var ussala= $('input#usuarioftpsala').val();
											var psala =$('input#passftpsala').val();
											
											var uszona= $('input#usuarioftpzona').val();
											var pzona=$('input#passftpzona').val();
											
											alert("antes del post");
											
											var respuesta;
											
											$.post("conf.php",{ipservidor:ipservidorbd,adminbase:adminbase,passbase:passbase,bd:nombrebase,rsala:rsala,robra:robra,rzona:rzona,rinclude:rinclude,rencuadro:rencuadro,sftp:ipftp,usobra:usobra,pobra:pobra,ussala:ussala,psala:psala,uszona:uszona,pzona:pzona,ns:respuesta},function(respuesta){
											
												if(respuesta==1)
												{
													alert("Se guardo su configuracion");
													location.reload();
												}
												else
												{	
													alert("La configuracion no pudo ser guardada");
													location.reload();
													
													
												}
												
											  
											});  
											
											
											
									}
									else
									{
										alert("no existe la carpeta server_php en su servidor ftp, el FTP debe de tener esta carpeta, vuelva a configurar ");
										location.reload();
									}
									
									
								});	
			
	return false;
	});
	
	
	
	
	$("#ftptotal").submit(function () {  
	
		if($("#ipservidorftp").val().length !=""){
		
			pintarcajitaverde('#ipservidorftp');
		
			if($("#usuarioftpsala").val().length !=""){
				pintarcajitaverde('#usuarioftpsala');
					if($("#passftpsala").val().length !=""){
						pintarcajitaverde('#passftpsala');
							if($("#usuarioftpobra").val().length !=""){
								pintarcajitaverde('#usuarioftpobra');
									if($("#passftpobra").val().length !=""){
										pintarcajitaverde('#passftpobra');
											if($("#usuarioftpzona").val().length !=""){
												pintarcajitaverde('#usuarioftpzona');
													if($("#passftpzona").val().length !=""){
														pintarcajitaverde('#passftpzona');
														
														
														
														
														$.post("checkrutans.php",{ipftp:$("input#ipservidorftp").val()},function(respuesta5){
														if(respuesta5 != 0)	
														{
												
														
															var ipservidorftp=$("input#ipservidorftp").val();
															var usuario= $("input#usuarioftpsala").val();
															var pass=$("input#passftpsala").val();
														
														
																$.post("checkftp.php",{ipservidorftp:ipservidorftp, usuario:usuario, pass:pass},function(respuesta){
																	if(respuesta==0)	
																	{
				
																			var usuarioobra= $("input#usuarioftpobra").val();
																			var passobra=$("input#passftpobra").val();
																			
																			
																			
																			$.post("checkftp.php",{ipservidorftp:ipservidorftp, usuario:usuarioobra, pass:passobra},function(respuesta1){
																			if(respuesta1==0)	
																			{
																					
																					
																					var usuariozona= $("input#usuarioftpzona").val();
																					var passzona=$("input#passftpzona").val();
																					$.post("checkftp.php",{ipservidorftp:ipservidorftp, usuario:usuariozona, pass:passzona},function(respuesta2){
																					if(respuesta2==0)	
																					{	
																						alert("Se configuro correctamente el FTP");
																					
																						prueba=prueba+3;		
																						habilitarboton();
																					
																						$('#botonbd').attr('disabled','disabled');
																					
																					
																					}	
																					else	
																					{
																						alert("La conexion FTP de zonas no es correcta, verifique usuario, password y servidor FTP");
																						$('input#ipservidorzona').val("");
																						$("#ipservidorzona").focus();
																						$('input#usuarioftpzona').val("");
																						$('input#passftpzona').val("");
																						
																					
																					}
																				});
																			}
																			else
																			{
																				alert("La conexion FTP de obras no es correcta, verifique usuario, password y servidor FTP");
																				$('input#ipservidorftp').val("");
																				pintarcajita('#ipservidorftp');
																				$("#ipservidorftp").focus();
																				$('input#usuarioftpobra').val("");
																				pintarcajita('#usuarioftpobra');
																				$('input#passftpobra').val("");
																				pintarcajita('#passftpobra');
																				
																			
																			}
																		});
																	}
																	else
																	{
																		alert("La conexion FTP de salas no es correcta, verifique usuario, password y servidor FTP");
																			$('input#ipservidorftp').val("");
																			$("#ipservidorftp").focus();
																			pintarcajita('#ipservidorftp');
																			
																			$('input#usuarioftpsala').val("");
																			pintarcajita('#usuarioftpsala');
																			$('input#passftpsala').val("");
																			pintarcajita('#passftpsala');
																		
																	}
																});
														
															}	
																else
															{
																alert("no existe la carpeta server_php en su servidor ftp, el FTP debe de tener esta carpeta, vuelva a configurar ");
																location.reload();
															}
															
															
														});	
															
														
														
														
														
														
														
														
											
													}
													else
													{
															alert("Por favor ingrese el password de zonas");
															$('input#passftpzona').val("");
															$("#passftpzona").focus();
															pintarcajita('#passftpzona');
													
													}
											
											}
											else
											{
													alert("Por favor ingrese el usuario FTP de zonas");
													$('input#usuarioftpzona').val("");
													$("#usuarioftpzona").focus();
													pintarcajita('#usuarioftpzona');
											}
							
									}
									else
									{
											alert("Por favor ingrese el password de obras");
											$('input#passftpobra').val("");
											$("#passftpobra").focus();
											pintarcajita('#passftpobra');
									}
							}
							else
							{
									alert("Por favor ingrese el usuario FTP de obras");
									$('input#usuarioftpobra').val("");
									$("#usuarioftpobra").focus();
									pintarcajita('#usuarioftpobra');
							
							}
						
					}
					else
					{
							alert("Por favor ingrese el password de salas");
							$('input#passftpsala').val("");
							$("#passftpsala").focus();
							pintarcajita('#passftpsala');
					
					
					}
			}
			else
			{
					alert("Por favor ingrese el usuario FTP de salas");
					$('input#usuarioftpsala').val("");
					$("#usuarioftpsala").focus();
					pintarcajita('#usuarioftpsala');
			}
				
		}
		else
		{
			alert("Por favor ingrese Direccion de servidor FTP");
			$('input#ipservidorftp').val("");
			$("#ipservidorftp").focus();
			pintarcajita('#ipservidorftp');
		}
			
		
			
	return false;
	});
	
	
	$("#formconfbdini").submit(function () {  
 
	
		
		if($("#ipservidorbd").val().length <= 6) {  
            alert("El servidor debe de tener más de 6 caracteres");  
			$("#ipservidorbd").focus();
			
			pintarcajita("#ipservidorbd");
			
            return false;  
        }  
		else
		{
		
			despintarcajita("#ipservidorbd");
			$("#base").focus();
			
				if($("#base").val().length == "" ) {  
					alert("El nombre de la Base de datos debe de tener un caracter como minimo");  
					$("#base").focus();	

					pintarcajita("#base");	
				   return false;
				   
				}  
				else
				{
					 despintarcajita("#base");		
					
						$("#adminbase").focus();
			
					if($("#adminbase").val().length == "" ) {  
						alert("El Admin de la BD debe de tener un caracter como minimo");  
						$("#adminbase").focus();	

						pintarcajita("#adminbase");	
						return false;
				   
					}  
					else
					{
					 despintarcajita("#adminbase");		
					
						if($("#passadmin").val().length == "" ) {
							alert("Ingrese el Password del Administrador");
							$("#passadmin").focus();
					
					
							pintarcajita("#passadmin");
							return false;
						}
						else
						{
							despintarcajita("#passadmin");
							checkbaseini();	
						}
					
					}
					
				}	
		}
		
			
        return false;  
    }); 
	
	
	function checkbaseini()
	{
		var ipservidorbd = $('input#ipservidorbd').val();
		var adminbase = $('input#adminbase').val();
		var passbase = $('input#passadmin').val();
		var nombrebase = $('input#base').val();
		
		
		var usuario= $("input#nombreadmin").val();
		var passusuario=$("input#passadminsitio").val();
		
		
		$.post("checkbase.php",{ipservidor:ipservidorbd, bd:nombrebase, adminbase:adminbase, passbase:passbase},function(respuesta){
		//alert(respuesta);
				
				
				if(respuesta==1)
				{
					despintarcajita("#ipservidorbd");		
					despintarcajita("#adminbase");		
					despintarcajita("#passadmin");
					despintarcajita("#base");
					
							
							// $.post("conf.php",{ipservidor:ipservidorbd,bd:nombrebase,adminbase:adminbase, passbase:passbase,usuario:usuario,passusuario:passusuario},function(respuesta){
								alert("Guardado Base de Datos Correcto");  
								$('#ipservidorbd').attr('disabled','disabled');
								pintarcajitaverde('#ipservidorbd');
								$('#adminbase').attr('disabled','disabled');
								pintarcajitaverde('#adminbase');		
								$('#base').attr('disabled','disabled');
								pintarcajitaverde('#base');	
								$('#passadmin').attr('disabled','disabled');
								pintarcajitaverde('#passadmin');
								$('#botonbd').attr('disabled','disabled');
								$("#formconfbd").css("display", "none");
								$("#formconf").css("display", "block");
										
							$('#botonbd').attr('background','green');		
										
								prueba=prueba+3;		
								habilitarboton();
							
							//}
							//);
			
								
				}
				else
				{
					pintarcajita("#ipservidorbd");		
					pintarcajita("#adminbase");		
					pintarcajita("#passadmin");
					pintarcajita("#base");
					$("#ipservidorbd").focus();
					
					alert("Verifique los datos de conexion a la base");
				}
				
						
				
			}
		);
	}
	
	
	function checkftpini()
	{
		
	
		var rutasalas = $('input#rutasalas').val();
		var rutaobras = $('input#rutaobras').val();
		var rutazona = $('input#rutazonas').val();
		var rutainclude = $('input#rutainclude').val();
		var rutaencuadro = $('input#rutaencuadro').val();
		
		
						var respuesta4;

						alert($('input#rutazonas').val());	



						

						
						$.post("checkruta2.php",{ruta:$("input#ipservidorftp"},function(respuesta4){

							alert(respuesta4);
							if(respuesta4==1)
							{
													
								alert("encuentra");

							}			

							});









						
							
							}
						
		 $("#formconfini").submit(function () {  
 
									
					
					
								if($("#rutazonas").val().length == "") {  
									alert("La ruta al directorio Zona debe de tener al menos un caracter");  
									$("#rutazonas").focus();
									
									pintarcajita("#rutazonas");	
									return false;  
									
									alert("llega aca");
									
								}  
								else
								{
								
									despintarcajita("#rutazona");	
									
									
										



									if($("#rutasalas").val().length == "") {  
											alert("La ruta al directorio Salas debe de tener al menos un caracter");  
											$("#rutasalas").focus();
											
											pintarcajita("#rutasalas");	
											return false;  
											
										}  
										else
										{
											despintarcajita("#rutasalas");		
												
											
											
											if($("#rutaobras").val().length == "") {  
												alert("La ruta al directorio Obras debe de tener al menos un caracter");  
												$("#rutaobras").focus();
												
												pintarcajita("#rutaobras");	
												return false;  
												
											}  
											else
											{
												despintarcajita("#rutaobras");		
													
												
												if($("#rutaencuadro").val().length == "") {  
													alert("La ruta al directorio Encuadro debe de tener al menos un caracter");  
													$("#rutaencuadro").focus();
													
													pintarcajita("#rutaencuadro");	
													return false;  
													
												}  
												else
												{
													despintarcajita("#rutaencuadro");		
														
													if($("#rutainclude").val().length == "") {  
														alert("La ruta al directorio Include debe de tener al menos un caracter");  
														$("#rutainclude").focus();
														
														pintarcajita("#rutainclude");	
												
														
													}  
													else
													{
															checkftpini();
													}
												}
													
											}
												
										}
								
								}
			
      
    }); 				
						
							 $("#finalini").submit(function () {  
				
		
											var ipftp=$('input#ipservidorftp').val();
											var ipservidorbd = $('input#ipservidorbd').val();
											var adminbase = $('input#adminbase').val();
											var passbase = $('input#passadmin').val();
											var nombrebase = $('input#base').val();
		//FORM BD
											var rsala = $('input#rutasalas').val();
											var robra = $('input#rutaobras').val();
											var rzona = $('input#rutazonas').val();
											
											
											var rinclude = $('input#rutainclude').val();
											var rencuadro = $('input#rutaencuadro').val();
				//form Rutas							
											var usobra= $('input#usuarioftpobra').val();
											var pobra=$('input#passftpobra').val();
											
											var ussala= $('input#usuarioftpsala').val();
											var psala =$('input#passftpsala').val();
											
											var uszona= $('input#usuarioftpzona').val();
											var pzona=$('input#passftpzona').val();
													
											
									$.post("checkrutans.php",{ipftp:$("input#ipservidorftp").val()},function(respuesta5){
									if(respuesta5 != 0)	
									{		
											
											
											var respuesta;
										$.post("conf.php",{ipservidor:ipservidorbd,adminbase:adminbase,passbase:passbase,bd:nombrebase,rsala:rsala,robra:robra,rzona:rzona,rinclude:rinclude,rencuadro:rencuadro,sftp:ipftp,usobra:usobra,pobra:pobra,ussala:ussala,psala:psala,uszona:uszona,pzona:pzona,ns:ipftp},function(respuesta){
											
												if(respuesta==1)
												{
													alert("Se guardo su configuracion");
													location.reload();
												}
												else
												{	
													alert("La configuracion no pudo ser guardada");
													location.reload();
													
													
												}
												
											  
											});  	
											
									}
									else
									{		
										alert("no existe la carpeta server_php en su servidor ftp, el FTP debe de tener esta carpeta, vuelva a configurar ");
										location.reload();
									}
									});			
											
											
										
		
			return false;
		
		});
						
						
						
						
						
						
	function habilitarboton(){					
		if (prueba==9)	
		{
			
			$("#guardarcambios").css("display", "block");   //cambiar a 9 cuando se ponga lo del ftp
		}					
						
		}

		
	
		
}); 
