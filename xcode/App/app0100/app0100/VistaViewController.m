//
//  VistaViewController.m
//  demo05
//
//  Created by encuadro augmented reality on 7/21/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "VistaViewController.h"



@interface VistaViewController ()

@end

@implementation VistaViewController
@synthesize window = _window;
@synthesize vistaStory = _vistaStory;
@synthesize vistaImg =_vistaImg;
@synthesize button = _button;
@synthesize HWview = _HWview;
@synthesize ARidObra = _ARidObra;
@synthesize ARType = _ARType;
@synthesize ARObj = _ARObj;

@synthesize vistaTouch = _vistaTouch;
@synthesize theMovieVista = _theMovieVista;

@synthesize backround;// = _backround;

@synthesize viewController = _viewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"INIT VISTA");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self addChildViewController:_viewController];
        [Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeRight;
        // Specify auto-rotation strategy if required (for example via the UIViewController and only landscape)
        [Isgl3dDirector sharedInstance].autoRotationStrategy =Isgl3dAutoRotationByUIViewController;
        [Isgl3dDirector sharedInstance].allowedAutoRotations = Isgl3dAllowedAutoRotationsLandscapeOnly;
    }
    return self;
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"TOUCH VISTA VIEWCONTROLLER");
//    NSLog(@"TOUCH VISTA VIEWCONTROLLER");
//    NSLog(@"TOUCH VISTA VIEWCONTROLLER");
//    
//    [super touchesBegan:touches withEvent:event];
//    
//  
//    
//    if (self.viewController.touchFull) {
//        NSLog(@" TOUCHFULL VISTA FALSE");
//        self.viewController.touchFull=false;
////        [self viewWillAppear:YES];
//        
//    }else{
//        NSLog(@" TOUCHFULL VISTA TRUE");
//        self.viewController.touchFull=true;
//        //self.view=_viewController.theMovie.view;
//        
////        [self viewWillDisappear:YES];
////        [self desplegarVideoVista];
//        
//
//        
//    }
//    
//    
//    
//    
//}


-(void) desplegarVideoVista{
    
    
    
    
    /////////viendo commit
    
    
    
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"GangnamStyle" ofType:@"mov"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    self.theMovieVista = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
   // self.theMovieVista=self.viewController.theMovie;
    //Place it in subview, else it won’t work
    self.theMovieVista.view.frame = CGRectMake(0, 0, 1024, 768);
    //theMovie.fullscreen=YES;
    self.theMovieVista.controlStyle=MPMovieControlStyleNone;
    //theMovie.view.contentMode=UIViewContentModeScaleToFill;
    self.theMovieVista.scalingMode=MPMovieScalingModeFill;
    
    
    [self.view addSubview:self.theMovieVista.view];
    //Resize window – a bit more practical
    UIWindow *moviePlayerWindow = nil;
    moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
    //[moviePlayerWindow setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    // Play the movie.
    [self.theMovieVista play];
    
    
}



//- (IBAction)hacerRender:(id)sender
- (void) hacerRender{
    
    
    
    
    NSLog(@"HACER RENDER VISTA");
    app0100AppDelegate *appDelegate = (app0100AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.viewController=(Isgl3dViewController*)appDelegate.viewController;
    
    if ([self.ARType isEqual:@"video"]) {
        _viewController.videoPlayer=true;
        _viewController.videoName=self.ARObj;
    }
   
    
    [self createViews];
    
    
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    [_viewController viewDidLoad];
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    
    self.viewController.videoView.alpha=0.0;
    self.viewController.view.alpha=0.0;
    
    //agrego video
    [self.view addSubview:self.viewController.videoView];
    [self.view bringSubviewToFront:self.viewController.videoView];
    
    //agrego render
    [self.view addSubview:self.viewController.view];
    [self.view bringSubviewToFront:self.viewController.view];
    self.viewController.view.opaque = NO;
    
    
    //agrego vistaTouch
//    self.vistaTouch = [[TouchVista alloc] init];
//    self.vistaTouch.frame=CGRectMake(0, 0, 480, 320);
//    [self.view addSubview:self.vistaTouch];
    
    

    [UIView animateWithDuration:4
                          delay:0.6
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.backround.transform = CGAffineTransformMakeScale(20,20);
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    
    
    
    [UIView animateWithDuration:5 delay:3 options: UIViewAnimationCurveEaseOut animations:^{
        backround.alpha = 0.0;
        self.viewController.videoView.alpha=1.0;
        self.viewController.view.alpha=1.0;
    } completion:^(BOOL finished){
        [backround removeFromSuperview];
         
    }];
    
    
    
    //activo procesamiento
   // _viewController.AugmReal=true;
    
    
    ////////BOTON
    
//    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [self.button addTarget:self 
//               action:@selector(buttonClicked:)
//     forControlEvents:UIControlEventTouchDown];
//    [self.button setTitle:@"Back to Story" forState:UIControlStateNormal];
//    self.button.frame = CGRectMake(50,50, 120.0, 50.0);
//    [self.viewController.view addSubview:self.button];
  

    ////////BOTON
    
   // [[Isgl3dDirector sharedInstance] startAnimation];
}




- (void) removeViews {
	   
    NSLog(@"REMOVE VIEWS VISTA");
	// Create view and add to Isgl3dDirector
	//Isgl3dView * view = [HelloWorldView view];
    
   
    
   // [self.view removeFromSuperview:self.HWview];
    
	[[Isgl3dDirector sharedInstance] removeView:self.viewController.isgl3DView];
    _viewController.isgl3DView = nil;
    [self.viewController.view removeFromSuperview];
    [self.HWview release];
}



- (void) createViews {
    NSLog(@"CREATE VIEWS");
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
    
	// Set the background transparent
	[Isgl3dDirector sharedInstance].backgroundColorString = @"00000000"; 
    
	// Create view and add to Isgl3dDirector
//    self.HWview =[[Isgl3dView alloc] init];
    NSLog(@"PRE INSTANCIA [HELLOWORLD VIEW]");
    
	//self.HWview = [HelloWorldView view];
    NSLog(@"POST INSTANCIA [HELLOWORLD VIEW]");
    printf("ArID desde VISTAVIEWCTRL: %d\n",[self.ARidObra intValue]);
    
    _viewController.isgl3DView =  [[HelloWorldView alloc] init:[self.ARidObra intValue] ARType:self.ARType ARObj:self.ARObj];
    
    [[Isgl3dDirector sharedInstance] addView:_viewController.isgl3DView];
    
    
}

//este metodo es igual a buttonclicked
- (void) buttonBACK {
NSLog(@"BUTTON BACK");
// _viewController.AugmReal=false;

    [self removeViews];
  
    [self.viewController.session stopRunning];
    [self.viewController.theMovie stop];
    self.viewController.theMovie=nil;
    [self.viewController.theMovie autorelease];

//////////////////////////////////////////////////////    

// applicationWillTerminate
// applicationWillTerminate
// applicationWillTerminate

[[Isgl3dDirector sharedInstance].openGLView removeFromSuperview];

// End and reset the director

//[Isgl3dDirector resetInstance];

// Release
[_viewController release];
_viewController = nil;
[_window release];
_window = nil;


// applicationWillTerminate
// applicationWillTerminate
// applicationWillTerminate


//////////////////////////////////////////////////////    
[[Isgl3dDirector sharedInstance] resume];


//self.view=Nil;


[_button release];
_button=nil;

}

//-(void)zoomInAndFadeOut{
//
//    [UIView animateWithDuration:4
//                          delay:0.6
//                        options: UIViewAnimationCurveEaseOut
//                     animations:^{
//                         backround.transform = CGAffineTransformMakeScale(20,20);
//                     }
//                     completion:^(BOOL finished){
//                         NSLog(@"Done!");
//                     }];
//    
//    
//    
//    
//    [UIView animateWithDuration:5 delay:3 options: UIViewAnimationCurveEaseOut animations:^{
//        backround.alpha = 0.0;
//    } completion:^(BOOL finished){
//        [backround removeFromSuperview];
//    }];
//    
//    
//}



- (void)viewDidLoad
{
    NSLog(@"VIEW DID LOAD VISTA");
    //NSLog(@"ARID OBRA ES: %@",self.ARidObra);
    [super viewDidLoad];
}


//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//
//
////[self buttonBACK];
//}



- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"WILL DIS VISTA");
    [super viewWillDisappear:animated];
    
    [self buttonBACK];
}
//
//
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"VIEW WILL APPEAR VISTA");
    [super viewWillAppear:animated];
   
    [self hacerRender];
    
   // [self.navigationController setNavigationBarHidden:NO animated:animated];
}



- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 
    NSLog(@"WILL Autorotate VISTA");
    [_viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{


     NSLog(@"DID Autorotate VISTA");

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"SHOULD Autorotate VISTA");
    return YES;
   
    
    
}

-(IBAction)TWeet:(id)sender{
    
    if([TWTweetComposeViewController canSendTweet]) {
        
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
        [controller setInitialText:@"Arte Interactivo. Realidad Aumentada desde App! @etchart_martin, @juanibraun, @PFloresGuridi, @MauriGoNappa, @juan_cardelino"];
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //[self.HWview renderInContext:UIGraphicsGetCurrentContext()];
        [self.viewController.videoView.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        [controller addImage:img];
        // [controller addImage:[UIImage imageNamed:@"jessica.jpeg"]];
        UIGraphicsEndImageContext();
        
        
        controller.completionHandler = ^(TWTweetComposeViewControllerResult result)  {
            
            [self dismissModalViewControllerAnimated:YES];
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    break;
                    
                case TWTweetComposeViewControllerResultDone:
                    break;
                    
                default:
                    break;
            }
        };
        
        [self presentModalViewController:controller animated:YES];
    }
    
    
    
}
@end
