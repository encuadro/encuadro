package com.Respuesta;

public class Respuesta_Abierta extends Respuesta{
	private String text;
	public Respuesta_Abierta(){
		this.text = "";
	}
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}
}
