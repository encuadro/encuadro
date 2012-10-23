//
//  HelloWorldView.h
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#ifdef __cplusplus
extern "C"{
#endif

#import "isgl3d.h"
#include "vvector.h"
#import "configuration.h"
#import <AVFoundation/AVFoundation.h>
#import "claseDibujar.h"

#ifdef __cplusplus
}
#endif

bool fin;


@interface videoView : UIImageView <AVAudioPlayerDelegate> {
}
//@property(nonatomic,retain) Isgl3dViewController* viewController;
@end


@class Isgl3dDemoCameraController;
@interface HelloWorldView : Isgl3dBasic3DView {
    
@private
	// The rendered text
    Isgl3dMeshNode * _3dText;
    Isgl3dDemoCameraController * _cameraController;
    Isgl3dNode * _container;
    Isgl3dSkeletonNode * _model;
    Isgl3dSkeletonNode * _model2;
}
@property (nonatomic) float* eulerAngles;
@property (nonatomic) float* traslacion;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (bool) getDibujar;
- (void) setRotacion:(float*) rot;


@end

/*
 * Principal class to be instantiated in main.h.
 */
//#import "app0100AppDelegate.h"
//@interface AppDelegate : app0100AppDelegate
//- (void) createViews;
//@end


