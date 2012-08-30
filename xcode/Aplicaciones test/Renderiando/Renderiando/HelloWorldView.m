//
//  HelloWorldView.m
//  Renderiando
//
//  Created by Pablo Flores Guridi on 23/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"



#pragma mark UIBackgroundView
int numero = 1;
double puntoProyectado3D1[3], puntoProyectado3D2[3], puntoProyectado3D3[3], b[3];
double punto3D1[3] = {0,0,-30}, punto3D2[3] = {190,0,-30}, punto3D3[3]={0,100,-30};
Isgl3dVector3 angles;


@implementation UIBackgroundView

- (id) init {
	
	if ((self = [super init])) {
        NSLog(@"init del background\n");
        
        Isgl3dTextureMaterial * backgroundMaterial;
        Isgl3dGLUIImage * background;
        
        switch (numero) {
            case 1:
        
                backgroundMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"marker_0003.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
                background = [Isgl3dGLUIImage imageWithMaterial:backgroundMaterial andRectangle:CGRectMake(0, 0, 480, 360) width:1024 height:768];
                [self.scene addChild:background];
              
                break;
                
            case 2:
                break;
        }
		
	}
	
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}


@end

#pragma mark Simple3DView

#import "Isgl3dDemoCameraController.h"
@interface Simple3DView()
@property(nonatomic, readwrite) Isgl3dMatrix4 matriz;

@end
@implementation Simple3DView

@synthesize matriz = _matriz;


double rotacion[3][3];
double traslacion[3];


- (id) init {
	
	if ((self = [super init])) {
		// Create the primitive
                printf("punto A\n");
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dCube * cubeMesh = [Isgl3dCube meshWithGeometry:60 height:60 depth:60 nx:40 ny:40];
		_cube1 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        _cube2 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        _cube3 = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];

        self.camera.position = iv3(0, 0, 0.1);
        self.camera.fov = 34.8225;
        self.camera.width = 480;
        self.camera.height = 360;
        self.camera.aspect = 1/0.75;
        printf("%f \t %f \t %f\n",self.camera.aspect, self.camera.width, self.camera.height);
        switch (numero) {
            case 1:
            
                 printf("punto C\n");
                traslacion[0] = -100;
                traslacion[1] = -100;
                traslacion[2] = 1000;
                 printf("punto D\n");
                rotacion[0][0] = 1;
                rotacion[0][1] = 0;
                rotacion[0][2] = 0;
          printf("punto E\n");
                rotacion[1][0] = 0;
                rotacion[1][1] = 1;
                rotacion[1][2] = 0;
               printf("punto F\n"); 
                rotacion[2][0] = 0;
                rotacion[2][1] = 0;
                rotacion[2][2] = 1;
                
                printf("punto 0\n");
                
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
                break;
                
            case 2:
                
                break;
        }
        
        
		// Schedule updates
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
	[_cameraController release];
    
	[super dealloc];
}

- (void) tick:(float)dt {

}

- (void) onActivated {
	// Add camera controller to touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] addResponder:_cameraController withView:self];
}

- (void) onDeactivated {
	// Remove camera controller from touch-screen manager
	[[Isgl3dTouchScreen sharedInstance] removeResponder:_cameraController];
}

@end



#pragma mark AppDelegate

/*
 * Implement principal class: simply override the createViews method to return the desired demo view.
 */

@implementation AppDelegate

- (void) createViews {
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
    
	// Create 2D view background and add to Isgl3dDirector
	Isgl3dView * background = [UIBackgroundView view];
	[[Isgl3dDirector sharedInstance] addView:background];
    
	// Create 3D view and add to Isgl3dDirector
	Isgl3dView * view = [Simple3DView view];
	[[Isgl3dDirector sharedInstance] addView:view];
    
    
}

@end
