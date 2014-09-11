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
public class ABMCuestionario extends javax.swing.JFrame {
    int modificaciones=0;
    int id_cuest = 0;
    int id_pregunta;
    ArrayList<String> arrayPreguntas = new ArrayList<String>();
    ArrayList<Integer> arrayIdPreguntas = new ArrayList<Integer>();
    int cant_preguntas = 0;
    int tipo = 1;
    boolean ver=true;
    boolean modificando=false;
    
    String [] games12;
            
    public ABMCuestionario() {
        initComponents();
        Image icono = new ImageIcon(Global.directorioLocal + "\\museo.png").getImage();
        setIconImage(icono);
        list1.removeAll();
        
        String data = getTextAllPreguntas();
        
        games12 = data.split("=>");
        
        for (int i=0; i< games12.length; i++){
            if ((i-3)%5==0){
                list1.add(games12[i]);
            }
        }
    }

    public void cargarLista(){
        for(int u=0; u<arrayPreguntas.size(); u++){
            list2.add(arrayPreguntas.get(u));
        }
    }
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        list2 = new java.awt.List();
        list1 = new java.awt.List();
        btnAgregar = new javax.swing.JButton();
        btnQuitar = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Agregar Pregunta");
        setBounds(new java.awt.Rectangle(0, 0, 488, 285));

        btnAgregar.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        btnAgregar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/iconos/arrow_right.png"))); // NOI18N
        btnAgregar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnAgregarActionPerformed(evt);
            }
        });

        btnQuitar.setFont(new java.awt.Font("Times New Roman", 1, 14)); // NOI18N
        btnQuitar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/iconos/arrow_left.png"))); // NOI18N
        btnQuitar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnQuitarActionPerformed(evt);
            }
        });

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/iconos/arrow_down.png"))); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/iconos/arrow_up.png"))); // NOI18N
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton3.setText("Finalizar Cuestionario");
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(list1, javax.swing.GroupLayout.PREFERRED_SIZE, 311, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(btnAgregar, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(btnQuitar, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(list2, javax.swing.GroupLayout.PREFERRED_SIZE, 147, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jButton3)
                .addGap(18, 18, 18)
                .addComponent(jButton2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton1)
                .addGap(27, 27, 27))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(list1, javax.swing.GroupLayout.PREFERRED_SIZE, 239, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(list2, javax.swing.GroupLayout.PREFERRED_SIZE, 241, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(92, 92, 92)
                        .addComponent(btnAgregar)
                        .addGap(18, 18, 18)
                        .addComponent(btnQuitar)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton1)
                        .addComponent(jButton2))
                    .addComponent(jButton3))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnQuitarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnQuitarActionPerformed
        modificaciones++;
        arrayIdPreguntas.remove(list2.getSelectedIndex());
        arrayPreguntas.remove(list2.getSelectedIndex());
        
        list2.removeAll();
        for (int j=0; j<arrayIdPreguntas.size(); j++){
                    list2.add(arrayPreguntas.get(j));
                }
        
        
        
    }//GEN-LAST:event_btnQuitarActionPerformed

    private void btnAgregarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnAgregarActionPerformed
        
        if (list1.getSelectedIndex()!=-1){
            int flag=1;
            for (int i=0; i<arrayIdPreguntas.size();i++){
                if(list1.getSelectedItem().equals(arrayPreguntas.get(i))){
                    flag=-1;
                    } 
            }
            if (flag==1){
                modificaciones++;
                arrayIdPreguntas.add(Integer.parseInt(games12[list1.getSelectedIndex()*5]));
                arrayPreguntas.add(list1.getSelectedItem());
                list2.add(list1.getSelectedItem());
            }else {
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"Error: La pregunta seleccionada ya fue agregada anteriormente!");        
                }
        } else{
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: Debe seleccionar una pregunta!");
        }
    }//GEN-LAST:event_btnAgregarActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        // subir
        if (list2.getSelectedIndex()!=-1){
            if (list2.getSelectedIndex()!=0){
                modificaciones++;
                //item seleccionado
                int id_selected=arrayIdPreguntas.get(list2.getSelectedIndex());
                String preg_sel=arrayPreguntas.get(list2.getSelectedIndex());
                
                
                //copiar el de arriba abajo
                arrayIdPreguntas.set(list2.getSelectedIndex(),arrayIdPreguntas.get(list2.getSelectedIndex()-1));
                arrayPreguntas.set(list2.getSelectedIndex(), arrayPreguntas.get(list2.getSelectedIndex()-1));
                
                //insertar el seleccionado arriba
                arrayIdPreguntas.set(list2.getSelectedIndex()-1, id_selected);
                arrayPreguntas.set(list2.getSelectedIndex()-1, preg_sel);
                
                //refresh list2
                
                list2.removeAll();
                for (int j=0; j<arrayIdPreguntas.size(); j++){
                    list2.add(arrayPreguntas.get(j));
                }
                
            }else{
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"Error: Ha seleccionado la primer pregunta. No puede intercambiarla por otra anterior porque no hay!");    
            }
        }else {
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: Debe seleccionar una pregunta de la lista de la derecha para ser movida a una posición superior!");
        }
        
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        //bajar
        if (list2.getSelectedIndex()!=-1){
            if (!list2.getSelectedItem().equals(list2.getItem(arrayIdPreguntas.size()-1))){
                modificaciones++;
                //item seleccionado
                int id_selected=arrayIdPreguntas.get(list2.getSelectedIndex());
                String preg_sel=arrayPreguntas.get(list2.getSelectedIndex());
                System.out.println("seleccionado "+preg_sel+" id "+id_selected);
                
                //copiar el de abajo en el seleccionado
                arrayIdPreguntas.set(list2.getSelectedIndex(),arrayIdPreguntas.get(list2.getSelectedIndex()+1));
                arrayPreguntas.set(list2.getSelectedIndex(), arrayPreguntas.get(list2.getSelectedIndex()+1));
                
                //insertar el seleccionado en de abjajo
                arrayIdPreguntas.set(list2.getSelectedIndex()+1, id_selected);
                arrayPreguntas.set(list2.getSelectedIndex()+1, preg_sel);
                
                //refresh list2
                
                list2.removeAll();
                for (int j=0; j<arrayIdPreguntas.size(); j++){
                    list2.add(arrayPreguntas.get(j));
                }
            }else{
                this.setAlwaysOnTop(false);
                JOptionPane.showMessageDialog(null,"Error: Ha seleccionado la ultima pregunta. No puede intercambiarla por otra posterior porque no hay!");    
            }
        }else {
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: Debe seleccionar una pregunta de la lista de la derecha para ser movida a una posición superior!");
        }
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
    if (modificando==false){        
        for (int j=0; j<arrayIdPreguntas.size(); j++){
                    asociarPreguntaConCuestionario(arrayIdPreguntas.get(j), id_cuest, j+1);
                }
        this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"El Cuestionario fue creado con exito!");
        
        
        this.dispose();
    } else{
        if (modificaciones>0){
        
            int dfs = borrarRelacionPreguntasCuestionario(id_cuest);
            
            for (int j=0; j<arrayIdPreguntas.size(); j++){
                    asociarPreguntaConCuestionario(arrayIdPreguntas.get(j), id_cuest, j+1);
                }
            
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"El Cuestionario fue modificado con exito!");
            this.dispose();
        
        } else{
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"No se han realizado modificaciones!");
            this.dispose();
        }
    }
        
    }//GEN-LAST:event_jButton3ActionPerformed

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
            java.util.logging.Logger.getLogger(ABMCuestionario.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ABMCuestionario.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ABMCuestionario.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ABMCuestionario.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ABMCuestionario().setVisible(true);
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnAgregar;
    private javax.swing.JButton btnQuitar;
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private java.awt.List list1;
    private java.awt.List list2;
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

    private static int borrarRelacionPreguntasCuestionario(int idCuest) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.borrarRelacionPreguntasCuestionario(idCuest);
    }
    
}
