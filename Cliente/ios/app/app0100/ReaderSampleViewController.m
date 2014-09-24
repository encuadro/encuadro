//
//  ReaderSampleViewController.m
//  ReaderSample
//
//  Created by spadix on 4/14/11.
//

#import "ReaderSampleViewController.h"

@implementation ReaderSampleViewController

@synthesize resultImage, resultText,site, audioPlayer,start, backround, nombreSala,identObra, tweet, actInd;
@synthesize string=_string;
@synthesize AuxTipoRecorridoSVC = _AuxTipoRecorridoSVC;
@synthesize AuxSiguientePEscanear = _AuxSiguientePEscanear;
@synthesize AuxJEscanear = _AuxJEscanear;
@synthesize AuxContarJEscanear = _AuxContarJEscanear;
@synthesize AuxHoraJEscanear = _AuxHoraJEscanear;

- (IBAction) scanButtonTapped
{

    
   
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    //[self presentModalViewController: reader animated: YES];
    [self presentViewController:reader animated:YES completion:nil];

   // [reader release];
        
    
    
    
    
}

- (IBAction) play{
 
    if (click==0) {
       // audioPlayer=nil;
        click=1;
        NSURL *url =[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Adele - Rolling In The Deep.mp3", [[NSBundle mainBundle] resourcePath]]];
        NSError *error;
        audioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops=0;
        [audioPlayer play];
        
        [start setTitle:@"Stop" forState:UIControlStateNormal];
        
    }else {
        //audioPlayer=nil;
        [audioPlayer stop];
        click=0;
        [start setTitle:@"Start" forState:UIControlStateNormal];
    }
   

}

-(IBAction)tweeti{
    if([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
        UIImage *img = resultImage.image;
        [controller addImage:img];
        [controller setInitialText:[NSString stringWithFormat:@"Arte Interactivo. Tweet desde app! En sala #%@ @encuadroAR",  self.nombreSala.text]];
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
//- (IBAction) enCuadroSite:(id)sender { 
//    
//    NSURL *url = [ [ NSURL alloc ] initWithString:site];  
//    [[UIApplication sharedApplication] openURL:url];  
//}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    

    NSLog(@"IMAGE PICKER");
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode

               break;
    
    NSLog(@"IMAGE BREAK");
    
    //Aca vendria la busqueda en base de datos del texto del QR
//
    
    self.string=symbol.data;
 NSLog(@"IMAGE SYMBOL");
    opcionAutor = self.string;
    if(opcionAutor != NULL){
        //UIAlertView *alertWithOkButton;
        [actInd startAnimating];
        obtSalas *os = [[obtSalas alloc]initWithString:opcionAutor];
        while(!finSal) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        /*if([[[os getNom] objectAtIndex:0] isEqualToString:@""]){
            UIAlertView *alertWithOkButton = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"El id del QR detectado no es una sala disponible." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertWithOkButton show];
            [alertWithOkButton release];
        }
        else{*/
        //alertWithOkButton = [[UIAlertView alloc] initWithTitle:@"QR Detectado!"                                                       message:@"Presione Foward para reconocer cuadro" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alertWithOkButton show];
        //[alertWithOkButton release];
        if([[[os getNom] objectAtIndex:0] isEqualToString:@"-1"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atención!" message:@"Ocurrió un error al obtener los datos o no existe la sala." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            [identObra setEnabled:YES];
            [tweet setEnabled:YES];
            NSMutableArray *obtNombre = [os getNom];
            NSMutableArray *obtDesc = [os getDesc];
            NSMutableArray *obtImagen = [os getIma];
            resultText.text = [obtDesc objectAtIndex:0];
            [resultText setHidden:NO];
            room = [obtNombre objectAtIndex:0];
            cad = [obtImagen objectAtIndex:0];
            self.nombreSala.text = [obtNombre objectAtIndex:0];
            [self.nombreSala setHidden:NO];
            UIImage *cuadroPhoto = [UIImage imageWithContentsOfFile:cad];
            resultImage.image = cuadroPhoto;
            [reader dismissViewControllerAnimated:YES completion:nil];
            opcionAutor = self.string;
            [actInd stopAnimating];
        }
            
        //}
    }

   /* if ([string rangeOfString:@"BLANES"].location != NSNotFound) {
        //zona BLANES

        resultText.text = symbol.data;
        site=@"http://www.mnav.gub.uy/cms.php?a=1";
        opcionAutor=1;
        room=@"blanes";
        cad=@"AutorBlanes.jpeg";
        
       
    } else if ([string rangeOfString:@"FIGARI"].location != NSNotFound) {
        //zona FIGARI
        
        resultText.text = symbol.data;
        site=@"http://www.mnav.gub.uy/cms.php?a=6";
        opcionAutor=2;
        room=@"figari";
        cad=@"AutorFigari.jpeg";

        
    }else if ([string rangeOfString:@"TORRES"].location != NSNotFound) {
        //zona TORRES
        
        resultText.text = symbol.data;
        site=@"http://www.mnav.gub.uy/cms.php?a=4";
        opcionAutor=3;
        room=@"torres";
        cad=@"AutorTorres.jpeg";
        
    
    }else if ([string rangeOfString:@"ESCULTURAS"].location != NSNotFound) {
    
        resultText.text = symbol.data;
        site=@"http://www.mnav.gub.uy/cms.php?a=6";
        opcionAutor=4;
        room=@"esculturas";
        cad=@"artigasafe.jpeg";
        //printf("esculturas");

    }
    else {
       //ninguna ZONA
        resultText.text = @"No está en zona BLANES, FIGARI, TORRES GARCIA o ESCULTURAS DIGITALES";
        site=@"http://code.google.com/p/encuadro/";
        opcionAutor=0;
        room=@"noroom";
        cad=@"Blanes_sraCarlota.jpg";
         

    }
    

      
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
     NSLog(@"IMAGE PHOTO");
    UIImage *cuadroPhoto = [UIImage imageNamed:cad];
     NSLog(@"IMAGE CUADROPHOTO");
    resultImage.image = cuadroPhoto;
    
    UIAlertView *alertWithOkButton;
   
    alertWithOkButton = [[UIAlertView alloc] initWithTitle:@"QR Detectado!"
                                                   message:@"Presione Foward para reconocer cuadro" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertWithOkButton show];
    [alertWithOkButton release];
    
NSLog(@"IMAGE ANTES");
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"IMAGE DESPUES");
    
    
    
    NSLog(@"opcionAutor en picker es %d",opcionAutor);*/
    
    //[reader release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
//    
//    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
//    //[picker release];
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    ImagenServerViewController *VistaImagen = [segue destinationViewController];
    if (_AuxJEscanear != NULL) {
        [VistaImagen setAuxSiguientePImagen:[NSString stringWithString:_AuxSiguientePEscanear]];
        [VistaImagen setAuxJImagen:[NSString stringWithString:_AuxJEscanear]];
        [VistaImagen setAuxContarJImagen:[NSString stringWithString:_AuxContarJEscanear]];
        [VistaImagen setAuxHoraJImagen:[NSString stringWithString:_AuxHoraJEscanear]];
        NSLog(@"Mostrando valores a pasar: _AuxSiguientePEscanear = %@ /n _AuxJEscanear = %@ /n _AuxContarJEscanear = %@ /n _AuxHoraJEscanear = %@ ",_AuxSiguientePEscanear, _AuxJEscanear, _AuxContarJEscanear, _AuxHoraJEscanear);
    }
    
    
    if ([[segue identifier] isEqualToString:@"Fow"])
    {
        [audioPlayer stop];
        click=0;
        [start setTitle:@"Start" forState:UIControlStateNormal];
        opcionAutor = self.string;
        //tipo recorrido y juego
        
        
    if ([[segue identifier] isEqualToString:@"IrImagen"])
    {
        ImagenServerViewController *VistaImagen = [segue destinationViewController];
        if (_AuxJEscanear != NULL) {
            [VistaImagen setAuxSiguientePImagen:[NSString stringWithString:_AuxSiguientePEscanear]];
            [VistaImagen setAuxJImagen:[NSString stringWithString:_AuxJEscanear]];
            [VistaImagen setAuxContarJImagen:[NSString stringWithString:_AuxContarJEscanear]];
            [VistaImagen setAuxHoraJImagen:[NSString stringWithString:_AuxHoraJEscanear]];
            NSLog(@"Mostrando valores a pasar: _AuxSiguientePEscanear = %@ /n _AuxJEscanear = %@ /n _AuxContarJEscanear = %@ /n _AuxHoraJEscanear = %@ ",_AuxSiguientePEscanear, _AuxJEscanear, _AuxContarJEscanear, _AuxHoraJEscanear);
        }
         }
    }
}

-(void) viewDidLoad{
        NSLog(@"Mostrando en ReaderSampleViewController Pista sig: %@ y Id Juego: %@ y la suma va en: %@",_AuxSiguientePEscanear,_AuxJEscanear,_AuxContarJEscanear);
    [super viewDidLoad];
    room=@"noroom";
    //backround.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView animateWithDuration:3
                          delay:0.6
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         backround.center=CGPointMake(100,100);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    [UIView animateWithDuration:5 delay:3 options: UIViewAnimationCurveEaseOut animations:^{
        backround.alpha = 0.0;
    } completion:^(BOOL finished){
        [backround removeFromSuperview];
    }];

}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return(YES);
}

- (void) dealloc {
    self.resultImage = nil;
    self.resultText = nil;
  //  [super dealloc];
}

@end
