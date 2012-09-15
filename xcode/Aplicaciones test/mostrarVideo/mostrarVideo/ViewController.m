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

-(IBAction)reproducir:(id)sender{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"marker_lo" ofType:@"mov"]];
    /* Con ViewController
    MPMoviePlayerViewController *player=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:player];
    player.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
    player.view.bounds=CGRectMake(0, 0, 100, 100);
    [player.moviePlayer play];
    player=nil;
    */

    
    MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:url];  
    [self.view addSubview:moviePlayerController.view];  
    moviePlayerController.fullscreen = YES;  
    [moviePlayerController play];

}


-(IBAction)playMovie:(id)sender  
{  
  
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] 
                                             pathForResource:@"marker_lo" ofType:@"mov"]];
        MPMoviePlayerController *moviePlayer = 
        [[MPMoviePlayerController alloc] 
         initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer];
        
        moviePlayer.controlStyle = MPMovieControlStyleDefault;
        moviePlayer.shouldAutoplay = YES;
        [self.view addSubview:moviePlayer.view];
        [moviePlayer setFullscreen:YES animated:YES];
     
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
