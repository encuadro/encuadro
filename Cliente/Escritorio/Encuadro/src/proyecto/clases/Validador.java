/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto.clases;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *Clase para la validación de los datos de formularios
 * @author SysAdmin
 */
public class Validador {
    
    /**
     * Verifica si un string es numérico.\nTRUE: es numérico.\nFALSE: no numérico.
     */
    public static boolean isNumeric(String num){
        try{
            Integer.parseInt(num);
        } catch(NumberFormatException nfe) {
            return false;
        }
        return true;
    }
    
    /**
     * Verifica si un string es una fecha válida, con el formato dd/MM/yyyy.\nTRUE: válido.\nFALSE: inválido.
     */
    public static boolean isDate(String fechax) {
        try {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
            Date fecha = formatoFecha.parse(fechax);
        } catch (Exception e) {
            return false;
        }
        return true;
    }
    
    /**
     * Verifica el formato de una dirección de email.\nTRUE: correcto.\nFALSE: incorrecto.
     */
    public static boolean isEmail(String email) {
        Pattern pat = null;
        Matcher mat = null;
        pat = Pattern.compile("^([0-9a-zA-Z]([_.w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-w]*[0-9a-zA-Z].)+([a-zA-Z]{2,9}.)+[a-zA-Z]{2,3})$");
        mat = pat.matcher(email);
        
        if (mat.find()) {
            //System.out.println("[" + mat.group() + "]");
            return true;
        }else{
            return false;
        }
    }
    
    /**
     * Verifica los dígitos de una Cédula de Identidad.\n1: válido.\n0: inválido.
     * @param ci
     * @return 
     */
    public static int validarCedula(int ci){
        //Inicializo los coefcientes en el orden correcto

        String aux = Integer.toString(ci);
        String cis[] = new String[8];    
        String validador[] = new String[7];
        int c = 0;
        int c1 = 0;
        int dveri = 0;

        for(int e = 0; e<8; e++){   
            if(e != 7) {
                cis[e] = aux.substring(e,e+1);
            }else {
                dveri = Integer.parseInt(aux.substring(e,e+1));
            }
        }

        for (int i = 0 ; i<7 ; i++){
            if(c==0){
            validador[i] = Integer.toString(2);}
            if(c==1){
            validador[i] = Integer.toString(9);}
            if(c==2){
            validador[i] = Integer.toString(8);}  
            if(c==3){
            validador[i] = Integer.toString(7);}
            if(c==4){
            validador[i] = Integer.toString(6);}
            if(c==5){
            validador[i] = Integer.toString(3);}
            if(c==6){
            validador[i] = Integer.toString(4);}
            c++;
        }

        int ce = 0;
        int suma = 0;
        int f = 0;
        String multi[] = new String[7];
        for(int y = 0 ; y < 7 ; y++){
            multi[y] = Integer.toString(Integer.parseInt(cis[y]) * Integer.parseInt(validador[y]));
            if(multi[y].length()>1){
                f = Integer.parseInt(multi[y].substring(1, 2));
                suma = suma + f;
            }else{
                f = Integer.parseInt(multi[y]);
                suma = suma + f;
            }
        }
        
        if((suma % 10) == 0 && dveri == 0){
            return 1;
        }else{
            boolean ok = false;
            int resultado = 0;
            int resultado2 = 0;
            int mayor = 0;
            String aux2;
            while(ok == false){
                if(mayor < suma){
                    mayor++;
                }else{
                    aux2 = Integer.toString(mayor);    
                    if(aux2.substring(1, 2).equals("0") && mayor > suma){
                        System.out.println("aux2"+aux2);
                        ok = true;
                    }else{
                        mayor++;
                    }
                }
            }
            
            resultado = mayor - suma;
            resultado2 = 10-(suma %10);
            if(resultado == resultado2 && resultado == dveri) {
                return 1;
            }else {
                return 0;
            }
        }
    }
}
