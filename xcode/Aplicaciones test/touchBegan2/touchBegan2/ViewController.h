//
//  ViewController.h
//  touchBegan2
//
//  Created by encuadro on 10/20/12.
//  Copyright (c) 2012 encuadro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "moviePlayImplemented.h"
#import "TouchVista.h"

@interface ViewController : UIViewController
@property (nonatomic,retain) IBOutlet UILabel *texto;
@property (nonatomic, retain) moviePlayImplemented *theMovieImplemented;
@property (nonatomic, retain) TouchVista *vistaTouch;
@property (nonatomic, retain) MPMoviePlayerController *theMovie;
@property (nonatomic, readwrite) bool *touchFull;
@end
