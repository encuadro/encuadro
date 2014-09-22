//
//  FTP.m
//  app0100
//
//  Created by encuadro on 2/28/13.
//
//

#import "FTP.h"

@implementation FTP
@synthesize connection    = _connection;
@synthesize filePath      = _filePath;
@synthesize fileStream    = _fileStream;
@synthesize anduvo = _anduvo;
-(FTP*)initWithString:(NSString *)ruta yotroString:(NSString *)rutaFTP{
    finiteFTP = NO;
    anduvo = YES;
    BOOL                success;
    NSURL *             url;
    NSURLRequest *      request;
    //assert(self.connection == nil);         // don't tap receive twice in a row!
    //assert(self.fileStream == nil);         // ditto
    //assert(self.filePath == nil);           // ditto
    // First get and check the URL.
    url = [[NetworkManager sharedInstance] smartURLForString:rutaFTP];
    success = (url != nil);
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    if ( ! success) {
        NSLog(@"hola");
        finiteFTP = YES;
        anduvo = NO;
        //statusLabel.text = @"Invalid URL";
    } /*else if ( ! [[NetworkManager sharedInstance] isImageURL:url] ) {
       //statusLabel.text = @"Can only get images";
       NSLog(@"hola2");
       }*/ else {
           // Open a stream for the file we're going to receive into.
           //self.filePath = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
           self.filePath = ruta;
           assert(self.filePath != nil);
           self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:NO];
           assert(self.fileStream != nil);
           [self.fileStream open];
           // Open a connection for the URL.
           request = [NSURLRequest requestWithURL:url];
           assert(request != nil);
           connection = [NSURLConnection connectionWithRequest:request delegate:self];
           assert(connection != nil);
           // Tell the UI we're receiving.
           [self receiveDidStart];
       }
    return self;
}

-(void)receiveDidStart{
    // Clear the current image so that we get a nice visual cue if the receive fails.
    //imageview.image = [UIImage imageNamed:@"mayas-temple.jpg"];
    //statusLabel.text = @"Receiving";
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

-(void)receiveDidStopWithStatus:(NSString *)statusString{
    if (statusString == nil) {
        assert(self.filePath != nil);
        //imageview.image = [UIImage imageWithContentsOfFile:self.filePath];
        statusString = @"GET succeeded";
        finiteFTP = YES;
        anduvo = YES;
    }
    else{
        finiteFTP = YES;
        anduvo = NO;
    }
    //self.statusLabel.text = statusString;
    [[NetworkManager sharedInstance] didStopNetworkOperation];
}

-(void)stopReceiveWithStatus:(NSString *)statusString{
    if (connection != nil) {
        [connection cancel];
        connection = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self receiveDidStopWithStatus:statusString];
    self.filePath = nil;
}

-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
#pragma unused(theConnection)
#pragma unused(response)
    assert(theConnection == connection);
    assert(response != nil);
}

-(void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data{
#pragma unused(theConnection)
    NSUInteger      dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSUInteger      bytesWrittenSoFar;
    
    assert(theConnection == connection);
    
    dataLength = [data length];
    dataBytes  = [data bytes];
    
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
        assert(bytesWritten != 0);
        if (bytesWritten <= 0) {
            [self stopReceiveWithStatus:@"File write error"];
            break;
        } else {
            bytesWrittenSoFar += (NSUInteger) bytesWritten;
        }
    } while (bytesWrittenSoFar != dataLength);
}

-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error{
#pragma unused(theConnection)
#pragma unused(error)
    assert(theConnection == connection);
    
    [self stopReceiveWithStatus:@"Connection failed"];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection{
#pragma unused(theConnection)
    assert(theConnection == connection);
    
    [self stopReceiveWithStatus:nil];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //imageview.image=image;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
