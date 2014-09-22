//
//  lsd_vdsp.c
//  lsd_optimizer
//
//  Created by Juan Cardelino on 6/10/13.
//  Copyright (c) 2013 Pablo Flores Guridi. All rights reserved.
//

#include <stdio.h>
#include "lsd_encuadro.h"



#include <stdio.h>

#include <Accelerate/Accelerate.h>


#define	OutputLength	16
#define	FilterLength	4
#define	D				2


void sampler_tests()
{
	float A[(OutputLength-1)*D+FilterLength];
	float B[FilterLength];
	float C0[OutputLength], C1[OutputLength];
	
	for (unsigned int i = 0; i < (OutputLength-1)*D+FilterLength; ++i)
		A[i] = 1;
	
	for (unsigned int i = 0; i < FilterLength; ++i)
		B[i] = 1;
	
	for (unsigned int i = 0; i < OutputLength; ++i)
	{
		float sum = 0;
		for (unsigned int p = 0; p < FilterLength; ++p)
			sum += A[i*D+p] * B[p];
		C0[i] = sum;
	}
	
	vDSP_desamp(A, D, B, C1, OutputLength, FilterLength);
	
	for (unsigned int i = 0; i < OutputLength; ++i)
		printf("C0[%d] = %g.  C1[%d] = %g.\n", i, C0[i], i, C1[i]);
	
}
