//
//  ViewController.h
//  sendEmail
//
//  Created by encuadro augmented reality on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController  {
    IBOutlet UIButton *button;
    IBOutlet UITextField *messageText;
    IBOutlet UIButton *backgroundButton;
}

@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UITextField *messageText;
@property (nonatomic, retain) UIButton *backgroundButton;

-(IBAction)sendMail:(id)sender;
-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)backgroundClick:(id)sender;

@end