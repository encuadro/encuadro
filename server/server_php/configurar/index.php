<html>
<head>
	<title></title>
	 <style type="text/css" src="plantilla.css"></style>	


  <link href="estilo.css" rel="stylesheet" type="text/css" />

   <script type="text/javascript" src="./js/jquery-1.4.2.min.js"></script>  
  
  
<link href="./js/jquery.alerts.css" rel="stylesheet" type="text/css" />  

<script type="text/javascript" src="./funciones.js"></script>	
	
	
<script type="text/javascript">
	
	$.post("existearchivo.php",function(respuesta){
			if(respuesta==1)
			{
			
				$("#principal").load("encuentraarchivo.php");
			
			}
			else
			{
				$("#principal").load("dibujarforms.php");
			}
	
		});
	
	
	</script>	
	
</head>
<body>

<div id='principal'>

	



</div>

</body>
</html>