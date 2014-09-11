/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto.clases;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Point;
import java.awt.RenderingHints;
import java.awt.Shape;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import javax.imageio.ImageIO;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import proyecto.agContZi;
import proyecto.modZi;

/**
 *
 * @author SysAdmin
 */
public class PanelImagen extends JPanel implements MouseMotionListener, MouseListener{
    private Image imaOriginal;
    private BufferedImage imaEnMemoria;
    private BufferedImage tmpRecorte;
    private Graphics2D g2D;
    private boolean con_foto = false;
    private Color colorLinea = new Color(200, 0, 0);
    private float grosorLinea = 3f;
    private Point inicioArrastre;
    private Point finArrastre;
    private ArrayList<Shape> rectangulos = new ArrayList<Shape>();
    private String accion = null;
    
    public PanelImagen(BufferedImage b, String acc){
        this.imaOriginal = b;
        this.setSize(b.getWidth(), b.getHeight());
        this.setVisible(true);
        this.con_foto = true;
        this.accion = acc;
        addMouseMotionListener(this);
        addMouseListener(this);
    }
    @Override
    public void paintComponent(Graphics g){
        Graphics2D g2 = (Graphics2D) g;
        if(this.con_foto){
            //lienzo tamaño foto
            imaEnMemoria = new BufferedImage(this.getWidth(), this.getHeight(), BufferedImage.TYPE_INT_RGB);
            g2D = imaEnMemoria.createGraphics();
            g2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            //add foto grande original
            g2D.drawImage(imaOriginal, 0, 0, imaOriginal.getWidth(this), imaOriginal.getHeight(this), this);
            //crear rectangulo
            g2D.setStroke(new BasicStroke(this.grosorLinea));
            g2D.setColor(colorLinea);
            if(inicioArrastre != null && finArrastre != null){//se esta arrastrando mouse?
                Rectangle2D rr = new Rectangle2D.Float(inicioArrastre.x, inicioArrastre.y, finArrastre.x-inicioArrastre.x, finArrastre.y-inicioArrastre.y);
                g2D.draw(rr);
            }
            //dibuja todo
            g2.drawImage(imaEnMemoria, 0, 0, this);
        }
    }
    
    public void guardarImagen(String f){
//        recortar();
        try{
            //escribe en disco
            ImageIO.write(tmpRecorte, "jpg", new File(f));
            JOptionPane.showMessageDialog(null, "El recorte se guardó correctamente.");
        }catch(IOException e){
            JOptionPane.showMessageDialog(null, "Error: no se pudo guardar la imagen.");
        }
    }

    public void mouseDragged(MouseEvent e) {
        finArrastre = new Point(e.getX(), e.getY());
        if(finArrastre.getX() > imaOriginal.getWidth(this)) {
            finArrastre.setLocation(0, imaOriginal.getWidth(this));
        }
        if(finArrastre.getY() > imaOriginal.getHeight(this)) {
            finArrastre.setLocation(imaOriginal.getHeight(this), 0);
        }
        this.repaint();
    }

    public void mouseMoved(MouseEvent e) {
    }

    public void mouseClicked(MouseEvent e) {
    }

    public void mousePressed(MouseEvent e) {
        inicioArrastre = new Point(e.getX(), e.getY());
        finArrastre = inicioArrastre;
        repaint();
    }

    public void mouseReleased(MouseEvent e) {
        //if(JOptionPane.showConfirmDialog(this, "¿Confirmar la Zona de Interés?") == JOptionPane.YES_OPTION){
            Global.rrr = new Rectangle2D.Float(inicioArrastre.x, inicioArrastre.y, finArrastre.x - inicioArrastre.x, finArrastre.y - inicioArrastre.y);
            rectangulos.add(Global.rrr);
            inicioArrastre = null;
            finArrastre = null;
            Global.zii.setVisible(false);
            Global.modif_zona = true;
            if(Global.label_imagen != null){
                modZi.RefrescarImagenZona();
            }
            
            if("agregar".equals(accion)){
                Global.agcontZi = new agContZi();
                Global.agcontZi.setVisible(true);
                Global.agcontZi.setLocationRelativeTo(this);
            }
        //}
    }

    public void mouseEntered(MouseEvent e) {
    }

    public void mouseExited(MouseEvent e) {
    }
}
