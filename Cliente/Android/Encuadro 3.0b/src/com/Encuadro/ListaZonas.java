package com.Encuadro;

import com.example.qr.R;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;

public class ListaZonas extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_lista_zonas);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.lista_zonas, menu);
		return true;
	}
}