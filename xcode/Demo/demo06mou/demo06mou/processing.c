//
//  processing.c
//  prueba2
//
//  Created by Juan Cardelino on 18/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "processing.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>



void rgb2gray(double* brillo, unsigned char *pixels, int w, int h, int d)
{
    // printf("w: %-3d h: %-3d\n",w,h);
    //        double* luminancia;
    //        luminancia = (double *) malloc(w*h*sizeof(double));
    
    unsigned long int  pixelNr;
    for(int j=0;j<h;j++)
    {
        
        for(int i=0;i<w;i=i++)
        {
            //printf("1 %hhu\n",*pixels);
            //pixelNr = i*h+j;
            pixelNr = j*w+i;
            
            //printf("2 %hhu\n",*pixels);
            int blue                = pixelNr*d;
            
            //printf("3 %hhu\n",*pixels);
            int green               = pixelNr*d+1;
            
            //printf("4 %hhu\n",*pixels);
            int red                = pixelNr*d+2;
            
           // printf("5 %hhu\n",*pixels);
            int r,g,b;
            
            //printf("6 %hhu\n",*pixels);
            r=pixels[red];
            
            //printf("7 %hhu\n",*pixels);
            g=pixels[green];
            
            //printf("8 %hhu\n",*pixels);
            b=pixels[blue];
            //convert each pixel to gray
            
            double fvalue=0.30*r + 0.59*g + 0.11*b;
            
            
            //for debugging purpose only
            //printf(" %g",fvalue);
            //printf(" %ld\n",pixelNr);
            //printf(" %d \t %d \t %d\n",w,h,d);
            //printf("9 %hhu\n",*pixels);
           // printf(" (%d,%d,%d)",r,g,b);
            
            brillo[pixelNr] = rint(fvalue);
             //printf("10 %hhu\n",*pixels);
        }
    }
    //    return luminancia;
}


    
