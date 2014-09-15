package com.Encuadro;

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
import android.widget.EditText;
import android.widget.ListView;

public class ListaObras extends Activity {
	private ListView lv1;
	private EditText et1;
	private Button b1;
	Consumirws ws;
	String[] separated;
	ProgressDialog pDialog;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_lista_obras);  
		
		lv1 = (ListView) findViewById(R.id.listobras);
		et1 = (EditText) findViewById(R.id.editText1);
		b1 = (Button) findViewById(R.id.btnEscO);
		b1.requestFocus();
		b1.setFocusable(true);
		b1.setFocusableInTouchMode(true);
		ws = new Consumirws();
		Bundle extras = getIntent().getExtras();
		
		ListaObrasExecute lo = new ListaObrasExecute();
		String i = extras.getString("idSala");
		
		System.out.print(i);
    	lo.execute(i);   
    	
		lv1.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View v, int posicion, long id) {		
				ContenidoObrasExecute co = new ContenidoObrasExecute();
				co.execute(lv1.getItemAtPosition(posicion).toString());
			}
		});
  	  
		b1.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				System.out.print( "hola:" );
				BuscarObraExecute bo = new BuscarObraExecute();
				bo.execute(et1.getText().toString());
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.lista_obras, menu);
		return true;
	}
	
	class ListaObrasExecute extends AsyncTask<String,String,String>{
        @Override
        protected void onPreExecute() {
        	pDialog = new ProgressDialog(ListaObras.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
        }
 
        @Override
        protected String doInBackground(String... params) {
        	String result="";
        	try {
        		result =ws.getObraSala(Integer.parseInt(params[0]));
			} catch (NumberFormatException e) {
				result =ws.getObras();
			} catch (Exception e){
				result = e.toString();
			}
        	return result;
        }
 
        @Override
        protected void onPostExecute(String result) {
        	pDialog.dismiss();
        	
    		String[] separated = result.split("=>");
    		ArrayAdapter <String> adapter = new ArrayAdapter<String>(ListaObras.this,android.R.layout.simple_list_item_1,separated );
    	    lv1.setAdapter(adapter);
    	    adapter.notifyDataSetChanged();
        }
	}
        
    class ContenidoObrasExecute extends AsyncTask<String,String,String>{
		@Override
		protected void onPreExecute() {
			pDialog = new ProgressDialog(ListaObras.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
		}
 
		@Override
		protected String doInBackground(String... params) {
			String result="";
			try {
				
//            		result =ws.getDataSalaNombre(lv1.getItemAtPosition(posicion).toString()); 	

				result =ws.getDataObra(params[0]); 
			} catch (Exception e) {
				result=e.toString();
			}
			return result;
		}
 
		@Override
		protected void onPostExecute(String result) {
			pDialog.dismiss();
			Intent i= new Intent(ListaObras.this, ContenidoObras.class);
			i.putExtra("result",result);	
			startActivity(i);
		}
	}
        
    	
	class BuscarObraExecute extends AsyncTask<String,String,String>{ 
		@Override
		protected void onPreExecute() {
			pDialog = new ProgressDialog(ListaObras.this);
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
				}else{
					result =ws.getObrasl(params[0]);
				}
			}catch (Exception e) {
				result=e.toString();
			}
			return result;
		}
 
		@Override
		protected void onPostExecute(String result) {
			pDialog.dismiss();
			
			String[] separated = result.split("=>");
			ArrayAdapter <String> adapter = new ArrayAdapter<String>(ListaObras.this,android.R.layout.simple_list_item_1,separated );
			lv1.setAdapter(adapter);
		}
	}
}
	


