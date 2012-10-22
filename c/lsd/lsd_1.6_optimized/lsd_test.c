//
//  lsd_test.c
//  lsd v1.6 optimizado
//
//  Created by Pablo Flores Guridi on 22/10/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#include <stdio.h>
#include "lsd.h"
#include "processing.h"

int main(int argc, char ** argv)
{
    char *nombre = argv[1];
    
    float scale = 0.5;
    float sigma_scale = 0.6; /* Sigma for Gaussian filter is computed as
                              sigma = sigma_scale/scale.                    */
    float quant = 2.0;       /* Bound to the quantization error on the
                              gradient norm.                                */
    float ang_th = 22.5;     /* Gradient angle tolerance in degrees.           */
    float log_eps = 0.0;     /* Detection threshold: -log10(NFA) > log_eps     */
    float density_th = 0.7;  /* Minimal density of region points in rectangle. */
    int n_bins = 1024;        /* Number of bins in pseudo-ordering of gradient
                               modulus.                                       */
    int width = 512;
    int height = 512;
    image_float imagen_float;
    image_float luminancia_sub;
    
    float* out;
    int n;
    
    float *datafloat = (float *) malloc( width * height * sizeof(float));
    datafloat = read_pgm_image_float(&width,&height,nombre);
    imagen_float = new_image_float_ptr( (unsigned int) width, (unsigned int) height, datafloat );
    luminancia_sub = gaussian_sampler(imagen_float, scale, sigma_scale);
    out = LineSegmentDetection(&n, luminancia_sub->data, luminancia_sub->xsize, luminancia_sub->ysize,2, sigma_scale, quant, ang_th, log_eps, density_th, n_bins, NULL, NULL, NULL);
    
 	/* print output */
 	int i,j;
	printf("%d line segments found:\n",n);
	for(i=0;i<n;i++)
    {
    	for(j=0;j<7;j++)
			printf("%f ",out[7*i+j]);
		printf("\n");
    }
    
    /*Ahora tenemos los segmentos en "list" y la cantidad de segmentos en listSize*/

    free_image_float(imagen_float);
    free_image_float(luminancia_sub);
    free(out);
//	free(datafloat);	// YA LO LIBERA free_image_float
    

    return 0;
}

