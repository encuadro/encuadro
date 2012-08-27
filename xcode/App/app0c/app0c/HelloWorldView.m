//
//  HelloWorldView.m
//  demo05
//
//  Created by Pablo Flores Guridi on 17/07/12.
//  Copyright 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "HelloWorldView.h"


/*viewView*/
@implementation videoView


- (id) init {
	
	if ((self = [super init])) {
        
	}
	
	return self;
}


- (void) dealloc {
    
	[super dealloc];
}

@end


/*HelloWorldView*/
@interface HelloWorldView()
@property(nonatomic, retain) Isgl3dNode* cubito1;
@property(nonatomic, retain) Isgl3dNode* cubito2;
@property(nonatomic, retain) Isgl3dNode* cubito3;
@property(nonatomic, retain) Isgl3dNode* redondel1;
@property(nonatomic, retain) Isgl3dNode* redondel2;
@property(nonatomic, retain) Isgl3dNode* redondel3;


@end
@implementation HelloWorldView

@synthesize cubito1 = _cubito1;
@synthesize cubito2 = _cubito2;
@synthesize cubito3 = _cubito3;
@synthesize redondel1 = _redondel1;
@synthesize redondel2 = _redondel2;
@synthesize redondel3 = _redondel3;
@synthesize traslacion = _traslacion;
@synthesize eulerAngles = _eulerAngles;


double punto3D1[3], punto3D2[3], punto3D3[3], punto3D4[3], puntoModelo3D1[4] = {0,0,-65/2,1}, puntoModelo3D2[4] = {-32.5,-32.5,-65,1}, puntoModelo3D3[4] = {32.5,32.5,-65,1}, puntoModelo3D4[4] = {0,0,-65,1};
/*Si queremos meter cubos*/
//puntoModelo3D2[4] = {187.5,0,35/2,1}, puntoModelo3D3[4] = {0,105,35/2,1},
double Matriz[4][4];
double rotacion[3][3];


- (void) setRotacion:(double*) rot
{
    rotacion[0][0] = rot[0];
    rotacion[0][1] = rot[1];
    rotacion[0][2] = rot[2];
    
    rotacion[1][0] = rot[3];
    rotacion[1][1] = rot[4];
    rotacion[1][2] = rot[5];
    
    rotacion[2][0] = rot[6]; 
    rotacion[2][1] = rot[7];
    rotacion[2][2] = rot[8];
    
}
- (id) init {
	/*"Si el init del padre anduvo bien..."*/
	if ((self = [super init])) {
        
        printf("init del HelloWorldView\n");
        
        // Create the primitive
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
        Isgl3dCube* cubeMesh = [Isgl3dCube  meshWithGeometry:65 height:65 depth:65 nx:40 ny:40];       
        _cubito1 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        //        _cubito2 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        //        _cubito3 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        
        Isgl3dSphere * sphereMesh = [Isgl3dSphere meshWithGeometry:5 longs:40 lats:40];
        
        _redondel1 = [self.scene createNodeWithMesh:sphereMesh andMaterial:material];
        _redondel2 = [self.scene createNodeWithMesh:sphereMesh andMaterial:material];
        _redondel3 = [self.scene createNodeWithMesh:sphereMesh andMaterial:material];
        
        _cubito1.position = iv3(100,100,-1000);
        //        _cubito2.position = iv3(-100,-100,-1000);
        //        _cubito3.position = iv3(0,0,-1000);
        _redondel1.position =  iv3(0,0,-1000);
        _redondel2.position =  iv3(0,0,-1000);
        _redondel3.position =  iv3(0,0,-1000);
        
        
        // Defnimos el lookAt de la camara.
        
        self.camera.position = iv3(42,-2,0.1);
        //self.camera.position = iv3(0,0,0.1);
        [self.camera setLookAt:iv3(self.camera.x, self.camera.y,0) ];
        
        /*Seteamos el fov.*/
        self.camera.fov = 36;
        
        /*Seteamos las dimensiones de la imagen*/
        //        self.camera.height = 288;
        //        self.camera.width = 352;
        //   printf("%f",self.camera.aspect);
        
        // Esto originalmente estaba descomentado
        [self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}


- (void) tick:(float)dt {
	


} 

@end

