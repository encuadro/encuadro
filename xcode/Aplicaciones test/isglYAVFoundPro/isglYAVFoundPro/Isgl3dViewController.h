//
//  Isgl3dViewController.h
//  casoUso0101
//
//  Created by Pablo Flores Guridi on 01/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HelloWorldView.h"
#import "isglYAVFoundProAppDelegate.h"


@interface Isgl3dViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    
    
}

@property (readwrite, retain) IBOutlet UIImageView* videoView;
@property (readwrite, retain) IBOutlet HelloWorldView* isgl3DView;

- (void) procesamiento;

@end
