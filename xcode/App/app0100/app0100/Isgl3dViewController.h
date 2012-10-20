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

#import "processing.h"
#import "lsd.h"
#import "segments.h"
#import "marker.h"
#import "Composit.h"
#import "CoplanarPosit.h"
#import <stdlib.h>
#import "configuration.h"
#import "kalman.h"




@interface Isgl3dViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    MPMoviePlayerController *theMovie;
    
}

@property (readwrite, retain) UIImageView* videoView;
@property (readwrite, retain) IBOutlet HelloWorldView* isgl3DView;

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

- (void) procesamiento;
- (void) reservarMemoria;
-(void)createVideoWindow:(UIWindow *)window;

@end
