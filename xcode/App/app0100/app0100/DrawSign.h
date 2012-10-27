//
//  DrawSign.h
//  app0100
//
//  Created by encuadro on 10/27/12.
//
//

#import <UIKit/UIKit.h>

@interface DrawSign : UIViewController{
    CGPoint point;
    UIImageView *image;
    BOOL mouseSwiped;
    int mouseMoved;
}
@property (retain, nonatomic)IBOutlet UIImageView *image;

@end
