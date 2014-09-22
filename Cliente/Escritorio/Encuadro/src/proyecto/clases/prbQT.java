/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto.clases;

import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import quicktime.QTSession;
import quicktime.app.display.QTCanvas;
import quicktime.app.players.MoviePlayer;
import quicktime.io.OpenMovieFile;
import quicktime.io.QTFile;
import quicktime.std.movies.Movie;
//setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE)
/**
 *
 * @author Usuario
 */
public class prbQT extends Frame{
    public Movie movie = null;
   
    public prbQT(String title){ 
        super(title);
        try { 
            QTSession.open();
            OpenMovieFile omFile = OpenMovieFile.asRead (new QTFile (Global.fvid)); 
            movie = Movie.fromFile (omFile); 
            // get a Drawable for Movie, put in QTCanvas 
            MoviePlayer player = new MoviePlayer (movie); 
            QTCanvas canvas = new QTCanvas(); 
            canvas.setClient (player, true); 
            add (canvas); // windows-like close-to-quit 
            addWindowListener (new WindowAdapter() {           
                public void windowClosing (WindowEvent e) { 
                    //QTSession.close();
                    dispose();
                } 
            }); 
        }catch (Exception e) { 
            e.printStackTrace(); 
        } 
    }
}
