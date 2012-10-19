//
//  HelloWorldView.h
//  casoUso0400
//
//  Created by Pablo Flores Guridi on 15/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#ifdef __cplusplus
extern "C"{
#endif
    
#import "isgl3d.h"
#include "vvector.h"
#import <AVFoundation/AVFoundation.h>
#import "claseDibujar.h"

#ifdef __cplusplus
}
#endif
//#import "configuration.h"

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
    Isgl3dAnimationController * _animationController;
}
@property (nonatomic) float* eulerAngles;
@property (nonatomic) float* traslacion;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (bool) getSegments;
- (bool) getCorners;
- (bool) getReproyected;
- (void) setRotacion:(float*) rot;

@end

/*
 * Principal class to be instantiated in main.h.
 */
#import "casoUso0400AppDelegate.h"
@interface AppDelegate : casoUso0400AppDelegate
- (void) createViews;
@end


