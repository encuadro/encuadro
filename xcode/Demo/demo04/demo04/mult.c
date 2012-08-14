/* Description:To multiply given to matrix using arrays*/

#include"mult.h"

double* mult(double matrizT[4][4], double puntos3D[4])
{
int i,j,k;
int a,b,c;/*three variables to get the row and colum of the two matrix*/
double sum;
    double* vectorSalida;

    vectorSalida=(double *) malloc(4*sizeof(double));
    
a=4;
b=4;
c=1;
sum = 0;   

   for(i=0;i<a;i++)
     {
//    for(j=0;j<c;j++)
//     {
       sum=0;
       for(k=0;k<b;k++)
        {
          sum=sum+(matrizT[i][k]*puntos3D[k]);
            
            
          
        }
//     }
         vectorSalida[i]=sum;
  }
    vectorSalida[0] = vectorSalida[0]/vectorSalida[3];
    vectorSalida[1] = vectorSalida[1]/vectorSalida[3];
    vectorSalida[2] = vectorSalida[2]/vectorSalida[3];
    
    return vectorSalida;
 }
