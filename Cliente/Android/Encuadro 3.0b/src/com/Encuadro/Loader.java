package com.Encuadro;

import com.example.qr.R;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.view.Menu;
import android.widget.ImageView;

public class Loader extends Activity {
	SharedPreferences prefs=null;
	SharedPreferences.Editor editor=null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_loader);
		
		prefs = getSharedPreferences("user",Context.MODE_PRIVATE);
		editor = prefs.edit();
        //El primer campo es el atributo, el segundo la variable.
		editor.putInt("progreso",0);							//Progreso del jugador. Se coteja con las obras descubiertas sobre la cantidad de obras del juego.
		editor.putInt("idobraactual", 0);						//Última obra escaneada	
		editor.putInt("cantidadobras", 0);                      //Cantidaddeobras=pistas+1; obras que estan en el juego
		editor.putInt("estajugando",0);                     	//Variable para saber si esta jugando. 1 = está jugando
		editor.putInt("obrasig",0);                         	//Id  obras sigiente 
		editor.putString("pista", "");                      	//Pista de la obra
		editor.putInt("puntos",0);                          	//Puntos generado por el jugador a cada encuentro de obra
		editor.putInt("idjuego",0);                         	//Id del juego 
		editor.putInt("idvisitante",0);                         //Id del visitante 
		editor.putString("tiempoinicio", "00:00:00");
		editor.putInt("realizo_cues",0);
		editor.commit();
		
		ImageView img = (ImageView)findViewById(R.id.imageView1);
		img.setBackgroundResource(R.drawable.loader);

		// Get the background, which has been compiled to an AnimationDrawable object.
		AnimationDrawable frameAnimation = (AnimationDrawable) img.getBackground();

		// Start the animation (looped playback by default).
		frameAnimation.start();
		
		//Este activity se cierra luego de 3 segundos y llama al activity estadística. Se llama a finish() para cerrar esta actividad
		//Y que no se puede volver a cargarla en esta ejecución por el tema de sharedpreferences
		new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
            	Intent inten = new Intent(Loader.this, Estadistica.class); 
				startActivity(inten);
				Loader.this.finish();
            }
        }, 3000);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.loader, menu);
		return true;
	}
}