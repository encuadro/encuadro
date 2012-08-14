/* -*- C++ -*- ------------------------------------------------------------
 @@COPYRIGHT@@
 *-----------------------------------------------------------------------*/
/** @file
 *  @brief A set of very simple examples of current CML functionality.
 */
#include "simple.h"

#include "cml_config.h"         // Must be first (for now)!

#include <iostream>
#include <iomanip>
#include <cmath>
#include <cml/cml.h>
using namespace cml;

using std::cout;
using std::endl;
using std::sqrt;


 
double* euler(double MatrizRotacion[3][3])
    {
        
        
        /* 3-space matrix, fixed length, double coordinates: */
        typedef cml::matrix<double, fixed<3,3>, col_basis> matrix_d3;
        typedef constants<double> constants_t;
        
        
        matrix_d3 R_right;
        double* sal;
        double angle_0;
        double angle_1;
        double angle_2;
        
        sal = (double *) malloc(3*sizeof(double));
        //    phi=40*constants_t::pi()/180; //ROLL       // phi esta asociado a la rotacion en el eje X
        //    tita=30*constants_t::pi()/180;  //PITCH  	// tita esta asociado a la rotacion en el eje Y
        //    psi=160*constants_t::pi()/180;  //YAW		// psi esta asociado a la rotacion en el eje Z
        
        
        // El algoritmo de DeMenthon arroja una matriz que aparentemente usa la convencion R_right, que a su vez hay que hacerle la traspuesta
        
        
        
        /*Matriz R_right generica
         *
         */
        R_right(0,0) = MatrizRotacion[0][0];    R_right(0,1) = MatrizRotacion[0][1];    R_right(0,2) = MatrizRotacion[0][2];
        R_right(1,0) = MatrizRotacion[1][0];    R_right(1,1)=  MatrizRotacion[1][1];    R_right(1,2) = MatrizRotacion[1][2];
        R_right(2,0) = MatrizRotacion[2][0];   	R_right(2,1) = MatrizRotacion[2][1];  	R_right(2,2) = MatrizRotacion[2][2];
        
        
        
        
        /*    void matrix_to_euler(
         const mat_type& m,
         scalar_type& angle_0,
         scalar_type& angle_1,
         scalar_type& angle_2,
         EulerOrder order,
         scalar_type tolerance = default_epsilon
         );
         */
        
        //left xyz funciona y deja en angle 0 a phi, angle 1 tita y a angle 2 psi (convecion yaw-pitch-roll-----z-y-x)
        //transpose_right zyx funciona y deja en angle 0 a psi, angle 1 tita y a angle 2 phi
        matrix_to_euler(
                        transpose(R_right),
                        angle_0,
                        angle_1,
                        angle_2,
                        cml::euler_order_zyx,
                        0.1
                        );
        
        
        //    phi=phi*180/constants_t::pi();
        //    tita=tita*180/constants_t::pi();
        //    psi=psi*180/constants_t::pi();
        
        angle_0=angle_0*180/constants_t::pi();
        angle_1=angle_1*180/constants_t::pi();
        angle_2=angle_2*180/constants_t::pi();
        
        if (angle_0<0) {
            angle_0=360+angle_0;
            
        }
        if (angle_1<0) {
            angle_1=360+angle_1;
            
        }
        if (angle_2<0) {
            angle_2=360+angle_2;
            
        }
        
        sal[0]= angle_2;
        sal[1]= angle_1;
        sal[2]= angle_0;
        
        cout << std::endl << "BLOQUE Matrix to Euler:" << endl;
        cout << std::endl << "Angulos calculados con R_right transpuesta:" << endl;
        cout << "  phi_calc = " << angle_2 << endl;
        cout << "  tita_calc = " << angle_1 << endl;
        cout << "  psi_calc = " << angle_0 << endl;       
        
        return sal;
        
}    
    



