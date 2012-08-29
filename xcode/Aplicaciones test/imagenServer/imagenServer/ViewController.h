//
//  ViewController.h
//  imagenServer
//
//  Created by Pablo Flores Guridi on 16/08/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    UIImageView *imagenView;
    UIButton *tomarFoto;
    
    
}


@property (nonatomic,retain)IBOutlet UIImageView *imagenView;
@property (nonatomic,retain)IBOutlet UIButton *tomarFoto;


-(IBAction)tomarFoto:(id)sender;

@end
