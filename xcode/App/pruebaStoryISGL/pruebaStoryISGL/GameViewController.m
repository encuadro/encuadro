//
//  PauseMenuViewController.m
//  simon2
//
//  Created by Juan Cardelino on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "Isgl3d.h"
#import "Isgl3dAppDelegate.h"
#import "Isgl3dViewController.h"


#import <QuartzCore/QuartzCore.h>


#define VERBOSE


@interface GameViewController ()


@property (retain, nonatomic) NSTimer* timer;
@end

@implementation GameViewController

@synthesize foregroundMenuView=_foregroundMenuView;
@synthesize backgroundMenuView=_backgroundMenuView;
@synthesize hudView=_hudView;
@synthesize levelEndedView=_levelEndedView;
@synthesize gameEndedView=_gameEndedView;
@synthesize levelStartedView=_levelStartedView;
@synthesize level=_level;
@synthesize hudLabel=_hudLabel;
@synthesize timer=_timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		 NSLog(@"Initializing PauseViewController");
	
    }
    return self;
}

- (void)viewDidLoad
{
	
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
	Isgl3dViewController *vc=(Isgl3dViewController*)appDelegate.viewController;
	HelloWorldView *hv=vc.mainView;
	
	
	if (appDelegate)
	{
		
		[self.foregroundMenuView setOpaque:false];
		[self.foregroundMenuView setBackgroundColor:[UIColor clearColor]];
		
		[self.backgroundMenuView setBackgroundColor:[UIColor grayColor]];
	
		
		 
		self.backgroundMenuView.alpha=0.5;
		
		[self.backgroundMenuView removeFromSuperview];
		[self.foregroundMenuView removeFromSuperview];
		[self.hudView removeFromSuperview];
		[self.hudView setBackgroundColor:[UIColor clearColor]];
			
		[self.view addSubview:vc.view];
		[self.view bringSubviewToFront:vc.view];
	
		[[Isgl3dDirector sharedInstance] resume];
		[vc.view setNeedsDisplay];
		
		
		////////////////////////
		[self.view addSubview:self.backgroundMenuView];
		[self.view bringSubviewToFront:self.backgroundMenuView];
		[self.view addSubview:self.foregroundMenuView];
		[self.view bringSubviewToFront:self.foregroundMenuView];
		self.foregroundMenuView.hidden=NO;
		self.backgroundMenuView.hidden=NO;
		
		Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
		Isgl3dViewController *vc=(Isgl3dViewController*)appDelegate.viewController;
		[self.view addSubview:vc.view];
		[self.view bringSubviewToFront:vc.view];
		vc.view.opaque = NO;
		
		//pause menu
		
		UIView *view = (UIView*)[self.view viewWithTag:201];
	
		//ThemeConfiguration *theme=[[ThemeConfiguration alloc] init];
		
		
		[[Isgl3dDirector sharedInstance] resume];
	}

}

- (void) viewWillAppear:(BOOL)animated
{

}

- (void) viewDidAppear:(BOOL)animated
{
//correction of orientation
Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
Isgl3dViewController *vc=(Isgl3dViewController*)appDelegate.viewController;
NSLog(@"orientation: %d",vc.interfaceOrientation);
[vc willRotateToInterfaceOrientation:vc.interfaceOrientation duration:0];
}



- (void)updateHUD:(NSString *)msg
{
	//NSLog(@"PVC updateHUD");
	self.hudLabel.text=msg;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	NSLog(@"GameViewController viewDidUnload");
    // Release any retained subviews of the main view.
	/*
	Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
	Isgl3dViewController *vc=(Isgl3dViewController*)appDelegate.viewController;
	[vc.view removeFromSuperview];
	 */
}




- (IBAction)startGameTime
{

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PauseToGame"])
	{
		Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
		Isgl3dViewController* vc=(Isgl3dViewController*)appDelegate.viewController;
		
		
		GameViewController *nc =segue.destinationViewController;
		[nc.view addSubview:vc.view];
		[nc.view bringSubviewToFront:nc.hudView];
	}
}

- (IBAction) skipLevel
{
	NSLog(@"GameViewController skipLevel");

}


-(IBAction) showPauseMenu
{
	//	#define USE_EXTERNAL_MENUS
#ifndef USE_EXTERNAL_MENUS
	[self.view addSubview:self.backgroundMenuView];
	[self.view bringSubviewToFront:self.backgroundMenuView];
	[self.view addSubview:self.foregroundMenuView];
	[self.view bringSubviewToFront:self.foregroundMenuView];
	self.foregroundMenuView.hidden=NO;
	self.backgroundMenuView.hidden=YES;
	
	Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
	Isgl3dViewController *vc=(Isgl3dViewController*)appDelegate.viewController;
	[self.view addSubview:vc.view];
	[self.view bringSubviewToFront:vc.view];
	vc.view.opaque = NO;
	
	//pause menu
	
	UIView *view = (UIView*)[self.view viewWithTag:201];

	
	[[Isgl3dDirector sharedInstance] pause];
#else
	
	[self performSegueWithIdentifier:@"PauseMenu" sender:self];
#endif
}

-(IBAction) resumePause
{
#undef USE_EXTERNAL_MENUS
#ifndef USE_EXTERNAL_MENUS
	//[self.view addSubview:self.backgroundMenuView];
	//[self.view bringSubviewToFront:self.backgroundMenuView];
	//[self.view addSubview:self.foregroundMenuView];
	//[self.view bringSubviewToFront:self.foregroundMenuView];
	self.foregroundMenuView.hidden=YES;
	self.backgroundMenuView.hidden=YES;
	[[Isgl3dDirector sharedInstance] resume];
#else
	
	//[self performSegueWithIdentifier:@"PauseMenu" sender:self];
#endif
}

-(IBAction) continueToNextLevel
{

}

- (IBAction)buttonAugment
{
	
}

- (IBAction)exitButton
{

}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
	
	NSLog(@"GameViewController willRotateToInterfaceOrientation");
#if 1
	Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate]; 
	[appDelegate.viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
#endif
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//NSLog(@"observed game changed state");
	//NSLog(@"keyPath: %@",keyPath);
	if([keyPath isEqualToString:@"gameState"])
		[self reactToGameState:keyPath ofObject:object change:change context:context];
	if([keyPath isEqualToString:@"status"])
		[self reactToHUDStatus:keyPath ofObject:object change:change context:context];	
	
}

-(void)reactToGameState:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
	//NSLog(@"New property value: %@.", newValue);
	NSObject *o=(NSObject *)newValue;
	NSString *str=[o description];
	//NSLog(@"New property value: %@.", str);
	Class *c=[newValue class];
	//NSLog(@"class: %@.", c);
	NSNumber *n=(NSNumber *)newValue;
	int state=[n intValue];
	//NSLog(@"New property value: %d.", state);
	
	switch(state)
	{
		case 0:
			[self displayStartLevel:@"Starting level #1"];
			break;
		case 1:
			[self displayEndLevel:@"Congratulations!"];
			break;
		case 2:
			[self displayEndGame:0];
			break;
		case 3:
			[self displayEndGame:1];
			break;
		default:
			NSLog(@"Unknown state");
			break;
	}
}


-(void)reactToHUDStatus:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
	//NSLog(@"New property value: %@.", newValue);
	NSObject *o=(NSObject *)newValue;
	NSString *str=[o description];
	//NSLog(@"New property value: %@.", str);
	[self updateHUD:str];

}


- (void)displayStartLevel:(NSString *)msg
{
	NSLog(@"displayStartLevel: %@",msg);
	
	
	[self.view addSubview:self.backgroundMenuView];
	[self.view bringSubviewToFront:self.backgroundMenuView];
	[self.view addSubview:self.levelStartedView];
	[self.view bringSubviewToFront:self.levelStartedView];
	self.backgroundMenuView.hidden=NO;
	self.levelStartedView.hidden=NO;
	
	
	Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
	Isgl3dViewController* vc=appDelegate.viewController;
	HelloWorldView *hv=vc.mainView;
	
	UIView *view = (UIView*)[self.levelStartedView viewWithTag:401];


	
	UILabel *title = (UILabel*)[self.view viewWithTag:402];
	UILabel *description = (UILabel*)[self.view viewWithTag:403];
	
		
	[[Isgl3dDirector sharedInstance] pause];

}

- (void)displayEndLevel:(NSString *)msg
{
	//NSString *msg;
	NSString *msg_desc=@"Level completed successfully.";
	UIColor *c;
	
	NSLog(@"displayEndLevel");
	
	[self.view addSubview:self.backgroundMenuView];
	[self.view bringSubviewToFront:self.backgroundMenuView];
	[self.view addSubview:self.foregroundMenuView];
	[self.view bringSubviewToFront:self.levelEndedView];
	
	
	UIView *view = (UIView*)[self.view viewWithTag:301];
	UILabel *title = (UILabel*)[self.view viewWithTag:302];
	UILabel *description = (UILabel*)[self.view viewWithTag:303];
	
	title.text=msg;
	description.text=msg_desc;
	c=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
	[view setBackgroundColor:c];
	

	
	self.levelEndedView.hidden=NO;
	self.backgroundMenuView.hidden=NO;
	
	

	
	//save user state
	Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
	Isgl3dViewController *vc=(Isgl3dViewController*)appDelegate.viewController;
	HelloWorldView *hv=vc.mainView;

		//save data to disc

	
	[[Isgl3dDirector sharedInstance] pause];
}



- (IBAction)cameraLeft:(id)sender
{
	NSLog(@"cameraLeft");
	
	
	Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
	Isgl3dViewController *vc=(Isgl3dViewController*)appDelegate.viewController;
	
	//[vc.mainView moveCameraFree];
	[vc.mainView camera_left_right:0];
	
}


- (IBAction)cameraRight:(id)sender
{
	NSLog(@"cameraRight");
	
	
	Isgl3dAppDelegate *appDelegate = (Isgl3dAppDelegate *)[[UIApplication sharedApplication] delegate];
	Isgl3dViewController *vc=(Isgl3dViewController*)appDelegate.viewController;
	
	//[vc.mainView moveCameraFree];
	[vc.mainView camera_left_right:1];
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)cameraL:(id)sender
{
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(cameraLeft:) userInfo:nil repeats:YES];
}

-(IBAction)cameraR:(id)sender
{
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(cameraRight:) userInfo:nil repeats:YES];
}

-(IBAction)touchesEnded:(id)sender
{
   if (self.timer != nil) 
      [self.timer invalidate];
	self.timer = nil;
}


@end
