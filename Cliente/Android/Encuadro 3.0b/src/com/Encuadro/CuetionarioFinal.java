package com.Encuadro;

import java.util.ArrayList;
import java.util.List;

import com.Respuesta.Multiple_Opcion;
import com.Respuesta.Respuesta;
import com.Respuesta.Respuesta_Abierta;
import com.example.qr.R;

import android.os.AsyncTask;
import android.os.Bundle;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.RadioGroup.OnCheckedChangeListener;

public class CuetionarioFinal extends Activity {

	List<Pregunta> p = new ArrayList();
	LinearLayout ll;
	ProgressDialog pDialog;
	Consumirws ws;
	
	SharedPreferences prefs=null;
	SharedPreferences.Editor editor=null;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_cuetionario_final);
		
		
		ll = (LinearLayout) findViewById(R.id.linearlayout1);
//		final ViewGroup vg = (ViewGroup) findViewById(R.id.scrollView1);
		
		prefs = getSharedPreferences("user",Context.MODE_PRIVATE);
		editor = prefs.edit();
		
         
         
         
		Button btn = (Button) findViewById(R.id.button1);
		
		btn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Boolean falta_algo = false;
				ll.clearFocus();
				for (Pregunta pre: p) {
//					Toast.makeText(getApplicationContext(), "any true:" + pre.anyTrue().toString() + " / nom: " + pre.getPregunta(), Toast.LENGTH_SHORT).show();
					if(!pre.anyTrue())
						falta_algo = true;
				}
				if(falta_algo)
					Toast.makeText(getApplicationContext(), "Algo falta", Toast.LENGTH_SHORT).show();
				else{
//					Toast.makeText(getApplicationContext(), ConcatenarDatos(), Toast.LENGTH_SHORT).show();
					EnviarDatos ed = new EnviarDatos();
					ed.execute();
				}
			}
		});
		
		fruta f = new fruta();
		f.execute("");
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	private String ConcatenarDatos(){
		String result="";
		for (Pregunta pre : p) {
			result= result + pre.getId() + "=>";
			for(Respuesta res : pre.getRes()){
				if(res.getClass()==Multiple_Opcion.class){
					Multiple_Opcion mo = (Multiple_Opcion)res;
					if(mo.getSelected()){
						result= result + mo.getId() + "=>1" + "=>";
					}
				}else{
					Respuesta_Abierta ra = (Respuesta_Abierta) res;
					result= result + ra.getText()+ "=>0" + "=>";
				}
			}
		}
		return result;
		//***************************
		//llamar WS y mandar result *
		//***************************
	}
	
	private View CargarPregunta(final Pregunta pregunta){
		View rowView;
		
        // Create a new view into the list.
        LayoutInflater inflater = (LayoutInflater) getApplicationContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        rowView = inflater.inflate(R.layout.pregunta_respuesta, null, false);
        //obtengo los objetos a insertar en esta view.
        final TextView tv_pregunta = (TextView) rowView.findViewById(R.id.textView1);
        final EditText et_respuesta = (EditText) rowView.findViewById(R.id.editText1);
        final RadioGroup rg_respuestas = (RadioGroup) rowView.findViewById(R.id.radioGroup1);
       
        
        tv_pregunta.setText(pregunta.getPregunta());;     
        tv_pregunta.setTextColor(Color.BLACK);
        
        //diferenciando entre multiple opcion o abierta
        if(pregunta.getItem(0).getClass().equals(Multiple_Opcion.class)){
        	
        	rg_respuestas.setVisibility(View.VISIBLE);
			et_respuesta.setVisibility(View.GONE);
            for (Respuesta r : pregunta.getRes()) {	            	
            		
            		Multiple_Opcion aux = (Multiple_Opcion)r;
            		
	            	RadioButton rb = new RadioButton(getApplicationContext());
	            	rb.setText(aux.getText());
	            	
	            	rb.setTextColor(Color.DKGRAY);
	            	rb.setGravity(Gravity.CENTER_VERTICAL);
					rg_respuestas.addView(rb);	
					rb.setChecked(aux.getSelected());
            	}
            
            rg_respuestas.setOnCheckedChangeListener(new OnCheckedChangeListener(){
	    		 
	 		    @Override
	 		    public void onCheckedChanged(RadioGroup group, int checkedId) {
	 		    	RadioButton rb = (RadioButton) group.findViewById(checkedId);
	 		    	outerloop:
	 		    	for(int i=0; i<group.getChildCount();i++){
	 		    		if(rb.getId()==group.getChildAt(i).getId()){
	 		    			Respuesta res= (Respuesta) pregunta.getItem(i);
	 		    			Multiple_Opcion aux = (Multiple_Opcion)res;
	 		    			pregunta.refreshRes();
	 		    			aux.setSelected(true);
//	 		    			Toast.makeText(getApplicationContext(), "id: " + i + " - " + aux.getSelected(), Toast.LENGTH_SHORT).show();
	 		    			break outerloop;
	 		    		}
	 		    	}
	 		    	
	 		   }
	 		     
	 		});
        }
        //en caso de que sea una pregunta abierta
        else {
        	
			rg_respuestas.setVisibility(View.GONE);
			et_respuesta.setVisibility(View.VISIBLE);
			
			et_respuesta.setOnFocusChangeListener(new OnFocusChangeListener() {
				
				@Override
				public void onFocusChange(View v, boolean hasFocus) {

					Respuesta_Abierta res_abierta = (Respuesta_Abierta)pregunta.getItem(0);
					res_abierta.setText(et_respuesta.getText().toString());
//					Toast.makeText(getApplicationContext(), "Text" + res_abierta.getText(), Toast.LENGTH_SHORT).show();
					
				}
			});
		}

        return rowView;
	}
	
	class fruta extends AsyncTask<String,String,String>{ 
		@Override
		protected void onPreExecute() {
			pDialog = new ProgressDialog(CuetionarioFinal.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
		}
 
		@Override
		protected String doInBackground(String... params) {
			String result="";
			try {
				ws = new Consumirws();
				result = ws.frutaMadre();
			}catch (Exception e) {
				result=e.toString();
			}
			return result;
		}
 
		@Override
		protected void onPostExecute(String result) {
			pDialog.dismiss();
			
			Integer id_pregunta_ini=0;
			Integer id_respuesta_ini=0;
			
			if(result=="-2"){
				Toast.makeText(getApplicationContext(), "Visitante imprevisto, no se puede reguistrar el cuestionario", Toast.LENGTH_SHORT).show();
				CuetionarioFinal.this.finish();
			}else if(result=="-1"){
				Toast.makeText(getApplicationContext(), "Hubo un problema con el servidor lo sentimos", Toast.LENGTH_SHORT).show();
				CuetionarioFinal.this.finish();
			}else if(result=="0" || result=="" || result.length()<=1){
				Toast.makeText(getApplicationContext(), "No hemos encontrado ningun cuestionario", Toast.LENGTH_SHORT).show();
				CuetionarioFinal.this.finish();
			}
			
			try {
				
				List<Respuesta> list_res = null;
				Pregunta pre_aux;
				String[] separated = result.split("=>");
				for (int i = 0; i<=separated.length-1;i=i+4) {
					
					Integer id_pregunta = Integer.parseInt(separated[i]);
					String contenido_pregunta = separated[i+1];
					Integer id_respuesta = Integer.parseInt(separated[i+2]);
					String contenido_respuesta = separated[i+3];
					
					
					if(id_pregunta!=id_pregunta_ini){
											
						list_res = new ArrayList();
						pre_aux = new Pregunta(id_pregunta,contenido_pregunta,list_res);
						p.add(pre_aux);
	//					Toast.makeText(getApplicationContext(), "Id pregunta:" + id_pregunta, Toast.LENGTH_SHORT).show();
					}
				
					if(id_respuesta==0){
						Respuesta ra = new Respuesta_Abierta();
						list_res.add(ra);
	//					Toast.makeText(getApplicationContext(), "Id Respuesta" + id_respuesta, Toast.LENGTH_SHORT).show();
					}else{
						Respuesta mo = new Multiple_Opcion(id_respuesta,contenido_respuesta,false);
						list_res.add(mo);
	//					Toast.makeText(getApplicationContext(), "Id Respuesta" + id_respuesta, Toast.LENGTH_SHORT).show();
					}
					
					id_pregunta_ini=id_pregunta;
				}
			} catch (Exception e) {
				Toast.makeText(getApplicationContext(), e.toString() + " " + result, Toast.LENGTH_SHORT).show();
			}
			
			for (Pregunta pre : p) {
				ll.addView(CargarPregunta(pre));
			}
			
			
		}
	}
	class EnviarDatos extends AsyncTask<Void,Void,String>{ 
		@Override
		protected void onPreExecute() {
			pDialog = new ProgressDialog(CuetionarioFinal.this);
			pDialog.setMessage("Espere por favor...");
			pDialog.setIndeterminate(false);
			pDialog.setCancelable(false);
			pDialog.show();
		}
 
		@Override
		protected String doInBackground(Void... params){
			String result="";
			try {
				int id_visitante = prefs.getInt("idvisitante", 0);
				if(id_visitante!=0){
				ws = new Consumirws();
				result = ws.setFormulario(id_visitante, ConcatenarDatos());
				}else{
					result="-2";
				}
			}catch (Exception e) {
				result="-1";
			}
			return result;
		}
 
		@Override
		protected void onPostExecute(String res) {
			pDialog.dismiss();
			editor.putInt("realizo_cues",1);
			editor.commit();
			if(res=="-2"){
				Toast.makeText(getApplicationContext(), "Visitante imprevisto, no se puede reguistrar el cuestionario", Toast.LENGTH_SHORT).show();
			}else if(res=="-1"){
				Toast.makeText(getApplicationContext(), "Uvo un problema con el servidor lo sentimos", Toast.LENGTH_SHORT).show();
			}else if(res=="0"){
				Toast.makeText(getApplicationContext(), "No hemos encontrado ningun cuestionario", Toast.LENGTH_SHORT).show();
			}else{
				Toast.makeText(getApplicationContext(), "Enhorabuena! Gracias por su ayuda", Toast.LENGTH_SHORT).show();				
			}
//			Toast.makeText(getApplicationContext(), "Realizo? " + prefs.getInt("realizo_cues", 0), Toast.LENGTH_SHORT).show();	
			CuetionarioFinal.this.finish();
		}
	}
		
}