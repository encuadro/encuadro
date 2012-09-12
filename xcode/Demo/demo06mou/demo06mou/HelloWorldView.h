//
//  HelloWorldView.h
//  demo06mou
//
//  Created by Pablo Flores Guridi on 11/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "isgl3d.h"
//#import "mult.h"
#include "vvector.h"
#import "configuration.h"

@interface videoView : UIImageView {
}

@end


@class Isgl3dDemoCameraController;
@interface HelloWorldView : Isgl3dBasic3DView {
    
@private
	// The rendered text
    Isgl3dMeshNode * _3dText;
    Isgl3dDemoCameraController * _cameraController;
}
@property (nonatomic) double* eulerAngles;
@property (nonatomic) double* traslacion;


-(void) setRotacion:(double*) rot;


@end

/*
 * Principal class to be instantiated in main.h.
 */
#import "demo06mouAppDelegate.h"
@interface AppDelegate : demo06mouAppDelegate
- (void) createViews;
@end

