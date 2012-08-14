//
//  ViewController.h
//  siftConCamara
//
//  Created by Pablo Flores Guridi on 13/08/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sift.h"
#import "pgm.h"
//#import "vl/mathop.h"
#import "processing.h"
#import "generic.h"
#import "encuadroSift.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *dir;
@property (weak, nonatomic) IBOutlet UIImageView *despliegue;
@property (weak, nonatomic) IBOutlet UIButton *leer;
@property (weak, nonatomic) IBOutlet UIButton *leerPuntoC;

@end
