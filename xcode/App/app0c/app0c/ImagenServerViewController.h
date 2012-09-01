//
//  ImagenServerViewController.h
//  app0c
//
//  Created by encuadro augmented reality on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ReaderSampleViewController.h"
#import "ObraCompletaViewController.h"
NSString *returnString;
@interface ImagenServerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    UIImageView *imagenView;
    UIButton *tomarFoto;
    
    
}


@property (nonatomic,retain)IBOutlet UIImageView *imagenView;
@property (nonatomic,retain)IBOutlet UIButton *tomarFoto;
-(IBAction)tomarFoto:(id)sender;


@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;

//@property (retain, nonatomic) IBOutlet UIView *vista;
@property (retain, nonatomic) IBOutlet UILabel *mensaje;

@end
