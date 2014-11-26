package com.Encuadro;

import com.example.qr.R;

import android.app.Activity;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnErrorListener;
import android.net.Uri;
import android.os.Bundle;
import android.view.Menu;
import android.view.Window;
import android.view.WindowManager;
import android.widget.MediaController;
import android.widget.Toast;
import android.widget.VideoView;

public class ReproducirVideo extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.activity_reproducir_video);
		
		Bundle extras = getIntent().getExtras();
		String video = extras.getString("video");
		VideoView videoView = (VideoView)findViewById(R.id.videoView1);
		
		try {
		    System.out.println("Reproduciendo video...");
			MediaController mc = new MediaController(this);
			System.out.println("Reproduciendo video...2");
		    videoView.setMediaController(mc);
		    System.out.println("String del video:  "+ video);
		    Uri uri = Uri.parse(video);
		    System.out.println("PAth de uri::  "+ uri.getPath());
		    videoView.setVideoURI(uri);
		    System.out.println("Reproduciendo video...5");
		    videoView.requestFocus();

		    System.out.println("Reproduciendo video...6");
		    videoView.start();

		    System.out.println("Reproduciendo video...out");
		} catch (Exception e) {
			System.err.println("ERROR:"+e.getMessage());
			Toast.makeText(this, e.toString(), Toast.LENGTH_LONG).show();
			super.finish();
		}
		
	}
	
	protected void onPause(){
		 super.onPause();
		VideoView videoView = (VideoView)findViewById(R.id.videoView1);
//		videoView.
		videoView.pause();
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.reproducir_video, menu);
		return true;
	}
}
