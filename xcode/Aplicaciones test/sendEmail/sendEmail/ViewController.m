//
//  ViewController.m
//  sendEmail
//
//  Created by encuadro augmented reality on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize button, messageText, backgroundButton;

-(IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

-(IBAction)backgroundClick:(id)sender {
    [messageText resignFirstResponder]; 
}

-(void)displayAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"Thank you for contacting me" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageText setText:@""];
    [alert show];
   // [alert release];
}

-(void)displaySheet {
    NSString *msg = nil;
    msg = [[NSString alloc] initWithFormat:@"Send Email? Your message:\"%@\"", messageText.text];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:msg delegate:self cancelButtonTitle:@"Not yet" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
 //   [actionSheet release];
 //   [msg release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if( !(buttonIndex == [actionSheet cancelButtonIndex]) ){
        NSString *post = nil;
        post = [[NSString alloc] initWithFormat:@"message=%@",messageText.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *request;
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://silviaguridi99.no-ip.info/sendemail.php"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [ NSURLConnection connectionWithRequest:request delegate:self ];
        
       // [post release];
        [self displayAlert];
    }
}

-(IBAction)sendMail:(id)sender { 
    [self displaySheet];
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
