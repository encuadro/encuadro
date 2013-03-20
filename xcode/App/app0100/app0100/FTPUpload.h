//
//  FTPUpload.h
//  app0100
//
//  Created by encuadro on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
enum{
    kSendBufferSize = 32768
};
BOOL finiteUpload;
@interface FTPUpload : NSObject{
    NSString *filepath;
    NSOutputStream *fileStream;
    uint8_t _buffer[kSendBufferSize];
}
@property (nonatomic, copy,   readwrite) NSString *filePath;
@property (nonatomic, retain, readwrite) NSOutputStream *networkStream;
@property (nonatomic, assign, readonly ) uint8_t *buffer;
@property (nonatomic, assign, readwrite) size_t bufferOffset;
@property (nonatomic, assign, readwrite) size_t bufferLimit;
@property (nonatomic, retain, readwrite) NSOutputStream *fileStream;
-(FTPUpload*)initWithString:(NSString*)file;
@end
