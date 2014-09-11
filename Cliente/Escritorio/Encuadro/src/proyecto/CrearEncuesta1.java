/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto;

import java.awt.Image;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
import proyecto.clases.Global;

/**
 *
 * @author LucasMiranda
 */
public class CrearEncuesta1 extends javax.swing.JFrame {

    int flag=0; //0=crear comun  //1= modificar nombre y eso //2 editar todo
    String datos[];
    int id_c;
    /**
     * Creates new form CrearEncuesta1
     */
    public CrearEncuesta1() {
        initComponents();
        Image icono = new ImageIcon(Global.directorioLocal + "\\museo.png").getImage();
        setIconImage(icono);
        String data = getTextAllPreguntas();
        
        String [] games12 = data.split("=>");
        int i=0;
        
        if (games12.length<10){//tiene al menos dos filas (hay dos preguntas)
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: Para poder crear un Cuestionario deben haber al menos dos preguntas creadas!");   
            crearCuest.setEnabled(false);
        }
    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        descrCuestionario = new javax.swing.JTextArea();
        nomCuestionario = new javax.swing.JTextField();
        crearCuest = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("Nuevo Cuestionario");

        jLabel1.setText("Nombre");

        jLabel2.setText("Descripción");

        descrCuestionario.setColumns(20);
        descrCuestionario.setRows(5);
        jScrollPane1.setViewportView(descrCuestionario);

        nomCuestionario.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nomCuestionarioActionPerformed(evt);
            }
        });

        crearCuest.setText("Crear  >>");
        crearCuest.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                crearCuestActionPerformed(evt);
            }
        });

        jButton1.setText("Volver");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2)
                    .addComponent(jLabel1))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(nomCuestionario)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 263, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(28, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(crearCuest)
                .addGap(18, 18, 18)
                .addComponent(jButton1)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(22, 22, 22)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(nomCuestionario, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(crearCuest)
                    .addComponent(jButton1))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void nomCuestionarioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nomCuestionarioActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_nomCuestionarioActionPerformed

    private void crearCuestActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_crearCuestActionPerformed
        if (flag==0){
        DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy-HH:mm:ss");
        Calendar cal = Calendar.getInstance();
        String fecha = dateFormat.format(cal.getTime()).toString();
        System.out.println(fecha);
        int id_cuest = agregarCuestionarioo(nomCuestionario.getText(), descrCuestionario.getText(),fecha, Global.IDUsu);
        System.out.println(id_cuest);
        System.out.println(nomCuestionario.getText()+"   "+ descrCuestionario.getText());
        ABMCuestionario ap = new ABMCuestionario();
        ap.id_cuest = id_cuest;
        ap.setVisible(true);
        ap.setLocationRelativeTo(null);
        ap.setAlwaysOnTop(true);
        this.dispose();
        } else if (flag==1){
            if (!nomCuestionario.getText().equals(datos[0]) || !descrCuestionario.getText().equals(datos[1])){
                
                
                //nombre y eso
                int asd = setCuestionariio(id_c, nomCuestionario.getText(), descrCuestionario.getText());
            }
            String dataa = getTextPreguntas(id_c);
            System.out.println("------datos preguntas------"+dataa);
            
            String [] preguntas = dataa.split("=>");
            
            

            this.dispose();
            ABMCuestionario ap = new ABMCuestionario();
            ap.id_cuest = id_c;
                    
            for (int t=0; t<preguntas.length; t++){
                if (t%5==0){
                    ap.arrayIdPreguntas.add(Integer.parseInt(preguntas[t+1]));
                    ap.arrayPreguntas.add(preguntas[t+3]);
                    
                }
                
            }
            System.out.println(";;;;ids;;;;;"+ap.arrayIdPreguntas);
            System.out.println(";;;;preg;;;;;"+ap.arrayPreguntas);
            
            ap.cargarLista();
            ap.modificando=true;
            ap.setVisible(true);
            ap.setLocationRelativeTo(null);
            ap.setAlwaysOnTop(true);
    
            
        } else {
            this.setAlwaysOnTop(false);
            JOptionPane.showMessageDialog(null,"Error: No ha realizado modificaciones!");
        }
    }//GEN-LAST:event_crearCuestActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        this.dispose();
        
    
        
    }//GEN-LAST:event_jButton1ActionPerformed

    public void actualizar(int f, int id_cuest){
        flag=f;
        id_c=id_cuest;
        if (flag==1){//cambiar nombre y eso
            this.setTitle("Modificar Cuestionario");
            crearCuest.setText("Confirmar >>");
            
            String data = getDatosPregunta(id_cuest);
            datos = data.split("=>");
            
            nomCuestionario.setText(datos[0]);
            descrCuestionario.setText(datos[1]);
            
        } else if (flag==2){//modificar todo
            this.setTitle("Modificar Cuestionario");
            crearCuest.setText("Continuar >>");
            
            String data = getDatosPregunta(id_cuest);
            datos= data.split("=>");
            
            nomCuestionario.setText(datos[0]);
            descrCuestionario.setText(datos[1]);
        
        }
    }
    
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
            java.util.logging.Logger.getLogger(CrearEncuesta1.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(CrearEncuesta1.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(CrearEncuesta1.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(CrearEncuesta1.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new CrearEncuesta1().setVisible(true);
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton crearCuest;
    private javax.swing.JTextArea descrCuestionario;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextField nomCuestionario;
    // End of variables declaration//GEN-END:variables

    private static int agregarCuestionario(java.lang.String nombre, java.lang.String descripcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.agregarCuestionario(nombre, descripcion);
    }

    private static int agregarCuestionarioo(java.lang.String nombre, java.lang.String descripcion, java.lang.String fechaCreacion, int idCreador) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.agregarCuestionarioo(nombre, descripcion, fechaCreacion, idCreador);
    }

    private static String getTextAllPreguntas() {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getTextAllPreguntas();
    }

    private static String getDatosPregunta(int idCuest) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getDatosPregunta(idCuest);
    }

//    private static int setCuestionariio(int idCuest, java.lang.String nombre, java.lang.String descripcion) {
//        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
//        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
//        return port.setCuestionariio(idCuest, nombre, descripcion);
//    }

    private static String getTextPreguntas(int idCuest) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.getTextPreguntas(idCuest);
    }

    private static int setCuestionariio(int idCuest, java.lang.String nombre, java.lang.String descripcion) {
        _109._2._0._10.server_php.Comision service = new _109._2._0._10.server_php.Comision();
        _109._2._0._10.server_php.ComisionPortType port = service.getComisionPort();
        return port.setCuestionariio(idCuest, nombre, descripcion);
    }
}
