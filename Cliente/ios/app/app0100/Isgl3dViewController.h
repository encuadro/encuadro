//
//  Isgl3dViewController.h
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HelloWorldView.h"
//#import "app0100AppDelegate.h"
//#import "VistaViewController.h"
//#import "TouchVista.h"



#import "lsd_encuadro.h"
#import "segments.h"
#import "marker.h"
#import "Composit.h"
#import "CoplanarPosit.h"
#import <stdlib.h>
#import "configuration.h"
#import "kalman.h"

#include "AuxiVar.h"

#include "homografia.h"

int augmID;

@interface Isgl3dViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    MPMoviePlayerController *theMovie;
    
}

@property (readwrite, retain) UIImageView* videoView;
#ifdef USE_ISGL
@property (readwrite, retain) IBOutlet HelloWorldView* isgl3DView;
#endif
@property(nonatomic, retain) AVCaptureSession * session;
@property(nonatomic, retain) AVCaptureDevice * videoDevice;
@property(nonatomic, retain) AVCaptureDeviceInput * videoInput;
@property(nonatomic, retain) AVCaptureVideoDataOutput * frameOutput;
@property(nonatomic, retain) CIContext* context;

@property (nonatomic, retain) MPMoviePlayerController *theMovie;
@property (nonatomic,readwrite) bool iPhone;
@property (nonatomic,readwrite) int wSize;
@property (nonatomic,readwrite) int hSize;
@property (nonatomic,readwrite) bool videoPlayer;
@property (nonatomic,readwrite) bool* touchFull;
@property (nonatomic, retain) NSString *videoName;


- (void) procesamiento;
- (void) reservarMemoria;
-(void)createVideoWindow:(UIWindow *)window;

@end