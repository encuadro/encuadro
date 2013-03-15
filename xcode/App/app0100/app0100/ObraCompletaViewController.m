//
//  ObraCompletaViewController.m
//  TableViewStory
//
//  Created by encuadro augmented reality on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObraCompletaViewController.h"

@interface ObraCompletaViewController ()

@end

@implementation ObraCompletaViewController
@synthesize obra = _obra;
@synthesize autor = _autor;
@synthesize imagenObra = _imagenObra;
@synthesize detalle = _detalle;
@synthesize texto = _texto;
@synthesize audioPlayer = _audioPlayer;
@synthesize start, AR, tw;
@synthesize mano1;
@synthesize mano4;
@synthesize upsi;
@synthesize vistaTouch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"TOUCH OBRA ");
    NSLog(@"TOUCH OBRA ");
    NSLog(@"TOUCH OBRA ");
    
    if (self.vistaTouch.touchman) {
        //call segue
        //DrawSign *drawS = [[DrawSign alloc] init];
        
        // do any setup you need for myNewVC
        //[self performSegueWithIdentifier: @"todraw" sender: self];
        //[self presentViewController:drawS animated:YES completion:NO];
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    conUpsi=true;
//    if (manual==true) {
//        
//        //CAMINO MANUAL
//        self.autor.text = [self.descripcionObra objectAtIndex:0];
//        
//        // self.obra.text = [self.descripcionObra objectAtIndex:1];
//        
//        self.imagenObra.image = [UIImage imageNamed: 
//                                 [self.descripcionObra objectAtIndex:2]];
//        self.detalle.text=[self.descripcionObra objectAtIndex:3];
//        
//        
//
//    }else {
        //CAMINO AUTOMATICO
        
        
        
        /*NSString *filePath = [self.descripcionObra objectAtIndex:0];
        NSData* textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
        NSString* text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
        self.autor.text=text;
        
        filePath= [self.descripcionObra objectAtIndex:1];
        textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
        text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
        self.obra.text=text;
        
        
        filePath= [self.descripcionObra objectAtIndex:2];
        textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
        UIImage *imagen =  [[UIImage alloc] initWithData:textData];
        self.imagenObra.image=imagen;
        
        
        filePath= [self.descripcionObra objectAtIndex:3];
        textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
        text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
        self.detalle.text=text;*/
//    }
    
    justLoaded=true;
    

//    [UIView animateWithDuration:1
//                          delay:0.3
//                        options: UIViewAnimationCurveEaseOut
//                     animations:^{
//                         mano1.center=CGPointMake(-100,150);
//                         mano4.center=CGPointMake(700,150);
//                     }
//                     completion:^(BOOL finished){
//                         NSLog(@"Done!");
//                     }];
//    //agrego vistaTouch
//    self.vistaTouch = [[TouchVista alloc] init];
//    self.vistaTouch.obraCompleta=true;
//    self.vistaTouch.frame=CGRectMake(600,650,500, 500);
//    [self.view addSubview:self.vistaTouch];
//    
//    upsi.center=CGPointMake(950,1000);
//    if (conUpsi) {
//        [UIView animateWithDuration:2
//                              delay:0.6
//                            options: UIViewAnimationCurveEaseOut
//                         animations:^{
//                             
//                             upsi.center=CGPointMake(950,950);
//                             
//                             
//                         }
//                         completion:^(BOOL finished){
//                             NSLog(@"Done!");
//                             self.vistaTouch.frame=CGRectMake(900,650,500, 500);
//                             [self UpsiAppear];
//                         }];
//    }
    
    
    


}

- (void)UpsiAppear
{
    
    //upsi.center=CGPointMake(950,1000);
    if (conUpsi) {
        [UIView animateWithDuration:2
                              delay:0.6
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             
                             upsi.center=CGPointMake(950,700);
                             
                             
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                            // self.vistaTouch.frame=CGRectMake(750,500,200, 200);
                            // [self UpsiUpMoveLeft];
                         }];
    }

}


- (void)UpsiUpMoveLeft
{
    
    [UIView animateWithDuration:1
                          delay:0.6
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         //upsi.transform=CGAffineTransformRotate(upsi.transform, M_PI);
                         
                         upsi.center=CGPointMake(400,700);
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         //upsi.transform=CGAffineTransformRotate(upsi.transform, M_PI);
                         self.vistaTouch.frame=CGRectMake(200,500, 200, 200);
                         [self UpsiDownMoveLeft];
                     }];
}

- (void)UpsiDownMoveLeft
{
    
    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         //upsi.transform=CGAffineTransformRotate(upsi.transform, M_PI);
                         
                         upsi.center=CGPointMake(950,1500);
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         //upsi.transform=CGAffineTransformRotate(upsi.transform, M_PI);
                         self.vistaTouch.frame=CGRectMake(1000,1000, 100, 100);
                         [self UpsiAppear];
                     }];
}

- (void)UpsiDisAppear
{
    
    [UIView animateWithDuration:1
                          delay:1
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         upsi.center=CGPointMake(400,340);
                         
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         self.vistaTouch.frame=CGRectMake(370,320, 100, 100);
                         [self UpsiAppear];
                     }];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) play{
    if([[descripcionObra objectAtIndex:4] isEqualToString:@"null"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Atención!" message:@"No esta disponible ningun audio para esta obra." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if (click==0 || justLoaded) {
            // audioPlayer=nil;
            justLoaded=false;
            click=1;
            NSString *estring=[descripcionObra objectAtIndex:4];
            //NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],estring]];
            NSURL *url = [NSURL fileURLWithPath:estring];
            //  NSURL *url = [[NSURL alloc] initFileURLWithPath:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"];
            // NSURL *url =[NSURL fileURLWithPath:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"];
            // NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"]];
            NSError *error;
            self.audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            self.audioPlayer.numberOfLoops=0;
            [self.audioPlayer play];
            [self.start setTitle:@"Stop"/* forState:UIControlStateNormal*/];
        }else {
            //audioPlayer=nil;
            [self.audioPlayer stop];
            click=0;
            [self.start setTitle:@"Audio"/* forState:UIControlStateNormal*/];
    }
    }
    
}

-(IBAction)tweet{
    if([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
        UIImage *img = self.imagenObra.image;
        [controller addImage:img];
        [controller setInitialText:[NSString stringWithFormat:@"Arte Interactivo. Tweeting desde App! @encuadroAR #%@ #%@", [descripcionObra objectAtIndex:0], [descripcionObra objectAtIndex:1]]];
        //UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        //[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        //[controller addImage:[UIImage imageNamed:@"jessica.jpeg"]];
        //UIGraphicsEndImageContext();
        controller.completionHandler = ^(TWTweetComposeViewControllerResult result)  {
            [self dismissModalViewControllerAnimated:YES];
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    NSLog(@"Twitter Result: cancelled");
                    break;
                case TWTweetComposeViewControllerResultDone:
                    NSLog(@"Twitter Result: sent");
                    break;
                default:
                    NSLog(@"Twitter Result: default");
                    break;
            }
        };
        [self presentModalViewController:controller animated:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWILL APPEAR");
    self.vistaTouch.touchman=false;
    [actInd startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        NSMutableString *autorNombre = [[NSMutableString alloc] init];
        [autorNombre appendString:[descripcionObra objectAtIndex:0]];
        [autorNombre appendString:@" - "];
        [autorNombre appendString:[descripcionObra objectAtIndex:1]];
        self.autor.text=autorNombre;
        self.obra.text=[descripcionObra objectAtIndex:1];
        UIImage *imagen =  [UIImage imageWithContentsOfFile:[descripcionObra objectAtIndex:2]];
        self.imagenObra.image=imagen;
        self.detalle.text = [descripcionObra objectAtIndex:3];
        [descripcionObra addObject:[oo getAudio]];
        [descripcionObra addObject:[oo getVideo]];
        [descripcionObra addObject:[oo getTexto]];
        self.texto.text = [descripcionObra objectAtIndex:6];
        [descripcionObra addObject:[oo getModelo]];
        [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:0]];
        [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:1]];
        [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:2]];
        [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:3]];
        [descripcionObra addObject:[[oo getAnimaciones] objectAtIndex:4]];
        if([descripcionObra objectAtIndex:12] != NULL){
            [actInd stopAnimating];
            [self.autor setHidden:NO];
            [self.detalle setHidden:NO];
            [self.start setEnabled:YES];
            [self.AR setEnabled:YES];
            [self.tw setEnabled:YES];
            if(![[descripcionObra objectAtIndex:6] isEqualToString:@"null"])
                [self.texto setHidden:NO];
        }
    });

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (click!=0) {
        [self.audioPlayer stop];
        click=0;
        [self.start setTitle:@"Start"/* forState:UIControlStateNormal*/];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"AR"])
    {
        if (click!=0) {
            [self.audioPlayer stop];
            click=0;
            [self.start setTitle:@"Start" forState:UIControlStateNormal];
        }
        
        VistaViewController *ARVistaViewController =
        [segue destinationViewController];
        
       /*
        NSString *filePath = [self.descripcionObra objectAtIndex:5];
        NSData* textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
        NSString* text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
        ARVistaViewController.ARidObra=text;
        
        filePath = [self.descripcionObra objectAtIndex:6];
        textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
        text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
        ARVistaViewController.ARType=text;
        
        filePath = [self.descripcionObra objectAtIndex:7];
        textData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:filePath]];
        text = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
        ARVistaViewController.ARObj=text;
    
        */
    }
}

@end
