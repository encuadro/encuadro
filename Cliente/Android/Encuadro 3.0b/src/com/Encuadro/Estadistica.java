package com.Encuadro;

import org.apache.http.impl.client.TunnelRefusedException;

import com.example.qr.R;

import android.R.string;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.widget.Button;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.Toast;

public class Estadistica extends Activity {
	
	
	private Button b1,b2;
	ProgressDialog pDialog;
	private RadioGroup rdgVisita;
	private RadioGroup rdgNacio;
	private RadioGroup rdgSexo;
	private RadioGroup rdgEdad;
	private String checkVisita="";
	private String checkNacio="";
	private String checkSexo="";
	private String checkEdad="";

	private boolean omitir=false;
	private boolean back2=false;
	SharedPreferences prefs=null;
	SharedPreferences.Editor editor=null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_estadistica);
		
		prefs = getSharedPreferences("user",Context.MODE_PRIVATE);
		editor = prefs.edit();
		
		b1 = (Button) findViewById(R.id.button1);
		b2 = (Button) findViewById(R.id.button2);
		rdgVisita = (RadioGroup)findViewById(R.id.rdgVisita);
		rdgNacio = (RadioGroup)findViewById(R.id.rdgNacio);
		rdgSexo = (RadioGroup)findViewById(R.id.rdgSexo);
		rdgEdad = (RadioGroup) findViewById (R.id.rdgEd);
		
		  rdgVisita.setOnCheckedChangeListener(new OnCheckedChangeListener(){
	    		 
	 		    @Override
	 		    public void onCheckedChanged(RadioGroup group, int checkedId) {
	 		        // TODO Auto-generated method stub
	 		        if (checkedId == R.id.radio0){
	 	               checkVisita = "Grupal";
	 		        }else if (checkedId == R.id.radio1){
	 		           checkVisita = "Invividual"; 
	 		         }
	 		      
	 		    }
	 		     
	 		});
		  
		  rdgNacio.setOnCheckedChangeListener(new OnCheckedChangeListener(){
	    		 
	 		    @Override
	 		    public void onCheckedChanged(RadioGroup group, int checkedId) {
	 		        // TODO Auto-generated method stub
	 		        if (checkedId == R.id.radio0){
	 	               checkNacio = "Uruguaya";
	 		        }else if (checkedId == R.id.radio1){
	 		           checkNacio = "Extranjera"; 
	 		           }
	 		    }
	 		     
		  });
		  
		  rdgSexo.setOnCheckedChangeListener(new OnCheckedChangeListener(){
	    		 
	 		    @Override
	 		    public void onCheckedChanged(RadioGroup group, int checkedId) {
	 		        // TODO Auto-generated method stub
	 		        if (checkedId == R.id.radio0){
	 	               checkSexo = "Masculino";
	 		        }else if (checkedId == R.id.radio1){
	 		           checkSexo = "Femenino"; 
	 		           }
	 		    }
	 		     
	 		});
		  
		  rdgEdad.setOnCheckedChangeListener(new OnCheckedChangeListener(){
	    		 
	 		    @Override
	 		    public void onCheckedChanged(RadioGroup group, int checkedId) {
	 		        // TODO Auto-generated method stub
	 		        if (checkedId == R.id.radio0){
	 	               checkEdad = "0 a 12";
	 		        }else if (checkedId == R.id.radio1){
	 		           checkEdad = "13 a 15"; 
	 		        }else if (checkedId == R.id.radio2){
	 		           checkEdad = "16 a 18";
	 		       }else if (checkedId == R.id.radio3){
	 		           checkEdad = "+ de 18";
	 		         }
	 		    }
	 		     
	 		});
		  
		  b1.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					// TODO Auto-generated method stub 
					if(checkNacio=="" || checkSexo=="" || checkVisita=="" || checkEdad==""){
						Toast.makeText(getApplicationContext(), "No pueden haber Campos Vacios", Toast.LENGTH_SHORT).show();
					}else{
						EnviarDatosEstadistica envDatos = new EnviarDatosEstadistica();
						System.out.println(checkNacio + " : " + checkSexo  +" : "+checkVisita +" : " +checkEdad );
						omitir = false;
						envDatos.execute(checkNacio,checkSexo,checkVisita,checkEdad);
						}
				    
				}
			});
		 
		  b2.setOnClickListener(new View.OnClickListener() {				
				@Override
				public void onClick(View v) {
					omitir = true;
					EnviarDatosEstadistica envDatos = new EnviarDatosEstadistica();
					envDatos.execute(null,null,null,null);
				}
			});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		//Menú modificado
		MenuInflater inflater = getMenuInflater();
	    inflater.inflate(R.menu.estadistica, menu);
	    return true;

	}
	
	//Listener para preguntar si sale con el botón back
	@Override
	public void onBackPressed() {
	   System.out.println("OnBack " + back2);
	   if(back2){
		   Estadistica.this.finish();
	   }else{
		   back2=true;
		   AlertDialog.Builder cartelsalida = new AlertDialog.Builder(Estadistica.this);
		   cartelsalida.setTitle("Salir");
		   cartelsalida.setMessage("¿Desea salir?");
		   cartelsalida.setPositiveButton("Aceptar", new DialogInterface.OnClickListener() {
		    	public void onClick(DialogInterface dialog, int which) {
		    		Estadistica.this.finish();
		    	}
		    });
		   cartelsalida.setNegativeButton("Cancelar", new DialogInterface.OnClickListener() {
		    	public void onClick(DialogInterface dialog, int which) {
		    		back2=false;
		    	}
		    });
		   cartelsalida.create();
		   cartelsalida.show();
		   
	   }
	   
	}
	
	class EnviarDatosEstadistica extends AsyncTask<String,String,String>{
		 
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(Estadistica.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result ="";
        	String nacionalidad=params[0], sexo=params[1], tipo_v=params[2], edad=params[3];
        	try {
        		Consumirws ws = new Consumirws();
        		if(!omitir)
        			result =ws.Altavisita(nacionalidad, sexo, tipo_v, edad);
        		else
        			result =ws.Altavisita("","","","");
			} catch (Exception e) {
				result = e.toString();
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String v) {
        	Parser parser = new Parser(v);        	
        	int id = Integer.parseInt(parser.getParameter("ret"));
        	if(id>0){
        		editor.putInt("idvisitante", id);
        		editor.commit();
        		Intent intent = new Intent(Estadistica.this,MainActivity.class); 					
    			startActivity(intent);
    			Estadistica.this.finish();
        		if(!omitir)
        			Toast.makeText(getApplicationContext(), "Datos enviados Correctamente", Toast.LENGTH_SHORT).show();
        		}else if(id==-2){
        			Toast.makeText(getApplicationContext(), "No tenemos respuesta del Servidor", Toast.LENGTH_LONG).show();
        		}else{
        			Toast.makeText(getApplicationContext(), "Error interno del server " + id, Toast.LENGTH_LONG).show();
                	}
//        	
			
			pDialog.dismiss();
//        	
        	
           

        }
    }
	
}