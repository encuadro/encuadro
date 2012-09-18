//
//  HelloWorldView.m
//  renderiandoDinamico
//
//  Created by Pablo Flores Guridi on 18/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"

@interface HelloWorldView()
@property(nonatomic, readwrite) Isgl3dMatrix4 matriz;
@end

@implementation HelloWorldView

@synthesize matriz = _matriz;

double puntoProyectado3D1[3], puntoProyectado3D2[3], puntoProyectado3D3[3], b[3];
double punto3D1[3] = {0,0,-30}, punto3D2[3] = {190,0,-30}, punto3D3[3]={0,100,-30};
Isgl3dVector3 angles;

double rotacion[3][3];
double traslacion[3];
int numero = 0;

- (id) init {
	
	if ((self = [super init])) {
		// Create the primitive
        printf("punto A\n");
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"backround.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dCube * cubeMesh = [Isgl3dCube meshWithGeometry:60 height:60 depth:60 nx:40 ny:40];
		_cube1 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        _cube2 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        _cube3 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        
        self.camera.position = iv3(0, 0, 0.000000000000001);
        //self.camera.fov = 34.8225;
        self.camera.fov = 35.6;
        self.camera.width = 480;
        self.camera.height = 360;
        self.camera.aspect = 1/0.75;
        printf("%f \t %f \t %f\n",self.camera.aspect, self.camera.width, self.camera.height);
         
        
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {

	[super dealloc];
}


- (void) tick:(float)dt {
	// Rotate the text around the y axis

}

- (void) cambiarCubos: (int) numero
{
    switch (numero) {
            /*------------------------------------*/
        case 0:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;

            /*Terminamos la inicializacion*/
            
            
            traslacion[0] = 0;
            traslacion[1] = 0;
            traslacion[2] = 1000;
            
            rotacion[0][0] = 1;
            rotacion[0][1] = 0;
            rotacion[0][2] = 0;
            
            rotacion[1][0] = 0;
            rotacion[1][1] = 0.8660;
            rotacion[1][2] = -0.5000;
            
            rotacion[2][0] = 0;
            rotacion[2][1] = 0.5000;
            rotacion[2][2] = 0.8660;
            
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            printf("Punto 1\n");
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            
            
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            
            break;
            /*------------------------------------*/
        case 1:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;
            
            /*Terminamos la inicializacion*/

            
            traslacion[0] = 0;
            traslacion[1] = 0;
            traslacion[2] = 1000;
            
            rotacion[0][0] =  0.8660;
            rotacion[0][1] = 0;
            rotacion[0][2] = 0.5000;
            
            rotacion[1][0] = 0;
            rotacion[1][1] = 1;
            rotacion[1][2] = 0;
            
            rotacion[2][0] = -0.5000;
            rotacion[2][1] = 0;
            rotacion[2][2] = 0.8660;
            
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            printf("Punto 1\n");
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            
            
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            
            break;
            
            /*------------------------------------*/
        case 2:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;
            
            /*Terminamos la inicializacion*/

            traslacion[0] = 0;
            traslacion[1] = 0;
            traslacion[2] = 1000;
            
            rotacion[0][0] =  0.8660;
            rotacion[0][1] = -0.5000;
            rotacion[0][2] = 0;
            
            rotacion[1][0] = 0.5000;
            rotacion[1][1] = 0.8660;
            rotacion[1][2] = 0;
            ;
            rotacion[2][0] = 0;
            rotacion[2][1] = 0;
            rotacion[2][2] = 1;
            
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            
            
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            
            break;
            /*------------------------------------*/
        case 3:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;
            
            /*Terminamos la inicializacion*/

            
            traslacion[0] = -100;
            traslacion[1] = -100;
            traslacion[2] = 1000;
            
            rotacion[0][0] = 1;
            rotacion[0][1] = 0;
            rotacion[0][2] = 0;
            
            rotacion[1][0] = 0;
            rotacion[1][1] = 1;
            rotacion[1][2] = 0;
            
            rotacion[2][0] = 0;
            rotacion[2][1] = 0;
            rotacion[2][2] = 1;
            
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            printf("Punto 1\n");
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            
            
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            
            break;
            /*------------------------------------*/
        case 4:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;
            
            /*Terminamos la inicializacion*/

            
            traslacion[0] = -100;
            traslacion[1] = -100;
            traslacion[2] = 500;
            
            rotacion[0][0] = 1;
            rotacion[0][1] = 0;
            rotacion[0][2] = 0;
            
            rotacion[1][0] = 0;
            rotacion[1][1] = 1;
            rotacion[1][2] = 0;
            
            rotacion[2][0] = 0;
            rotacion[2][1] = 0;
            rotacion[2][2] = 1;
            
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            printf("Punto 1\n");
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            
            
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            
            break;
            /*------------------------------------*/
        case 5:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;
            
            /*Terminamos la inicializacion*/

            traslacion[0] = 100;
            traslacion[1] = 0;
            traslacion[2] = 1000;
            
            rotacion[0][0] = 1;
            rotacion[0][1] = 0;
            rotacion[0][2] = 0;
            
            rotacion[1][0] = 0;
            rotacion[1][1] = 0.8660;
            rotacion[1][2] = -0.5000;
            
            rotacion[2][0] = 0;
            rotacion[2][1] = 0.5000;
            rotacion[2][2] = 0.8660;
            
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            printf("Punto 1\n");
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            
            
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            
            break;
            /*------------------------------------*/
        case 6:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;
            
            /*Terminamos la inicializacion*/

            traslacion[0] = 100;
            traslacion[1] = 150;
            traslacion[2] = 1000;
            
            rotacion[0][0] =  0.8660;
            rotacion[0][1] = 0;
            rotacion[0][2] = 0.5000;
            
            rotacion[1][0] = 0;
            rotacion[1][1] = 1;
            rotacion[1][2] = 0;
            
            rotacion[2][0] = -0.5000;
            rotacion[2][1] = 0;
            rotacion[2][2] = 0.8660;
            
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            printf("Punto 1\n");
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            
            
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            
            break;
            /*------------------------------------*/
        case 7:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;
            
            /*Terminamos la inicializacion*/

            traslacion[0] = 0;
            traslacion[1] = 0;
            traslacion[2] = 500;
            
            rotacion[0][0] = 0.7500;
            rotacion[0][1] = 0.6495;
            rotacion[0][2] = -0.1250;
            
            rotacion[1][0] = -0.4330;
            rotacion[1][1] = 0.6250;
            rotacion[1][2] = 0.6495;
            
            rotacion[2][0] = 0.5000;
            rotacion[2][1] = -0.4330;
            rotacion[2][2] = 0.7500;
            
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            printf("Punto 1\n");
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            break;
            /*------------------------------------*/
        case 8:
            
            /*Inicializamos*/
            
            _cube1.rotationX = 0;
            _cube1.rotationY = 0;
            _cube1.rotationZ = 0;
            
            _cube2.rotationX = 0;
            _cube2.rotationY = 0;
            _cube2.rotationZ = 0;
            
            _cube3.rotationX = 0;
            _cube3.rotationY = 0;
            _cube3.rotationZ = 0;
            
            /*Terminamos la inicializacion*/

            traslacion[0] = 0;
            traslacion[1] = 0;
            traslacion[2] = 500;
            
            rotacion[0][0] = 0.8660;
            rotacion[0][1] = 0.2500;
            rotacion[0][2] =  -0.4330;
            
            rotacion[1][0] = 0;
            rotacion[1][1] = 0.8660;
            rotacion[1][2] = 0.5000;
            
            rotacion[2][0] =  0.5000;
            rotacion[2][1] = -0.4330;
            rotacion[2][2] = 0.7500;
            
            
            _matriz.sxx = rotacion[0][0];
            _matriz.sxy = rotacion[0][1];
            _matriz.sxz = rotacion[0][2];
            _matriz.tx = traslacion[0];
            
            _matriz.syx = rotacion[1][0];
            _matriz.syy = rotacion[1][1];
            _matriz.syz = rotacion[1][2];
            _matriz.ty = traslacion[1];
            
            _matriz.szx = rotacion[2][0];
            _matriz.szy = rotacion[2][1];
            _matriz.szz = rotacion[2][2];
            _matriz.tz = traslacion[2];
            
            _matriz.swx = 0;
            _matriz.swy = 0;
            _matriz.swz = 0;
            _matriz.tw = 1;
            
            printf("Punto 1\n");
            angles = im4ToEulerAngles(&_matriz);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D1);
            VEC_SUM(puntoProyectado3D1,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D2);
            VEC_SUM(puntoProyectado3D2,b,traslacion);
            
            MAT_DOT_VEC_3X3(b, rotacion, punto3D3);
            VEC_SUM(puntoProyectado3D3,b,traslacion);
            
            printf("%f \t %f \t %f \n",puntoProyectado3D1[0],puntoProyectado3D1[1],puntoProyectado3D1[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D2[0],puntoProyectado3D2[1],puntoProyectado3D2[2]);
            printf("%f \t %f \t %f \n",puntoProyectado3D3[0],puntoProyectado3D3[1],puntoProyectado3D3[2]);
            _cube1.position = iv3(puntoProyectado3D1[0],-puntoProyectado3D1[1],-puntoProyectado3D1[2]);
            _cube2.position = iv3(puntoProyectado3D2[0],-puntoProyectado3D2[1],-puntoProyectado3D2[2]);
            _cube3.position = iv3(puntoProyectado3D3[0],-puntoProyectado3D3[1],-puntoProyectado3D3[2]);
            
            
            
            [_cube1 roll:-angles.z];
            [_cube1 yaw:-angles.y];
            [_cube1 pitch:angles.x];
            
            //FIXME: Nos dimos cuenta de dos cosas:
            // 1. Hay que usar function R=euler2Matrix(psi,theta,phi) de matlab y no rodrigues porque no anda del todo bien.
            // 2. El orden de rotacion es el de este ejemplo. Hay que cambiarlo en la demo.
            
            [_cube2 roll:-angles.z];
            [_cube2 yaw:-angles.y];
            [_cube2 pitch:angles.x];
            
            [_cube3 roll:-angles.z];
            [_cube3 yaw:-angles.y];
            [_cube3 pitch:angles.x];
            
            break;
            
            
            
    }

}

@end

