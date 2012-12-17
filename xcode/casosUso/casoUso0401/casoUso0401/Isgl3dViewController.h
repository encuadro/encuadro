//
//  Isgl3dViewController.h
//  ARtigas
//
//  Created by Pablo Flores Guridi on 13/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HelloWorldView.h"
#import "casoUso0401AppDelegate.h"


#import "lsd_encuadro.h"
#import "segments.h"
#import "marker.h"
#import "CoplanarPosit.h"
#import <stdlib.h>
#import "kalman.h"
#import "vvector.h"

@interface Isgl3dViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    
    
}

@property (readwrite, retain) IBOutlet UIImageView* videoView;
@property (readwrite, retain) IBOutlet HelloWorldView* isgl3DView;

- (void) procesamiento;

@end
