//
//  ViewController.h
//  mapaMapiApp
//
//  Created by encuadro on 12/11/12.
//  Copyright (c) 2012 encuadro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "processing.h"
#import "lsd.h"
#import "segments.h"
#import "marker.h"
//#import "Composit.h"
//#import "CoplanarPosit.h"
#import <stdlib.h>
//#import "kalman.h"
#import "vvector.h"

bool fadeVolOut;
bool audioYvideo;
int click;
bool iPhone;
int wSize,hSize;

@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    //video
    MPMoviePlayerController *theMovie;
}

//camara
@property(nonatomic, retain) AVCaptureSession * session;
@property(nonatomic, retain) AVCaptureDevice * videoDevice;
@property(nonatomic, retain) AVCaptureDeviceInput * videoInput;
@property(nonatomic, retain) AVCaptureVideoDataOutput * frameOutput;
@property(nonatomic, retain) CIContext* context;
@property (readwrite, retain) IBOutlet UIImageView* videoView;
@property (readwrite, retain) IBOutlet UIImageView* imagenViewMaya;
@property (readwrite, retain) IBOutlet UIImageView* imagenViewAzteca;
@property (readwrite, retain) IBOutlet UIImageView* imagenViewZapoteca;

//audio
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@end
