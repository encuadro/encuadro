package com.Encuadro;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import org.apache.commons.net.ftp.FTPClient;

import com.Encuadro.ContenidoObras.FtpAudio;
import com.example.qr.R;

import android.media.MediaPlayer;
import android.media.MediaScannerConnection;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaScannerConnection.MediaScannerConnectionClient;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class ContenidoSalas extends Activity {
	
	private static int TAKE_PICTURE = 1;
	private String nombre = "",idsala = "", dirFoto = "",dirFotoaux = "", nomFoto = "";
	int posicion = 0;
	
	TextView tv1, tv2;
	ImageView img;
	Button btnSalaObra, btnRec, btnPlay, btnVideo;
	ProgressDialog pDialog;
	MediaPlayer mp;

	Consumirws ws;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_contenido_salas);
		//Limpiar algun rastro que quede del audio;
		destruir();
		
		tv1 = (TextView) findViewById(R.id.textView1);
		tv2 = (TextView) findViewById(R.id.tvDescripcionSala);
		img = (ImageView)findViewById(R.id.imageView1);
		btnSalaObra = (Button) findViewById(R.id.btnObrasSala);
		btnRec = (Button) findViewById(R.id.btnREC);
		btnPlay = (Button) findViewById(R.id.btnAudio);
		btnVideo = (Button) findViewById(R.id.btnVideo);
		
		Bundle extras = getIntent().getExtras();		
		String[] separated = extras.getString("result").split("=>");
		
		//Directorio donde guardaremos la foto
		dirFoto = Environment.getExternalStorageDirectory() + "/foto.jpg";
		dirFotoaux = Environment.getExternalStorageDirectory() + "/foto2.jpg";
		nomFoto = "foto.jpg";
		
		idsala = separated[0];
		nombre = separated[1];
  	    
		tv1.setText("Nombre: \n" + separated[1]);
		tv2.setText("Descripción: \n" + separated[2]);
		
		btnPlay.setText("Audio");
		
		FtpExecute ftp = new FtpExecute();
  	    String[] sala = {idsala,separated[(separated.length-1)]};	
  	    ftp.execute(sala);
		
		//Para listar las obras de esta sala
		btnSalaObra.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent intent = new Intent(ContenidoSalas.this,ListaObras.class);
				intent.putExtra("idSala", idsala);
				startActivity(intent);
			}
		});
		//Captura de foto y comienzo de reconocimiento de imagen
		btnRec.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
                Intent intent =  new Intent(MediaStore.ACTION_IMAGE_CAPTURE);   
                Uri output = Uri.fromFile(new File(dirFoto));
                intent.putExtra(MediaStore.EXTRA_OUTPUT, output);
                int code = TAKE_PICTURE;
                startActivityForResult(intent, code);
			}
		});
		
		btnPlay.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(btnPlay.getText().toString()=="Audio"){
					FtpAudio ftpaudio = new FtpAudio();
					ftpaudio.execute(idsala,nombre);				
					btnPlay.setText("Stop");
				}else{
					btnPlay.setText("Audio");
					detener(v);
				}
			}
		});
		
		btnVideo.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				obtenerVideo nv = new obtenerVideo();
				nv.execute();
				
			}
		});
		
	}
	

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.contenido_salas, menu);
		return true;
	}

	 @Override protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		 if(resultCode==RESULT_OK){
			 if (requestCode == TAKE_PICTURE) {
				 	
				 	try {
				 		BitmapFactory bf = new BitmapFactory();
				 		
			     		//Tomo la la imagen en bitmap
			     		Bitmap bm = bf.decodeFile(dirFoto);
			     		//Modifico su tamaño
						bm = getResizedBitmap(bm,600,600);
					
						
						FileOutputStream fos;
						fos = new FileOutputStream(dirFoto);
						bm.compress(Bitmap.CompressFormat.JPEG, 100, fos);
						
			     		//llamo al hilo para subir la imagen
			     		ReconocimientoImg ftpImg = new ReconocimientoImg();
				    	String[] obra = {nomFoto,dirFoto,idsala};
				    	ftpImg.execute(obra);
				    	fos.close();
				    	
				    	
					} catch (Exception e) {
						System.out.print(e.toString());
						Toast.makeText(getApplicationContext(), e.toString(), Toast.LENGTH_LONG).show();
					}   
				}
		 }
		
	 }
	 
	class FtpExecute extends AsyncTask<String,String,Bitmap>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ContenidoSalas.this);
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
		    	if(ftp.LoginSalas()){
		    		bitmap = ftp.GetImgSala(params[0],params[1],true,0);
		    	}
			} catch (Exception e) {
				System.out.println("error: " + e);
			}
        	return bitmap;
        }
 
        @Override
        protected void onPostExecute(Bitmap bitmap) {
        	if(bitmap != null){
    			img.setImageBitmap(bitmap);
    		}
        	else{
    			System.out.print(" img: null ");
    		}
        	pDialog.dismiss();
        }
    }

	class ReconocimientoImg extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ContenidoSalas.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result="";
        	String nombre = params[0], directorio = params[1], idDeSala = params[2];
        	String idObra = "";
        	try {
        		MyFTP ftp = new MyFTP(getApplicationContext());
        		Consumirws ws = new Consumirws();
		    	if(ftp.LoginObras()){	
		    		if(ftp.subirImgObra(nombre,directorio)){
		    			idObra = ws.getNombreObraDescriptor(Integer.parseInt(idDeSala), nombre);
		    			
		    			if(idObra.equals("0")){
		    				result = "0";
		    			}else{
		    				result = ws.getDataObraId(Integer.parseInt(idObra));
		    			}
		    		}
		    	}
			} catch (Exception e) {
				result="Error: "+e;
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String v) {
        	pDialog.dismiss();
        	if(v.equals("0")){
        		Toast.makeText(getApplicationContext(),"Obra no encontrada, intentelo de nuevo", Toast.LENGTH_LONG).show();
        		pDialog.dismiss();
        	}else{
	        	Intent intent = new Intent(ContenidoSalas.this,ContenidoObras.class);
	        	intent.putExtra("result", v);
	        	startActivity(intent);
        	}
        }
    }
	
	class FtpAudio extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ContenidoSalas.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result="Audio..";
        	String nombre=params[1];
        	String idSala=params[0];
        	String audio = null;
        	try {
        		MyFTP ftp = new MyFTP(getApplicationContext());
		    	if(ftp.LoginSalas()){
		    		
                    result = ws.getContenidoSalaId(Integer.parseInt(idSala));
		    		
		    		String separatedaux[] = result.split("=>");
		    		String separatedaudio[] = separatedaux[0].split("/");
		    		audio = separatedaudio[separatedaudio.length-1];
		    		
		    		if(audio!=null){
			    		if(ftp.getAudioSala(idSala, audio, true, 0)){
			    			File fil = new File(ContenidoSalas.this.getCacheDir() + "/" + audio );
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
			    				result = "Sala sin audio ";
			    			}
			    			fis.close();
			    		}
		    		}
		    		else{
		    			result = "Sala sin audio ";
		    		}
		    	}
			}catch(NullPointerException n){
				result = "Sala sin audio ";
			}catch (Exception e) {
				result = "Sala sin audio ";
			}
        	return result;
        }
        @Override
        protected void onPostExecute(String v) {
        	pDialog.dismiss();
        	if(v=="Obra sin audio ") btnPlay.setText("Audio");
        	Toast.makeText(ContenidoSalas.this, v,Toast.LENGTH_LONG).show();
        }
}
	
	class obtenerVideo extends AsyncTask<String,String,String>{
	    @Override
	    protected void onPreExecute() {
	    	pDialog = new ProgressDialog(ContenidoSalas.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
	    }
	
	    @Override
	    protected String doInBackground(String... params) {
	    	String video="";
	    	try {
	    		video=ws.getVideoSalaId(Integer.parseInt(idsala));
	    		
			} catch (Exception e) {
				System.out.println("Error: " + e);
			}
	    	return video;
	    }
	
	    @Override
	    protected void onPostExecute(String video) {
	    	pDialog.dismiss();
	    	if(video.equals("0") || video.equals("null") || video.equals("") || video.length()<=1){
				Toast.makeText(getApplicationContext(), "Sala sin video", Toast.LENGTH_SHORT).show();
			}
			else{
//				El resto esta comentado por que no existe video en BD	
				Toast.makeText(getApplicationContext(), "Return: " + video, Toast.LENGTH_SHORT).show();
				
				String url="http://"+MyFTP._HOST+"/salas/"+idsala+"/video/"+video+".mp4";
				Intent i= new Intent(ContenidoSalas.this, ReproducirVideo.class);
				i.putExtra("video",url);
				startActivity(i);
			}
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
    public Bitmap getResizedBitmap(Bitmap bm, int newHeight, int newWidth) {
   	 
    	int width = bm.getWidth();    	 
    	int height = bm.getHeight();
    	 
    	float scaleWidth = ((float) newWidth) / width;    	 
    	float scaleHeight = ((float) newHeight) / height;
    	 
    	// Crear matrix para manejar  	 
    	Matrix matrix = new Matrix();
    	 
    	// Modificando tamaño   	 
    	matrix.postScale(scaleWidth, scaleHeight);
    	 
    	// recrea el nuevo bitmap 
    	Bitmap resizedBitmap = Bitmap.createBitmap(bm, 0, 0, width, height, matrix, false);
    	 
    	return resizedBitmap;
    	 
    }
    
    
}