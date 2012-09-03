#include "Composit.h"
#include "PositCopl.h"
#include "svd.h"
#include "Error.h"


/*********************************************************************************************************/
void Composit(long int np, double** coplImage,double** copl,double fLength,double R[3][3],double T[3]){
/*Retourne le nombre de poses DIFFERENTES acceptables (cf plus bas pour cette notion) en nsol, ainsi que*/ 
/*la meilleure pose (rota1, transa1), i.e. la plus proche en rotation (transmission de rota) lorsque 2*/
/*sont acceptables, ou celle donnant la plus faible erreur E s'il n'y en a pas 2 acceptables.*/
//
//long int   np;
//double **coplImage,**copl;
//double R[3][3],T[3];
//double fLength;


long int i,j,Ep1,Ep2,fr;
double   E1,E2,Ehvmax1,Ehvmax2;
double   **coplVectors,**coplMatrix;
double   POSITRot1[3][3],POSITTrans1[3],POSITRot2[3][3],POSITTrans2[3];


/*allocations*/
coplVectors=(double **)malloc(np * sizeof(double *));
coplMatrix=(double **)malloc(3 * sizeof(double *));
for (i=0;i<np;i++) coplVectors[i]=(double *)malloc(3 * sizeof(double));
for (i=0;i<3;i++) coplMatrix[i]=(double *)malloc(np * sizeof(double));

for (i=0;i<np;i++)
  {
    coplVectors[i][0]=copl[i][0]-copl[0][0];
    coplVectors[i][1]=copl[i][1]-copl[0][1];
    coplVectors[i][2]=copl[i][2]-copl[0][2];
  }

PseudoInverse(coplVectors,np,coplMatrix); /*coplMatrix est la pseudoinverse de coplVectors*/

//for (i=0;i<3;i++)
//{
// printf("\n");
//  for (j=0;j<np;j++) printf("%e ",coplMatrix[i][j]);
//}

PositCopl(np,coplImage,copl,coplMatrix,fLength,
          POSITRot1,POSITTrans1,POSITRot2,POSITTrans2);
/*retourne les DEUX poses resultant de la convergence des deux branches de POSIT, sans les juger*/

/*calcul des translations d'origine a origine  (l'origine du rep. objet n'est pas forcement*/
/*confondue avec Mo)*/
for (i=0;i<3;i++)
  {
    for (j=0;j<3;j++)
	{
	  POSITTrans1[i]-=POSITRot1[i][j]*copl[0][j];
	  POSITTrans2[i]-=POSITRot2[i][j]*copl[0][j];
	}
  }


/*ATTENTION: Positcopl() met un "2" en premiere position des matrices de rotation si la pose est*/
/*impossible (points derriere le plan image, par exemple)*/
if ((POSITRot1[0][0]!=2)&&(POSITRot2[0][0]!=2))
  {
    Error(np,coplImage,copl,fLength,POSITRot1,POSITTrans1,&E1,&Ep1,&Ehvmax1);
    Error(np,coplImage,copl,fLength,POSITRot2,POSITTrans2,&E2,&Ep2,&Ehvmax2);
    /*Error retourne differentes mesures d'erreurs fondees sur les ecarts*/
    /*Image TPP reconstruite/Image de depart:*/
    /*E est la distance euclidienne moyenne entre points images reconstruits et points images originaux*/
    /*Ep est la somme des ecarts horizontaux et verticaux en pixels*/
    /*Ehvmax est l'ecart horizontal ou vertical maximum rencontre (valeurs non arrondies en pixels)*/
    /*printf("\nErhvmax1=%f Erhvmax2=%f\n",Ehvmax1,Ehvmax2);*/



    /*cas de deux solutions "ACCEPTABLES", pour le niveau de bruit*/
    /*(i.e ((Ehvmax1<=noise+noise_quantif)&&(Ehvmax2<=noise+noise_quantif))),*/
    /*ou de deux solutions pas forcement "acceptables pour le niveau de bruit", mais donnant la meme*/
    /*erreur en pixels sur les images reconstruites (Ep1=Ep2, dans ce cas les deux sol sont tout aussi*/
    /*vraissemblables (equipotentielle), et il n'y a pas de raison de privilegier la "meilleure" au*/
    /*sens E). Parmi les deux poses, on retientalors celle qui est la plus proche en orientation de*/
    /*celle qui a servi a synthetiser l'image de depart. Si de plus ces deux poses sont distantes de*/
    /*plus de 5 degres en orientation, elle sont considerees comme differentes et nbsol=2*/


	if (E1<E2)
	  {
	    for (i=0;i<3;i++)
	      {
		T[i]=POSITTrans1[i];
		for (j=0;j<3;j++) R[i][j]=POSITRot1[i][j];
	      }
	  }
	else
	  {
	    for (i=0;i<3;i++)
	      {
		T[i]=POSITTrans2[i];
		for (j=0;j<3;j++) R[i][j]=POSITRot2[i][j];
	      }
	  }
      }
  


/*cas ou l'une des deux poses est impossible. L'autre est alors selectionnee*/
if ((POSITRot1[0][0]!=2)&&(POSITRot2[0][0]==2))
  {
    /*Error(np,coplImage,copl,fLength,POSITRot1,POSITTrans1,&E1,&Ep1,&Ehvmax1);*/
    /*Error(np,coplImage,copl,fLength,POSITRot2,POSITTrans2,&E2,&Ep2,&Ehvmax2);*/
    /*printf("\nErhvmax1=%f Erhvmax2=%f\n",Ehvmax1,Ehvmax2); */
    for (i=0;i<3;i++)
       {
	 T[i]=POSITTrans1[i];
	 for (j=0;j<3;j++) R[i][j]=POSITRot1[i][j];
       }
  }
if ((POSITRot1[0][0]==2)&&(POSITRot2[0][0]!=2))
  {
    /*Error(np,coplImage,copl,fLength,POSITRot1,POSITTrans1,&E1,&Ep1,&Ehvmax1);*/
    /*Error(np,coplImage,copl,fLength,POSITRot2,POSITTrans2,&E2,&Ep2,&Ehvmax2);*/
    /*printf("\nErhvmax1=%f Erhvmax2=%f\n",Ehvmax1,Ehvmax2);*/
    for (i=0;i<3;i++)
       {
	 T[i]=POSITTrans2[i];
	 for (j=0;j<3;j++) R[i][j]=POSITRot2[i][j];
       }
  }

/* if ((POSITRot1[0][0]==2)&&(POSITRot2[0][0]==2))...CAS A IMPLEMENTER (n'apparait jamais)*/

/*desallocations*/
for (fr=0;fr<np;fr++) free(coplVectors[fr]);
for (fr=0;fr<3;fr++) free(coplMatrix[fr]);

}







