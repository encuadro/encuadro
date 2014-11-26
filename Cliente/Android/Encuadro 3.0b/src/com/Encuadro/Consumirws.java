package com.Encuadro;

import java.net.SocketTimeoutException;
import java.util.concurrent.TimeoutException;

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;



public class Consumirws {	 
     
	 private static String _PATH =  "http://"+MyFTP._HOST+"/server_php/";
	 private static String _URL =  _PATH + "server_php.php?wsdl";
	
	public String setFormulario(int id_visitante, String datos){
		String SOAP_ACTION = _PATH + "server_php.php/setCuestionarioVisitante";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "setCuestionarioVisitante";
	    String URL =_URL;
    
    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

	// Use this to add parameters

	request.addProperty("id_visitante", id_visitante);
	request.addProperty("id_result", datos);
	SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
			SoapEnvelope.VER11);

	envelope.setOutputSoapObject(request);
	envelope.dotNet = true;

	try {
		HttpTransportSE androidHttpTransport = new HttpTransportSE(URL);

		// this is the actual part that will call the webservice
		androidHttpTransport.call(SOAP_ACTION, envelope);

		// Get the SoapResult from the envelope body.
		SoapObject result = (SoapObject) envelope.bodyIn;

		if (result != null) {
			// Get the first property and change the label text
			return result.getProperty(0).toString();	
		} else {
			return "error:=>no se encontrosala=>";
		}
	}catch(SocketTimeoutException e){
		return "TiemOut Exeption: " + e.toString();
	}catch (Exception e) {
		return "error =>" + e.toString();
	}
   		
 }
	//obtine listado de preguntas y sus respuestas del formulario activo
	public String frutaMadre(){
		String SOAP_ACTION = _PATH + "server_php.php/getfrutamadre";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getfrutamadre";
	    String URL =_URL;
    
    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

	SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(	SoapEnvelope.VER11);

	envelope.setOutputSoapObject(request);
	envelope.dotNet = true;

	try {
		HttpTransportSE androidHttpTransport = new HttpTransportSE(URL);

		// this is the actual part that will call the webservice
		androidHttpTransport.call(SOAP_ACTION, envelope);

		// Get the SoapResult from the envelope body.
		SoapObject result = (SoapObject) envelope.bodyIn;

		if (result != null) {
			// Get the first property and change the label text
			return result.getProperty(0).toString();	
		} else {
			return "error:=>no se encontro sala=>";
		}
	}catch(SocketTimeoutException e){
		return "TiemOut Exeption: " + e.toString();
	}catch (Exception e) {
		return "error =>" + e.toString();
	}
   		
 }
	 public String getpuntajes(){
			String SOAP_ACTION = _PATH + "server_php.php/getpuntajes";
		    String NAMESPACE = _PATH;
		    String METHOD_NAME = "getpuntajes";
		    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(	SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();	
			} else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
	   		
	 }
	 public String getPosicion(int id_visitante){
			String SOAP_ACTION = _PATH + "server_php.php/getposicion";
		    String NAMESPACE = _PATH;
		    String METHOD_NAME = "getposicion";
		    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

	    request.addProperty("id_visitante", id_visitante);
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(	SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();	
			} else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
	   		
	 }
	 public String getHora(){
			String SOAP_ACTION = _PATH + "server_php.php/gethora";
		    String NAMESPACE = _PATH;
		    String METHOD_NAME = "gethora";
		    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		//request.addProperty("id_sala",idsala);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();	
			} else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
	   		
	 }
	 public String FinJuego(Integer id_visitante,Integer id_juego, Integer puntaje, String nick_name){
			String SOAP_ACTION = _PATH + "server_php.php/finJuego";
		    String NAMESPACE = _PATH;
		    String METHOD_NAME = "finJuego";
		    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		request.addProperty("id_visitante",id_visitante);
		request.addProperty("id_juego",id_juego);
		request.addProperty("puntaje",puntaje);
		request.addProperty("nick_name", nick_name);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();	
			} else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
	   		
	 }
	 
	public String getObraSala(int idsala){
		String SOAP_ACTION = _PATH + "server_php.php/getObraSala";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getObraSala";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		request.addProperty("id_sala",idsala);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();
			} 
			else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
	}

	public String getContenidoObra(String nombre){
		String SOAP_ACTION = _PATH + "server_php.php/getContenidoObra";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getContenidoObra";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		request.addProperty("nombre",nombre);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();
			} 
			else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
		
	}
	
	public String getContenidoSalaNombre(String nombre){
		String SOAP_ACTION = _PATH + "server_php.php/getContenidoSalaNombre";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getContenidoSalaNombre";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		request.addProperty("nombre",nombre);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();
			} 
			else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
		
	}


	public String getNombreObraDescriptor(int idSala, String nombre_archivo){
		String SOAP_ACTION = _PATH + "server_php.php/getNombreObra";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getNombreObra";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		request.addProperty("id_sala",idSala);
		request.addProperty("nombre_archivo",nombre_archivo);
		
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;
		System.out.println("FUNCION DE WEB SERVICE"+ idSala + "  "+ nombre_archivo);
		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();
			} 
			else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
	}
	
	public String getDataSalaNombreImagen(String nombre){
		String SOAP_ACTION = _PATH + "server_php.php/getDataSalaNombreImagen";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getDataSalaNombreImagen";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		request.addProperty("nombre",nombre);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();	
			} 
			else {
				return "error:=>no se encontrosala=>";
				
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
	}

    public String getDataSalaIdImagen(int idsala){
		String SOAP_ACTION = _PATH + "server_php.php/getDataSalaIdImagen";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getDataSalaIdImagen";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);
	
		// Use this to add parameters
	
		request.addProperty("id_sala",idsala);
	
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);
	
		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;
	
		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);
	
			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);
	
			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;
	
			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();
			} 
			else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
    }
    
    public String getVideoSalaId(int idsala){
		String SOAP_ACTION = _PATH + "server_php.php/getVideoSalaId";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getVideoSalaId";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);
	
		// Use this to add parameters
	
		request.addProperty("id_sala",idsala);
	
		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);
	
		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;
	
		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);
	
			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);
	
			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;
	
			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();
			} 
			else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
    }
	public String getDataSala(int idsala){
		String SOAP_ACTION = _PATH + "server_php.php/getDataSalaId";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getDataSalaId";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		request.addProperty("id_sala",idsala);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();
			} 
			else {
				return "error:=>no se encontrosala=>";
				
			}
		} catch (Exception e) {
			return "error =>" + e.toString();
		}
	}
	
	public String getDataObraId(int idobra){
		String SOAP_ACTION = _PATH + "server_php.php/getDataObraId";
	    String NAMESPACE = _PATH;
	    String METHOD_NAME = "getDataObraId";
	    String URL =_URL;
	    
	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

		// Use this to add parameters

		request.addProperty("id_obra",idobra);

		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
				SoapEnvelope.VER11);

		envelope.setOutputSoapObject(request);
		envelope.dotNet = true;

		try {
			HttpTransportSE androidHttpTransport = new HttpTransportSE(
					URL);

			// this is the actual part that will call the webservice
			androidHttpTransport.call(SOAP_ACTION, envelope);

			// Get the SoapResult from the envelope body.
			SoapObject result = (SoapObject) envelope.bodyIn;

			if (result != null) {
				// Get the first property and change the label text
				return result.getProperty(0).toString();
			} 
			else {
				return "error:=>no se encontrosala=>";
			}
		} catch (Exception e) {
			return "error e =>" + e.toString();
		}
	}
	
	 public String getObras(){
   		String SOAP_ACTION = _PATH + "server_php.php/getObras";
   	    String NAMESPACE = _PATH;
   	    String METHOD_NAME = "getObras";
   	    String URL =_URL;
   	    
   	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

   		// Use this to add parameters

   		//request.addProperty("id_sala",idsala);

   		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
   				SoapEnvelope.VER11);

   		envelope.setOutputSoapObject(request);
   		envelope.dotNet = true;

   		try {
   			HttpTransportSE androidHttpTransport = new HttpTransportSE(
   					URL);

   			// this is the actual part that will call the webservice
   			androidHttpTransport.call(SOAP_ACTION, envelope);

   			// Get the SoapResult from the envelope body.
   			SoapObject result = (SoapObject) envelope.bodyIn;

   			if (result != null) {
   				// Get the first property and change the label text
   				return result.getProperty(0).toString();	
   			} else {
   				return "error:=>no se encontrosala=>";
   			}
   		} catch (Exception e) {
   			return "error =>" + e.toString();
   		}
	   		
   	 }
	 
	 public String getObrasl(String obra){
   		String SOAP_ACTION = _PATH + "server_php.php/getObrasl";
   	    String NAMESPACE = _PATH;
   	    String METHOD_NAME = "getObrasl";
   	    String URL =_URL;
   	    
   	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

   		// Use this to add parameters

   		request.addProperty("nombre_obra",obra);

   		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
   				SoapEnvelope.VER11);

   		envelope.setOutputSoapObject(request);
   		envelope.dotNet = true;

   		try {
   			HttpTransportSE androidHttpTransport = new HttpTransportSE(
   					URL);

   			// this is the actual part that will call the webservice
   			androidHttpTransport.call(SOAP_ACTION, envelope);

   			// Get the SoapResult from the envelope body.
   			SoapObject result = (SoapObject) envelope.bodyIn;

   			if (result != null) {
   				// Get the first property and change the label text
   				return result.getProperty(0).toString();	
   			} 
   			else {
   				return "error:=>no se encontrosala=>";
   			}
   		} catch (Exception e) {
   			return "error =>" + e.toString();
   		}
	 }
	 
	 public String getSalasl(String sala){
   		String SOAP_ACTION = _PATH + "server_php.php/getSalasl";
   	    String NAMESPACE = _PATH;
   	    String METHOD_NAME = "getSalasl";
        
   	    String URL =_URL;
   	    
   	    
   	    
   	    
   	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

   		// Use this to add parameters

   		request.addProperty("nombre",sala);

   		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
   				SoapEnvelope.VER11);

   		envelope.setOutputSoapObject(request);
   		envelope.dotNet = true;

   		try {
   			HttpTransportSE androidHttpTransport = new HttpTransportSE(
   					URL);

   			// this is the actual part that will call the webservice
   			androidHttpTransport.call(SOAP_ACTION, envelope);

   			// Get the SoapResult from the envelope body.
   			SoapObject result = (SoapObject) envelope.bodyIn;

   			if (result != null) {
   				// Get the first property and change the label text
   				return result.getProperty(0).toString();
   			} else {
   				return "error:=>no se encontrosala=>";
   			}
   		} catch (Exception e) {
   			return "error =>" + e.toString();
   		}
   	}
	 
	 public String getNombreSalas(){	
   		String SOAP_ACTION = _PATH + "server_php.php/getNombreSalas";
   	    String NAMESPACE = _PATH;
   	    String METHOD_NAME = "getNombreSalas";
   	    String URL =_URL;
   	    
   	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

   		// Use this to add parameters

   		//request.addProperty("id_sala",idsala);

   		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
   				SoapEnvelope.VER11);

   		envelope.setOutputSoapObject(request);
   		envelope.dotNet = true;

   		try {
   			HttpTransportSE androidHttpTransport = new HttpTransportSE(
   					URL);

   			// this is the actual part that will call the webservice
   			androidHttpTransport.call(SOAP_ACTION, envelope);

   			// Get the SoapResult from the envelope body.
   			SoapObject result = (SoapObject) envelope.bodyIn;

   			if (result != null) {
   				// Get the first property and change the label text
   				return result.getProperty(0).toString();	
   			} else {
   				return "error:=>no se encontrosala=>";
   			}
   		} catch (Exception e) {
   			return "error =>" + e.toString();
   		}
   		
   	}
       
	 public String getDataObra(String obra){	
   		String SOAP_ACTION = _PATH + "server_php.php/getDataObra";
   	    String NAMESPACE = _PATH;
   	    String METHOD_NAME = "getDataObra";
   	    String URL =_URL;
   	    
   	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

   		// Use this to add parameters

   		request.addProperty("nombre_obra",obra);

   		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
   				SoapEnvelope.VER11);

   		envelope.setOutputSoapObject(request);
   		envelope.dotNet = true;

   		try {
   			HttpTransportSE androidHttpTransport = new HttpTransportSE(
   					URL);

   			// this is the actual part that will call the webservice
   			androidHttpTransport.call(SOAP_ACTION, envelope);

   			// Get the SoapResult from the envelope body.
   			SoapObject result = (SoapObject) envelope.bodyIn;

   			if (result != null) {
   				// Get the first property and change the label text
   				return result.getProperty(0).toString();	
   			} else {
   				return "error:=>no se encontrosala=>";
   			}
   		} catch (Exception e) {
   			return "error =>" + e.toString();
   		}
   	}
   	
	 public String getNombreObraLike(String obra){
  		String SOAP_ACTION = _PATH + "server_php.php/getNombreObraLike";
  	    String NAMESPACE = _PATH;
  	    String METHOD_NAME = "getNombreObraLike";
  	    String URL =_URL;
  	    
  	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

  		// Use this to add parameters

  		request.addProperty("nombre_obra",obra);

  		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
  				SoapEnvelope.VER11);

  		envelope.setOutputSoapObject(request);
  		envelope.dotNet = true;

  		try {
  			HttpTransportSE androidHttpTransport = new HttpTransportSE(
  					URL);

  			// this is the actual part that will call the webservice
  			androidHttpTransport.call(SOAP_ACTION, envelope);

  			// Get the SoapResult from the envelope body.
  			SoapObject result = (SoapObject) envelope.bodyIn;

  			if (result != null) {
  				// Get the first property and change the label text
  				return result.getProperty(0).toString();	
  			} else {
  				return "error:=>no se encontro obra=>";
  			}
  		} catch (Exception e) {
  			return "error =>" + e.toString();
  		} 		
  	}
	 public String getContenidoSalaId(int id_Sala){
	   		
	   		String SOAP_ACTION = _PATH + "server_php.php/getContenidoSala";
	   	    String NAMESPACE = _PATH;
	   	    String METHOD_NAME = "getContenidoSala";
	   	    String URL =_URL;
	   	    
	   	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

	   		// Use this to add parameters

	   		request.addProperty("id_Sala",id_Sala);

	   		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
	   				SoapEnvelope.VER11);

	   		envelope.setOutputSoapObject(request);
	   		envelope.dotNet = true;

	   		try {
	   			HttpTransportSE androidHttpTransport = new HttpTransportSE(
	   					URL);

	   			// this is the actual part that will call the webservice
	   			androidHttpTransport.call(SOAP_ACTION, envelope);

	   			// Get the SoapResult from the envelope body.
	   			SoapObject result = (SoapObject) envelope.bodyIn;

	   			if (result != null) {
	   				// Get the first property and change the label text
	   				return result.getProperty(0).toString();
	   				
	   				//nombreapp.setText("Nombre "+separated[0] +" id "+contents+ "desc. " + separated[1]);

	   				
	   			} else {
	   				return "error:=>no se encontrosala=>";
	   				
	   			}
	   		} catch (Exception e) {
	   			return "error =>" + e.toString();
	   		}
	   		
	   	}
	 public String Altavisita(String nacioV, String sexoV, String visita, String edadV){
 		
	 		String SOAP_ACTION = _PATH + "server_php.php/Altavisita";
	 	    String NAMESPACE = _PATH;
	 	    String METHOD_NAME = "Altavisita";
	 	    String URL =_URL;
	 	    
	 	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

	 		// Use this to add parameters
	      
	 	    
	 		request.addProperty("nacionalidad", nacioV);
	 		request.addProperty("sexo", sexoV);
	 		request.addProperty("tipo_visita", visita);
	 		request.addProperty("rango_edad", edadV);

	 		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
	 				SoapEnvelope.VER11);

	 		envelope.setOutputSoapObject(request);
	 		envelope.dotNet = true;

	 		try {
	 			HttpTransportSE androidHttpTransport = new HttpTransportSE(URL,10000);

	 			// this is the actual part that will call the webservice
	 			androidHttpTransport.call(SOAP_ACTION, envelope);

	 			// Get the SoapResult from the envelope body.
	 			SoapObject result = (SoapObject) envelope.bodyIn;

	 			if (result != null) {
	 				// Get the first property and change the label text
	 				return result.getProperty(0).toString();
	 				
	 				//nombreapp.setText("Nombre "+separated[0] +" id "+contents+ "desc. " + separated[1]);

	 				
	 			} else {
	 				return "error:=>no se encontrosala=>";
	 				
	 			}
	 		}catch (Exception e) {
	 			return "-2";
	 		}
	 		
	 	}
	 
     public String BuscarPista(int idobra, int idjuego){
 		
 		String SOAP_ACTION = _PATH + "server_php.php/BusquedaPista";
 	    String NAMESPACE = _PATH;
 	    String METHOD_NAME = "BusquedaPista";
 	    String URL =_URL;
 	    
 	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

 		// Use this to add parameters

 		request.addProperty("id_obra",idobra);
 		request.addProperty("idjuego",idjuego);

 		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
 				SoapEnvelope.VER11);

 		envelope.setOutputSoapObject(request);
 		envelope.dotNet = true;

 		try {
 			HttpTransportSE androidHttpTransport = new HttpTransportSE(
 					URL);

 			// this is the actual part that will call the webservice
 			androidHttpTransport.call(SOAP_ACTION, envelope);

 			// Get the SoapResult from the envelope body.
 			SoapObject result = (SoapObject) envelope.bodyIn;

 			if (result != null) {
 				// Get the first property and change the label text
 				return result.getProperty(0).toString();
 				
 				
 			} else {
 				return "error:=>no se encontrosala=>";
 				
 			}
 		} catch (Exception e) {
 			return "Error ws  =>" + e.toString();
 		}
 		
 	}

     public String ObraPerteneceAJuego(int idobra){
    		
    		String SOAP_ACTION = _PATH + "server_php.php/ObraPerteneceAJuego";
    	    String NAMESPACE = _PATH;
    	    String METHOD_NAME = "ObraPerteneceAJuego";
    	    String URL =_URL;
    	    
    	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

    		// Use this to add parameters

    		request.addProperty("id_obra",idobra);

    		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
    				SoapEnvelope.VER11);

    		envelope.setOutputSoapObject(request);
    		envelope.dotNet = true;

    		try {
    			HttpTransportSE androidHttpTransport = new HttpTransportSE(
    					URL);

    			// this is the actual part that will call the webservice
    			androidHttpTransport.call(SOAP_ACTION, envelope);

    			// Get the SoapResult from the envelope body.
    			SoapObject result = (SoapObject) envelope.bodyIn;

    			if (result != null) {
    				// Get the first property and change the label text
    				return result.getProperty(0).toString();
    				
    			} else {
    				return "error:=>no se encontrosala=>";
    				
    			}
    		} catch (Exception e) {
    			return "Error ws  =>" + e.toString();
    		}
    		
    	}

     public String CantidadObrasJuego(int id_juego){
  		
   		String SOAP_ACTION = _PATH + "server_php.php/CantidadObrasJuego";
   	    String NAMESPACE = _PATH;
   	    String METHOD_NAME = "CantidadObrasJuego";
   	    String URL =_URL;
   	    
   	    SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

   		// Use this to add parameters

   		request.addProperty("id_juego",id_juego);

   		SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(
   				SoapEnvelope.VER11);

   		envelope.setOutputSoapObject(request);
   		envelope.dotNet = true;

   		try {
   			HttpTransportSE androidHttpTransport = new HttpTransportSE(
   					URL);

   			// this is the actual part that will call the webservice
   			androidHttpTransport.call(SOAP_ACTION, envelope);

   			// Get the SoapResult from the envelope body.
   			SoapObject result = (SoapObject) envelope.bodyIn;

   			if (result != null) {
   				// Get the first property and change the label text
   				return result.getProperty(0).toString();

   				
   			} else {
   				return "error:=>no se encontro juego=>";
   				
   			}
   		} catch (Exception e) {
   			return "Error ws  =>" + e.toString();
   		}
   		
   	}

}