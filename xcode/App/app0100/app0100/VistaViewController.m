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

@synthesize vistaTouch = _vistaTouch;

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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"TOUCH VISTA VIEWCONTROLLER");
    NSLog(@"TOUCH VISTA VIEWCONTROLLER");
    NSLog(@"TOUCH VISTA VIEWCONTROLLER");
    
    [super touchesBegan:touches withEvent:event];
    
  
    
    if (self.viewController.touchFull) {
        NSLog(@" TOUCHFULL VISTA FALSE");
        self.viewController.touchFull=false;
        
    }else{
        NSLog(@" TOUCHFULL VISTA TRUE");
        self.viewController.touchFull=true;
    }
    
    
    
    
}



//- (IBAction)hacerRender:(id)sender
- (void) hacerRender{
    NSLog(@"HACER RENDER VISTA");
    app0100AppDelegate *appDelegate = (app0100AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.viewController=(Isgl3dViewController*)appDelegate.viewController;
    
    
    if ([self.ARidObra intValue]<5){
        NSLog(@"AR DOS CUBOS");
        DosCubos=true;
        _viewController.videoPlayer=false;
        [self createViews];
        
     }else if([self.ARidObra intValue]>10) {
        NSLog(@"AR UN CUBO y MODELOS");
        DosCubos=false;
        _viewController.videoPlayer=false;
        [self createViews];
        
    }else{
        DosCubos=false;
        NSLog(@"AR VIDEO");
        
        _viewController.videoPlayer=true;
    }
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    [_viewController viewDidLoad];
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////

 
    
    //agrego video
    [self.view addSubview:self.viewController.videoView];
    [self.view bringSubviewToFront:self.viewController.videoView];
    
    //agrego render
    [self.view addSubview:self.viewController.view];
    [self.view bringSubviewToFront:self.viewController.view];
    self.viewController.view.opaque = NO;
    

    //agrego vistaTouch
    self.vistaTouch = [[TouchVista alloc] init];
    self.vistaTouch.frame=CGRectMake(0, 0, 480, 320);
    [self.view addSubview:self.vistaTouch];
    
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
    
    [self.viewController.view removeFromSuperview];
   // [self.view removeFromSuperview:self.HWview];
    _viewController.isgl3DView = nil;
	[[Isgl3dDirector sharedInstance] removeView:self.HWview];
    [self.HWview release];
}



- (void) createViews {
    NSLog(@"CREATE VIEWS");
	// Set the device orientation
	[Isgl3dDirector sharedInstance].deviceOrientation = Isgl3dOrientationLandscapeLeft;
    
	// Set the background transparent
	[Isgl3dDirector sharedInstance].backgroundColorString = @"00000000"; 
    
	// Create view and add to Isgl3dDirector
    self.HWview =[[Isgl3dView alloc] init];
    NSLog(@"PRE INSTANCIA [HELLOWORLD VIEW]");
    //[HelloWorldView s]
	self.HWview = [HelloWorldView view];
    NSLog(@"POST INSTANCIA [HELLOWORLD VIEW]");
    _viewController.isgl3DView = self.HWview;
	[[Isgl3dDirector sharedInstance] addView:self.HWview];
}

//este metodo es igual a buttonclicked
- (void) buttonBACK {
NSLog(@"BUTTON BACK");
// _viewController.AugmReal=false;

    [self removeViews];

    [self.viewController.session stopRunning];
    [self.viewController.theMovie stop];

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

@end
