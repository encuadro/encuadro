//
//  ViewController.m
//  mostrarVideo
//
//  Created by encuadro augmented reality on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize boton = _boton;
@synthesize imagen = _imagen;
@synthesize theMovie = _theMovie;

-(IBAction)reproducir:(id)sender{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"marker_lo" ofType:@"mov"]];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"marker_lo" ofType:@"mov"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    //Place it in subview, else it won’t work
    theMovie.view.frame = CGRectMake(0, 0, 100, 100);
    
    
//    CGAffineTransform rotate = CGAffineTransformMakeRotation(0.95);
//	CGAffineTransform moveRight = CGAffineTransformMakeTranslation(100, 200);
//	CGAffineTransform combo1 = CGAffineTransformConcat(rotate, moveRight);
//	CGAffineTransform zoomIn = CGAffineTransformMakeScale(1, 1);
//	CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
//    theMovie.view.transform = combo1;
    
    
    
    theMovie.view.transform = CGAffineTransformMake(0, 1, 2, 1, 0, 0);
    [self.view addSubview:theMovie.view];
    //Resize window – a bit more practical
    UIWindow *moviePlayerWindow = nil;
    moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
    //[moviePlayerWindow setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    // Play the movie.
    [theMovie play];
}


-(IBAction)playMovie:(id)sender  
{  
  
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:15];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(0.95);
	CGAffineTransform moveRight = CGAffineTransformMakeTranslation(100, 200);
	CGAffineTransform combo1 = CGAffineTransformConcat(rotate, moveRight);
	CGAffineTransform zoomIn = CGAffineTransformMakeScale(5.8, 5.8);
	CGAffineTransform transform = CGAffineTransformConcat(zoomIn, combo1);
    self.view.transform = transform;
	[UIView commitAnimations];
     
}  

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    MPMoviePlayerController *moviePlayer = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self      
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    if ([moviePlayer 
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [moviePlayer.view removeFromSuperview];
    }
    //[moviePlayer release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
