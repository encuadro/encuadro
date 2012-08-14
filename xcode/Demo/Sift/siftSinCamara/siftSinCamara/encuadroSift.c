//
//  encuadroSift.c
//  siftSinCamara
//
//  Created by Pablo Flores Guridi on 09/08/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#include <stdio.h>
#include "encuadroSift.h"




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

                                      
Pair* compare (Pair* pairs_iterator, int * L1_pt, int * L2_pt, int K1, int K2, int ND, float thresh, int* matches)
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
                acc += delta*delta ;
                
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

    return pairs_iterator ;
}

int* levantarDescriptor(char* nombre, int* nKeyPoints)
{
    FILE *archivo;
    
    //    char* direccion[200]="/Users/juanignaciobraun/encuadro/benchmark/iPod/640x480/Caso1/Scale0.6/threshold16/Caso1-PuntosFiltro57.txt";
    archivo=fopen(nombre, "r");
    int *descr = NULL;
    long int largo;
    
    if (archivo==NULL)
    {
        printf("Could not open file!");
    }
    else
    {
        fscanf(archivo,"%ld\n \n",&largo);
        //printf("%ld\n",largo);
        descr = (int*) malloc(largo*sizeof(int));
        *nKeyPoints = largo/128;
        for (int i=0; i<largo;i++)
        {
          fscanf(archivo,"%d\n",&descr[i]);
            //printf("%d\t%d\n",i,descr[i]);
        }
        
    }

    return descr;
}

void escribirDescriptor(char* nombre, int* descriptor, long int largo)
{
    FILE *archivo;
    
    //    char* direccion[200]="/Users/juanignaciobraun/encuadro/benchmark/iPod/640x480/Caso1/Scale0.6/threshold16/Caso1-PuntosFiltro57.txt";
    archivo=fopen(nombre, "w");
    
    long int i=0;
    
    if (archivo==NULL)
    {
        printf("Could not open file!");
    }
    else
    {
        fprintf(archivo,"%ld\n \n",largo);
        
        for (i=0;i<largo;i++)
        {
            fprintf(archivo,"%d\n",*descriptor);
            descriptor++;
           
        }
        
        fclose(archivo);
    }

}

