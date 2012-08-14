#include "Composit.h"


#define NUMBER_OF_ROT 17  /*nombre de rotations autour de Ou, premier axe du rep. objet*/
#define NUMBER_OF_TRANS 1 /*nombre de translations suivant Cz, axe optique*/
#define TRANS_MIN 500     /*premiere des translations suivant Cz. Unites du rep. objet*/
#define TRANS_STEP 100    /*increment des translations suivant Cz*/

static double x;

#define round(a) (x=(a),(fabs(x - ceil(x))) < (fabs(x - floor(x))) ? \
(ceil(x)) : (floor(x)))

/*******************************************************************************************************/
int coplanar(double** imagePts, double xo, double yo) /*donnee des points objets, focale et amplitude du bruit*/
{
long int NumberOfPoints,i;
    double **object, f=448;/*f: longueur focale, en pixels*/
//double **imagePts;
double **coplMatrix;
double Rot1[3][3],Trans1[3],Rot2[3][3],Trans2[3];
    double *nbsol;
    double a;
      /*ampl_noise: amplitude pour le generateur aleatoire uniforme de bruit:*/
                             /*0.0->bruit de quantification seul*/
                             /*1.0->+ ou - 1 pixel en plus => ecart jusqu'a 1.5 pixel*/
                              /*2.0->+ ou - 2 pixel en plus => ecart jusqu'a 2.5 pixel*/
    

NumberOfPoints=36;           /*nombre de points utilises: a changer si != 10*/

/* allocation */
object=(double **)malloc(NumberOfPoints * sizeof(double *));
for (i=0;i<NumberOfPoints;i++) object[i]=(double *)malloc(3 * sizeof(double));
    
/*imagePts=(double **)malloc(NumberOfPoints * sizeof(double *));
for (i=0;i<NumberOfPoints;i++)imagePts[i]=(double *)malloc(2 * sizeof(double));*/
    
coplMatrix=(double **)malloc(3 * sizeof(double *));
for (i=0;i<3;i++) coplMatrix[i]=(double *)malloc(NumberOfPoints * sizeof(double));

    
    //    Modelo marcador
    a = 10;
    
    // Marcador 1
    
    object[0][0]=0.0*a;
    object[0][1]=0.0*a;
    object[0][2]=0.0*a;
    
    object[1][0]=0.0*a;   
    object[1][1]=9.5*a;
    object[1][2]=0.0*a;
    
    object[2][0]=9.5*a;
    object[2][1]=9.5*a;
    object[2][2]=0.0*a;
    
    object[3][0]=9.5*a; 
    object[3][1]=0.0*a;   
    object[3][2]=0.0*a;
    
    object[4][0]=1.5*a;
    object[4][1]=1.5*a;
    object[4][2]=0.0*a;
    
    object[5][0]=1.5*a;
    object[5][1]=8.0*a;
    object[5][2]=0.0*a;
    
    object[6][0]=8.0*a;
    object[6][1]=8.0*a;
    object[6][2]=0.0*a;
    
    object[7][0]=8.0*a;
    object[7][1]=1.5*a;
    object[7][2]=0.0*a;
    
    object[8][0]=3.0*a;
    object[8][1]=3.0*a;
    object[8][2]=0.0*a;
    
    object[9][0]=3.0*a;   
    object[9][1]=6.5*a;
    object[9][2]=0.0*a;
    
    object[10][0]=6.5*a;
    object[10][1]=6.5*a;
    object[10][2]=0.0*a;
    
    object[11][0]=6.5*a; 
    object[11][1]=0.0*a;  
    object[11][2]=0.0*a;
    
    // Marcador 2
    
    object[12][0]=10.5*a;
    object[12][1]=0.0*a;
    object[12][2]=0.0*a;
    
    object[13][0]=10.5*a;
    object[13][1]=9.5*a;
    object[13][2]=0.0*a;
    
    object[14][0]=20.0*a;
    object[14][1]=9.5*a;
    object[14][2]=0.0*a;
    
    object[15][0]=20.0*a;
    object[15][1]=0.0*a;
    object[15][2]=0.0*a;
    
    object[16][0]=12.0*a;
    object[16][1]=1.5*a;
    object[16][2]=0.0*a;
    
    object[17][0]=12.0*a;   
    object[17][1]=8.0*a;
    object[17][2]=0.0*a;
    
    object[18][0]=18.5*a;
    object[18][1]=8.0*a;
    object[18][2]=0.0*a;
    
    object[19][0]=18.5*a; 
    object[19][1]=1.5*a;   
    object[19][2]=0.0*a;
    
    object[20][0]=13.5*a;
    object[20][1]=3.0*a;
    object[20][2]=0.0*a;
    
    object[21][0]=13.5*a;
    object[21][1]=6.5*a;
    object[21][2]=0.0*a;
    
    object[22][0]=17.0*a;
    object[22][1]=6.5*a;
    object[22][2]=0.0*a;
    
    object[23][0]=17.0*a;
    object[23][1]=3.0*a;
    object[23][2]=0.0*a;
    
    // Marcador3
    
    object[24][0]=0.0*a;
    object[24][1]=19.0*a;
    object[24][2]=0.0*a;
    
    object[25][0]=0.0*a;   
    object[25][1]=28.5*a;
    object[25][2]=0.0*a;
    
    object[26][0]=9.5*a;
    object[26][1]=28.5*a;
    object[26][2]=0.0*a;
    
    object[27][0]=9.5*a;
    object[27][1]=19.0*a;   
    object[27][2]=0.0*a;
    
    object[28][0]=1.5*a;
    object[28][1]=20.5*a;
    object[28][2]=0.0*a;
    
    object[29][0]=1.5*a;
    object[29][1]=27.0*a;
    object[29][2]=0.0*a;
    
    object[30][0]=8.0*a;
    object[30][1]=27.0*a;
    object[30][2]=0.0*a;
    
    object[31][0]=8.0*a;
    object[31][1]=20.5*a;
    object[31][2]=0.0*a;
    
    object[32][0]=3.0*a;
    object[32][1]=22.0*a;
    object[32][2]=0.0*a;
    
    object[33][0]=3.0*a;
    object[33][1]=25.5*a;
    object[33][2]=0.0*a;
    
    object[34][0]=6.5*a;
    object[34][1]=25.5*a;
    object[34][2]=0.0*a;
    
    object[35][0]=6.5*a;
    object[35][1]=22.0*a;
    object[35][2]=0.0*a;
   
    
    // Puntos en la imagen****************************************************
/*    LOS PUNTOS DE LA IMAGEN SE SACAN DE LA FUNCION GETMARKERS
    xo=242.8;
    yo=212.9;*/

    
    // Marcador 1
/**********************************************************************************************
    imagePts[0][0] = 80.1995-xo;
    imagePts[0][1] = 37.3752-yo;
    
    imagePts[1][0] = 202.1010-xo;
    imagePts[1][1] = 36.1562-yo;
    
    imagePts[2][0] = 201.4915-xo;
    imagePts[2][1] = 164.1528-yo;
    
    imagePts[3][0] = 83.2470-xo;
    imagePts[3][1] = 159.2767-yo;
    
    imagePts[4][0] = 100.9228-xo;
    imagePts[4][1] = 57.4890-yo;
    
    imagePts[5][0] = 181.9873-xo;
    imagePts[5][1] = 57.4890-yo;
    
    imagePts[6][0] = 183.2063-xo;  
    imagePts[6][1] = 145.2581-yo;
    
    imagePts[7][0] = 100.9228-xo;  
    imagePts[7][1] = 142.8200-yo;
    
    imagePts[8][0] = 120.4270-xo;   
    imagePts[8][1] = 77.6027-yo;
    
    imagePts[9][0] = 162.4830-xo;   
    imagePts[9][1]  = 76.9932-yo;
    
    imagePts[10][0] = 164.3115-xo;  
    imagePts[10][1] = 123.9253-yo;
    
    imagePts[11][0] = 119.8175-xo;  
    imagePts[11][1] = 122.7063-yo;
    
    
    // Marcador 2    

    
    imagePts[12][0] = 83.3599-xo;  
    imagePts[12][1] = 173.4784-yo;
    
    imagePts[13][0] = 200.7491-xo;  
    imagePts[13][1] = 176.5839-yo;
    
    imagePts[14][0] = 199.5069-xo;  
    imagePts[14][1] = 297.6998-yo;
    
    imagePts[15][0] = 84.6021-xo;  
    imagePts[15][1] = 291.4888-yo;
    
    imagePts[16][0] = 102.6142-xo;  
    imagePts[16][1] = 193.3538-yo;
    
    imagePts[17][0] = 182.1159-xo;  
    imagePts[17][1] = 195.8382-yo;
    
    imagePts[18][0] = 180.8737-xo;  
    imagePts[18][1] = 278.4455-yo;
    
    imagePts[19][0] = 102.6142-xo;  
    imagePts[19][1] = 273.4766-yo;
    
    imagePts[20][0] = 120.6263-xo;  
    imagePts[20][1] = 213.2292-yo;
    
    imagePts[21][0] = 162.8616-xo;  
    imagePts[21][1] = 214.4715-yo;
    
    imagePts[22][0] = 162.2405-xo;  
    imagePts[22][1] = 258.5701-yo;
    
    imagePts[23][0] = 120.0052-xo;  
    imagePts[23][1] = 256.7067-yo;
    
    // Marcador 3
    
    imagePts[24][0] = 330.5606-xo; 
    imagePts[24][1] = 34.9715-yo;
    
    imagePts[25][0] = 469.0675-xo;   
    imagePts[25][1] = 34.9715-yo;
    
    imagePts[26][0] = 461.6142-xo;  
    imagePts[26][1] = 170.9939-yo;
    
    imagePts[27][0] = 326.2128-xo;  
    imagePts[27][1] = 167.8884-yo;
    
    imagePts[28][0] = 351.6782-xo;   
    imagePts[28][1] = 57.3313-yo;
    
    imagePts[29][0] = 444.2232-xo;   
    imagePts[29][1] = 57.3313-yo;
    
    imagePts[30][0] = 439.8754-xo;  
    imagePts[30][1] = 149.2552-yo;
    
    imagePts[31][0] = 347.9516-xo;  
    imagePts[31][1] = 147.3919-yo;
    
    imagePts[32][0] = 372.1747-xo;   
    imagePts[32][1] = 78.4490-yo;
    
    imagePts[33][0] = 423.1055-xo;   
    imagePts[33][1] = 78.4490-yo;
    
    imagePts[34][0] = 420.0000-xo;  
    imagePts[34][1] = 128.1375-yo;
    
    imagePts[35][0] = 370.3114-xo;  
    imagePts[35][1] = 126.8953-yo;
    
    ***************************************************************************************************/



    
    /* Esos puntos son el modelo para el damero
    
    object[0][0]=0.0;
    object[0][1]=0.0;
    object[0][2]=0.0;
    
    object[1][0]=88.0;
    object[1][1]=0.0;
    object[1][2]=0.0;
    
    object[2][0]=0.0;
    object[2][1]=88.0;
    object[2][2]=0.0;
    
    object[3][0]=88.0;
    object[3][1]=88.0;
    object[3][2]=0.0;

    object[4][0]=176.0;
    object[4][1]=0.0;
    object[4][2]=0.0;

    object[5][0]=0.0;
    object[5][1]=176.0;
    object[5][2]=0.0;

    object[6][0]=176.0;
    object[6][1]=176.0;
    object[6][2]=0.0;

    object[7][0]=132.0;
    object[7][1]=132.0;
    object[3][2]=0.0;

    */
    
    /* Estos puntos son los ginput de la imagen Calibrar1.jpg a [480x320]
     
    imagePts[0][0]=213.786956521739-232.21387;
    imagePts[0][1]=67.5608695652174-149.33345;
    
    imagePts[1][0]=268.882608695652-232.21387;
    imagePts[1][1]=79.2478260869565-149.33345;
    
    imagePts[2][0]=204.882608695652-232.21387;
    imagePts[2][1]=119.873913043478-149.33345;
    
    imagePts[3][0]=260.534782608696-232.21387;
    imagePts[3][1]=128.778260869565-149.33345;
    
    imagePts[4][0]=321.195652173913-232.21387;
    imagePts[4][1]=88.1521739130435-149.33345;
    
    imagePts[5][0]=193.752173913044-232.21387;
    imagePts[5][1]=168.291304347826-149.33345;

    imagePts[6][0]=305.613043478261-232.21387;
    imagePts[6][1]=186.100000000000-149.33345;

    imagePts[7][0]=282.795652173913-232.21387;
    imagePts[7][1]=158.273913043478-149.33345;
*/
    Trans1[0] = -123.3477;
    Trans1[1] =  -136.5015;
    Trans1[2] =  350.6666;

    Rot1[0][0] = -0.0217;       
    Rot1[0][1] = 0.9868;
    Rot1[0][2] = -0.1607;
    
    Rot1[1][0] = 0.9915;    
    Rot1[1][1] = 0.0419;
    Rot1[1][2] = 0.1235;
    
    Rot1[2][0] = 0.1286;     
    Rot1[2][1] = -0.1566;
    Rot1[2][2] = -0.9793;

Composit(NumberOfPoints,imagePts,object,f,Rot1,Trans1);    

    printf("\nRotacion: \n");
    printf("%f\t %f\t %f\n",Rot1[0][0],Rot1[0][1],Rot1[0][2]);
    printf("%f\t %f\t %f\n",Rot1[1][0],Rot1[1][1],Rot1[1][2]);
    printf("%f\t %f\t %f\n",Rot1[2][0],Rot1[2][1],Rot1[2][2]);
    printf("Traslacion: \n");
    printf("%f\t %f\t %f\n",Trans1[0],Trans1[1],Trans1[2]);

}



















