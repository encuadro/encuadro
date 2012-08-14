//
//  Isgl3dViewController.h
//  demo00
//
//  Created by encuadro augmented reality on 6/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HelloWorldView.h"

@interface Isgl3dViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>{
    
}
@property (readwrite, retain) UIImage* imagen;
@property (readwrite, retain) IBOutlet UIImageView* videoView;


@end
