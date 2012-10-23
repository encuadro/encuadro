//
//  ViewController.m
//  touchBegan2
//
//  Created by encuadro on 10/20/12.
//  Copyright (c) 2012 encuadro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize texto = _texto;
@synthesize theMovieImplemented = _theMovieImplemented;
@synthesize theMovie = _theMovie;
@synthesize touchFull = _touchFull;


-(void) desplegarVideoImplemented{
    
    /////////viendo commit
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"GangnamStyle" ofType:@"mov"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    self.theMovie = [[moviePlayImplemented alloc] initWithContentURL:movieURL];    //Place it in subview, else it won’t work
    self.theMovie.view.frame = CGRectMake(0, 0, 60, 60);
    self.theMovieImplemented.moviePlayer.fullscreen=NO;
    self.theMovieImplemented.moviePlayer.controlStyle=MPMovieControlStyleNone;
    //theMovie.view.contentMode=UIViewContentModeScaleToFill;
    self.theMovieImplemented.moviePlayer.scalingMode=MPMovieScalingModeFill;
    
    
    self.theMovieImplemented.moviePlayer.view.frame=CGRectMake(0, 0, 60, 60);
    self.theMovie.view.frame=CGRectMake(0, 0, 60, 60);
    [self.view addSubview:self.theMovieImplemented.moviePlayer.view];
    
    //Resize window – a bit more practical
//    UIWindow *moviePlayerWindow = nil;
//    moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
    //[moviePlayerWindow setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    // Play the movie.
    [self.theMovieImplemented.moviePlayer play];
    
    
}

-(void) desplegarVideo{
    
    /////////viendo commit
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"GangnamStyle" ofType:@"mov"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    self.theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    //Place it in subview, else it won’t work
    self.theMovie.view.frame = CGRectMake(0, 0, 60, 60);
    //theMovie.fullscreen=YES;
    self.theMovie.controlStyle=MPMovieControlStyleNone;
    //theMovie.view.contentMode=UIViewContentModeScaleToFill;
    self.theMovie.scalingMode=MPMovieScalingModeFill;
    
    
    
    
    [self.view addSubview:self.theMovie.view];
    //Resize window – a bit more practical
    UIWindow *moviePlayerWindow = nil;
    moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
    //[moviePlayerWindow setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    // Play the movie.
    [self.theMovie play];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"TOUCH VIEW CONTROLLER");
    NSLog(@"TOUCH VIEW CONTROLLER");
    NSLog(@"TOUCH VIEW CONTROLLER");
    
    
    if (self.touchFull) {
        self.touchFull=false;
        self.theMovie.controlStyle=MPMovieControlStyleNone;
        self.theMovie.fullscreen=NO;
        self.theMovie.scalingMode=MPMovieScalingModeFill;
        
    }else{
        self.touchFull=true;
        self.theMovie.controlStyle=MPMovieControlStyleNone;
        self.theMovie.fullscreen=YES;
        self.theMovie.scalingMode=MPMovieScalingModeFill;
    }
//    UITouch *touch=[touches anyObject];
//    
//    if ([touch tapCount] == 2) {
//        
//        self.texto.text=@"TOUCH 2 TIMES";
//        
//    }
    
    
}
- (void)viewDidLoad
{
    NSLog(@"view DID LOAD");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //agrego vistaTouch

    //[self desplegarVideoImplemented];
    [self desplegarVideo];
    
    self.vistaTouch = [[TouchVista alloc] init];
    self.vistaTouch.frame=CGRectMake(0, 0, 480, 320);
    [self.view addSubview:self.vistaTouch];
    [self.view bringSubviewToFront:self.vistaTouch];
}



- (void) viewWillDisappear:(BOOL)animated{
    NSLog(@"view WILL DIS");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
