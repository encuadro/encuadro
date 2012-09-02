#include "svd.h"

/*******************************************************************************************************/
/*A part PseudoInverse(), toutes les fonctions sont tirees de l'ouvrage "Numerical Recipes"*/
/*de W.H. Press, B.P. Flannery, S.A. Teukolsky, et W.T. Vetterling, Cambridge University Press*/

static double at,bt,ct;
static double maxarg1,maxarg2;

#define PYTHAG(a,b) ((at=fabs(a)) > (bt=fabs(b)) ? \
(ct=bt/at,at*sqrt(1.0+ct*ct)) : (bt ? (ct=at/bt,bt*sqrt(1.0+ct*ct)): 0.0))

#define MAX(a,b) (maxarg1=(a),maxarg2=(b),(maxarg1) > (maxarg2) ?\
	(maxarg1) : (maxarg2))

#define SIGN(a,b) ((b) >= 0.0 ? fabs(a) : -fabs(a))

/*******************************************************************************************************/
void nrerror(error_text) /*edite un message d'erreur et rend la main au systeme*/
char error_text[];
{
void exit();
printf("%s\n",error_text);
printf("...now exiting to system...\n");
exit(1);
}

/*******************************************************************************************************/
double *vector(nl,nh) /*allocation de memoire*/
long int nl,nh;
{
double *v;
v=(double *)malloc((unsigned) (nh-nl+1)*sizeof(double));
if (!v) nrerror("allocation failure in vector()");
return v-nl;
}

/*******************************************************************************************************/
void free_vector(v,nl) /*desallocation de memoire*/
double *v;
long int nl;
{
free((char*) (v+nl));
}

/*******************************************************************************************************/
void svdcmp(double **a,int m,int n,double *w,double **v) /*Etant donnee une matrice a de dimension m x n, cette routine calcule sa*/
                       /*decomposition en valeurs singulieres, a=U.W.(V)t. La matrice U remplace*/
                       /*a en sortie. La matrice diagonale des valeurs singulieres, W, est fournie*/
                       /*sous forme de vecteur w. La matrice V (dont on utilise la transposee) est*/
                       /*egale a v. m doit etre superieur ou egal a n. Si ce n'est pas le cas, rendre*/
                       /*a carree par adjonction de lignes nulles*/

{
long int flag,i,its,j,jj,k,l,nm;
double c,f,h,s,x,y,z;
double anorm=0.0,g=0.0,scale=0.0;
double *rv1,*vector();
void nrerror(),free_vector();

  if (m < n) nrerror("SVDCMP: You must augment A with extra zero rows");
  rv1=vector(1,n);
  for (i=1;i<=n;i++) {
    l=i+1;
    rv1[i]=scale*g;
    g=s=scale=0.0;
    if (i <= m) {
      for (k=i;k<=m;k++) scale += fabs(a[k-1][i-1]);
      if (scale) {
	for (k=i;k<=m;k++) {
	  a[k-1][i-1] /= scale;
	  s += a[k-1][i-1]*a[k-1][i-1];
	}
	f=a[i-1][i-1];
	g = -SIGN(sqrt(s),f);
	h=f*g-s;
	a[i-1][i-1]=f-g;
	if (i != n) {
	  for (j=l;j<=n;j++) {
	    for (s=0.0,k=i;k<=m;k++) s += a[k-1][i-1]*a[k-1][j-1];
	    f=s/h;
	    for (k=i;k<=m;k++) a[k-1][j-1] += f*a[k-1][i-1];
	  }
	}
	for (k=i;k<=m;k++) a[k-1][i-1] *= scale;
      }
    }
    w[i-1]=scale*g;
    g=s=scale=0.0;
    if (i <= m && i != n) {
      for (k=l;k<=n;k++) scale += fabs(a[i-1][k-1]);
      if (scale) {
	for (k=l;k<=n;k++) {
	  a[i-1][k-1] /= scale;
	  s += a[i-1][k-1]*a[i-1][k-1];
	}
	f=a[i-1][l-1];
	g = -SIGN(sqrt(s),f);
	h=f*g-s;
	a[i-1][l-1]=f-g;
	for (k=l;k<=n;k++) rv1[k]=a[i-1][k-1]/h;
	if (i != m) {
	  for (j=l;j<=m;j++) {
	    for (s=0.0,k=l;k<=n;k++) s += a[j-1][k-1]*a[i-1][k-1];
	    for (k=l;k<=n;k++) a[j-1][k-1] += s*rv1[k];
	  }
	}
	for (k=l;k<=n;k++) a[i-1][k-1] *= scale;
      }
    }
    anorm=MAX(anorm,(fabs(w[i-1])+fabs(rv1[i])));
  }
  for (i=n;i>=1;i--) {
    if (i < n) {
      if (g) {
	for (j=l;j<=n;j++)
	  v[j-1][i-1]=(a[i-1][j-1]/a[i-1][l-1])/g;
	for (j=l;j<=n;j++) {
	  for (s=0.0,k=l;k<=n;k++) s += a[i-1][k-1]*v[k-1][j-1];
	  for (k=l;k<=n;k++) v[k-1][j-1] += s*v[k-1][i-1];
	}
      }
      for (j=l;j<=n;j++) v[i-1][j-1]=v[j-1][i-1]=0.0;
    }
    v[i-1][i-1]=1.0;
    g=rv1[i];
    l=i;
  }
  for (i=n;i>=1;i--) {
    l=i+1;
    g=w[i-1];
    if (i < n)
      for (j=l;j<=n;j++) a[i-1][j-1]=0.0;
    if (g) {
      g=1.0/g;
      if (i != n) {
	for (j=l;j<=n;j++) {
	  for (s=0.0,k=l;k<=m;k++) s += a[k-1][i-1]*a[k-1][j-1];
	  f=(s/a[i-1][i-1])*g;
	  for (k=i;k<=m;k++) a[k-1][j-1] += f*a[k-1][i-1];
	}
      }
      for (j=i;j<=m;j++) a[j-1][i-1] *= g;
    }
    else {
    for (j=i;j<=m;j++) a[j-1][i-1]=0.0;
    }
    ++a[i-1][i-1];
  }
  for (k=n;k>=1;k--) {
    for (its=1;its<=30;its++) {
      flag=1;
      for (l=k;l>=1;l--) {
	nm=l-1;
	if (fabs(rv1[l])+anorm == anorm) {
	  flag=0;
	  break;
	}
	if (fabs(w[nm])+anorm == anorm) break;
      }
      if (flag) {
	c=0.0;
	s=1.0;
	for (i=l;i<=k;i++) {
	  f=s*rv1[i];
	  if (fabs(f)+anorm != anorm) {
	    g=w[i-1];
	    h=PYTHAG(f,g);
	    w[i-1]=h;
	    h=1.0/h;
	    c=g*h;
	    s=(-f*h);
	    for (j=1;j<=m;j++) {
	      y=a[j-1][nm-1];
	      z=a[j-1][i-1];
	      a[j-1][nm-1]=y*c+z*s;
	      a[j-1][i-1]=z*c-y*s;
	    }
	  }
	}
      }
      z=w[k-1];
      if (l == k) {
	if (z < 0.0) {
	  w[k-1] = -z;
	  for (j=1;j<=n;j++) v[j-1][k-1]=(-v[j-1][k-1]);
	}
	break;
      }
      if (its == 50) nrerror("No convergence in 50 SVDCMP iterations");
      x=w[l-1];
      nm=k-1;
      y=w[nm-1];
      g=rv1[nm];
      h=rv1[k];
      f=((y-z)*(y+z)+(g-h)*(g+h))/(2.0*h*y);
      g=PYTHAG(f,1.0);
      f=((x-z)*(x+z)+h*((y/(f+SIGN(g,f)))-h))/x;
      c=s=1.0;
      for (j=l;j<=nm;j++) {
	i=j+1;
	g=rv1[i];
	y=w[i-1];
	h=s*g;
	g=c*g;
	z=PYTHAG(f,h);
	rv1[j]=z;
	c=f/z;
	s=h/z;
	f=x*c+g*s;
	g=g*c-x*s;
	h=y*s;
	y=y*c;
	for (jj=1;jj<=n;jj++) {
	  x=v[jj-1][j-1];
	  z=v[jj-1][i-1];
	  v[jj-1][j-1]=x*c+z*s;
	  v[jj-1][i-1]=z*c-x*s;
	}
	z=PYTHAG(f,h);
	w[j-1]=z;
	if (z) {
	  z=1.0/z;
	  c=f*z;
	  s=h*z;
	}
	f=(c*g)+(s*y);
	x=(c*y)-(s*g);
	for (jj=1;jj<=m;jj++) {
	  y=a[jj-1][j-1];
	  z=a[jj-1][i-1];
	  a[jj-1][j-1]=y*c+z*s;
	  a[jj-1][i-1]=z*c-y*s;
	}
      }
      rv1[l]=0.0;
      rv1[k]=f;
      w[k-1]=x;
    }
  }
  free_vector(rv1,1);
}


/*******************************************************************************************************/
void  PseudoInverse(double** A,long int N,double** B) /*retourne en B la pseudoinverse de A qui est de dimension N x 3*/
                           /*C'est par definition la matrice v.[diag(1/wi)].(u)t (cf. svdcmp())*/



{
  void svdcmp();
  double **V,*W,temp[3][3];
  double WMAX;
  double TOL = 0.01;
  long int i,j,k,cn;

  /*allocations*/
  V=(double **)malloc(3*sizeof(double *));
  W=(double *)malloc(3*sizeof(double));		//Afshin: I corrected this line. It was sizeof(double *) by mistake
//  W=(double *)malloc(3*sizeof(double *));	//Afshin: This was the original line
  for (i=0;i<3;i++) V[i]=(double *)malloc(3*sizeof(double));

  /*decomposition en valeurs singulieres*/
  svdcmp(A,N,3,W,V);

  /*recherche de la plus grande valeur singuliere*/
  WMAX=0.0;
  for (i=0;i<3;i++)
    {
      if (W[i]>WMAX) WMAX=W[i];
    }

  /*annulation des valeurs singuliere inferieure a TOL fois la plus grande*/
  for (i=0;i<3;i++)
    {
      if (W[i]<TOL*WMAX) W[i]=0;
    }

/*elimination des colonnes de v et a correspondant aux valeurs singulieres nulles*/
  cn=0;
  for (j=0;j<3;j++)
    {
      if (W[j]==0)
	{
	  cn++;	     
	  for (k=j;k<2;k++) 
	    {
	      for (i=0;i<N;i++) A[i][k]=A[i][k+1];
	      for (i=0;i<3;i++) V[i][k]=V[i][k+1];
	    }
	}
    }

/*elimination des valeurs singulieres nulles*/
  for (j=0;j<2;j++)
    {
      if (W[j]==0) W[j]=W[j+1];
    }

/*calcul de B*/     
  for (i=0;i<3;i++)
    {
      for (j=0;j<3-cn;j++)
	{
	  temp[i][j]=V[i][j]/W[j];
	}
    }
  for (i=0;i<3;i++)
    {
      for (j=0;j<N;j++)
	{
	  B[i][j]=0.0;
	  for (k=0;k<3-cn;k++) B[i][j]+=temp[i][k]*A[j][k];
	}
    }

/*desallocations*/
free(W); 
for (i=0;i<3;i++) free(V[i]);

}
/*******************************************************************************************************/
void  PseudoInverseGen(double** A,int N,int M,double** B) /*retourne en B la pseudoinverse de A qui est de dimension N x M*/
/*C'est par definition la matrice v.[diag(1/wi)].(u)t (cf. svdcmp())*/



{
    void svdcmp();
    double **U;
    double **V,*W,temp[M][M];
    double WMAX;
    double TOL = 0.01;
    long int i,j,k,cn;
    
    /*allocations*/
    U=(double **)malloc(N*sizeof(double *));
    V=(double **)malloc(M*sizeof(double *));
    W=(double *)malloc(M*sizeof(double));		//Afshin: I corrected this line. It was sizeof(double *) by mistake
    //  W=(double *)malloc(M*sizeof(double *));	//Afshin: This was the original line
    for (i=0;i<M;i++) V[i]=(double *)malloc(M*sizeof(double));
    for (i=0;i<N;i++) U[i]=(double *)malloc(M*sizeof(double));
    
    for (i=0;i<N;i++){
        for (j=0;j<M;j++) {
            U[i][j]=A[i][j];
        }
    }
    /*decomposition en valeurs singulieres*/
    svdcmp(U,N,M,W,V);
    
//    printf("U:\n");
//    for (i=0;i<N; i++) {
//        for(j=0;j<M;j++){
//            printf("%f\t",U[i][j]);
//        }
//        printf("\n");
//    }
//    
//    printf("V:\n");
//    for (i=0;i<M; i++) {
//        for(j=0;j<M;j++){
//            printf("%f\t",V[i][j]);
//        }
//        printf("\n");
//    }
//
//    
//    printf("W:\n");
//        for(j=0;j<M;j++){
//            printf("%f\t",W[j]);
//        }
//        printf("\n");

    
    /*seek greater singular value*/
    WMAX=0.0;
    for (i=0;i<M;i++)
    {
        if (W[i]>WMAX) WMAX=W[i];
    }
    
//    /*annulation des valeurs singuliere inferieure a TOL fois la plus grande*/
//    for (i=0;i<M;i++)
//    {
//        if (W[i]<TOL*WMAX) W[i]=0;
//    }
    
    /*elimination des colonnes de v et a correspondant aux valeurs singulieres nulles*/
    cn=0;
    for (j=0;j<M;j++)
    {
        if (W[j]==0)
        {
            cn++;	     
            for (k=j;k<2;k++) 
            {
                for (i=0;i<N;i++) U[i][k]=U[i][k+1];
                for (i=0;i<M;i++) V[i][k]=V[i][k+1];
            }
        }
    }
    
    /*elimination des valeurs singulieres nulles*/
    for (j=0;j<2;j++)
    {
        if (W[j]==0) W[j]=W[j+1];
    }
    
    /*calcul de B*/     
    for (i=0;i<M;i++)
    {
        for (j=0;j<M-cn;j++)
        {
            temp[i][j]=V[i][j]/W[j];
        }
    }
    for (i=0;i<M;i++)
    {
        for (j=0;j<N;j++)
        {
            B[i][j]=0.0;
            for (k=0;k<M-cn;k++) B[i][j]+=temp[i][k]*U[j][k];
        }
    }
    
    /*desallocations*/
    free(W); 
    free(U);
    for (i=0;i<M;i++) free(V[i]);
    
}



