//
//  HelloWorldView.m
//  Renderiando
//
//  Created by Pablo Flores Guridi on 23/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldView.h"

@implementation HelloWorldView

- (id) init {
	
	if ((self = [super init])) {
		// Create a button to calibrate the accelerometer
		Isgl3dTextureMaterial * calibrateButtonMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"angle.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * calibrateButton = [Isgl3dGLUIButton buttonWithMaterial:calibrateButtonMaterial];
		[self.scene addChild:calibrateButton];
		[calibrateButton setX:8 andY:264];
		[calibrateButton addEvent3DListener:self method:@selector(calibrateButtonPressed:) forEventType:TOUCH_EVENT];
        
		// Create a button to pause the scene
		Isgl3dTextureMaterial * pauseButtonMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"pause.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * pauseButton = [Isgl3dGLUIButton buttonWithMaterial:pauseButtonMaterial];
		[self.scene addChild:pauseButton];
		[pauseButton setX:424 andY:264];
		[pauseButton addEvent3DListener:self method:@selector(pauseButtonPressed:) forEventType:TOUCH_EVENT];
        
		// Create a button to allow movement of the camera
		Isgl3dTextureMaterial * cameraButtonMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"camera.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dGLUIButton * cameraButton = [Isgl3dGLUIButton buttonWithMaterial:cameraButtonMaterial];
		[self.scene addChild:cameraButton];
		[cameraButton setX:8 andY:8];
		[cameraButton addEvent3DListener:self method:@selector(cameraButtonPressed:) forEventType:TOUCH_EVENT];
	}
	
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}

- (void) calibrateButtonPressed:(Isgl3dEvent3D *)event {
	NSLog(@"Calibrate button pressed");
	[[Isgl3dDirector sharedInstance] resume];
}

- (void) pauseButtonPressed:(Isgl3dEvent3D *)event {
	NSLog(@"Pause button pressed");
	[[Isgl3dDirector sharedInstance] pause];
}

- (void) cameraButtonPressed:(Isgl3dEvent3D *)event {
	NSLog(@"Camera button pressed");
}

@end

#pragma mark UIBackgroundView


@implementation UIBackgroundView

- (id) init {
	
	if ((self = [super init])) {
        NSLog(@"init del background\n");
		// Create a button to calibrate the accelerometer
		Isgl3dTextureMaterial * backgroundMaterial = [Isgl3dTextureMaterial materialWithTextureFile:@"gozando.png" shininess:0 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dGLUIImage * background = [Isgl3dGLUIImage imageWithMaterial:backgroundMaterial andRectangle:CGRectMake(0, 0, 480, 320) width:480 height:320];
		[self.scene addChild:background];
	}
	
	return self;
}

- (void) dealloc {
    
	[super dealloc];
}


@end

#pragma mark Simple3DView

#import "Isgl3dDemoCameraController.h"

@implementation Simple3DView

- (id) init {
	
	if ((self = [super init])) {
		// Create the primitive
		Isgl3dTextureMaterial * material = [Isgl3dTextureMaterial materialWithTextureFile:@"red_checker.png" shininess:0.9 precision:Isgl3dTexturePrecisionMedium repeatX:NO repeatY:NO];
		Isgl3dTorus * torusMesh = [Isgl3dTorus meshWithGeometry:2 tubeRadius:1 ns:32 nt:32];
		_torus = [self.scene createNodeWithMesh:torusMesh andMaterial:material];
        
		// Add light
		Isgl3dLight * light  = [Isgl3dLight lightWithHexColor:@"FFFFFF" diffuseColor:@"FFFFFF" specularColor:@"FFFFFF" attenuation:0.005];
		light.position = iv3(5, 15, 15);
		[self.scene addChild:light];
        
		// Create camera controller
		_cameraController = [[Isgl3dDemoCameraController alloc] initWithCamera:self.camera andView:self];
		_cameraController.orbit = 14;
		_cameraController.theta = 30;
		_cameraController.phi = 30;
//
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
	[_torus rotate:0.5 x:0 y:1 z:0];
	
	[_cameraController update];
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
    
	// Create UI and add to Isgl3dDirector
	Isgl3dView * ui = [HelloWorldView view];
	[[Isgl3dDirector sharedInstance] addView:ui];
    
}

@end
