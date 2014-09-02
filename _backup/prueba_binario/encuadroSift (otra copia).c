//
//  main.c
//  sift
//
//  Created by Pablo Flores Guridi on 21/08/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//


#include <stdio.h>
#include "encuadroSift.h"
#include <mysql.h>


/* estas librerias son para recorrer los directorios */

#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <errno.h>


#include <string.h>



unsigned char* pixels;
//vl_sift_pix pixelsGray[262144];
int err=0;
FILE            *in    = 0 ;
VlPgmImage pim ;
vl_uint8        *data  = 0 ;
vl_sift_pix     *fdata = 0 ;


char *server; //direccion del servidor 127.0.0.1, localhost o direccion ip
char *user; //usuario para consultar la base de datos
char *password; // contraseña para el usuario en cuestion
char *database; //nombre de la base de datos a consultar

void error(const char *s)
{
  /* perror() devuelve la cadena S y el error (en cadena de caracteres) que tenga errno */
  perror (s);
  exit(EXIT_FAILURE);
}

void sift(float* fdata, int width, int height, int* nKeyPoints, double** keyPoints, int** descriptors)
{
    
    double* frames = 0;
    int nframes =0;
    int reserved = 0;
    int* descr  = 0;
    
    /*Definimos los parametros*/
    
    int	noctaves = 5;
    int	nlevels =3;
    int o_min = 0;
    int nikeys = -1;
    
    double             edge_thresh = 10;
    double             peak_thresh = 0;
    double             norm_thresh = 0;
    double             magnif      = 3;
    double             window_size = 2;
    
    VlSiftFilt* filtroSift = vl_sift_new(width,height,noctaves, nlevels, o_min);
	
    vl_sift_set_peak_thresh(filtroSift, peak_thresh);
    vl_sift_set_edge_thresh(filtroSift, edge_thresh);
    vl_sift_set_norm_thresh(filtroSift, norm_thresh);
    vl_sift_set_magnif(filtroSift, magnif);
    vl_sift_set_window_size(filtroSift,window_size);
    
    /*Procesamos cada octava*/
    int i     = 0 ;
    vl_bool first = 1 ;
    while (1)
    {
        int                   err ;
        VlSiftKeypoint const* keys  = 0 ;
        int                   nkeys = 0 ;
        
        
        /* Calculate the GSS for the next octave .................... */
        if (first)
        {
            err   = vl_sift_process_first_octave (filtroSift, fdata) ;
            first = 0 ;
        } else {
            err   = vl_sift_process_next_octave  (filtroSift) ;
        }
        
        if (err) break ;
        
        
        /* Run detector ............................................. */
        if (nikeys < 0) {
            vl_sift_detect (filtroSift) ;
            
            keys  = vl_sift_get_keypoints(filtroSift) ;
            nkeys = vl_sift_get_nkeypoints(filtroSift) ;
            i     = 0 ;
        } else {
            nkeys = nikeys ;
        }
        
        /* For each keypoint ........................................ */
        for (; i < nkeys ; ++i) {
            double                angles [4] ;
            int                   nangles ;
            VlSiftKeypoint const *k ;
            
            /* Obtain keypoint orientations ........................... */
            
            k = keys + i ;
            nangles = vl_sift_calc_keypoint_orientations(filtroSift, angles, k) ;
            
            /* For each orientation ................................... */
            for (int q = 0 ; q < nangles ; ++q) {
                vl_sift_pix  buf [128] ;
                vl_sift_pix rbuf [128] ;
                
                /* compute descriptors*/
                vl_sift_calc_keypoint_descriptor (filtroSift, buf, k, angles [q]) ;
                transposeDescriptor (rbuf, buf);
                
                
                /* make enough room for all these keypoints and more */
                if (reserved < nframes + 1) {
                    reserved += 2 * nkeys ;
                    frames = (double*) malloc(4 * sizeof(double) * reserved) ;
                    descr  = (int*) malloc (128 * sizeof(int) * reserved) ;
                }
                
                /* Save back with MATLAB conventions. Notice tha the input
                 * image was the transpose of the actual image. */
                frames [4 * nframes + 0] = k -> y + 1 ;
                frames [4 * nframes + 1] = k -> x + 1 ;
                frames [4 * nframes + 2] = k -> sigma ;
                frames [4 * nframes + 3] = VL_PI / 2 - angles [q] ;
                
                
                for (int j = 0 ; j < 128 ; ++j) {
                    float x = 512.0F * rbuf [j] ;
                    x = (x < 255.0F) ? x : 255.0F ;
                    ((int*)descr) [128 * nframes + j] = (int) x ;
                }
                
                
                ++ nframes ;
            } /* next orientation */
        } /* next keypoint */
    } /*next octave*/
    
    
    *nKeyPoints = nframes;
    *keyPoints = frames;
    *descriptors = descr;
    vl_sift_delete (filtroSift);
    
}


void transposeDescriptor (vl_sift_pix* dst, vl_sift_pix* src)
{
    int const BO = 8 ;  /* number of orientation bins */
    int const BP = 4 ;  /* number of spatial bins     */
    int i, j, t ;
    
    for (j = 0 ; j < BP ; ++j) {
        int jp = BP - 1 - j ;
        for (i = 0 ; i < BP ; ++i) {
            int o  = BO * i + BP*BO * j  ;
            int op = BO * i + BP*BO * jp ;
            dst [op] = src[o] ;
            for (t = 1 ; t < BO ; ++t)
                dst [BO - t + op] = src [t + o] ;
        }
    }
}


void compare (Pair* pairs_iterator, int * L1_pt, int * L2_pt, int K1, int K2, int ND, float thresh, int* matches)
{
    // L1_pt la lista de descriptores de la imagen 1
    // L2_pt la lista de descriptores de la imagen 2
    // K1 la cantidad de keyPoints de la lista 1
    // K2 la contidad de keyPoints de la lista 2
    // ND es el numero de descriptores. Deberia valer siempre 128.
    // thresh es el umbral de comparacion
    
    int k1, k2 ;
    const int maxval = 0x7fffffff ;
    *matches= 0;
    
    for(k1 = 0 ; k1 < K1 ;++k1, L1_pt += ND ) {
        
        int best = maxval ;
        int second_best = maxval ;
        int bestk = -1 ;
        
        
        /* For each point P2[k2] in the second image... */
        for(k2 =  0 ; k2 < K2 ; ++k2, L2_pt += ND) {
            
            int bin ;
            int acc = 0 ;
            for(bin = 0 ; bin < ND ; ++bin) {
                int delta =
                (L1_pt[bin]) -
                (L2_pt[bin]) ;
                acc +=delta*delta;
                if(acc>second_best) break;
            }
            
            
            /* Filter the best and second best matching point. */
            if(acc < best) {
                second_best = best ;
                best = acc ;
                bestk = k2 ;
                
            } else if(acc < second_best) {
                second_best = acc ;
            }
        }
        /*En este punto tengo el keyPoint de la imagen 2, mas parecido al keyPoint k1 de la imagen 1*/
        
        L2_pt -= ND*K2 ;
        /*Vuelvo el puntero L2_pt a apuntar a su valor original, para luego poder comparar contra el keyPoint de la imagen 1 de valor k1+1*/
        
        /* Lowe's method: accept the match only if unique. */
        /*Las correspondencias obtenidas en ocaciones son algo menores de lo que deberian ser
         por tener el menor estricto. Para el caso de dos imagenes iguales*/
        if(thresh * (float) best < (float) second_best &&
           bestk != -1) {
            pairs_iterator->k1 = k1 ;
            pairs_iterator->k2 = bestk ;
            pairs_iterator->score = best ;
            pairs_iterator++ ;
            *matches = *matches+1;
            
        }
    }
    
}


int* levantarDescBD(char *id_obra, int* nKeyPoints){ //levanta el descriptor desc en la base de datos
	
 	MYSQL *conn; //variable de conexion para mysql
	MYSQL_RES *res; // variable que contendra el resultado de la consuta
	MYSQL_ROW row; //variable que contendra los campos por cada registro consultado
	
	conn = mysql_init(NULL); //inicializacion a nula la conexion
	
	/* Connect to database */
	if (!mysql_real_connect(conn, server,
	user, password, database, 0, NULL, 0)) { // definir los arametros de la conexion antes establecidos
	fprintf(stderr, "%s\n", mysql_error(conn)); // si hay un error definir cual fue dicho error
	exit(1);
	}
	
	char sql[15100];
	strcpy(sql,"select id_descriptor,descriptor from descriptor where id_obra ='");
	strcat(sql,id_obra);
	strcat(sql,"' order by id_descriptor");
	//printf("sql es %s",sql);
	//printf("termino sql");
	// send SQL query 
	if (mysql_query(conn, sql)) { // definicion de la consulta y el origen de la conexion
	fprintf(stderr, "%s\n", mysql_error(conn));
	exit(1);
	}
	res = mysql_use_result(conn);

	int *descr = NULL;
	long int largo;
	
    	
	if ((row = mysql_fetch_row(res)) != NULL)	
        {
		sscanf(row[1],"%ld\n \n",&largo);			
	}
	
	*nKeyPoints = largo/128;

	descr = (int*) malloc(largo*sizeof(int));

	int i = 0;
	int *da=0;
	
	
	while ((row = mysql_fetch_row(res)) != NULL){ // recorrer la variable res con todos los registros obtenidos para su uso
		
        	//printf("\nid_descriptor %s", row[0]);
		//char str[] = "now # is the time for all # good men to come to the # aid of their country";
		char delims[] = "\n";
		char *result = NULL;
		char aux[100]="";

		
		
		result = strtok( row[1], delims );
		
		
		while( result != NULL ) {
			sscanf(result,"%d",&descr[i]);		
			
		    	result = strtok( NULL, delims );
			i++;	
			
			
		}
		//printf("entro al while que lelna descr tantas veces esto\n");		
		
	};
	//escribirDescriptorPrueba("prueba.txt", descr, largo);	
	mysql_free_result(res);
	mysql_close(conn);
	//printf("descr pos 9 = %d",descr[9]);
	return descr;
}

const char* buscarBaseDeDatos(int nKeyPoints, int* descriptors, vl_bool ranking,const char* nombresala)
{
	long int kb = 0;	  	
    int* nKeyPoints_base =kb;
    int* descriptors_base = 0;
    int correspondences, final_matches;
    Pair* pairs_iterator = (Pair*) malloc(sizeof(Pair) * (nKeyPoints+nKeyPoints));
	char im[200]="";
	
    char* imagen= im;   
    
    int i;
    int j;    
     
    int vecesloop=0;  

	MYSQL *conn; //variable de conexion para mysql
	MYSQL_RES *res; // variable que contendra el resultado de la consuta
	MYSQL_ROW row; //variable que contendra los campos por cada registro consultado
	
	conn = mysql_init(NULL); //inicializacion a nula la conexion

	/* Connect to database */
	if (!mysql_real_connect(conn, server,
	user, password, database, 0, NULL, 0)) { // definir los arametros de la conexion antes establecidos
	fprintf(stderr, "%s\n", mysql_error(conn)); // si hay un error definir cual fue dicho error
	exit(1);
	}

	char sql[100];
	strcpy(sql,"select id_obra from obra where obra.id_sala ='");
	strcat(sql,nombresala);
	strcat(sql,"'");
	//printf("sql es %s",sql);
	//printf("termino sql");
	// send SQL query 
	if (mysql_query(conn, sql)) {// definicion de la consulta y el origen de la conexion
	fprintf(stderr, "%s\n", mysql_error(conn));
	exit(1);
	}
	res = mysql_use_result(conn);
	
	while ((row = mysql_fetch_row(res)) != NULL)
	{
		if (vecesloop==0){
    			
    			descriptors_base = levantarDescBD(row[0], &nKeyPoints_base);
    			
    			compare (pairs_iterator, descriptors, descriptors_base,nKeyPoints,nKeyPoints_base, 128, 2   ,&correspondences);
    			

			strcpy(imagen, row[0]);

    			final_matches = correspondences;

			vecesloop++;
    			
    		}
    		else{
    			
    			descriptors_base = levantarDescBD(row[0], &nKeyPoints_base);
    			

 	   		compare (pairs_iterator, descriptors, descriptors_base,nKeyPoints,nKeyPoints_base, 128, 2   ,&correspondences);
    			
    	       		if (correspondences>final_matches)
    			{ 
    				
				strcpy(imagen, row[0]);
    				final_matches = correspondences;
    				
    			}  		
    		}
		
    		free(descriptors_base);	
		
	}
	
	mysql_free_result(res);
	mysql_close(conn);   
  	return imagen;
}

void escribirDescBD(char *desc,char *id_obra){ //escribe el descriptor desc en la base de datos
	
 	MYSQL *conn; //variable de conexion para mysql
	MYSQL_RES *res; // variable que contendra el resultado de la consuta
	MYSQL_ROW row; //variable que contendra los campos por cada registro consultado
	
	
	conn = mysql_init(NULL); //inicializacion a nula la conexion

	/* Connect to database */
	if (!mysql_real_connect(conn, server,
	user, password, database, 0, NULL, 0)) { // definir los arametros de la conexion antes establecidos
	fprintf(stderr, "%s\n", mysql_error(conn)); // si hay un error definir cual fue dicho error
	exit(1);
	}

	char sql[50000];
	strcpy(sql,"insert into proyecto.descriptor (id_obra,descriptor) values ('");
	strcat(sql,id_obra);
	strcat(sql,"','");
	strcat(sql,desc);
	strcat(sql,"')");
	//printf("sql es %s",sql);
	//printf("termino sql");
	// send SQL query 
	if (mysql_query(conn, sql)) { // definicion de la consulta y el origen de la conexion
	fprintf(stderr, "%s\n", mysql_error(conn));
	exit(1);
	}
	res = mysql_use_result(conn);
	mysql_free_result(res);
	mysql_close(conn);
}

void escribirDescriptor(char* id_obra, int* descriptor, long int largo)
{  
	long int i=0;
	long int j=0;
	char aux[largo];
	char aux2[largo];
        char *a=aux;
	char *a2 = aux2;
    
   	// sprintf(aux2,"%ld\n \n",largo); voy a probar poner la primera fila con el numero de descriptores
        //printf("\nlargo %ld",largo);
	sprintf(aux2,"%ld\n \n",largo);
	escribirDescBD(aux2,id_obra);
	strcpy(aux2,"");
	
        for (i=0;i<largo;i++)
        {   
	   sprintf(aux,"%d\n",*descriptor);	   
	   strcat(aux2,aux);
	   if ((i!=0) & (i % 15000 == 0)){//cuando llego a 15000 mando a la BD lo que tengo
		//printf("\naca entro con i %ld",i);
            	escribirDescBD(aux2,id_obra);
		strcpy(aux2,"");
		}
	    descriptor++;
            
        }   
	
	if(strlen(aux2)!=0)  //guarda el resto de largo div 15000
		escribirDescBD(aux2,id_obra);          
	 
}


/*----------------------| MAIN |-----------------------*/
int main(int argc,char * argv[])
{	
    char* nombsala;
    char* nombarchivo;				
    int largosala;	
    int largoarchivo; 	
    int largoruta;	
 
	
    int j;	
	

    
    int nKeyPoints =0;
    double* keyPoints = 0;
    int* descriptors = 0;	
    
    
    const char* direccion = argv[1];
    
        //----------------------------Levantamos la imagen PNG y obtenemos los pixels----------------------------------
    
    in = fopen (direccion, "rb") ;

    // read PGM header 
    err = vl_pgm_extract_head (in, &pim) ;
    
    // allocate buffer 
    data  = malloc(vl_pgm_get_npixels (&pim) *
                   vl_pgm_get_bpp       (&pim) * sizeof (vl_uint8)   ) ;
    fdata = malloc(vl_pgm_get_npixels (&pim) *
                   vl_pgm_get_bpp       (&pim) * sizeof (vl_sift_pix)) ;
    
    
    err  = vl_pgm_extract_data (in, &pim, data) ;
    
    // convert data type 
    for (int q = 0 ; q < (unsigned) (pim.width * pim.height) ; ++q) {
        fdata [q] = data [q] ;
    }
    
    //----------------------------- Tenemos los pixeles de la imagen en fdata -------------------------------------
    
    int width = pim.width;
    int height = pim.height;
   
    
    
    //Calculamos los descriptores de la imagen de entrada
    sift(fdata, width, height,&nKeyPoints,&keyPoints,&descriptors);
    int r=0;
    
    const char* image_out;   

    //tienen que venir 4 mas argumentos 
    server = argv[3]; //direccion del servidor 127.0.0.1, localhost o direccion ip
    user = argv[4]; //usuario para consultar la base de datos
    password = argv[5]; // contraseña para el usuario en cuestion
    database = argv[6]; //nombre de la base de datos a consultar
	
    if (argc==7)
    {
	
       	char resultado_char[100]="";	
	nombsala=argv[2];
        image_out = buscarBaseDeDatos(nKeyPoints, descriptors,0,nombsala);
       
	strcpy(resultado_char,image_out);
	 
	sscanf(resultado_char,"%d",&r);
	 printf("%d",r);
    }
    else if (argc==8)
    {
    	     
        if(strcmp(argv[7],"generar")==0){ 
	     
             escribirDescriptor(argv[2], descriptors, nKeyPoints*128);
	     printf("1");
             
        }	   
        
    }
   

    return 1;
}

