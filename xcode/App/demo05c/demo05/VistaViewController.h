//
//  VistaViewController.h
//  demo05
//
//  Created by encuadro augmented reality on 7/21/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Isgl3dViewController.h"

@interface VistaViewController : UIViewController{

@private
//	Isgl3dViewController * _viewController;

}


@property (nonatomic, retain) UIWindow * window;
@property (nonatomic, retain) UIView * vistaStory;
@property (nonatomic, retain) UIImageView* vistaImg;
@property (nonatomic, retain) UIButton *button;

@property (nonatomic, retain) Isgl3dViewController <AVCaptureVideoDataOutputSampleBufferDelegate> * viewController;


- (IBAction)buttonPressed;

@end
