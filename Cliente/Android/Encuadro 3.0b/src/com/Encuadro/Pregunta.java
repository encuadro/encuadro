package com.Encuadro;

import java.util.List;

import com.Respuesta.Multiple_Opcion;
import com.Respuesta.Respuesta;
import com.Respuesta.Respuesta_Abierta;


public class Pregunta{
	private int id;
	private String pregunta;
	private List<Respuesta> res;
//	private String tipo;

	public Pregunta(){
	}
	public Pregunta(int id, String pregunta, List<Respuesta> res){
		this.setPregunta(pregunta);
		this.setRes(res);
		this.setId(id);
//		this.setTipo(tipo);
	}

	public Object getItem(int position) {
        return this.res.get(position);
    }

	public int getResCount() {
		return res.size();
		
	}
	public String getPregunta() {
		return pregunta;
	}


	public void setPregunta(String pregunta) {
		this.pregunta = pregunta;
	}


	public List<Respuesta> getRes() {
		return res;
	}


	public void setRes(List<Respuesta> res) {
		this.res = res;
	}
    
    //refresca rodas las respuestas y las coloca en false
    public void refreshRes() {
    	for (Respuesta r : res) {
    		if(r.getClass().equals(Multiple_Opcion.class)){
    			Multiple_Opcion aux = (Multiple_Opcion)r;
    			aux.setSelected(false);
    			}
		}
    }
    
    //busca en las respuestas si existe alguna en true
    public Boolean anyTrue(){
    	if(getItem(0).getClass().equals(Multiple_Opcion.class)){
    		for (Respuesta r : res) {
    			Multiple_Opcion aux = (Multiple_Opcion)r;
    			if(aux.getSelected())
    				return true;
    		}
		}else{
			Respuesta_Abierta ra = (Respuesta_Abierta) getItem(0);
			if(ra.getText().length()>0)
				return true;
		}
    	return false;
    }

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

//	public String getTipo() {
//		return tipo;
//	}
//
//
//	public void setTipo(String tipo) {
//		this.tipo = tipo;
//	}

}
