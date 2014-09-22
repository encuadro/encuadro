/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto.clases;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.IOException;
import java.net.URL;
import javax.media.CannotRealizeException;
import javax.media.Manager;
import javax.media.NoPlayerException;
import javax.media.Player;
import javax.swing.JFrame;
import javax.swing.JPanel;

/**
 *
 * @author SysAdmin
 */
public class MediaPanelAudio extends JPanel {
    
    Player mediaPlayer;
    JFrame mediaTest;
    
    public MediaPanelAudio(URL mediaURL) {
        mediaTest = new JFrame( "Media" );
        mediaTest.setDefaultCloseOperation( JFrame.DISPOSE_ON_CLOSE );
        this.mediaTest.addWindowListener(new WindowAdapter(){public void windowClosing(WindowEvent e){
        mediaPlayer.stop();
        mediaPlayer.close();
        }});
        mediaTest.add( this );
        mediaTest.setSize(300, 70);
        mediaTest.setVisible( true );
        setLayout( new BorderLayout() ); // use a BorderLayout
        // Uso de componentes sencillos
        Manager.setHint( Manager.LIGHTWEIGHT_RENDERER, true );
        try{
            // crear un reproductor para la URl especifica
            mediaPlayer = Manager.createRealizedPlayer( mediaURL );
            // componentes de interfaz para el mostrar el video y controles
            Component video = mediaPlayer.getVisualComponent();
            Component controls = mediaPlayer.getControlPanelComponent();
            if ( video != null )
                // agragar el video al componente
                add( video, BorderLayout.CENTER );
            if ( controls != null )
                // agregar controles
                add( controls, BorderLayout.NORTH );
            mediaPlayer.start(); //  reproducir el clip
          }
        catch ( NoPlayerException noPlayerException ){
            System.err.println( "No se encontro archivos de multimedia" );
            }
        catch ( CannotRealizeException cannotRealizeException ){
            System.err.println( "No se puede reconocer el reproductor" );
            }
        catch ( IOException iOException ){
            System.err.println( "Error al leer la fuente" );
            }
    }
   

    public void windowOpened(WindowEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void windowClosed(WindowEvent e) {
        mediaPlayer.stop();
        mediaPlayer.close();
    }

    public void windowIconified(WindowEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void windowDeiconified(WindowEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void windowActivated(WindowEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void windowDeactivated(WindowEvent e) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
