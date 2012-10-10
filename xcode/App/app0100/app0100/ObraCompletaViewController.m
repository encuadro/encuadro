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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

@end
