//
//  TouchVista.m
//  app0100
//
//  Created by encuadro on 10/20/12.
//
//

#import "TouchVista.h"

@implementation TouchVista

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"TOUCH VISTA ");
    NSLog(@"TOUCH VISTA ");
    NSLog(@"TOUCH VISTA ");
    
    [super touchesBegan:touches withEvent:event];
    
    
}



//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"TOUCH TOUCH");
//    NSLog(@"TOUCH TOUCH");
//    NSLog(@"TOUCH TOUCH");
//    NSLog(@"TOUCH TOUCH");
    
//    UITouch *touch=[touches anyObject];
    
   // if ([touch tapCount] == 1) {
//        if (touchs) {
//            touchs=false;
//            
//        }else{
//        touchs=true;
//        }
   // }
    
    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
