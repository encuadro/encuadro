//
//  FTP.h
//  app0100
//
//  Created by encuadro on 2/28/13.
//
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#define kContrayIp @":12345678@10.0.2.109"
BOOL finiteFTP,anduvo;
@interface FTP : NSObject{
    NSURLConnection *connection;
    NSString *filepath;
    NSOutputStream *fileStream;
}
@property(nonatomic, retain, readwrite) NSURLConnection *connection;
@property(nonatomic, copy,   readwrite) NSString *filePath;
@property(nonatomic, retain, readwrite) NSOutputStream *fileStream;
@property BOOL anduvo;
-(FTP*)initWithString:(NSString*)ruta yotroString:(NSString*)rutaFTP;
@end
