package com.Encuadro;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.net.ftp.FTPClient;

import com.example.qr.R;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class ContenidoObras extends Activity {
	TextView tv1,tv2,tv3;
	Button btnPlay, btnVideo;
	ImageView img;
	public FTPClient mFTPClient = null;
	ProgressDialog pDialog;
	MediaPlayer mp;
	Integer posicion = 0, idjuego=0, idProximaObra=0, jugando=0;
	String nombre="", idObra="", videocache="";
	Consumirws ws = new Consumirws();
	
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
	 
	SharedPreferences prefs=null;
	SharedPreferences.Editor editor=null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_contenido_obras);
		
		prefs = getSharedPreferences("user",Context.MODE_PRIVATE);
		editor = prefs.edit();
		destruir();
		
		tv1 = (TextView) findViewById(R.id.textView1);
		tv2 = (TextView) findViewById(R.id.textView2);
		tv3 = (TextView) findViewById(R.id.textView3);
		img = (ImageView)findViewById(R.id.imageView1);
		btnPlay = (Button) findViewById(R.id.btnPlay);
		btnVideo = (Button) findViewById(R.id.btnVideo);
		 
		//SETEAMOS VARIABLES  
		idjuego = prefs.getInt("idjuego",0);
		jugando = prefs.getInt("estajugando",0);
 		idProximaObra= prefs.getInt("obrasig",0); 
		
		Bundle extras = getIntent().getExtras();
		Parser parser = new Parser(extras.getString("result"));//String[] separated = extras.getString("result").split("=>");
		System.out.println("result-->"+extras.getString("result"));
		String [] img = parser.getParameter("imagen").split("/");//separated[4].split("/");
		
		FtpExecute ftp = new FtpExecute();
    	String[] obra = {parser.getParameter("id_obra"),img[img.length-1]};//{separated[0],separatedImg[(separatedImg.length-1)]};
    	ftp.execute(obra);
		
    	idObra = parser.getParameter("id_obra");//separated[0];
    	nombre = parser.getParameter("nombre_obra");//separated[1];
    	tv1.setText(parser.getParameter("nombre_obra"));//separated[1]);
		tv2.setText("Autor: " + parser.getParameter("autor"));//separated[6]);
		tv3.setText("Descripcion Obra: \n" + parser.getParameter("descripcion_obra"));//separated[2]);
		btnPlay.setText("Audio");
		
		//EJECUTA EL OBRAPERTENECEAJUEGO CON EL idObra
    	if(idjuego>0 && jugando==1 ){
    		System.out.println("Está jugando");
//    		Toast.makeText(this, "jugando", Toast.LENGTH_SHORT).show();
    		final Integer idobra = Integer.parseInt(idObra);					//Obtengo la obra recientemente escaneada
    		Integer obrasig=prefs.getInt("obrasig",0);			//Obtengo la obra siguiente obtenida en la escaneada anterior
    		System.out.println("Idobra: "+idobra+" - obrasig: "+obrasig);
    		if (idobra.equals(obrasig)){									//Comparo si son iguales para seguir con el juego
    			System.out.println("Entro");
    			editor.putInt("idobraactual", idobra);
	    		editor.commit();
	    		
	    		AlertDialog.Builder builderjuego = new AlertDialog.Builder(ContenidoObras.this);
	    		builderjuego.setTitle("Obra encontrada");
	    		builderjuego.setMessage("¡Excelente!");
	    		builderjuego.setPositiveButton("Aceptar", new DialogInterface.OnClickListener() {
			    	public void onClick(DialogInterface dialog, int which) {
			    		Integer progreso = prefs.getInt("progreso",0);
			    		Integer cantobra = prefs.getInt("cantidadobras",0); 
			    		
			    		editor.putInt("progreso",progreso+1);
		    			editor.commit();
		    			
			    		System.out.println("Progreso: "+progreso+" - Cantidad "+cantobra);
			    		if((progreso+1)==cantobra){
			    			
			    					Mensaje_Fin();
			    		}
			    		else {
			    			
			    			BuscarPista bp = new BuscarPista();
		                	System.out.println("Buscarpista: "+idobra.toString()+" - "+idjuego);
		                  	bp.execute(idobra.toString(), idjuego.toString());
			    		}
			    	}
			    });
	    		builderjuego.create();
	    		builderjuego.show();
    		}
    		else {
    			System.out.println("No entro");
//    			Toast.makeText(this, "no juega " + idjuego, Toast.LENGTH_LONG).show();
    		}
    	}
    	else if(idjuego==0){
//    		Toast.makeText(this, "no juega " + idjuego, Toast.LENGTH_LONG).show();
    		ObraPreteneceAJuego opj = new ObraPreteneceAJuego();
        	opj.execute(idObra);
    	}
		
		btnPlay.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if(btnPlay.getText().toString()=="Audio"){
					FtpAudio ftpaudio = new FtpAudio();
					ftpaudio.execute(idObra,nombre);	
					btnPlay.setText("Stop");
				}else{
					btnPlay.setText("Audio");
					detener(v);
				}
			}
		});
		
		btnVideo.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				descargarVideo();
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.contenido_obras, menu);
		return true;
	}
	
	class FtpExecute extends AsyncTask<String,String,Bitmap>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ContenidoObras.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected Bitmap doInBackground(String... params) {
	    	Bitmap bitmap=null;
        	try {
        		MyFTP ftp = new MyFTP(getApplicationContext());
		    	if(ftp.LoginObras()){
		    		bitmap = ftp.GetImgObra(params[0],params[1],true,0);
		    		System.out.println("-->"+params[0]+params[1]);
		    	}
			} catch (Exception e) {
				System.out.println("Error: " + e);
			}
        	return bitmap;
        }
 
        @Override
        protected void onPostExecute(Bitmap bitmap) {
        	if(bitmap != null){
    			img.setImageBitmap(bitmap);
    		}else{
    			System.out.print(" img: null ");
    		}
        	pDialog.dismiss();
        }
    }

	class FtpAudio extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ContenidoObras.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	if(ws == null)
        		ws = new Consumirws();
        	String result="Audio..";
        	String nombre=params[1];
        	String idObra=params[0];
        	String audio = null;
        	try {
        		MyFTP ftp = new MyFTP(getApplicationContext());
		    	if(ftp.LoginObras()){
		    		result = ws.getContenidoObra(nombre);
		    		//String separatedaux[] = result.split("=>");
		    		Parser parser = new Parser(result);
		    		String separatedAudio[] = parser.getParameter("audio").split("/");
		    		audio = separatedAudio[separatedAudio.length-1];
		    		result = "Audio : " + audio + " ID: " + idObra;
		    		System.out.println(result);
		    		if(audio!=null){
			    		if(ftp.getAudioObra(idObra, audio, true, 0)){
			    			File fil = new File(ContenidoObras.this.getCacheDir() + "/" + audio );
			    			FileInputStream fis = new FileInputStream(fil.getPath());
			    			if(fil.exists()){
				    			mp = new MediaPlayer();
				    			mp.setDataSource(fis.getFD());
				    		
				    	        if(mp == null) {            
				    	           result = "Create() on MediaPlayer failed";       
				    	        } 
				    	        else {
				    	            mp.setOnCompletionListener(new OnCompletionListener() {
										@Override
										public void onCompletion(MediaPlayer mp) {
											// TODO Auto-generated method stub
									        if (mp != null) {
									            mp.stop();
									            mp.release();
									            mp = null;
									            posicion = 0;
									            btnPlay.setText("Audio");
									        }
										}
				    	            });
				    	            mp.prepare(); 
				    	            mp.start();
				    	            result = "Reprodiciendo...";		
				    	        }
			    			}
			    			else{
			    				result = "Obra sin audio ";
			    			}
			    			fis.close();
			    		}
		    		}
		    		else{
		    			result = "Obra sin audio ";
		    		}
		    	}
			}catch(NullPointerException n){
				result = "Obra sin audio ";
			}catch (Exception e) {
				result = "Obra sin audio ";
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String respuesta) {
        	if(respuesta=="Obra sin audio ") btnPlay.setText("Audio");
        	Toast.makeText(getApplicationContext(), respuesta, Toast.LENGTH_LONG).show();
        	pDialog.dismiss();	
        }
    }
	
	public void destruir() {
        if (mp != null)
            mp.release();
        	mp = null;
    }
	
    public void detener(View v) {
        if (mp != null) {
            mp.stop();
            mp.release();
            mp = null;
            posicion = 0;
        }
    }

	private void descargarVideo(){
		obtenerNombreVideo name = new obtenerNombreVideo();
		System.out.print( "Entro a descargarVideo"+name);
		name.execute();
		
	}
	
	class obtenerNombreVideo extends AsyncTask<String,String,String>{
	    @Override
	    protected void onPreExecute() {
	    	pDialog = new ProgressDialog(ContenidoObras.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
	    }
	
	    @Override
	    protected String doInBackground(String... params) {
	    	String video="";
	    	try {
	    		String consulta =ws.getContenidoObra(nombre);
	    		//String[] separated = consulta.split("=>");
	    		Parser parser = new Parser(consulta);
				video= parser.getParameter("video");
			} catch (Exception e) {
				System.out.println("Error: " + e);
			}
	    	return video;
	    }
	
	    @Override
	    protected void onPostExecute(String video) {
	    	pDialog.dismiss();
			if (video.equals("null") || video.equals("") || video.length()<=1){
		    	Toast.makeText(getApplicationContext(), "Obra sin video", Toast.LENGTH_LONG).show();
			}
			else {
//		    	Toast.makeText(getApplicationContext(), "El video es: "+ nombre, Toast.LENGTH_LONG).show();
				try{
				String[] nombrevideo = video.split("/");
				String videoconformato= nombrevideo[5];
				String[] videosinformato = videoconformato.split("\\.");
				
				
				String url="http://"+MyFTP._HOST+"/obras/"+idObra+"/video/"+videosinformato[0]+".mp4";
				//String url = "ftp://obras:12345678@10.0.2.109"+idObra+"/video/"+videosinformato[0]+".mp4";
				Intent i= new Intent(ContenidoObras.this, ReproducirVideo.class);
				System.out.println("Contenido Obras, reproduciendo video...");
				i.putExtra("video",url);
				System.out.println("i put extra...");
				startActivity(i);
				System.out.println("start activity...");
				}catch(Exception e){
					System.err.println("Error::"+e.getMessage());
				}
			}
	    	pDialog.dismiss();
	    }
	}
    
    class ObraPreteneceAJuego extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result2 ="";
        	String result="";
        	try {
        		Consumirws ws = new Consumirws();
        		result =ws.ObraPerteneceAJuego(Integer.parseInt(params[0]));
        		result2 = result+"=>"+params[0];
			} catch (Exception e) {
				System.out.println("error: " + e);
			}
        	System.out.println("Al parecer Obraperteneceajuego llega a devolver algo: "+result);
        	return result2;
        }
 
        @Override
        protected void onPostExecute(String result) {
        	pDialog.dismiss();
        	String[] separated = result.split("=>");
        	Parser parser = new Parser(separated[0]);
        	idjuego=Integer.parseInt(parser.getParameter("ret"));
        	idObra=separated[1];
			Jugar(idjuego);										//Llamo a la función jugar para que el async termine sus funciones antes.
        }
    }
	
	class BuscarPista extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ContenidoObras.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result ="";
        	try {
        		Consumirws ws = new Consumirws();
        		result =ws.BuscarPista(Integer.parseInt(params[0]),Integer.parseInt(params[1]));
        		//le pido al servidor la hora y la guardo en sesion
        		String tiempo = ws.getHora();
        		editor.putString("tiempoinicio",tiempo);
        		editor.commit();
			} catch (Exception e) {
				System.out.println("errorbuscarpista: " + "result: "+ result);
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String result) {
        	pDialog.dismiss();
        	//String[] separated = result.split("=>");
        	Parser parser = new Parser(result);
        	editor.putInt("obrasig", Integer.parseInt(parser.getParameter("id_proxima")));
        	editor.putString("pista", parser.getParameter("pista"));
        	editor.commit();
			AlertDialog.Builder builder = new AlertDialog.Builder(ContenidoObras.this);
			builder.setTitle("Pista");
			builder.setMessage("Pista: "+ parser.getParameter("pista"));
			builder.setPositiveButton("OK",null);
			builder.create();
			builder.show();
        }
    }
    
	class CantidadObrasJuego extends AsyncTask<String,String,String>{
       
 
        @Override
        protected String doInBackground(String... params) {
        	System.out.println("CantidadObrasJuego");
        	String result ="";
        	try {
        		Consumirws ws = new Consumirws();
        		result = ws.CantidadObrasJuego(Integer.parseInt(params[0]));
			} catch (Exception e) {
				System.out.println("errorbuscarpista: " + "result: "+ result);
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String result) {
        	Parser parser = new Parser(result);
        	editor.putInt("cantidadobras", Integer.parseInt(parser.getParameter("ret")));
        	editor.putInt("progreso", 1);
        	editor.commit();
        }
    }
  	private void Jugar(final Integer idjuego){
    	System.out.println("Obraexiste antes del if: "+ idjuego);

    	if (idjuego==0){
			//La obra no tiene juego.
			//Toast.makeText(getApplicationContext(), "La obra no tiene juego.", Toast.LENGTH_SHORT).show();
		}
		else {			
			//Si la obra tiene juego
			AlertDialog.Builder builder = new AlertDialog.Builder(ContenidoObras.this);
			builder.setTitle("Juego");
			builder.setMessage("La obra pertenece a un juego, ¿desea participar?");
		    builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
		    	public void onClick(DialogInterface dialog, int which) {
		    		//Toast.makeText(getApplicationContext(), "No desea jugar", Toast.LENGTH_SHORT).show();
                  }
            });
		    builder.setNeutralButton("AYUDA", new DialogInterface.OnClickListener() {
	        	public void onClick(DialogInterface dialog, int which) {
	        		AlertDialog.Builder builderayuda = new AlertDialog.Builder(ContenidoObras.this);
	        		builderayuda.setTitle("Ayuda");
	        		builderayuda.setMessage("La obra es parte de un juego de recorrido interactivo. Mediante el reconocimiento de " +
	        				"imagen debes escanear la obra indicada en la pista que se otorga para ganar puntos y ser el primero en " +
	        				"el ranking.");
	        		builderayuda.setPositiveButton("OK",null);
	        		builderayuda.create();
	        		builderayuda.show();
	        	}
	        });
		    builder.setPositiveButton("SI", new DialogInterface.OnClickListener() {
		    	public void onClick(DialogInterface dialog, int which) {
		    		CantidadObrasJuego cant = new CantidadObrasJuego();
		        	cant.execute(idjuego.toString());
		        	
		    		editor.putInt("estajugando", 1);
		    		editor.putInt("idobraactual", Integer.parseInt(idObra));
		    		editor.putInt("idjuego", idjuego);
		    		
		    		editor.commit();
		    		
                	BuscarPista bp = new BuscarPista();
                	System.out.println("Buscarpista: "+idObra+" - "+idjuego);
                  	bp.execute(idObra, idjuego.toString());
		    	}
		    });
		    builder.create();
		    builder.show(); 
		}
    }
public void Mensaje_Fin(){
		
		LayoutInflater factory = LayoutInflater.from(this);            
        final View textEntryView = factory.inflate(R.layout.nick_name_fild, null);

        AlertDialog.Builder alert = new AlertDialog.Builder(this); 

        alert.setTitle("Juego Finalizado!"); 
        alert.setMessage("Felicitaciones: Ingrese su Nick Name");  
        alert.setView(textEntryView); 

        final EditText input = (EditText) textEntryView.findViewById(R.id.editText1);

        alert.setPositiveButton("Submit", new DialogInterface.OnClickListener() { 
        public void onClick(DialogInterface dialog, int whichButton) { 
        	
    		String nick_name =input.getText().toString();
    		
    		if(nick_name!=null){
    			if(nick_name=="" || nick_name.length()==0){
    				Toast.makeText(getApplicationContext(), "Debe ingresar un nombre", Toast.LENGTH_LONG).show();
    				Mensaje_Fin();
    			}else{
    				
		    		FinJuego fj = new FinJuego();
		    		fj.execute(nick_name);
    			}
    		}else{
//    			Toast.makeText(getApplicationContext(), "Vasio null", Toast.LENGTH_LONG).show();
    		}
        } 
        }); 

        alert.setNegativeButton("Cancel", new DialogInterface.OnClickListener() { 
          public void onClick(DialogInterface dialog, int whichButton) { 
            // Canceled. 
          } 
        }); 
        alert.show(); 	
	}
	
	class FinJuego extends AsyncTask<String, String, String>{

		@Override
		protected void onPreExecute() {
		pDialog = new ProgressDialog(ContenidoObras.this);
		pDialog.setMessage("Espere por favor...");
		pDialog.setIndeterminate(false);
		pDialog.setCancelable(false);
		pDialog.show();
		}
		@Override
		protected String doInBackground(String... params) {
			String res = "", hora_fin="";
			String hora_inicio = prefs.getString("tiempoinicio", "00:00:00");
			int progreso = prefs.getInt("progreso", 0);
			int id_visitante = prefs.getInt("idvisitante", 0);
			int id_juego = prefs.getInt("idvisitante",0);
//			String hora_inicio = "00:00:00";
//			int progreso = 4;
//			int id_visitante = 1;
//			int id_juego = 		1;	
			String nick_name = params[0];
			try {
				Consumirws ws = new Consumirws();
				hora_fin = ws.getHora();
				
				Date fin = simpleDateFormat.parse(hora_fin);
	            Date inicio = simpleDateFormat.parse(hora_inicio);
	            
	            long difference = fin.getTime() - inicio.getTime();
	            
	            int s = (int) difference / (1000);
	            int puntaje = ((progreso*6000)/(s/2));
	            
	            res= ws.FinJuego(id_visitante, id_juego, puntaje, nick_name);
	            
			} catch (Exception e) {
				res = e.toString();
			}
			return res;
		}
		
		@Override
		protected void onPostExecute(String result) {
//			Toast.makeText(getApplicationContext(), result, Toast.LENGTH_LONG).show();
//			editor.putInt("progreso", 0);
//			editor.putInt("cantidadobras", 0);
			editor.putInt("estajugando", 0);
//			editor.remove("pista");
//			editor.remove("tiempoinicio");
			editor.commit();
			
			pDialog.dismiss();
			
			Intent intent = new Intent(ContenidoObras.this,Puntajes.class);
			startActivity(intent);
		}
	}
    
}
