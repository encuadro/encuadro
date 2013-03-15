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
#import "NetworkManager.h"
#import "FTPUpload.h"
#import "ReaderSampleViewController.h"
#import "obtObras.h"
NSString *returnString;
@interface ImagenServerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    UIImageView *imagenView;
    UIButton *tomarFoto;
    
    
}


@property (nonatomic,retain)IBOutlet UIImageView *imagenView;
@property (nonatomic,retain)IBOutlet UIButton *tomarFoto;
-(IBAction)tomarFoto:(id)sender;

@property(nonatomic,retain)NSString *filePath;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;

//@property (retain, nonatomic) IBOutlet UIView *vista;
@property (retain, nonatomic) IBOutlet UILabel *mensaje;
-(IBAction)subir:(id)sender;
-(IBAction)tweet;
@end
