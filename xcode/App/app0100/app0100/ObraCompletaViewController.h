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
#import "AutorTableViewController.h"

int click;
bool justLoaded;
bool manual;
bool conUpsi;
NSMutableArray *descripcionObra;
@interface ObraCompletaViewController : UIViewController{
    IBOutlet UIActivityIndicatorView *actInd;
    IBOutlet UIBarButtonItem *start;
    IBOutlet UIBarButtonItem *AR;
    IBOutlet UIBarButtonItem *tw;
}
@property (retain, nonatomic) IBOutlet UILabel *autor;
@property (retain, nonatomic) IBOutlet UILabel *obra;
@property (retain, nonatomic) IBOutlet UITextView *detalle;
@property (retain, nonatomic) IBOutlet UITextView *texto;
@property (retain, nonatomic) IBOutlet UIImageView *imagenObra;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
@property (assign) IBOutlet UIImageView *mano1;
@property (assign) IBOutlet UIImageView *mano4;
@property (assign) IBOutlet UIImageView *upsi;
@property (nonatomic, retain) TouchVista *vistaTouch;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *start;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *AR;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *tw;
- (IBAction) play;
-(IBAction)tweet;
@end
