package com.Encuadro;
	 
import com.example.qr.R;

import android.R.bool;
import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class MainActivity extends Activity {
	private Button buttonMan,buttonQR, btnProgreso;
	private boolean back2=false;
	ProgressDialog pDialog;
	
	SharedPreferences prefs=null;
	SharedPreferences.Editor editor=null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		buttonMan = (Button) findViewById(R.id.btnEscO);
		buttonQR = (Button) findViewById(R.id.btnEscS);
		btnProgreso = (Button) findViewById(R.id.button1);
		
		prefs = getSharedPreferences("user",Context.MODE_PRIVATE);
		editor = prefs.edit();
		
		
		
		buttonMan.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent inten = new Intent(MainActivity.this, MenPpal.class); 
				startActivity(inten);
			}
		});
		
		buttonQR.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				//Intent intent = new Intent("com.example.qr.SCAN");
				//startActivityForResult(intent, 0);
				Intent inten = new Intent(MainActivity.this, MenPpalAuto.class); 
				startActivity(inten);
			}
		}); 
		
		btnProgreso.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent inten = new Intent(MainActivity.this, Progreso.class); 
				startActivity(inten);
			}
		}); 
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	//Listener para preguntar si sale con el botón back
	@Override
	public void onBackPressed() {
		   System.out.println("OnBack " + back2);
		   if(back2 ||  prefs.getInt("realizo_cues", 0)==1){
			   MainActivity.this.finish();
		   }else{
			   back2=true;
			   AlertDialog.Builder cartelsalida = new AlertDialog.Builder(MainActivity.this);
			   cartelsalida.setTitle("Salir");
			   cartelsalida.setMessage("¿Antes de retirarse, nos ayudaria con un breve cuestionario?");
			   cartelsalida.setPositiveButton("Aceptar", new DialogInterface.OnClickListener() {
			    	public void onClick(DialogInterface dialog, int which) {
			    		back2=false;
			    		Intent inten = new Intent(MainActivity.this, CuetionarioFinal.class); 
						startActivity(inten);
			    	}
			    });
			   cartelsalida.setNegativeButton("Salir", new DialogInterface.OnClickListener() {
			    	public void onClick(DialogInterface dialog, int which) {
			    		MainActivity.this.finish();
			    	}
			    });
			   cartelsalida.create();
			   cartelsalida.show();
		   }
	}
	protected void onPause() {
        super.onPause();
        back2=false;
    }
	
	
	protected void onStart() {
		super.onStart();
		if(prefs.getInt("estajugando",0)==1){
			btnProgreso.setVisibility(View.VISIBLE);
		}
	}
}