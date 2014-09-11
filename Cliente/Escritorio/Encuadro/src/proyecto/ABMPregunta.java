/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto;

import java.awt.Image;
import java.util.ArrayList;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
import javax.swing.Timer;
import proyecto.clases.Global;

/**
 *
 * @author LucasMiranda
 */
public class ABMPregunta extends javax.swing.JFrame {

    int id_cuest = 0;
    int id_pregunta;
    ArrayList<String> arrayPreguntas = new ArrayList<String>();
    ArrayList<Integer> arrayIdPreguntas = new ArrayList<Integer>();
    int cant_preguntas = 0;
    int tipo = 1;
    boolean ver=true;
    boolean modif=false;
    String nom_op="";
    String nom_preg="";
    int id_op=0;
    boolean preg_ab=false;
    String [] arrVal = null;
    
    String [] games12;
            
    public ABMPregunta() {
        initComponents();
        Image icono = new ImageIcon(Global.directorioLocal + "\\museo.png").getImage();
        setIconImage(icono);
        buttonGroup1.add(jRadioButtonAbierta);
        buttonGroup1.add(jRadioButtonMultipleOp);
        
        jLabel1.setVisible(false);
        txt_pregunta.setVisible(false);
        jRadioButtonAbierta.setVisible(false);
        jRadioButtonMultipleOp.setVisible(false);
        
        list1.removeAll();
        
        String data = getTextAllPreguntas();
        System.out.println(data);
        games12 = data.split("=>");
        
        System.out.println("--------"+data);
        
        if (games12.length>4){
        
        for (int i=0; i< games12.length; i++){
            if ((i-3)%5==0){
                list1.add(games12[i]);
            }
        }
        
        } else {
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: No hay preguntas agregadas en el sistema!");
        }
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        txt_pregunta = new javax.swing.JTextField();
        jLabel1 = new javax.swing.JLabel();
        list2 = new java.awt.List();
        jRadioButtonAbierta = new javax.swing.JRadioButton();
        jRadioButtonMultipleOp = new javax.swing.JRadioButton();
        list1 = new java.awt.List();
        label_grupo = new javax.swing.JLabel();
        btnCrear = new javax.swing.JButton();
        btnVolver = new javax.swing.JButton();
        btnEliminar = new javax.swing.JButton();
        jLabel2 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Agregar Pregunta");
        setBounds(new java.awt.Rectangle(0, 0, 488, 285));
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        txt_pregunta.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txt_preguntaActionPerformed(evt);
            }
        });
        getContentPane().add(txt_pregunta, new org.netbeans.lib.awtextra.AbsoluteConstraints(72, 11, 406, -1));

        jLabel1.setText("Pregunta");
        getContentPane().add(jLabel1, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 14, -1, -1));

        list2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                list2ActionPerformed(evt);
            }
        });
        getContentPane().add(list2, new org.netbeans.lib.awtextra.AbsoluteConstraints(331, 132, 147, 117));

        jRadioButtonAbierta.setText("Pregunta Abierta");
        jRadioButtonAbierta.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonAbiertaActionPerformed(evt);
            }
        });
        getContentPane().add(jRadioButtonAbierta, new org.netbeans.lib.awtextra.AbsoluteConstraints(340, 60, -1, -1));

        jRadioButtonMultipleOp.setSelected(true);
        jRadioButtonMultipleOp.setText("Multiple Opcion");
        jRadioButtonMultipleOp.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButtonMultipleOpActionPerformed(evt);
            }
        });
        getContentPane().add(jRadioButtonMultipleOp, new org.netbeans.lib.awtextra.AbsoluteConstraints(340, 30, -1, 43));

        list1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                list1MouseClicked(evt);
            }
        });
        list1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                list1ActionPerformed(evt);
            }
        });
        getContentPane().add(list1, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 41, 311, 208));

        label_grupo.setText("                                   ");
        getContentPane().add(label_grupo, new org.netbeans.lib.awtextra.AbsoluteConstraints(350, 110, 120, -1));

        btnCrear.setText("Nueva");
        btnCrear.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnCrearActionPerformed(evt);
            }
        });
        getContentPane().add(btnCrear, new org.netbeans.lib.awtextra.AbsoluteConstraints(346, 260, -1, -1));

        btnVolver.setText("Volver");
        btnVolver.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnVolverActionPerformed(evt);
            }
        });
        getContentPane().add(btnVolver, new org.netbeans.lib.awtextra.AbsoluteConstraints(415, 260, -1, -1));

        btnEliminar.setText("Eliminar");
        btnEliminar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnEliminarActionPerformed(evt);
            }
        });
        getContentPane().add(btnEliminar, new org.netbeans.lib.awtextra.AbsoluteConstraints(190, 260, -1, -1));

        jLabel2.setText("Grupo:");
        getContentPane().add(jLabel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(340, 90, -1, -1));

        jButton1.setText("Modificar");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        getContentPane().add(jButton1, new org.netbeans.lib.awtextra.AbsoluteConstraints(265, 260, -1, -1));

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void txt_preguntaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txt_preguntaActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_txt_preguntaActionPerformed

    private void jRadioButtonAbiertaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonAbiertaActionPerformed
        
            tipo=0;
            System.out.println("tipo "+tipo);
            list1.setEnabled(false);
            list2.setEnabled(false);
    }//GEN-LAST:event_jRadioButtonAbiertaActionPerformed

    private void jRadioButtonMultipleOpActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButtonMultipleOpActionPerformed
       
            tipo=1;
            System.out.println("tipo "+tipo);
            list1.setEnabled(true);
            list2.setEnabled(true);
    }//GEN-LAST:event_jRadioButtonMultipleOpActionPerformed

    private void list1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_list1MouseClicked
        //ver opciones 
        if (ver==true){
            list2.removeAll();
            System.out.println("id de pregunta "+games12[list1.getSelectedIndex()*5+1]);
            String algo = getRespPreguntas(Integer.parseInt(games12[list1.getSelectedIndex()*5+1]));
            System.out.println("aaaaaaaaaaaaaaaaa "+algo);
            String[] games123 = algo.split("=>");
            if (games123[0].equals("-1") || algo.equals("-1")){
                list2.add("--PREGUNTA ABIERTA--");
                label_grupo.setText("           ");
            } else{
                String op = getOpcPregunta(Integer.parseInt(games12[list1.getSelectedIndex()*5+1]));
                label_grupo.setText(op);
                for(int k=0; k<games123.length; k++){
                        list2.add(games123[k]);
                    }
                }

            }
        if (modif==true){
        
        }

    }//GEN-LAST:event_list1MouseClicked

    private void btnCrearActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnCrearActionPerformed
        if (ver==true){        
            //pasa a creacion de pregunta
            
            jLabel1.setVisible(!false);
            txt_pregunta.setVisible(!false);
            jRadioButtonAbierta.setVisible(!false);
            jRadioButtonMultipleOp.setVisible(!false);
            
            ver=false;
            btnCrear.setText("Guardar");
            btnEliminar.setText("Ver Preg");
            jButton1.setEnabled(false);
            
            list1.removeAll();
            list2.removeAll();
            String data = getOpciones();
            System.out.println(data);
            games12 = data.split("=>");

            System.out.println(data);
            if (games12.length>1){
            for (int i=0; i< games12.length; i++){
                if ((i)%2==0){
                    list1.add(games12[i+1]);
                }
            }
            } else {
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"Error: Aún no se han creado grupos de opciones!");
            }
        }else {
            //guardar pregunta
            if (!txt_pregunta.getText().equals("")){
                if (tipo==1){
                //preg multiple opcion
                   if (list1.getSelectedIndex()!=-1){
                       if(JOptionPane.showConfirmDialog(rootPane, "Crear una pregunta con el grupo de opciones: "+games12[list1.getSelectedIndex()*2+1]+"") == JOptionPane.YES_OPTION){
                           System.out.println("respuesta si");
                           id_pregunta = agregarPregunta2(txt_pregunta.getText(), tipo, Integer.parseInt(games12[list1.getSelectedIndex()*2]));
                            this.setAlwaysOnTop(false);
                            JOptionPane.showMessageDialog(null,"Pregunta id: "+id_pregunta+" creada correctamente!");
                            this.dispose();
                            ABMPregunta p =new ABMPregunta();

                            p.setVisible(true);
                            p.setLocationRelativeTo(null);
                            p.setAlwaysOnTop(true);
                   } else {
                           System.out.println("respuesta neg");
                       }
                   } else {
                       this.setAlwaysOnTop(false);
                        JOptionPane.showMessageDialog(null,"Error: Tiene que relacionar la pregunta con un grupo de opciones!");
                   }
                   
                }else{
                //preg libre
                    id_pregunta = agregarPregunta2(txt_pregunta.getText(), tipo, -1);
                    this.setAlwaysOnTop(false);
                    JOptionPane.showMessageDialog(null,"Pregunta id: "+id_pregunta+" creada correctamente!");
                    this.dispose();
                    ABMPregunta p =new ABMPregunta();
                    
                    p.setVisible(true);
                    p.setLocationRelativeTo(null);
                    p.setAlwaysOnTop(true);
                    
                }
                //JOptionPane.showMessageDialog(null,"Pregunta id: "+id_pregunta+"  creada correctamente!");
            }else{
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"El campo Pregunta no puede estar vacío!");
            }
        }
    }//GEN-LAST:event_btnCrearActionPerformed

    private void btnVolverActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnVolverActionPerformed
        this.dispose();
        // TODO add your handling code here:
    }//GEN-LAST:event_btnVolverActionPerformed

    private void btnEliminarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnEliminarActionPerformed
        //eliminar
        if (ver==true && modif==false){
            if (list1.getSelectedIndex()!=-1){
                //ver si es usado en algun cuest (devuelve mayor 0 si true// 9999 = error)
                
                int asociaciones = isPreguntaAsociadaACuestionario(games12[list1.getSelectedIndex()*5]);
                System.out.println("--------------en cuantos cuestionarios? "+asociaciones);
                
                if (asociaciones<1 && asociaciones!=9999){
                    //eliminar
                    System.out.println("eliminaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaar");
                    
                    int b = borrarPregunta(Integer.parseInt(games12[list1.getSelectedIndex()*5]));

                    if (b==0){
                        this.setAlwaysOnTop(false);
                        JOptionPane.showMessageDialog(null,"La Pregunta fue Correctamente Eliminada!");

                        this.dispose();
                        ABMPregunta v = new ABMPregunta();
                        v.setVisible(true);
                        v.setLocationRelativeTo(null);
                        v.setAlwaysOnTop(true);
                    }



                } else {
                    this.setAlwaysOnTop(false);
                    JOptionPane.showMessageDialog(null,"Error: Esta Pregunta es usada en algún Cuestionario! No es posible eliminarla hasta no desvincularla de ese/os Cuestionario/s."); 
                }

            
            }else{
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"Error: Debe seleccionar una Pregunta para Eliminar");
                
            }
            
        }else{
            
            this.dispose();
            ABMPregunta p =new ABMPregunta();
            p.setVisible(true);
            p.setLocationRelativeTo(null);
            p.setAlwaysOnTop(true);
        
        }
       
    }//GEN-LAST:event_btnEliminarActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        if (modif==false){
        ver=false;      
        modif=true;
        jLabel2.setText("Grupo actual:");
        nom_op=label_grupo.getText();
            System.out.println("txxt op"+nom_op);
        btnCrear.setEnabled(false);
        jButton1.setText("Guardar");
        btnEliminar.setText("Ver Preg");
        txt_pregunta.setVisible(true);
        txt_pregunta.setText(list1.getSelectedItem());
        nom_preg=list1.getSelectedItem().toString();
        System.out.println("txxt preg"+nom_preg);
        System.out.println("llega hasta aca");
        String asdf = getDataPregunta(Integer.parseInt(games12[list1.getSelectedIndex()*5]));
        System.out.println("preg--------"+asdf);
            
        
        String [] wer = asdf.split("=>");
        id_pregunta=Integer.parseInt(wer[0]);
        System.out.println("========idpreg========="+id_pregunta);
        System.out.println("         wer    "+wer[3]);
        if (wer[3].equals("-1")){
           preg_ab=true;
           list1.setEnabled(false);
            label_grupo.setText("Pregunta Abierta");
            id_op=-1;
        } else {
            id_op=Integer.parseInt(wer[3]);
            System.out.println("========idop========="+id_op);
            String valores = getValoresDeOpcion(Integer.parseInt(wer[3]));
            System.out.println("valores "+valores);
            
            arrVal = valores.split("=>");
            
            list2.removeAll();
            for (int r=0; r<arrVal.length; r++){
                if (r%2==0){
                    list2.add(arrVal[r+1]);
                }
            }
        }
        
        list1.removeAll();
        String data = getOpciones();
        games12 = data.split("=>");
        System.out.println("----------opciones---------"+data);
        if (games12.length>1){
        for (int i=0; i< games12.length; i++){
            if ((i)%2==0){
                list1.add(games12[i+1]);
            }
        }
        
        
        } else {
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: Aún no se han creado grupos de opciones!");
        }
        } else {
            
            if (!nom_preg.equals(txt_pregunta.getText()) || (list1.getSelectedIndex()==-1 ) || (!list1.getSelectedItem().equals(nom_op))){
                if (!nom_preg.equals(txt_pregunta.getText())){
                    //\\modificar nombre
                    nom_preg=txt_pregunta.getText();
                }
                if (list1.getSelectedIndex()!=-1){
                if (!list1.getSelectedItem().equals(nom_op)){
                    ///modificar opcion
                    id_op=Integer.parseInt(games12[list1.getSelectedIndex()*2]);
                
                }
                }
                System.out.println("hago consulta con txt pregunta "+nom_preg+" id op "+id_op+" id preg "+id_pregunta);
                int resp = setPregunta(id_pregunta, id_op, nom_preg);
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"Las modificaciones se han realizado exitosamente!");
                this.dispose();
                
                ABMPregunta p = new ABMPregunta();
                p.setAlwaysOnTop(true);
                p.setLocationRelativeTo(null);
                p.setVisible(true);
                
            } else{
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"Error: No ha realizado ninguna modificación!");
            }
        
        }
    }//GEN-LAST:event_jButton1ActionPerformed

    private void list2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_list2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_list2ActionPerformed

    private void list1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_list1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_list1ActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(ABMPregunta.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ABMPregunta.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ABMPregunta.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ABMPregunta.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ABMPregunta().setVisible(true);
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnCrear;
    private javax.swing.JButton btnEliminar;
    private javax.swing.JButton btnVolver;
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JRadioButton jRadioButtonAbierta;
    private javax.swing.JRadioButton jRadioButtonMultipleOp;
    private javax.swing.JLabel label_grupo;
    private java.awt.List list1;
    private java.awt.List list2;
    private javax.swing.JTextField txt_pregunta;
    // End of variables declaration//GEN-END:variables

    private static int agregarValorOpcion(java.lang.String descripcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.agregarValorOpcion(descripcion);
    }

    private static int agregarPregunta(java.lang.String descripcion, int tipo) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.agregarPregunta(descripcion, tipo);
    }


    private static int asociarPreguntaConCuestionario(int idPreg, int idCuest, int indice) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.asociarPreguntaConCuestionario(idPreg, idCuest, indice);
    }

    private static int asociarPreguntaConOpcion(int idPreg, int idOp) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.asociarPreguntaConOpcion(idPreg, idOp);
    }

    private static int setOpcion(java.lang.String descripcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.setOpcion(descripcion);
    }

    private static int asociarOpcionesConValores(int idOpc, int valor) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.asociarOpcionesConValores(idOpc, valor);
    }

    private static int agregarPregunta2(java.lang.String descripcion, int tipo, int idOpciones) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.agregarPregunta2(descripcion, tipo, idOpciones);
    }

    private static String getTextAllPreguntas() {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getTextAllPreguntas();
    }

    private static String getRespPreguntas(int idPreg) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getRespPreguntas(idPreg);
    }

    private static String getOpcPregunta(int idPreg) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getOpcPregunta(idPreg);
    }

    private static String getOpciones() {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getOpciones();
    }

    private static int isPreguntaAsociadaACuestionario(java.lang.String idPreg) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.isPreguntaAsociadaACuestionario(idPreg);
    }

    private static int borrarPregunta(int idpreg) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.borrarPregunta(idpreg);
    }

    private static String getDataPregunta(int idPreg) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getDataPregunta(idPreg);
    }

    private static String getValoresDeOpcion(int idOpcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getValoresDeOpcion(idOpcion);
    }

    private static int setPregunta(int idPreg, int idOp, java.lang.String descripcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.setPregunta(idPreg, idOp, descripcion);
    }
    
}
