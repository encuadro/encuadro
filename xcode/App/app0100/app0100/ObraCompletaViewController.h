//
//  ObraCompletaViewController.h
//  TableViewStory
//
//  Created by encuadro augmented reality on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VistaViewController.h"

#import "Isgl3dViewController.h"
#import "Isgl3d.h"
#import "app0100AppDelegate.h"
#import "HelloWorldView.h"

#import "TouchVista.h"
#import "DrawSign.h"

int click;
bool justLoaded;
bool manual;

@interface ObraCompletaViewController : UIViewController

@property (retain, nonatomic) NSArray *descripcionObra;
@property (retain, nonatomic) IBOutlet UILabel *autor;
@property (retain, nonatomic) IBOutlet UILabel *obra;
@property (retain, nonatomic) IBOutlet UITextView *detalle;
@property (retain, nonatomic) IBOutlet UIImageView *imagenObra;

@property (assign) IBOutlet UIImageView *mano1;
@property (assign) IBOutlet UIImageView *mano4;
@property (assign) IBOutlet UIImageView *upsi;
@property (nonatomic, retain) TouchVista *vistaTouch;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UIButton *start;


- (IBAction) play;

@end
