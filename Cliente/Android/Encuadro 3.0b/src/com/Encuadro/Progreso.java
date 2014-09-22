package com.Encuadro;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.example.qr.R;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.SystemClock;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;


public class Progreso extends Activity{
	 private ProgressDialog pDialog;
	
	 SharedPreferences prefs=null;
	 SharedPreferences.Editor editor=null;
	
	 SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
	 Date date1, date2;
	 
	 Thread myThread = null;
	 
	String nick_name="";
	String pista = "";	
	String tiempo_inicio = "";
	Integer progreso = 0;
	Integer total_obras = 0;
	Integer id_visitante = 0;
	Integer id_juego = 0;
	int jugando = 0;
	 
	@Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_progreso);
        
        Button btn_fin_juego = (Button)findViewById(R.id.button1);
        Button btn_ver_puntaje = (Button)findViewById(R.id.button2);
        
        
        Runnable runnable = new CountDownRunner();
        myThread= new Thread(runnable);   

        prefs=getSharedPreferences("user",Context.MODE_PRIVATE);
		editor = prefs.edit();
		
		id_juego = prefs.getInt("idjuego", 0);
		id_visitante = prefs.getInt("idvisitante", 0);
		jugando = prefs.getInt("estajugando", 0);
		pista = prefs.getString("pista", "No has descubierto ninguna pista aun...");	
		tiempo_inicio = prefs.getString("tiempoinicio", "00:00:00");
		progreso = prefs.getInt("progreso", 0);
		total_obras = prefs.getInt("cantidadobras", 0);
		
		try{
			if(pista.equals("") || tiempo_inicio.equals("00:00:00") || progreso.equals(0) || jugando==0 || id_visitante==0 || id_juego==0){
				//Toast.makeText(this, pista + " / " + tiempo_inicio + " / " + progreso + "-" + total_obras + " / " + jugando + " / " + id_visitante + " / " + id_juego, Toast.LENGTH_LONG).show();
				btn_fin_juego.setEnabled(false);
				int hours = 0;
	            int minutes = 0;
	            int seconds = 0;
	            date1 = simpleDateFormat.parse(hours+":"+minutes+":"+seconds);
			}else{
				//Toast.makeText(this, pista + " / " + tiempo_inicio + " / " + progreso + "-" + total_obras + " / " + jugando + " / " + id_visitante, Toast.LENGTH_LONG).show();
				
				TextView tv_cant_obras = (TextView) findViewById(R.id.textView2);
				tv_cant_obras.setText("Obras: " + progreso.toString() + "/" + total_obras.toString());
				
				TextView tv_pista = (TextView) findViewById(R.id.textView4);
				tv_pista.setText(pista);
				
				String separated[] = tiempo_inicio.split(":");
				
				int hours  = Integer.parseInt(separated[0]);
				int minutes = Integer.parseInt(separated[1]);
				int seconds = Integer.parseInt(separated[2]);
				
//				Toast.makeText(this, hours + "-" + minutes + "-" + seconds, Toast.LENGTH_LONG).show();	
				
				date1 = simpleDateFormat.parse(hours+":"+minutes+":"+seconds);
				
				myThread.start();
			}
		}catch(Exception e){
			System.out.print(e.toString());
			Toast.makeText(this, e.toString(), Toast.LENGTH_SHORT).show();
		}
		
		btn_fin_juego.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				
				Mensaje_Fin();

			}
		});
		
		btn_ver_puntaje.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(Progreso.this,Puntajes.class);
				startActivity(intent);
			}
		});
		
		
        
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

	public void doWork() {
	    runOnUiThread(new Runnable() {
	        public void run() {
	            try{
	                TextView txtCurrentTime= (TextView)findViewById(R.id.textView3);
	                    Date dt = new Date();
	                    int hours = dt.getHours();
	                    int minutes = dt.getMinutes();
	                    int seconds = dt.getSeconds();
	                    
	                    date2 = simpleDateFormat.parse(hours+":"+minutes+":"+seconds);
	                    
	                    long difference = date2.getTime() - date1.getTime();
	                    
	                    int h = (int) difference / (1000*60*60); 
	                    int m = (int) (difference - (1000*60*60*h)) / (1000*60);
	                    int s = (int) (difference - (1000*60*60*h) - (1000*60*m)) / (1000);

	                    
	                    String curTime = "Tiempo: "  + h + ":" + m + ":" + s;
	                    
	                    
	                    txtCurrentTime.setText(curTime);
	            }catch (Exception e) {}
	        }
	    });
	}


	class CountDownRunner implements Runnable{
	    // @Override
	    public void run() {
	            while(!Thread.currentThread().isInterrupted()){
	                try {
	                doWork();
	                    Thread.sleep(1000);
	                } catch (InterruptedException e) {
	                        Thread.currentThread().interrupt();
	                }catch(Exception e){
	                }
	            }
	    }
	}
	
	public void Mensaje_Fin(){
		
		LayoutInflater factory = LayoutInflater.from(this);            
        final View textEntryView = factory.inflate(R.layout.nick_name_fild, null);

        AlertDialog.Builder alert = new AlertDialog.Builder(this); 

        alert.setTitle("Finalizando Juego"); 
        alert.setMessage("Ingrese su Nick Name");  
        alert.setView(textEntryView); 

        final EditText input = (EditText) textEntryView.findViewById(R.id.editText1);

        alert.setPositiveButton("Submit", new DialogInterface.OnClickListener() { 
        public void onClick(DialogInterface dialog, int whichButton) { 
        	
    		nick_name =input.getText().toString();
    		
    		if(nick_name!=null){
    			if(nick_name=="" || nick_name.length()==0){
    				Toast.makeText(getApplicationContext(), "Debe ingresar un nombre", Toast.LENGTH_LONG).show();
    				Mensaje_Fin();
    			}else{
		    		FinJuego fj = new FinJuego();
		    		fj.execute(nick_name);
    			}
    		}else{
    			Toast.makeText(getApplicationContext(), "Vasio null", Toast.LENGTH_LONG).show();
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
		pDialog = new ProgressDialog(Progreso.this);
		pDialog.setMessage("Espere por favor...");
		pDialog.setIndeterminate(false);
		pDialog.setCancelable(false);
		pDialog.show();
		}
		@Override
		protected String doInBackground(String... params) {
			String res = "", hora="";
			String nick_name = params[0];
			try {
				Consumirws ws = new Consumirws();
				hora = ws.getHora();
				Date aux = simpleDateFormat.parse(hora);
	            
	            long difference = aux.getTime() - date1.getTime();
	            
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
			editor.putInt("estajugando", 0);
			editor.commit();
			
			Button btn_fin_juego= (Button)findViewById(R.id.button1);
    		btn_fin_juego.setEnabled(false);
			
			pDialog.dismiss();
			
			Intent intent = new Intent(Progreso.this,Puntajes.class);
			startActivity(intent);
		}
	}
	
	
}
