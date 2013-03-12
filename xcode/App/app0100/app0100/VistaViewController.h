//
//  VistaViewController.h
//  demo05
//
//  Created by encuadro augmented reality on 7/21/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Isgl3dViewController.h"
#import "Isgl3d.h"
#import "app0100AppDelegate.h"
#import "HelloWorldView.h"
#import "ObraCompletaViewController.h"
#import "TouchVista.h"
#import <Twitter/Twitter.h>

bool DosCubos;
bool Artigas;

@interface VistaViewController : UIViewController{
    
    UIImageView *resultImage;
    UITextView *resultText;
    
@private
//	Isgl3dViewController * _viewController;

}


@property (nonatomic, retain) UIWindow * window;
@property (nonatomic, retain) UIView * vistaStory;
@property (nonatomic, retain) UIImageView* vistaImg;
@property (nonatomic, retain) UIButton *button;

@property (nonatomic, retain) Isgl3dViewController <AVCaptureVideoDataOutputSampleBufferDelegate> * viewController;
//@property (nonatomic, retain) app0bAppDelegate *appDelegate;
//@property (readwrite) bool AugmReal;
@property (nonatomic,retain) Isgl3dView * HWview;
//- (IBAction)buttonClicked:(id)sender;
@property (nonatomic, readwrite) NSNumber *ARidObra;
@property (nonatomic, retain) NSString *ARType; //modelo, animacion, video
@property (nonatomic, retain) NSString *ARObj;
@property (nonatomic, retain) NSString *ARObj2;
@property (nonatomic, retain) NSString *ARObj3;
@property (nonatomic, retain) NSString *ARObj4;
@property (nonatomic, retain) NSString *ARObj5;
//@property (nonatomic, readwrite) bool *DosCubos;

@property (nonatomic, retain) TouchVista *vistaTouch;
@property (nonatomic, retain) MPMoviePlayerController *theMovieVista;

@property (assign) IBOutlet UIImageView *backround;
-(IBAction)TWeet:(id)sender;

@end
