//
//  HelloWorldView.h
//  lsd_original
//
//  Created by Pablo Flores Guridi on 20/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "isgl3d.h"
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


- (bool) getLsd_all;

@end

/*
 * Principal class to be instantiated in main.h.
 */
#import "lsdOriginalAppDelegate.h"
@interface AppDelegate : lsdOriginalAppDelegate
- (void) createViews;
@end


