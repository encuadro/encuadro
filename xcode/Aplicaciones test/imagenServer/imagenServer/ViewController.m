//
//  ViewController.m
//  imagenServer
//
//  Created by Pablo Flores Guridi on 16/08/12.
//  Copyright (c) 2012 Pablo Flores Guridi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UIButton *read;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation ViewController
@synthesize url = _url;
@synthesize read =_read;
@synthesize image = _image;



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



-(IBAction)uploadImage:(id)sender
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
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]]; //NSUTF8StringEncoding
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"foto\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];//NSUTF8StringEncoding
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];//NSUTF8StringEncoding    probar con content-type: text/plain  
    
    //[body appendData:[[NSString stringWithString:@"Content-Type: text/plain\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];//NSUTF8StringEncoding
    
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
    
////setting up the body: 
//    NSMutableData *postBody = [NSMutableData data]; 
//    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
//    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"realname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; 
//    //[postBody appendData:[[NSString stringWithString:@"Joe Doe"] dataUsingEncoding:NSUTF8StringEncoding]]; 
//    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
//    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; 
//   // [postBody appendData:[[NSString stringWithString:@"joe.doe@company.biz"] dataUsingEncoding:NSUTF8StringEncoding]]; 
//    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
//    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"uploadFile\"; filename=\"test.txt\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; 
//    [postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; 
//    [postBody appendData:[NSData dataWithContentsOfFile:@"/Users/encuadro/Desktop/lenaTocada.txt"]]; 
//    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
//   // [postRequest setHTTPBody:postBody];
//    
//    
//    
    
    
    
    
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////    
    
    
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(returnString);


   // [self.image setImage:imagenView.image];
    
    //muestro imagen de la base de datos del server que coincide con la foto sacada
    NSData* imageDataServer = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:returnString]];
    
    UIImage* image = [[UIImage alloc] initWithData:imageDataServer];
    [self.image setImage:image];
    
    
    
    
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





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
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
