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
@synthesize descripcionObra = _descripcionObra;
@synthesize detalle = _detalle;
@synthesize audioPlayer = _audioPlayer;
@synthesize start = _start;
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
        [self performSegueWithIdentifier: @"todraw" sender: self];
        //[self presentViewController:drawS animated:YES completion:NO];
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (manual==true) {
        
        //CAMINO MANUAL
        self.autor.text = [self.descripcionObra objectAtIndex:0];
        
        // self.obra.text = [self.descripcionObra objectAtIndex:1];
        
        self.imagenObra.image = [UIImage imageNamed: 
                                 [self.descripcionObra objectAtIndex:2]];
        self.detalle.text=[self.descripcionObra objectAtIndex:3];
        
        

    }else {
        //CAMINO AUTOMATICO
        
        
        
        NSString *filePath = [self.descripcionObra objectAtIndex:0];
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
        self.detalle.text=text;
    }
    
    justLoaded=true;
    

    [UIView animateWithDuration:1
                          delay:0.3
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         mano1.center=CGPointMake(-100,150);
                         mano4.center=CGPointMake(700,150);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    upsi.center=CGPointMake(400,340);
    [UIView animateWithDuration:3
                          delay:0.6
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         upsi.center=CGPointMake(400,270);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    //agrego vistaTouch
    self.vistaTouch = [[TouchVista alloc] init];
    self.vistaTouch.obraCompleta=true;
    self.vistaTouch.frame=CGRectMake(370,240, 100, 100);
    [self.view addSubview:self.vistaTouch];


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
    
    if (click==0 || justLoaded) {
        // audioPlayer=nil;
        justLoaded=false;
        click=1;
        NSString *estring=[self.descripcionObra objectAtIndex:4];
        
        NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],estring]];
       
        //  NSURL *url = [[NSURL alloc] initFileURLWithPath:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"];
       // NSURL *url =[NSURL fileURLWithPath:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"];
       // NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/encuadro/Music/CAMPO/02 1987.mp3"]];
                
        NSError *error;
        self.audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.numberOfLoops=0;
        [self.audioPlayer play];
        
        [self.start setTitle:@"Stop" forState:UIControlStateNormal];
        
    }else {
        //audioPlayer=nil;
        [self.audioPlayer stop];
        click=0;
        [self.start setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (click!=0) {
        [self.audioPlayer stop];
        click=0;
        [self.start setTitle:@"Start" forState:UIControlStateNormal];
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
        
        //falta ver como asignar el ARidObra
       ARVistaViewController.ARidObra=[self.descripcionObra objectAtIndex:5];
    
    }
}

@end
