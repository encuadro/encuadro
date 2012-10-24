//
//  lsd_test.c
//  lsd v1.6 optimizado
//
//  Created by Pablo Flores Guridi on 22/10/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#include <stdio.h>
#include "lsd_encuadro.h"
#include <stdlib.h>

int main(int argc, char ** argv)
{
    char *nombre = argv[1];
    
    int width = 128;
    int height = 128;
    
    float *image;
    float* out;
    int n;
    
    int x,y;
    
	/* create a simple image: left half black, right half gray */
	image = (float *) malloc( width * height * sizeof(float) );
  	if( image == NULL )
    {
      fprintf(stderr,"error: not enough memory\n");
      exit(EXIT_FAILURE);
    }
  	for(x=0;x<width;x++)
    for(y=0;y<height;y++)
      image[x+y*width] = x<width/2 ? 0.0 : 64.0; /* image(x,y) */
        
    out = lsd_encuadro(&n, image, width, height);
    
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

    free(image);
    free(out);
//	free(datafloat);	// YA LO LIBERA free_image_float
    

    return 0;
}

