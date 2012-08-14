//
//  HelloWorldView.m
//  demo00
//
//  Created by encuadro augmented reality on 6/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"



@implementation videoView

@synthesize i = _i;

- (id) init {
	
	if ((self = [super init])) {
        
	}
	
	return self;
}


- (void) actualizar:(UIImage *)img
{
    self.image = img;
    printf("actualizar\n");
}

- (void) dealloc {
    
	[super dealloc];
}

@end


//@implementation UIBackgroundView
//@synthesize backgroundMaterial = _backgroundMaterial;
//@synthesize background = _background;
//@synthesize imagen = _imagen;
//@synthesize i;
//
//- (id) init {
//    
//	if ((self = [super init])) 
//    {
//        i=1;
//        printf("init de UIBackgroundView\n");
////        Isgl3dTextureMaterial * backgroundMaterial = [Isgl3dTextureMaterial materialWithTextureUIImage:self.imagen key:@"0"];
////        
//        i=0;
////        Isgl3dGLUIImage * background = [Isgl3dGLUIImage imageWithMaterial:backgroundMaterial andRectangle:CGRectMake(0, 0, 480, 320) width:480 height:320];
////        [self.scene addChild:background];
//        //[self actualizar];
//   
////        [self setBackgroundMaterial: [Isgl3dTextureMaterial materialWithTextureFile:@"Marcador480x320.jpg" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO]];
////        [self setBackground:[Isgl3dGLUIImage imageWithMaterial:_backgroundMaterial andRectangle:CGRectMake(0, 0, 480, 320) width:480 height:320]];
////        [self.scene addChild:_background];
//       
//        //[self.scene removeChild:_background];
//   
//
//        
//        
//        //[self.scene removeChild:_background];
//
//   
//    }
//     return self;
//}
//
//
//@end


@interface HelloWorldView()
@property(nonatomic, retain) Isgl3dNode* cubito;

@end

@implementation HelloWorldView
@synthesize cubito = _cubito;
- (id) init {
	/*"Si el init del padre anduvo bien..."*/
	if ((self = [super init])) {
        
        printf("init del HelloWorldView\n");
        
		// Create texture material with text
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithText:@"Hello World!" fontName:@"Arial" fontSize:48];
        
        
        
		// Create a UV Map so that only the rendered content of the texture is shown on plane
		float uMax = material.contentSize.width / material.width;
		float vMax = material.contentSize.height / material.height;
		Isgl3dUVMap * uvMap = [Isgl3dUVMap uvMapWithUA:0 vA:0 uB:uMax vB:0 uC:0 vC:vMax];
		
		// Create a plane with corresponding UV map
		Isgl3dPlane * plane = [Isgl3dPlane meshWithGeometryAndUVMap:6 height:2 nx:2 ny:2 uvMap:uvMap];
		
		// Create node to render the material on the plane (double sided to see back of plane)
		_3dText = [self.scene createNodeWithMesh:plane andMaterial:material];
		_3dText.doubleSided = YES;
		
        
        /**********

        ***********/

        
        // Create the primitive
		Isgl3dTextureMaterial * material2 = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
        Isgl3dCube* cubeMesh = [Isgl3dCube  meshWithGeometry: 10 height:10 depth:10 nx:40 ny:40];       
        _cubito = [self.scene createNodeWithMesh:cubeMesh andMaterial:material2];
        _cubito.position = iv3(0,0,0);
        
        
        // Translate the camera.
		[self.camera setPosition:iv3(0, 0, 20)];
        
        // Esto originalmente estaba descomentado
		[self schedule:@selector(tick:)];
	}
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}


- (void) tick:(float)dt {
	// Rotate the text around the y axis
	_3dText.rotationY += 2;
}



@end

