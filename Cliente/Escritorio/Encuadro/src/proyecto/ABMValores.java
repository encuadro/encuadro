
package proyecto;

import java.awt.Image;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
import proyecto.clases.Global;

/**
 *
 * @author LucasMiranda
 */
public class ABMValores extends javax.swing.JFrame {

    String [] games12;
    boolean modificar=false;
    
    public ABMValores() {
        initComponents();
        Image icono = new ImageIcon(Global.directorioLocal + "\\museo.png").getImage();
        setIconImage(icono);
        String data = getValoresDeOpciones();
        System.out.println(data);
        games12 = data.split("=>");
        
        jButtonEliminar.setVisible(false);
        jButtonModificar.setVisible(false);
        
        System.out.println(data);
        if (games12.length>1){
            for (int i=0; i< games12.length; i++){
                if ((i)%2==0){
                    listacosas.add(games12[i+1]);
                }
            }
        } else {
            JOptionPane.showMessageDialog(null,"Aún no se han creado valores de respuesta!");
        }
        
        labelNombre.setVisible(false);
        textField1.setVisible(false);
        button2.setVisible(false);
    }
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        listacosas = new java.awt.List();
        labelNombre = new java.awt.Label();
        textField1 = new java.awt.TextField();
        jButtonVolver = new javax.swing.JButton();
        jButtonModificar = new javax.swing.JButton();
        jButtonEliminar = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();
        button2 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("ABM Opcion");
        getContentPane().setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        listacosas.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                listacosasMouseClicked(evt);
            }
        });
        getContentPane().add(listacosas, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 10, 152, 195));

        labelNombre.setName(""); // NOI18N
        labelNombre.setText("Nombre Opcion");
        getContentPane().add(labelNombre, new org.netbeans.lib.awtextra.AbsoluteConstraints(172, 69, -1, -1));

        textField1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                textField1ActionPerformed(evt);
            }
        });
        getContentPane().add(textField1, new org.netbeans.lib.awtextra.AbsoluteConstraints(273, 69, 197, -1));

        jButtonVolver.setText("Volver");
        jButtonVolver.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonVolverActionPerformed(evt);
            }
        });
        getContentPane().add(jButtonVolver, new org.netbeans.lib.awtextra.AbsoluteConstraints(407, 182, -1, -1));

        jButtonModificar.setText("Modificar");
        jButtonModificar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonModificarActionPerformed(evt);
            }
        });
        getContentPane().add(jButtonModificar, new org.netbeans.lib.awtextra.AbsoluteConstraints(257, 182, -1, -1));

        jButtonEliminar.setText("Eliminar");
        jButtonEliminar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonEliminarActionPerformed(evt);
            }
        });
        getContentPane().add(jButtonEliminar, new org.netbeans.lib.awtextra.AbsoluteConstraints(182, 182, -1, -1));

        jButton1.setText("Nuevo");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        getContentPane().add(jButton1, new org.netbeans.lib.awtextra.AbsoluteConstraints(338, 182, -1, -1));

        button2.setText("Crear >>");
        button2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                button2ActionPerformed(evt);
            }
        });
        getContentPane().add(button2, new org.netbeans.lib.awtextra.AbsoluteConstraints(320, 100, -1, -1));

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void textField1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_textField1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_textField1ActionPerformed

    private void listacosasMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_listacosasMouseClicked
        //
        if (listacosas.getSelectedIndex()<games12.length/2){
            jButtonEliminar.setVisible(true);
            jButtonModificar.setVisible(true);
        }
        if (modificar==true){
            textField1.setText(listacosas.getSelectedItem());
        }
    }//GEN-LAST:event_listacosasMouseClicked

    private void jButtonVolverActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonVolverActionPerformed
        this.dispose();
        // TODO add your handling code here:
    }//GEN-LAST:event_jButtonVolverActionPerformed

    private void jButtonModificarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonModificarActionPerformed
        if (modificar==false){
            modificar=true;
            textField1.setText(listacosas.getSelectedItem());
            textField1.setVisible(true);
            button2.setVisible(false);
            jButtonModificar.setText("Confirmar >>");
            
        }else{
        if (!listacosas.getSelectedItem().equals(textField1.getText()) && !textField1.getText().equals("")){
            this.setAlwaysOnTop(false);
            if(JOptionPane.showConfirmDialog(rootPane, "Advertencia: Esta modificacion se verá reflejada en cada lugar donde esta opcion aparece! Desea confirmar los cambios?") == JOptionPane.YES_OPTION){
                System.out.println("id val----"+games12[listacosas.getSelectedIndex()*2]);
                int fl = setValorOpcc(games12[listacosas.getSelectedIndex()*2], textField1.getText());
                if (fl!=0){
                    this.setAlwaysOnTop(false);
                    JOptionPane.showMessageDialog(null,"Error: No se han podido realizar las modificaciones! Intente mas tarde.");
                } else{
                    this.setAlwaysOnTop(false);
                    JOptionPane.showMessageDialog(null,"Se realizaron los cambios exitosamente!");
                
                    this.dispose();
                    ABMValores v = new ABMValores();
                    v.setVisible(true);
                    v.setLocationRelativeTo(null);
                    v.setAlwaysOnTop(true);
                }
            }

        } else {
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: No se han realizado modificaciones! Debe modificar el campo Nombre de la Opcion");
        }
        }
    }//GEN-LAST:event_jButtonModificarActionPerformed

    private void jButtonEliminarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEliminarActionPerformed
        //ver si pertenece a algun grupo de opciones (devuelve mayor 0 si esta en algun grupo// 9999 = error)
        int asociaciones = isValorAsociadoAOpcion(games12[listacosas.getSelectedIndex()*2]);
        System.out.println("--------------asociaciones "+asociaciones);
        if (asociaciones<1 && asociaciones!=9999){
            //eliminar
            System.out.println("eliminaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaar");
            int b = borrarValorOpc(Integer.parseInt(games12[listacosas.getSelectedIndex()*2]));
            
            if (b==0){
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"La Opcion fue Correctamente Eliminada!");
                
                this.dispose();
                ABMValores v = new ABMValores();
                v.setVisible(true);
                v.setLocationRelativeTo(null);
                v.setAlwaysOnTop(true);
            }
            
            
            
        } else {
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: Esta opcion está relacionada a uno o mas Grupos! No es posible eliminarla hasta no desvincularla del/los Grupo/s."); 
        }
        
    }//GEN-LAST:event_jButtonEliminarActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        labelNombre.setVisible(true);
        textField1.setVisible(true);
        button2.setVisible(true);
    }//GEN-LAST:event_jButton1ActionPerformed

    private void button2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_button2ActionPerformed
        if (textField1.getText().equals("")){
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"El texto de la Opcion no puede ser vacío!");
        } else {
            int id_val_op = agregarValorOpcion(textField1.getText());
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Se creó correctamente la opcion id: "+id_val_op+"!");
            System.out.println("opcion id "+id_val_op);

            this.dispose();
            ABMValores v = new ABMValores();
            v.setVisible(true);
            v.setLocationRelativeTo(null);
            v.setAlwaysOnTop(true);
        }
    }//GEN-LAST:event_button2ActionPerformed

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
            java.util.logging.Logger.getLogger(ABMValores.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ABMValores.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ABMValores.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ABMValores.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ABMValores().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton button2;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButtonEliminar;
    private javax.swing.JButton jButtonModificar;
    private javax.swing.JButton jButtonVolver;
    private java.awt.Label labelNombre;
    private java.awt.List listacosas;
    private java.awt.TextField textField1;
    // End of variables declaration//GEN-END:variables

    private static String getOpciones() {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getOpciones();
    }

    private static String getValoresDeOpcion(int idOpcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getValoresDeOpcion(idOpcion);
    }

    private static String getValoresDeOpciones() {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getValoresDeOpciones();
    }

    private static int agregarValorOpcion(java.lang.String descripcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.agregarValorOpcion(descripcion);
    }

    private static int setValorOpcc(java.lang.String idVal, java.lang.String descripcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.setValorOpcc(idVal, descripcion);
    }

    private static int isValorAsociadoAOpcion(java.lang.String idValor) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.isValorAsociadoAOpcion(idValor);
    }

    private static int borrarValorOpc(int idValor) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.borrarValorOpc(idValor);
    }

    
}
