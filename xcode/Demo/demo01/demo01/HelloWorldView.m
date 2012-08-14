//
//  HelloWorldView.m
//  isgl3DYAVFoundation
//
//  Created by Pablo Flores Guridi on 12/05/12.
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
@property(nonatomic, retain) Isgl3dNode* cubito;

@end
@implementation HelloWorldView

@synthesize cubito = _cubito;
@synthesize traslacion = _traslacion;
@synthesize rotacion = _rotacion;

- (id) init {
	/*"Si el init del padre anduvo bien..."*/
	if ((self = [super init])) {
        
        printf("init del HelloWorldView\n");
        
        // Create the primitive
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
        Isgl3dCube* cubeMesh = [Isgl3dCube  meshWithGeometry: 10 height:10 depth:10 nx:40 ny:40];       
        _cubito = [self.scene createNodeWithMesh:cubeMesh andMaterial:material];
        _cubito.position = iv3(0,0,0);
        
        
        // Translate the camera.
		[self.camera setPosition:iv3(0, 0, 100)];
        
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
    _cubito.rotationZ = self.rotacion[2];
    NSLog(@"tick\n");
    //_cubito.rotationZ += 22;
}
- (void) actualizar:(double*)rotacion traslacion: (double*)traslacion
//- (void) actualizar
{
    _cubito.rotationZ += 22;
    
    //    redondel1.position = iv3(traslacion[0],traslacion[1],traslacion[2]);
    //    [redondel1 yaw:Rot[0]];
    //    [redondel  pitch:-Rot[1]];
    //    [redondel roll: -Rot[2]];    
    
}


@end

