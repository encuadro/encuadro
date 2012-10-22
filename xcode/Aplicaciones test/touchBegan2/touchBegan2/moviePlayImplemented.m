//
//  moviePlayImplemented.m
//  app0100
//
//  Created by encuadro on 10/20/12.
//
//

#import "moviePlayImplemented.h"

@interface moviePlayImplemented ()

@end

@implementation moviePlayImplemented

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"TOUCH TOUCH MOVIE");
    NSLog(@"TOUCH TOUCH MOVIE");
    NSLog(@"TOUCH TOUCH MOVIE");
    NSLog(@"TOUCH TOUCH MOVIE");
    
    UITouch *touch=[touches anyObject];
    
    // if ([touch tapCount] == 1) {
    //        if (touchs) {
    //            touchs=false;
    //
    //        }else{
    //        touchs=true;
    //        }
    // }
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
