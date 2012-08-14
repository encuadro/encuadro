/* -*- C++ -*- ------------------------------------------------------------
 @@COPYRIGHT@@
 *-----------------------------------------------------------------------*/
/** @file
 *  @brief A set of very simple examples of current CML functionality.
 */

#include "cml_config.h"         // Must be first (for now)!

#include <iostream>
#include <iomanip>
#include <cmath>
#include <cml/cml.h>
using namespace cml;

using std::cout;
using std::endl;
using std::sqrt;


void euler()
{


    /* 3-space matrix, fixed length, double coordinates: */
    typedef cml::matrix<double, fixed<3,3>, col_basis> matrix_d3;
    typedef constants<double> constants_t;


    matrix_d3 R_right, R_left, Aux3, Exp;
    double tita, phi, psi;
    double angle_0;
    double angle_1;
    double angle_2;

    phi=40*constants_t::pi()/180; //ROLL       // phi esta asociado a la rotacion en el eje X
    tita=30*constants_t::pi()/180;  //PITCH  	// tita esta asociado a la rotacion en el eje Y
    psi=160*constants_t::pi()/180;  //YAW		// psi esta asociado a la rotacion en el eje Z


    // El algoritmo de DeMenthon arroja una matriz que aparentemente usa la convencion R_right, que a su vez hay que hacerle la traspuesta



    /*Matriz R_right generica
     *
     */
    R_right(0,0) = cos(tita)*cos(psi);   R_right(0,1) = cos(phi)*sin(psi)+sin(phi)*sin(tita)*cos(psi);  R_right(0,2) = sin(phi)*sin(psi)-cos(phi)*sin(tita)*cos(psi) ;
    R_right(1,0) = -cos(tita)*sin(psi);  R_right(1,1)= cos(phi)*cos(psi)-sin(phi)*sin(tita)*sin(psi);   R_right(1,2) = sin(phi)*cos(psi)+cos(phi)*sin(tita)*sin(psi);
    R_right(2,0) = sin(tita);   		 R_right(2,1) = -sin(phi)*cos(tita);  							R_right(2,2) = cos(phi)*cos(tita);


    /*Matriz R_left generica
         *
         */
        R_left(0,0) = cos(tita)*cos(psi);   R_left(0,1) = -cos(phi)*sin(psi)+sin(phi)*sin(tita)*cos(psi);  R_left(0,2) = sin(phi)*sin(psi)+cos(phi)*sin(tita)*cos(psi) ;
        R_left(1,0) = cos(tita)*sin(psi);   R_left(1,1) = cos(phi)*cos(psi)+sin(phi)*sin(tita)*sin(psi);   R_left(1,2) = -sin(phi)*cos(psi)+cos(phi)*sin(tita)*sin(psi);
        R_left(2,0) = -sin(tita);   		R_left(2,1) = sin(phi)*cos(tita);  							   R_left(2,2) = cos(phi)*cos(tita);

        matrix_d3 Aux(
        		-0.0217,    0.9868,   -0.1607,

        		 0.9915,    0.0419,    0.1235,

        		  0.1286,   -0.1566,   -0.9793
                    );

        matrix_d3 Aux2(0.0185,    0.9996,   -0.0206,

        			 0.5166,   -0.0272,   -0.8558,

        			-0.8560,    0.0052,   -0.5169
        			);

        matrix_d3 R1    (  -0.160046, 	 0.956322, 	  0.244607,
                            0.985031, 	 0.170802, 	 -0.023265,
                           -0.064029, 	 0.237222, 	 -0.969343);

        matrix_d3 R2 (     -0.125177, 	 0.787658, 	 -0.603263,
                            0.991990, 	 0.109721, 	 -0.062579,
                            0.016900, 	-0.606265, 	 -0.795083);

        matrix_d3 R3(      -0.023269, 	 0.984843, 	 -0.171880,
                            0.999245, 	 0.028261,    0.026655,
                            0.031108, 	-0.171130, 	 -0.984757);

        matrix_d3 R4(      -0.011861, 	 0.873388, 	 -0.486880,
                            0.959993, 	 0.146182, 	  0.238841,
                            0.279774, 	-0.464569, 	 -0.840180);

        matrix_d3 R5(       0.040281, 	 0.936710,    0.347781,
                            0.998778, 	-0.027769, 	 -0.040888,
                           -0.028643, 	 0.349003, 	 -0.936684);


        matrix_d3 R6(      -0.119223, 	 0.975187, 	 -0.186539,
                            0.991584, 	 0.126499, 	  0.027560,
                            0.050473, 	-0.181683, 	 -0.982061);


        matrix_d3 R7(      -0.044813, 	 0.908300, 	  0.415911,
                            0.998269, 	 0.024837, 	  0.053319,
                            0.038100, 	 0.417581, 	 -0.907841);


        matrix_d3 R8(      -0.085147, 	 0.878595, 	 -0.469916,
                            0.996349, 	 0.078032, 	 -0.034640,
                            0.006234, 	-0.471150, 	 -0.882031);


        matrix_d3 R9(       0.035595, 	 0.974160, 	  0.223038,
                            0.997706, 	-0.021780, 	 -0.064097,
                           -0.057583, 	 0.224807, 	 -0.972700);

        matrix_d3 R10(  	0.089302, 	 0.991415, 	  0.095503,
                            0.995946,   -0.089926, 	  0.002247,
                            0.010815, 	 0.094915, 	 -0.995427);


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


    phi=phi*180/constants_t::pi();
    tita=tita*180/constants_t::pi();
    psi=psi*180/constants_t::pi();

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

    cout << std::endl << "BLOQUE Matrix to Euler:" << endl;
    cout << std::endl << "Angulos ingresados:" << endl;
    cout << "  phi = " << phi << endl;
    cout << "  tita = " << tita << endl;
    cout << "  psi = " << psi << endl;
    cout << std::endl << "Matriz generada:" << endl;
    cout << "  R_left = " << R_left << endl;
    cout << endl;
    cout << "  R_right = " << R_right << endl;
    cout << endl;
    cout << "  R_left_traspuesta = " << transpose(R_left) << endl;
    cout << std::endl << "Angulos calculados con R_right transpuesta:" << endl;
    cout << "  phi_calc = " << angle_2 << endl;
    cout << "  tita_calc = " << angle_1 << endl;
    cout << "  psi_calc = " << angle_0 << endl;




}


int main()
{

    euler();
    return 0;
}

// -------------------------------------------------------------------------
// vim:ft=cpp

