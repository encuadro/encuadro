//
//  ViewController.m
//  sacarFoto
//
//  Created by Pablo Flores Guridi on 02/07/12.
//  Copyright (c) 2012 pablofloresguridi@gmail.com. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@property(nonatomic, strong) AVCaptureStillImageOutput* imageOutput;
@property(nonatomic, strong) AVCaptureSession* session;
@property(nonatomic, strong) AVCaptureDevice* videoDevice;
@property(nonatomic, strong) AVCaptureInput* videoInput;
//@property(nonatomic, strong) AVCaptureVideoDataOutput* frameOutput;
@property(nonatomic, strong) IBOutlet UIImageView* imgView;
@property(nonatomic, strong) CIContext* context;

@property(nonatomic, retain) IBOutlet UIImageView *     vImage;
@property(nonatomic, retain) IBOutlet UIView *          vImagePreview;

@end

@implementation ViewController
@synthesize imageOutput = _imageOutput;
@synthesize session = _session;
@synthesize videoDevice = _videoDevice;
@synthesize videoInput = _videoIntup;
//@synthesize frameOutput = _frameOutput;
@synthesize imgView = _imgView;
@synthesize context = _context;

@synthesize vImage = _vImage;
@synthesize vImagePreview = _vImagePreview;

unsigned char* pixels;
size_t width;
size_t height;
size_t bitsPerComponent;
size_t bitsPerPixel; 
size_t bytesPerRow;  
int d;


- (CIContext*) context
{
    if (!_context)
    {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

-(IBAction) captureNow
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in self.imageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
    
	NSLog(@"about to request a capture from: %@", self.imageOutput);
	[self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
//		 CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
//		 if (exifAttachments)
//		 {
//             // Do something with the attachments.
//             NSLog(@"attachements: %@", exifAttachments);
//		 }
//         else
//             NSLog(@"no attachments");
        

         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         /*image es la imagen capturada*/
         
         self.vImage.image = image;
         
         ///esto de abajo es lo que ajusta el tamaño de la imagen sacada al tamaño completo de la pantalla MAINSCREEN BOUNDS
//         UIScreen *screen = [UIScreen mainScreen];
        
        //[self.vImage setCenter:CGPointMake(fullScreenRect.size.width/2, fullScreenRect.size.height/2)];  
        //[self.vImage setBounds:fullScreenRect];
         
         UIImageWriteToSavedPhotosAlbum(self.vImage.image, nil, nil, nil);
    
         
	 }];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
	   fromConnection:(AVCaptureConnection *)connection 
{ 

    
}


- (void)viewDidLoad
{    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

//    self.session = [[AVCaptureSession alloc] init];
//    self.session.sessionPreset = AVCaptureSessionPreset352x288;
//    
//    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil]; 
//    
//    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
//    self.imageOutput.outputSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt: kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
//    //self.frameOutput = [[AVCaptureVideoDataOutput alloc] init];
//    //self.frameOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt: kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
//    
//    [self.session addInput:self.videoInput];
//    [self.session addOutput:self.imageOutput];
//    
//    //[self.imageOutput jpegStillImageNSDataRepresentation:self];
//    
//    [self.session startRunning];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /////////////////////////////////////////////////////////////////////////////
    // Create a preview layer that has a capture session attached to it.
    // Stick this preview layer into our UIView.
    /////////////////////////////////////////////////////////////////////////////
	self.session = [[AVCaptureSession alloc] init];
	
    self.session.sessionPreset = AVCaptureSessionPresetMedium;

	CALayer *viewLayer = self.vImagePreview.layer;
	NSLog(@"viewLayer = %@", viewLayer);
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    

	captureVideoPreviewLayer.frame = self.imgView.bounds;
	[self.imgView.layer addSublayer:captureVideoPreviewLayer];
    
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[self.session addInput:input];
    
    
    /////////////////////////////////////////////////////////////
    // OUTPUT #1: Still Image
    /////////////////////////////////////////////////////////////
    // Add an output object to our session so we can get a still image
	// We retain a handle to the still image output and use this when we capture an image.
	self.imageOutput = [[AVCaptureStillImageOutput alloc] init];

	NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
	[self.imageOutput setOutputSettings:outputSettings];
	[self.session addOutput:self.imageOutput];
    
    
    /////////////////////////////////////////////////////////////
    // OUTPUT #2: Video Frames
    /////////////////////////////////////////////////////////////
    // Create Video Frame Outlet that will send each frame to our delegate
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
	captureOutput.alwaysDiscardsLateVideoFrames = YES; 
	//captureOutput.minFrameDuration = CMTimeMake(1, 3); // deprecated in IOS5
	
	// We need to create a queue to funnel the frames to our delegate
	dispatch_queue_t queue;
	queue = dispatch_queue_create("cameraQueue", NULL);
	[captureOutput setSampleBufferDelegate:self queue:queue];
	dispatch_release(queue);
	
	// Set the video output to store frame in BGRA (It is supposed to be faster)
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
	// let's try some different keys, 
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; 
	
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 
	[captureOutput setVideoSettings:videoSettings];    
    
    [self.session addOutput:captureOutput]; 
    /////////////////////////////////////////////////////////////
    
    
	// start the capture session
	[self.session startRunning];
    
    /////////////////////////////////////////////////////////////////////////////
    
    // initialize frame counter
    iFrameCount = 0;
	
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
    return NO;
}

@end
