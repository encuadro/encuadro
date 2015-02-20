/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto.clases;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
/**
 *
 * @author Kristian
 */
public class Parser {
    
    
    //private JSONObject json_object;
    private JSONArray json_array;
    private List<Map<String,String>> jsonMap;
    
    public Parser(){
    }
    public Parser(String json){
        if(isArray(json))
            this.setJsonArray(json);
        this.JsonToMap(json_array);
        
    }
    public void setJsonArray(String json){
        try {
            this.json_array = new JSONArray(json);
        } catch (JSONException e) {
            System.err.println(e);
        }
    }
    
    public String getParameter(String key){
        return  jsonMap.get(0).get(key);                
    }
    
    public String getParameter(String key, int pos){
            return jsonMap.get(pos).get(key);
    }    
    
    
    public static Boolean isJson(String texto){
        return texto.charAt(0) == '{' ;
    }
    
    public static Boolean isArray(String texto){
        return texto.charAt(0) == '[';
    }
    
    private void JsonToMap(JSONArray json){
        try{
            toMap(json);
        }catch(JSONException e){
            System.err.println(e);
        }
    }
    
    private void toMap(JSONArray json_array) throws JSONException{
        jsonMap = new ArrayList<Map<String, String>>();
        for(int x=0;x<json_array.length();x++){
            JSONObject json = json_array.getJSONObject(x);
            Iterator<String> keys = json.keys();
            Map<String,String> add = new HashMap<String, String>();
            while(keys.hasNext()){                    
                String key = keys.next();
                String value = json.get(key).toString();
                add.put(key, value);            
            }
            jsonMap.add(add);
        }
    }    
//    private void toMap(JSONObject json ) throws JSONException{
//        jsonMap = new HashMap<String, String>();
//        Iterator<String> keys = json.keys();
//        while(keys.hasNext()){
//            String key = keys.next();
//            String value = json.get(key).toString();
//            jsonMap.put(key, value);            
//        }
//    }
}
