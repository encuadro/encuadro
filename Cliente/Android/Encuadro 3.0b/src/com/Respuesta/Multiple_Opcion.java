package com.Respuesta;

public class Multiple_Opcion extends Respuesta{
	private String text;
	private Boolean selected;
	private int id;
	
	public Multiple_Opcion(int id, String text, Boolean selected) {
		this.selected = selected;
		this.text = text;
		this.setId(id);
	}

	public Boolean getSelected() {
		return selected;
	}

	public void setSelected(Boolean selected) {
		this.selected = selected;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
}
