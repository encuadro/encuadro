package com.Encuadro;

import com.example.qr.R;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.widget.Button;

public class MenPpal extends Activity {
	private Button b1,b2;
	String[] separated;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.men_ppal);
		
		b1 = (Button) findViewById(R.id.btnEscO);
		b2 = (Button) findViewById(R.id.btnEscS);
		
		b1.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent inten = new Intent(MenPpal.this, ListaObras.class); 
				inten.putExtra("idSala", "*");
				startActivity(inten);
			}
		});
		
		b2.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent inten = new Intent(MenPpal.this, ListaSalas.class); 
				startActivity(inten);
			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.men_ppal, menu);
		return true;
	}
}