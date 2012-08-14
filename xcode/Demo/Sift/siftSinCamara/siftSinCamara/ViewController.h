//
//  ViewController.h
//  siftSinCamara
//
//  Created by Pablo Flores Guridi on 12/07/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sift.h"
#import "vl/pgm.h"
//#import "vl/mathop.h"
#import "processing.h"
#import "vl/generic.h"
#import "encuadroSift.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *dir;
@property (weak, nonatomic) IBOutlet UIImageView *despliegue;
@property (weak, nonatomic) IBOutlet UIButton *leer;
@property (weak, nonatomic) IBOutlet UIButton *leerPuntoC;

@end
