package com.Encuadro;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.example.qr.R;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.RadioButton;

public class ListaSalas extends Activity {
	private ListView lv1;
	private EditText et1;
	private Button b1;
	private CheckBox chbObras;
	Consumirws ws;
	String[] separated;
	ProgressDialog pDialog;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_lista_salas);  
		
		lv1 = (ListView) findViewById(R.id.listsalas);
		et1 = (EditText) findViewById(R.id.editText1);
		b1 = (Button) findViewById(R.id.btnEscO);
		b1.requestFocus();
		b1.setFocusable(true);
		b1.setFocusableInTouchMode(true);
		chbObras = (CheckBox) findViewById(R.id.checkBox1);
		
		ws = new Consumirws();
		
		ListaSalasExecute ls = new ListaSalasExecute();
    	ls.execute("");
    	
		lv1.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View v, int posicion, long id) {
				//String result =ws.getDataSalaNombre(lv1.getItemAtPosition(posicion).toString()); 				
				if(chbObras.isChecked()==true){
					ListaObrasSalasExecute lobs = new ListaObrasSalasExecute();
					lobs.execute(lv1.getItemAtPosition(posicion).toString());
					
				}else{
				ContenidoSalasExecute cs = new ContenidoSalasExecute();
				cs.execute(lv1.getItemAtPosition(posicion).toString());
			}
			}
		});
    	  
		b1.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				BuscarSalaExecute bs = new BuscarSalaExecute();
				bs.execute(et1.getText().toString());
			}
		});   
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.lista_salas, menu);
		return true;
	}
	
	class ListaSalasExecute extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ListaSalas.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result="";
        	try {        		
        		result =ws.getNombreSalas();
			} catch (Exception e) {
				result=e.toString();
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String result) {
        	pDialog.dismiss();
        	
    		//String[] separated = result.split("=>");
    		List<String> separated = new ArrayList<String>();
    		Parser p = new Parser(result);
    		for(Map<String,String> it:p.getMap()){    			
    			separated.add(it.get("nombre_sala"));
    		}
    		ArrayAdapter <String> adapter = new ArrayAdapter<String>(ListaSalas.this,android.R.layout.simple_list_item_1,separated );
    	    lv1.setAdapter(adapter);
        }
    }
	
	class ListaObrasSalasExecute extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ListaSalas.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result="";
        	try {        		
        		result =ws.getDataSalaNombreImagen(params[0]);;
			} catch (Exception e) {
				result=e.toString();
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String result) {
        	pDialog.dismiss();
        	Parser parser = new Parser(result);
    		Intent intent = new Intent(ListaSalas.this, ListaObras.class);
    		intent.putExtra("idSala", parser.getParameter("id_sala"));//separated[0]
    		startActivity(intent);
        }
    }

	class ContenidoSalasExecute extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ListaSalas.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result="";
        	try {
        		result =ws.getDataSalaNombreImagen(params[0]);
			} catch (Exception e) {
				result=e.toString();
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String result) {
        	pDialog.dismiss();        
    	    Intent i= new Intent(ListaSalas.this, ContenidoSalas.class);
			i.putExtra("result",result);	
			startActivity(i);
        }
    }

	class BuscarSalaExecute extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ListaSalas.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result="";
        	try {
        		System.out.print( "Backgrund:" + params[0]);
        		if(params[0]==""){
        			result = ws.getObras();
        		}
				else{
        			result =ws.getSalasl(params[0]);
        		}
        	}catch (Exception e) {
				result=e.toString();
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String result) {
        	pDialog.dismiss();
        	
    		List<String> separated = new ArrayList<String>();
    		Parser p = new Parser(result);
    		String parameter = "nombre_obra";
    		if(p.getMap().get(0).containsKey("nombre_sala"))
    			parameter = "nombre_sala";    			
    		for(Map<String,String> it:p.getMap()){    			
    				separated.add(it.get(parameter));
    		}
    		ArrayAdapter <String> adapter = new ArrayAdapter<String>(ListaSalas.this,android.R.layout.simple_list_item_1,separated );
    	    lv1.setAdapter(adapter);
		}
	}  		
}