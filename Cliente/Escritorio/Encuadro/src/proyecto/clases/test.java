/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto.clases;

import org.json.JSONArray;

/**
 *
 * @author Kristian
 */
public class test {
    
    public static void main(String [] args){
        try{
            String json = getUsuariosEmpleado();
            Parser p = new Parser(json);
            System.out.println(json);
        }catch(Exception e){
            System.err.println(e);
        }
    }

    private static String getUsuariosEmpleado() {
        _185._10._168._192.server_php.Comision service = new _185._10._168._192.server_php.Comision();
        _185._10._168._192.server_php.ComisionPortType port = service.getComisionPort();
        return port.getUsuariosEmpleado();
    }
    
}
