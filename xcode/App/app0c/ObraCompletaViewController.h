//
//  ObraCompletaViewController.h
//  TableViewStory
//
//  Created by encuadro augmented reality on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

int click;
bool justLoaded;

@interface ObraCompletaViewController : UIViewController

@property (retain, nonatomic) NSArray *descripcionObra;
@property (retain, nonatomic) IBOutlet UILabel *autor;
@property (retain, nonatomic) IBOutlet UILabel *obra;
@property (retain, nonatomic) IBOutlet UITextView *detalle;
@property (retain, nonatomic) IBOutlet UIImageView *imagenObra;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet UIButton *start;

- (IBAction) play;

@end
