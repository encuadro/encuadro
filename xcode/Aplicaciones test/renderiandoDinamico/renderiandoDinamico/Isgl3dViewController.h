//
//  Isgl3dViewController.h
//  renderiandoDinamico
//
//  Created by Pablo Flores Guridi on 18/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloWorldView.h"


#import <stdlib.h>


@interface Isgl3dViewController : UIViewController{
    
}

@property (readwrite, retain) IBOutlet UIImageView* imagenView;
@property (readwrite, retain) IBOutlet HelloWorldView* isgl3DView;

@end
