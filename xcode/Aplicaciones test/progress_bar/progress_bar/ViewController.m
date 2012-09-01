//
//  ViewController.m
//  progress_bar
//
//  Created by Pablo Flores Guridi on 01/09/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *animate;
@property (weak, nonatomic) IBOutlet UIButton *stop;


@end

@implementation ViewController
@synthesize activity;
@synthesize animate;
@synthesize stop;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activity]; // spinner is not visible until started
      activity.center = CGPointMake(160, 100);

    // [activity setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // I do this because I'm in landscape mode

    // Release any retained subviews of the main view.
}
- (IBAction)animate:(id)sender {
        
    [activity startAnimating];
}

- (IBAction)stop:(id)sender {
    [activity stopAnimating];
}


- (void)viewDidUnload
{
    [self setActivity:nil];
    [self setAnimate:nil];
    [self setStop:nil];
    [super viewDidUnload];

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
