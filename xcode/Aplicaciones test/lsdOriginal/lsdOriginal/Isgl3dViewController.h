//
//  Isgl3dViewController.h
//  lsd_original
//
//  Created by Pablo Flores Guridi on 20/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HelloWorldView.h"
#import "lsdOriginalAppDelegate.h"


#import "lsd.h"
#import <stdlib.h>


@interface Isgl3dViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    
    
}

@property (readwrite, retain) IBOutlet UIImageView* videoView;
@property (readwrite, retain) IBOutlet HelloWorldView* isgl3DView;
- (void) setImage: (UIImage*) imagen;
- (void) procesamiento;

@end
