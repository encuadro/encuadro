//
//  ViewController.m
//  imagenServer
//
//  Created by Pablo Flores Guridi on 16/08/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#import "ImagenServerViewController.h"

@interface ImagenServerViewController ()
@property (retain, nonatomic) IBOutlet UITextField *url;
@property (retain, nonatomic) IBOutlet UIButton *read;
@property (retain, nonatomic) IBOutlet UIImageView *image;
@end

@implementation ImagenServerViewController
@synthesize url = _url;
@synthesize read =_read;
@synthesize image = _image;
@synthesize filePath = _filePath;
@synthesize mensaje;

@synthesize imagenView,tomarFoto,enviar,twitt, load;
@synthesize AuxTipoRecorridoISVC = _AuxTipoRecorridoISVC;
@synthesize AuxContarJImagen = _AuxContarJImagen;
@synthesize AuxHoraJImagen = _AuxHoraJImagen;
@synthesize AuxJImagen = _AuxJImagen;
@synthesize AuxSiguientePImagen = _AuxSiguientePImagen;

@synthesize juego;

-(IBAction)tomarFoto:(id)sender{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.sourceType =UIImagePickerControllerSourceTypeCamera;
    //[self presentModalViewController:picker animated:YES];
	[self presentViewController:picker animated:YES completion:NO];
    
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissModalViewControllerAnimated:YES];
    imagenView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *webData = UIImagePNGRepresentation(imagenView.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.filePath = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
    [webData  writeToFile:self.filePath atomically:YES];
    NSLog(@"%@",opcionAutor);
}

//-(IBAction)uploadImage:(id)sender
-(void)uploadImage
{

    
    /*
     turning the image into a NSData object
     getting the image back out of the UIImageView
     setting the quality to 90
     */
    NSData *imageData = UIImageJPEGRepresentation(imagenView.image, 90);

    // setting up the URL to post to
    NSString *urlString = @"http://192.168.1.111/upload.php";
    //   NSString *urlString = @"http://192.168.1.4/upload2.php";
    
    // setting up the request object now
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    /*
     add some header info now
     we always need a boundary when we post a file
     also we need to set the content type
     
     You might want to generate a random boundary.. this is just the same 
     as my output from wireshark on a valid html post
     */
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    /*
     now lets create the body of the post
     */
    NSLog(@"%@",room);
    
    NSString* message = @"Content-Disposition: form-data; name=\"userfile\"; filename=\"";
    message = [message stringByAppendingString:room];
    message = [message stringByAppendingString:@"\"\r\n"];
    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]]; //NSUTF8StringEncoding
    [body appendData:[message dataUsingEncoding:NSUTF8StringEncoding]];//NSUTF8StringEncoding
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];//NSUTF8StringEncoding    probar con content-type: text/plain  
    
    //[body appendData:[[NSString stringWithString:@"Content-Type: text/plain\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];//NSUTF8StringEncoding
    
        
    NSLog(@"ABOUT TO REQUEST");
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    NSLog(@"ABOUT TO REQUEST A");
    // now lets make the connection to the web
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSLog(@"ABOUT TO REQUEST B");
    returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"ABOUT TO REQUEST C ");
    NSLog(@"%@\n",returnString);
    NSLog(@"ALREADY RETURN D");
    
    
    // [self.image setImage:imagenView.image];
    
    //muestro imagen de la base de datos del server que coincide con la foto sacada
    NSData* imageDataServer = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:returnString]];
    
    UIImage* image = [[UIImage alloc] initWithData:imageDataServer];
    [self.image setImage:image];
    
  
    
}




- (IBAction)animate:(id)sender {
    //[mensaje sizeToFit];
   // mensaje.center=CGPointMake(20, 20);
    mensaje.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0.9 alpha:1];
    mensaje.text=@"Cargando...";
    [activity startAnimating];
}

- (IBAction)stop:(id)sender {
    [activity stopAnimating];
}





//metodo para leer foto desde servidor y mostrarla en el IPAD
- (IBAction)pressed:(id)sender
{
    [self.url resignFirstResponder];
    
    NSString* imageURL =self.url.text ;
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
    
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    [self.image setImage:image];
    
    
}

-(void)subir{
    FTPUpload *fu = [[FTPUpload alloc]initWithString:self.filePath];
    while(!finiteUpload) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSArray *nombreFoto = [self.filePath componentsSeparatedByString:@"Get"];
    NSMutableString *nombreFoto2 = [[NSMutableString alloc] initWithString:@"Get"];
    [nombreFoto2 appendString:[nombreFoto objectAtIndex:1]];
    NSString *foto = [NSString stringWithString:nombreFoto2];
    oo = [[obtObras alloc]initNombreIma:foto yIdSala:opcionAutor];
    while(!finOb) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSString *nombre = [[oo getNombre] objectAtIndex:0];
    NSString *autor = [[oo getAutor] objectAtIndex:0];
    NSString *descripcion = [[oo getDesc] objectAtIndex:0];
    NSString *imagen = [[oo getImagen] objectAtIndex:0];
    descripcionObra = [[NSMutableArray alloc] init];
    [descripcionObra addObject:autor];
    [descripcionObra addObject:nombre];
    [descripcionObra addObject:imagen];
    [descripcionObra addObject:descripcion];
}

-(IBAction)tweet{
    if([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
        UIImage *img = imagenView.image;
        [controller addImage:img];
        [controller setInitialText:@"Arte Interactivo. Lienzo libre desde App! @encuadroAR"];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //[self performSelectorInBackground:@selector(animate:) withObject:nil];
    [activity startAnimating];
    [load setHidden:NO];
    [imagenView setHidden:YES];
    [tomarFoto setHidden:YES];
    [enviar setHidden:YES];
    [twitt setEnabled:NO];
    [self subir];
    manual=false;
    
    ObraCompletaViewController *obracompletaViewController = [segue destinationViewController];
    //[VistaAutor setAuxSiguienteP:[NSString stringWithString:_IdPistaSiguiente]];
    
    [obracompletaViewController setAuxTipoRecorridoOCVC:[NSString stringWithString:_AuxTipoRecorridoISVC]];
     
    [twitt setEnabled:YES];
    [activity stopAnimating];
    [load setHidden:YES];
    [imagenView setHidden:NO];
    [tomarFoto setHidden:NO];
    [enviar setHidden:NO];
    //juego y recorrido
    [obracompletaViewController setJuego:juego];
    
    //if (_AuxJImagen != NULL) {
        //[obracompletaViewController setAuxJuegoId:[NSString stringWithString:_AuxJImagen]];
        //[obracompletaViewController setAuxIdPistaSiguiente:[NSString stringWithString:_AuxSiguientePImagen]];
        //[obracompletaViewController setAuxContarO:[NSString stringWithString:_AuxContarJImagen]];
        //[obracompletaViewController setHoraJuego:[NSString stringWithString:_AuxHoraJImagen]];
    //}
    /*
    if ([[segue identifier] isEqualToString:@"Detalle2"])
    {
        
        [self performSelectorInBackground:@selector(animate:) withObject:nil];
        [self uploadImage]; 
       
        manual=false;
        
        ObraCompletaViewController *obracompletaViewController = 
        [segue destinationViewController];
         
        NSString* autor = @"http://192.168.1.111/autores/";
        autor = [autor stringByAppendingString:returnString];
        autor = [autor stringByAppendingString:@".txt"];
        
        
        NSString* obra = @"http://192.168.1.111/obras/";
        obra = [obra stringByAppendingString:returnString];
        obra = [obra stringByAppendingString:@".txt"];
        
        
        NSString* texto = @"http://192.168.1.111/textos/";
        texto = [texto stringByAppendingString:returnString];
        texto = [texto stringByAppendingString:@".txt"];
        NSLog(@"%@",returnString);
        NSString* imagen = @"http://192.168.1.111/imagenes/";
        imagen = [imagen stringByAppendingString:returnString];
        imagen = [imagen stringByAppendingString:@".jpg"];
        
        
        NSString* audio = returnString;
        audio = [audio stringByAppendingString:@".mp3"];
        
        
        
        NSString* ARid = @"http://192.168.1.111/ARid/";
        ARid = [ARid stringByAppendingString:returnString];
        ARid = [ARid stringByAppendingString:@".txt"];
        
        
        NSString* ARType = @"http://192.168.1.111/ARType/";
        ARType = [ARType stringByAppendingString:returnString];
        ARType = [ARType stringByAppendingString:@".txt"];
        
        
        NSString* ARObj = @"http://192.168.1.111/ARObj/";
        ARObj = [ARObj stringByAppendingString:returnString];
        ARObj = [ARObj stringByAppendingString:@".txt"];
        

        
        
        
        obracompletaViewController.descripcionObra = [[NSArray alloc]
                                                      initWithObjects: 
                                                      autor,
                                                      obra,
                                                      imagen,
                                                      texto,
                                                      audio,
                                                      ARid,
                                                      ARType,
                                                      ARObj,
                                                      nil];

       [self performSelectorOnMainThread:@selector(stop:) withObject:nil waitUntilDone:YES];
       // [mensaje release];
        
        mensaje.text=nil;
        mensaje.backgroundColor=nil;
    }*/
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.sourceType =UIImagePickerControllerSourceTypeCamera;
    //[self presentModalViewController:picker animated:YES];
	[self presentViewController:picker animated:YES completion:NO];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",opcionAutor);
    _AuxTipoRecorridoISVC = @"1";
    NSLog(@"Tipo Recorrido --> %@",_AuxTipoRecorridoISVC);
    NSLog(@"Mostrando en ImagenServerViewController Pista sig: %@ y Id Juego: %@ y la suma va en: %@",_AuxSiguientePImagen,_AuxJImagen,_AuxContarJImagen);

}

- (void)viewDidUnload
{
    [self setActivity:nil];
    [self setAnimate:nil];
    [self setStop:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	//NSLog(@"shouldAutorotateToInterfaceOrientation BOOL IMAGEN SERVER");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
//    return NO;
}

-(BOOL)shouldAutorotate
{
	//NSLog(@"shouldAutorotate IMAGEN SERVER");
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
	//NSLog(@"supportedInterfaceOrientations NSUInteger IMAGEN SERVER");
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	//NSLog(@"preferredInterfaceOrientationForPresentation IMAGEN SERVER");
    return UIInterfaceOrientationLandscapeRight;
}

@end
