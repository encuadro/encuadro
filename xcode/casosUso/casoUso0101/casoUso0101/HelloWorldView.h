//
//  HelloWorldView.h
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "isgl3d.h"
#include "vvector.h"
#import "configuration.h"
#import <AVFoundation/AVFoundation.h>
#import "claseDibujar.h"

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
}
@property (nonatomic) float* eulerAngles;
@property (nonatomic) float* traslacion;
@property(nonatomic) float* distanciaMarcador;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (bool) getSegments;
- (bool) getCorners;
- (bool) getReproyected;
- (void) setRotacion:(float*) rot;

@end

/*
 * Principal class to be instantiated in main.h.
 */
#import "casoUso0101AppDelegate.h"
@interface AppDelegate : casoUso0101AppDelegate
- (void) createViews;
@end


