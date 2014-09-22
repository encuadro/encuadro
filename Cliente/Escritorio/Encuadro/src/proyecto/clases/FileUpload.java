/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto.clases;

/**
 *
 * @author SysAdmin
 */


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
 
/**
 * This class is used to upload a file to a FTP server.
 *
 * @author Muthu
 */
public  class FileUpload {
 
   /**
    * Upload a file to a FTP server. A FTP URL is generated with the
    * following syntax:
    * ftp://user:password@host:port/filePath;type=i.
    *
    * @param ftpServer , FTP server address (optional port ':portNumber').
    * @param user , Optional user name to login.
    * @param password , Optional password for user.
    * @param fileName , Destination file name on FTP server (with optional
    *            preceding relative path, e.g. "myDir/myFile.txt").
    * @param source , Source file to upload.
    * @throws MalformedURLException, IOException on error.
    */
    public static void upload( String ruta, File source) throws MalformedURLException, IOException {
        if (ruta != null && source != null){
            StringBuffer sb = new StringBuffer( ruta );
            // check for authentication else assume its anonymous access.
            /*
             * type ==&gt; a=ASCII mode, i=image (binary) mode, d= file directory
             * listing
             */
            sb.append( ";type=i" );
            BufferedInputStream bis = null;
            BufferedOutputStream bos = null;

            try{
               URL url = new URL( sb.toString() );
               URLConnection urlc = url.openConnection();

               bos = new BufferedOutputStream( urlc.getOutputStream() );
               bis = new BufferedInputStream( new FileInputStream( source ) );

               int i;
               // read byte by byte until end of stream
               while ((i = bis.read()) != -1){
                  bos.write( i );
               }
            }finally{
               if (bis != null) {
                    try{
                       bis.close();
                    }catch (IOException ioe){
                       ioe.printStackTrace();
                    }
               }
               if (bos != null){
                   try{
                       bos.close();
                       System.out.println("cerro");
                   }catch (IOException ioe){
                       ioe.printStackTrace();
                   }
                }
            }
        }else{
            System.out.println( "Input not available." );
        }
   }
   
    public static void download( String rutaFTP, File destination) throws MalformedURLException, IOException {
        if (rutaFTP != null && destination != null){
             StringBuffer sb = new StringBuffer( rutaFTP );
             // check for authentication else assume its anonymous access.
             /*
              * type ==> a=ASCII mode, i=image (binary) mode, d= file directory
              * listing
              */
             sb.append( ";type=i" );
            BufferedInputStream bis = null;
            BufferedOutputStream bos = null;
         
            try{
                URL url = new URL( sb.toString() );
                URLConnection urlc = url.openConnection();

                bis = new BufferedInputStream( urlc.getInputStream() );
                //bos = new BufferedOutputStream( new FileOutputStream(destination.getName() ) );
                bos = new BufferedOutputStream( new FileOutputStream(destination ) );
                int i;
                
                while ((i = bis.read()) != -1){
                   bos.write( i );
                }
            }finally{
                if (bis != null) {
                    try{
                       bis.close();
                    }catch (IOException ioe){
                       ioe.printStackTrace();
                    }
                }
                if (bos != null) {
                    try{
                       bos.close();
                       System.out.println("cerro");
                    }catch (IOException ioe){
                       ioe.printStackTrace();
                    }
                }
             }
        }else{
            System.out.println( "Input not available" );
        }
   }

/*Esto es para correrlo

public static void main(String[] args) throws MalformedURLException {
        
        
            File file = new File("C:/qr.gif");
            try {
                
                 FileUpload.download("10.0.2.109", "salas" , "12345678" , "qr.gif" ,file, "47/imagen/" );
        
            } catch (IOException ex) {
                Logger.getLogger(JavaApplication1.class.getName()).log(Level.SEVERE, null, ex);
            }
        
    }*/
   
   
 
   /**
    * Download a file from a FTP server. A FTP URL is generated with the
    * following syntax:
    * ftp://user:password@host:port/filePath;type=i.
    *
    * @param ftpServer , FTP server address (optional port ':portNumber').
    * @param user , Optional user name to login.
    * @param password , Optional password for user.
    * @param fileName , Name of file to download (with optional preceeding
    *            relative path, e.g. one/two/three.txt).
    * @param destination , Destination file to save.
    * @throws MalformedURLException, IOException on error.
    */


}