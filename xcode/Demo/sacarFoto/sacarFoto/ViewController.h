//
//  ViewController.h
//  sacarFoto
//
//  Created by Pablo Flores Guridi on 02/07/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

@interface ViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    int iFrameCount;
}

@end
