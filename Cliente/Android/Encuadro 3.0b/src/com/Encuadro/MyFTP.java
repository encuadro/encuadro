package com.Encuadro;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class MyFTP {
	public static String _HOST = "10.0.2.109"; 
	private boolean isObraLogin = false, isSalaLogin = false, isZonaLogin = false;
	public FTPClient salaClient = null, obraClient = null, zonaClient = null;
	String host = _HOST;//"10.0.2.109";
	//Salas
	String sUser = "salas", sPassword = "12345678";
	//Obras
	String oUser = "obras", oPassword = "12345678";
	//Zonas
	String zUser = "zonas", zPassword = "12345678";

	Context context;
	
	MyFTP(Context c){
	context = c;
	}

	public boolean LoginObras(){
		boolean status = false;
		try{
			obraClient = new FTPClient();
			obraClient.connect(host, 21);
			
			 // now check the reply code, if positive mean connection success
			 if (FTPReply.isPositiveCompletion(obraClient.getReplyCode())) {
				 // login using username & password
				 status = obraClient.login(oUser, oPassword);
				 isObraLogin = status;
				 
				 obraClient.setFileType(FTP.BINARY_FILE_TYPE);
				 obraClient.enterLocalPassiveMode();
			 }
		} catch(Exception e) {
			 System.out.println(e);
			 return false;
		}
		return status;
	}

	public boolean LoginSalas(){
		boolean status = false;
		try{
			salaClient = new FTPClient();
			salaClient.connect(host, 21);
			
			 // now check the reply code, if positive mean connection success
			 if (FTPReply.isPositiveCompletion(salaClient.getReplyCode())) {
				 // login using username & password
				 status = salaClient.login(sUser, sPassword);
				 isSalaLogin = status;
				 
				 salaClient.setFileType(FTP.BINARY_FILE_TYPE);
				 salaClient.enterLocalPassiveMode();
			 }
		} catch(Exception e) {
			 System.out.println(e);
			 return false;
		}
		return status;
	}

	public boolean LoginZona(){
		boolean status = false;
		try{
			zonaClient = new FTPClient();
			zonaClient.connect(host, 21);

			 // now check the reply code, if positive mean connection success
			 if (FTPReply.isPositiveCompletion(zonaClient.getReplyCode())) {
				 // login using username & password
				 status = zonaClient.login(zUser, zPassword);
				 isZonaLogin = status;
				 
				 zonaClient.setFileType(FTP.BINARY_FILE_TYPE);
				 zonaClient.enterLocalPassiveMode();
			 }
		} catch(Exception e) {
			 System.out.println(e);
			 return false;
		}
		return status;
	}

	public boolean LoginAll(){
		boolean statusObra=isObraLogin,statusSala=isSalaLogin,statusZona=isZonaLogin,result=false;
		if(!statusObra){
			statusObra = LoginObras();
		}
		if(!statusSala){
			statusSala = LoginSalas();
		}
		if(!statusZona){
			statusZona = LoginZona();
		}
		if(statusObra & statusSala & statusZona){
			result=true;
		}
		return result;
	}

	public void LogoutObras(){
		try {
			if(isObraLogin){
				obraClient.disconnect();
				isObraLogin = false;
			}
		} catch (IOException ioE) {
			System.out.println(ioE);
		}
	}

	public void LogoutSalas(){
		try {
			if(isSalaLogin){
				salaClient.disconnect();
				isSalaLogin = false;
			}
		} catch (IOException ioE) {
			System.out.println(ioE);
		}
	}

	public void LogoutZonas(){
		try {
			if(isZonaLogin){
				zonaClient.disconnect();
				isZonaLogin = false;
			}
		} catch (IOException ioE) {
			System.out.println(ioE);
		}
	}

	public void LogoutAll(){
		LogoutObras();
		LogoutSalas();
		LogoutZonas();
	}

	public boolean IfLoginSalas(){
		return isSalaLogin;
	}

	public boolean IfLoginZonas(){
		return isZonaLogin;
	}

	public boolean IfLoginObras(){
		return isObraLogin;
	}

	public boolean ifAllLogin(){
		if(isObraLogin & isSalaLogin & isZonaLogin) {
			return true;
		}
		else{
			return false;
		}
	}


	public Bitmap GetImgObra(String id, String name, boolean descargar, int loop){
		Bitmap img= null;
		File file = null;
		if(loop<=10){
			if(IfLoginObras()){
				try {
					file = new File(context.getCacheDir(), name); //or any other format supported
					if(file.exists()){
						System.out.println("Existe");
						FileInputStream streamIn = new FileInputStream(file);
						img = BitmapFactory.decodeStream(streamIn); //This gets the image
						streamIn.close();
					}
					else{
						System.out.println("no existe");
						if(descargar){
							if(descargarImg(id, name, obraClient)){
								System.out.println("descargo");
								// re false para que no buelba asecrargaralgo inesesario;
								descargar = false;
								img = GetImgObra(id, name, descargar, loop+1);
							}
							else{
								System.out.println("else de la descarga");
								descargar = true;
								img = GetImgObra(id, name, descargar,loop+1);
							}
						}
						else{
							img = GetImgObra(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return img;
				}
			}
		}
		return img;
	}
	
	public Bitmap GetImgSala(String id, String name, boolean descargar, int loop){
		Bitmap img= null;
		File file = null;
		if(loop<=10){
			if(IfLoginSalas()){
				try {
					file = new File(context.getCacheDir(), name); //or any other format supported
					if(file.exists()){
						System.out.println("Existe");
						FileInputStream streamIn = new FileInputStream(file);
						img = BitmapFactory.decodeStream(streamIn); //This gets the image
						streamIn.close();
					}
					else{
						System.out.println("no existe");
						if(descargar){
							if(descargarImg(id, name, salaClient)){
								System.out.println("descargo");
								//false para que no vuelva a cargar algo innecesario;
								descargar = false;
								img = GetImgSala(id, name, descargar, loop+1);
							}
							else{
								System.out.println("else de la descarga");
								descargar = true;
								img = GetImgSala(id, name, descargar,loop+1);
							}
						}
						else{
							img = GetImgSala(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return img;
				}
			}
		}
		return img;
	}
	
	public Bitmap GetImgZona(String id, String name, boolean descargar, int loop){
		Bitmap img= null;
		File file = null;
		if(loop<=10){
			if(IfLoginZonas()){
				try {
					file = new File(context.getCacheDir(), name); //or any other format supported
					if(file.exists()){
						System.out.println("Existe");
						FileInputStream streamIn = new FileInputStream(file);
						img = BitmapFactory.decodeStream(streamIn); //This gets the image
						streamIn.close();
					}
					else{
						System.out.println("no existe");
						if(descargar){
							if(descargarImg(id, name, zonaClient)){
								System.out.println("descargo");
								//false para que no vuelva a cargar algo innecesario;
								descargar = false;
								img = GetImgZona(id, name, descargar, loop+1);
							}
							else{
								System.out.println("else de la descarga");
								descargar = true;
								img = GetImgZona(id, name, descargar,loop+1);
							}
						}
						else{
							img = GetImgZona(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return img;
				}
			}
		}
		return img;
	}

	public Boolean getAudioObra(String id, String name, boolean descargar, int loop){
		Boolean result= false;
		File file = null;
		if(loop<=10){
			if(IfLoginObras()){
				try {
					file = new File(context.getCacheDir(), name);
					if(file.exists()){
						System.out.println("Existe");
						result = true;
					}
					else{
						System.out.println("no existe");
						if(descargar){
							if(descargarAudio(id, name, obraClient)){
								result= true;
							}
							else{
								System.out.println("else de la descarga");
								descargar = true;
								result = getAudioObra(id, name, descargar,loop+1);
							}
						}
						else{
							result = getAudioObra(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return false;
				}
			}
		}
		return result;
	}
	
	public Boolean getAudioSala(String id, String name, boolean descargar, int loop){
		Boolean result= false;
		File file = null;
		if(loop<=10){
			if(IfLoginSalas()){
				try {
					file = new File(context.getCacheDir(), name);
					if(file.exists()){
						System.out.println("Existe");
						result = true;
					}else{
						System.out.println("no existe");
						if(descargar){
							if(descargarAudio(id, name, salaClient)){
								result= true;
							}else{
								System.out.println("else de la descarga");
								descargar = true;
								result = getAudioSala(id, name, descargar,loop+1);
							}
						}else{
							result = getAudioSala(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return false;
				}
			}
		}
		return result;
	}
	
	public Boolean getAudioZona(String id, String name, boolean descargar, int loop){
		Boolean result= false;
		File file = null;
		if(loop<=10){
			if(IfLoginZonas()){
				try {
					file = new File(context.getCacheDir(), name);
					if(file.exists()){
						System.out.println("Existe");
						result = true;
					}
					else{
						System.out.println("no existe");
						if(descargar){
							if(descargarAudio(id, name, zonaClient)){
								result= true;
							}
							else{
								System.out.println("else de la descarga");
								descargar = true;
								result = getAudioZona(id, name, descargar,loop+1);
							}
						}
						else{
							result = getAudioZona(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return false;
				}
			}
		}
		return result;
	}

	public Boolean getVideoObra(String id, String name, boolean descargar, int loop){
		Boolean result= false;
		File file = null;
		if(loop<=10){
			if(IfLoginObras()){
				try {
					file = new File(context.getCacheDir(), name);
					if(file.exists()){
						System.out.println("Existe");
						result = true;
					}
					else{
						System.out.println("no existe");
						if(descargar){
							if(descargarVideo(id, name, obraClient)){
								result= true;
							}
							else{
								System.out.println("else de la descarga");
								descargar = true;
								result = getVideoObra(id, name, descargar,loop+1);
							}
						}
						else{
							result = getVideoObra(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return false;
				}
			}
		}
		return result;
	}
	
	public Boolean getVideoSala(String id, String name, boolean descargar, int loop){
		Boolean result= false;
		File file = null;
		if(loop<=10){
			if(IfLoginSalas()){
				try {
					file = new File(context.getCacheDir(), name);
					if(file.exists()){
						System.out.println("Existe");
						result = true;
					}
					else{
						System.out.println("no existe");
						if(descargar){
							if(descargarVideo(id, name, salaClient)){
								result= true;
							}
							else{
								System.out.println("else de la descarga");
								descargar = true;
								result = getVideoSala(id, name, descargar,loop+1);
							}
						}
						else{
							result = getVideoSala(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return false;
				}
			}
		}
		return result;
	}
	
	public Boolean getVideoZona(String id, String name, boolean descargar, int loop){
		Boolean result= false;
		File file = null;
		if(loop<=10){
			if(IfLoginZonas()){
				try {
					file = new File(context.getCacheDir(), name);
					if(file.exists()){
						System.out.println("Existe");
						result = true;
					}
					else{
						System.out.println("no existe");
						if(descargar){
							if(descargarVideo(id, name, zonaClient)){
								result= true;
							}
							else{
								System.out.println("else de la descarga");
								descargar = true;
								result = getVideoZona(id, name, descargar,loop+1);
							}
						}
						else{
							result = getVideoZona(id, name, descargar,loop+1);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
					return false;
				}
			}
		}
		return result;
	}

	public boolean descargarImg(String id, String name, FTPClient cliente){
		boolean result = false;
			try {
				FileOutputStream fos = null;
				fos = new FileOutputStream(context.getCacheDir() + "/" + name);
				cliente.retrieveFile("/" + id + "/imagen/" + name, fos);
				fos.close();
				result = true;
			} catch (Exception e) {
				System.out.println("error descarga :" + e);
				return false;
			}
		return result;
	}	
	
	public boolean descargarAudio(String id, String name, FTPClient cliente){
		boolean result = false;
			try {
				FileOutputStream fos = null;
				fos = new FileOutputStream(context.getCacheDir() + "/" + name);
				cliente.retrieveFile("/" + id + "/audio/" + name, fos);
				fos.close();
				result = true;
			} catch (Exception e) {
				System.out.println("error descarga :" + e);
				return false;
			}
		return result;
	}
	
	public boolean descargarVideo(String id, String name, FTPClient cliente){
		boolean result = false;
			try {
				FileOutputStream fos = null;
				fos = new FileOutputStream(context.getCacheDir() + "/" + name);
				cliente.retrieveFile("/" + id + "/video/" + name, fos);
				fos.close();
				result = true;
			} catch (Exception e) {
				System.out.println("error descarga :" + e);
				return false;
			}
		return result;
	}

	public boolean subirImgSala(String name, String path){
		boolean result = false;
		File file = null;
		if(IfLoginSalas()){
				try {
				file = new File(path);
				if(file.exists()){
					System.out.println("Existe");
					result =subirImg(name, salaClient, path);
					file.delete();
				}
				else{
					file.delete();
					System.out.println("no existe");
				}
			} catch (Exception e) {
				String error=String.valueOf(e);
				System.out.println(error);
				result = false;
			}
		}
		return result;
	}
	
	public boolean subirImgObra(String name, String path){
		boolean result = false;
		File file = null;
		if(IfLoginObras()){
				try {
				file = new File(path);
				if(file.exists()){
					System.out.println("Existe");
					result =subirImg(name, obraClient, path);
					file.delete();
				}
				else{
					file.delete();
					System.out.println("no existe");
				}
			} catch (Exception e) {
				String error=String.valueOf(e);
				System.out.println("error SO:" + error);
				result = false;
			}
		}
		return result;
	}
	
	public boolean subirImgZona(String name, String path){
		boolean result = false;
		File file = null;
		if(IfLoginZonas()){
				try {
				file = new File(path);
				if(file.exists()){
					System.out.println("Existe");
					result =subirImg(name, zonaClient, path);
					file.delete();
				}
				else{
					file.delete();
					System.out.println("no existe");
				}
			} catch (Exception e) {
				String error=String.valueOf(e);
				System.out.println(error);
				result = false;
			}
		}
		return result;
	}

	public boolean subirImg(String name, FTPClient cliente, String path){
		boolean result = false;
		File file = null;
		try{				
			file = new File(path);
			FileInputStream srcFileStream = new FileInputStream(file);
			System.out.print("cojio la imagen");
			result = cliente.storeFile("/" + name, srcFileStream);  
			System.out.print("subio la imagen");
			srcFileStream.close();
		}catch(Exception e){
			result = false;
			System.out.print(" Error: "+e.toString());
		}
		return result;
	}

	public void ftpPrintFilesList(){  
		try {  
		  FTPFile[] ftpFiles = obraClient.listFiles("/");  
		  int length = ftpFiles.length;  
		  for (int i = 0; i < length; i++) {  
			String name = ftpFiles[i].getName();  
			boolean isFile = ftpFiles[i].isFile();  
			if (isFile) {  
				System.out.print("File : " + name);  
			}  
			else {  
				System.out.print( "Directory : " + name);  
			}  
		  }  
		} catch(Exception e) {  
		  e.printStackTrace();  
		}  
	}   

	public void verContenidoDirectorio(){
		File f = new File(context.getCacheDir().getPath());
		File file[] = f.listFiles();
		System.out.print("Path: " + context.getCacheDir().getPath());
		for (int i=0; i < file.length; i++){
		 System.out.print(" FileName:" + file[i].getName());
		}
	}
	
	public String getContenidoDirectorio(){
		String result ="nada";
		File f = new File(context.getCacheDir().getPath());
		File file[] = f.listFiles();
		System.out.print("Path: " + context.getCacheDir().getPath());
		for (int i=0; i < file.length; i++){
		 System.out.print(" FileName:" + file[i].getName());
		 result = result + "\n FileName:" + file[i].getName();
		}
		return result;
	}	
}