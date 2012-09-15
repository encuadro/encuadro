//
//  ViewController.h
//  mostrarVideo
//
//  Created by encuadro augmented reality on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController : UIViewController{

MPMoviePlayerController *theMovie;

}


@property (nonatomic, retain) IBOutlet UIButton *boton;
@property (nonatomic, retain) IBOutlet UIImageView *imagen;
@property (nonatomic, retain) MPMoviePlayerController *theMovie;
@end
