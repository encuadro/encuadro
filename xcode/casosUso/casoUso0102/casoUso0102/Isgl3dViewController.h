//
//  Isgl3dViewController.h
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "HelloWorldView.h"
#import "casoUso0102AppDelegate.h"


#import "processing.h"
#import "lsd_encuadro.h"
#import "lsd.h"
#import "segments.h"
#import "marker.h"
#import "Composit.h"
#import "CoplanarPosit.h"
#import <stdlib.h>
#import "configuration.h"
#import "kalman.h"
#import "vvector.h"

@interface Isgl3dViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    
    CMMotionManager *manager;
    CMAttitude *referenceAttitude;
    CMAttitude *attitude;

  

}

@property (readwrite, retain) IBOutlet UIImageView* videoView;
@property (readwrite, retain) IBOutlet HelloWorldView* isgl3DView;
@property bool kalman;
@property bool sensors;
@property bool LSD;
@property bool LSD_original;
@property bool segments;
@property bool detectedPts;
@property bool reproyectedPts;
@property float segmentFilterThres;
@property float kalmanErrorGain;
@property bool newRefPose;

- (void) lsdOriginal;
- (void) procesamiento;
- (void) reservarMemoria;
@end
