package com.Encuadro;

import java.util.ArrayList;
import java.util.List;

import com.example.qr.R;

import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;


public class Puntajes extends Activity {
	
private ProgressDialog pDialog;
private int posicion_jugador=0;
private Integer id_visitante =0;

ListView lv;
List<ItemList> items = new ArrayList();

SharedPreferences prefs=null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_puntajes);
	
		TextView btn = (TextView)findViewById(R.id.textView1);
		lv = (ListView)findViewById(R.id.listView1);
       
        prefs=getSharedPreferences("user",Context.MODE_PRIVATE);
        id_visitante = prefs.getInt("idvisitante", 433);
        btn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
//				lv.setSelected(true);
				lv.setSelection(posicion_jugador);
				
				Toast.makeText(getBaseContext(), "Posicion: " + posicion_jugador, Toast.LENGTH_SHORT).show();
			}
		});
     
        
        lv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View v, int posicion, long id) {
				Toast.makeText(getBaseContext(), "Posicion: " + posicion, Toast.LENGTH_SHORT).show();	
			}
		});

        ObtenerPuntajes op = new ObtenerPuntajes();
        op.execute();
	}

	class ObtenerPuntajes extends AsyncTask<Void,Void,String>{
	    @Override
	    protected void onPreExecute() {
	    	pDialog = new ProgressDialog(Puntajes.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
	    }
	
	    @Override
	    protected String doInBackground(Void... params) {
	    	String res="";
	    	try {
		    	Consumirws ws = new Consumirws();
		    	res = ws.getpuntajes();
		    	String aux = ws.getPosicion(id_visitante);
		    	Parser parser = new Parser(aux);		    	
		    	posicion_jugador = Integer.parseInt(parser.getParameter("ret"));
			} catch (Exception e) {
				System.out.println("Error: " + e);
			}
	    	return res;
	    }
	
	    @Override
	    protected void onPostExecute(String result) {
	    	
	    	
	    	String[] separated = result.split("=>");
	    	if(separated.length<2){
	    		items.add(new ItemList(9999, "God"));
	    	}else{
		    	for (int i = 0; i+1 <= separated.length; i=i+2) {
					items.add(new ItemList(Integer.parseInt(separated[i]), separated[i+1]));
				}
	    	}
	    	lv.setAdapter(new ItemAdapter(getApplicationContext(), items));
	    	 
	    	pDialog.dismiss();
	    }
	}


	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.puntajes, menu);
		return true;
	}

	
}
