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

@synthesize activity;
@synthesize mensaje;

@synthesize imagenView,tomarFoto;

-(IBAction)tomarFoto:(id)sender{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.sourceType =UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:picker animated:YES];
    
    
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //saca la vista del controlador
    [picker dismissModalViewControllerAnimated:YES];
    //pone imagen tomada en el objeto UIImageView
    imagenView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
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
    NSData *textData = [NSData dataWithContentsOfFile:@"/Users/encuadro/Desktop/lenaTocada.txt"];
    // setting up the URL to post to
    NSString *urlString = @"http://silviaguridi99.no-ip.info/upload.php";
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
    NSLog(room);
    
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
    
        
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(returnString);
    
    
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



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
   
    
    if ([[segue identifier] isEqualToString:@"Detalle2"])
    {
        
        [self performSelectorInBackground:@selector(animate:) withObject:nil];
        [self uploadImage]; 
       
        manual=false;
        
        ObraCompletaViewController *obracompletaViewController = 
        [segue destinationViewController];
         
        NSString* autor = @"http://silviaguridi99.no-ip.info/autores/";
        autor = [autor stringByAppendingString:returnString];
        autor = [autor stringByAppendingString:@".txt"];
        
        
        NSString* obra = @"http://silviaguridi99.no-ip.info/obras/";
        obra = [obra stringByAppendingString:returnString];
        obra = [obra stringByAppendingString:@".txt"];
        
        
        NSString* texto = @"http://silviaguridi99.no-ip.info/textos/";
        texto = [texto stringByAppendingString:returnString];
        texto = [texto stringByAppendingString:@".txt"];
        
        NSString* imagen = @"http://silviaguridi99.no-ip.info/imagenes/";
        imagen = [imagen stringByAppendingString:returnString];
        imagen = [imagen stringByAppendingString:@".jpg"];
        
        
        NSString* audio = returnString;
        audio = [audio stringByAppendingString:@".mp3"];
        
        
        
        obracompletaViewController.descripcionObra = [[NSArray alloc]
                                                      initWithObjects: 
                                                      autor,
                                                      obra,
                                                      imagen,
                                                      texto,
                                                      audio,          
                                                      nil];

       [self performSelectorOnMainThread:@selector(stop:) withObject:nil waitUntilDone:YES];
       // [mensaje release];
        
        mensaje.text=nil;
        mensaje.backgroundColor=nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.sourceType =UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:picker animated:YES];
	// Do any additional setup after loading the view, typically from a nib.
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:activity]; // spinner is not visible until started
    activity.center = CGPointMake(160, 100);

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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



@end
