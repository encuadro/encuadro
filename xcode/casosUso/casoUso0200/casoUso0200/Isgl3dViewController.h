//
//  Isgl3dViewController.h
//  oneThread
//
//  Created by Pablo Flores Guridi on 13/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HelloWorldView.h"


#import "processing.h"
#import "lsd.h"
#import "segments.h"
#import "marker.h"
#import "Composit.h"
#import "CoplanarPosit.h"
#import <stdlib.h>
#import "configuration.h"
#import "claseDibujar.h"
bool azteca;
@interface Isgl3dViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    MPMoviePlayerController *theMovieMaya;
    MPMoviePlayerController *theMovieAzteca;
    
}

@property (readwrite, retain) IBOutlet UIImageView* videoView;
@property (readwrite, retain) IBOutlet HelloWorldView* isgl3DView;

@property (nonatomic, retain) MPMoviePlayerController *theMovieMaya;
@property (nonatomic, retain) MPMoviePlayerController *theMovieAzteca;
@property (readwrite, retain) IBOutlet claseDibujar *cgvista;

@end
