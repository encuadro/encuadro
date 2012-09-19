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
    
    unsigned long int  pixelNr;
    for(int j=0;j<h;j++)
    {
        
        for(int i=0;i<w;i=i++)
        {
            /* The values asigned to brillo obtained as follows:
            pixelNr = j*w+i;
            blue                = pixelNr*d;
            green               = pixelNr*d+1;
            red                = pixelNr*d+2;
            
            r=pixels[red];
            g=pixels[green];
            b=pixels[blue];
            */
            pixelNr = j*w+i;
            
            /*convert each pixel to gray*/
            brillo[pixelNr] = 0.30*pixels[pixelNr*d+2] + 0.59*pixels[pixelNr*d+1] + 0.11*pixels[pixelNr*d];
        }
    }
    
    
}


    
