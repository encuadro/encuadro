//
//  HelloWorldView.h
//  Renderiando
//
//  Created by Pablo Flores Guridi on 23/08/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "isgl3d.h"
#include "vvector.h"


#pragma mark UIBackgroundView

@interface UIBackgroundView : Isgl3dBasic2DView {
}

@end


#pragma mark Simple3DView

@class Isgl3dDemoCameraController;

@interface Simple3DView : Isgl3dBasic3DView {
    
@private
	Isgl3dMeshNode * _cube1;
    Isgl3dMeshNode * _cube2;
    Isgl3dMeshNode * _cube3;
	Isgl3dDemoCameraController * _cameraController;
    
}

@end

/*
 * Principal class to be instantiated in main.h.
 */
#import "RenderiandoAppDelegate.h"
@interface AppDelegate : RenderiandoAppDelegate
- (void) createViews;
@end


