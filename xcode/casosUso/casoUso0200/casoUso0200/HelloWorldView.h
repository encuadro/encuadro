//
//  HelloWorldView.h
//  oneThread
//
//  Created by Pablo Flores Guridi on 13/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "isgl3d.h"
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
@property (nonatomic) float* eulerAngles;
@property (nonatomic) float* traslacion;

- (bool) getDibujar;
-(void) setRotacion:(float*) rot;


@end

/*
 * Principal class to be instantiated in main.h.
 */
#import "casoUso0200AppDelegate.h"
@interface AppDelegate : casoUso0200AppDelegate
- (void) createViews;
@end


