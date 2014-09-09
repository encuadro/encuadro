/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto.clases;

import java.awt.geom.Rectangle2D;
import java.io.File;
import java.io.FileInputStream;
import javax.swing.ImageIcon;
import javax.swing.JCheckBox;
import javax.swing.JLabel;
import javax.swing.JTextArea;
import proyecto.AgregarObra2;
import proyecto.ModificarObra2;
import proyecto.ZonaInteresIma;
import proyecto.agContZi;
import proyecto.modZi;

/**
 *
 * @author SysAdmin
 */
public class Global {
    public static Boolean logueado;
    public static int TipoUs; //tipo de usuario logueado
    public static String nickUsLog; //nick del usuario logueado
    public static int IDUsu; //id del usuario logueado
    public static String passUs; //contraseña del usuario logueado
    public static String nomSala;
    public static File filei; //archivo de tipo imagen
    public static File filea; //archivo de tipo audio
    public static File filev; //archivo de tipo video
    public static File filem; //archivo de tipo modelo 3d
    public static File fvid; //archivo de tipo video para reproducir
    public static int IdSala = 0;
    public static String nomObra = null;
    public static Boolean imagen = false, video = false, audio = false, texto = false, modelo3D = false, animacion = false;
    public static AgregarObra2 agOb2 = null;
    public static ModificarObra2 modOb2 = null;
    public static String stringTexto = null;   
    public static JLabel lab = new javax.swing.JLabel();
    public static FileInputStream fileInputStream = null; 
    public static Boolean agMod = null;
    public static String directorioLocal = null; //ruta del directorio actual de la aplicación
    public static String directorioTemporal = null; //ruta del directorio temporal de la aplicación
    public static Rectangle2D rrr = null;
    public static ZonaInteresIma zii = null;
    public static agContZi agcontZi = null;
    public static modZi mzi = null;
    public static Boolean zag = false,zelim = false, zmod = false;
    public static JCheckBox chk_texto_AgOb2 = null;
    public static JTextArea txt_texto_ModOb2 = null;
    public static boolean modif_zona = false;
    public static boolean modif_texto = false;
    public static JLabel label_imagen = null;
    public static int idZona = 0;
    public static String nomImagen = null;
    public static int idObra = 0;
    public static JTextArea txt_texto_AgOb2 = null;
    public static ImageIcon gif_cargando = new ImageIcon(Global.directorioLocal + "/loading.gif");
    
    /**
     * Limpia las variables globales, excepto la sesión del usuario y los directorios de la aplicación
     */
    public static void LimpiarGlobal(){
        nomSala = null;
        filei = null; //archivo de tipo imagen
        filea = null; //archivo de tipo audio
        filev = null; //archivo de tipo video
        filem = null; //archivo de tipo modelo 3d
        fvid = null;
        IdSala = 0;
        nomObra = null;
        imagen = false;
        video = false;
        audio = false;
        texto = false;
        modelo3D = false;
        animacion = false;
        agOb2 = null;
        modOb2 = null;
        stringTexto = null;
        lab = new javax.swing.JLabel();;
        fileInputStream = null; 
        agMod = null;
        rrr = null;
        zii = null;
        agcontZi = null;
        mzi = null;
        zag = false;
        zelim = false;
        zmod = false;
        chk_texto_AgOb2 = null;
        txt_texto_ModOb2 = null;
        modif_zona = false;
        modif_texto = false;
        label_imagen = null;
        idZona = 0;
        nomImagen = null;
        idObra = 0;        
        txt_texto_AgOb2 = null;
    }
}
