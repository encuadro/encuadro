//
//  InicioViewController.m
//  app0c
//
//  Created by encuadro augmented reality on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InicioViewController.h"

@interface InicioViewController ()

@end

@implementation InicioViewController
@synthesize audioPlayer,start;
@synthesize basketTop;
@synthesize basketBottom;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction) play{
    
    if (click==0) {
        // audioPlayer=nil;
        click=1;
        NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Adele - Rolling In The Deep.mp3", [[NSBundle mainBundle] resourcePath]]];
        NSError *error;
        audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops=0;
        [audioPlayer play];
        
        [start setTitle:@"Stop" forState:UIControlStateNormal];
        
    }else {
        //audioPlayer=nil;
        [audioPlayer stop];
        click=0;
        [start setTitle:@"Instrucciones" forState:UIControlStateNormal];
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect basketTopFrame = basketTop.frame;
    basketTopFrame.origin.x = -basketTopFrame.size.width;
    
    CGRect basketBottomFrame = basketBottom.frame;
    basketBottomFrame.origin.y = self.view.bounds.size.height;
    

    [UIView animateWithDuration:1
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         basketTop.frame = basketTopFrame;
                         basketBottom.frame = basketBottomFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    

    
    
    
    
    
   
    
    
}

-(BOOL)shouldAutorotate
{
    NSLog(@"shouldAutorotate INICIO");
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"supportedInterfaceOrientations INICIO");
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"preferredInterfaceOrientationForPresentation INICIO");
    return UIInterfaceOrientationLandscapeRight;
}



//REIMPLEMENTED
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    NSLog(@"WILL ROTATE INICIO");


}

//REIMPLEMENTED
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

    NSLog(@"DID ROTATE INICIO");

}


- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if ([[segue identifier] isEqualToString:@"Fow"])
  //  {
        [audioPlayer stop];
        click=0;
        [start setTitle:@"Instrucciones" forState:UIControlStateNormal];
     // }
}


@end
