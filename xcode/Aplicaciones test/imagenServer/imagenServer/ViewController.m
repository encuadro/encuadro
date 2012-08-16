//
//  ViewController.m
//  imagenServer
//
//  Created by Pablo Flores Guridi on 16/08/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UIButton *read;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation ViewController
@synthesize url = _url;
@synthesize read =_read;
@synthesize image = _image;

- (IBAction)pressed:(id)sender
{
    [self.url resignFirstResponder];
    
    NSString* imageURL =self.url.text ;
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
    
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [self.image setImage:image];


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
