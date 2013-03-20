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
BOOL finiteFTP;
@interface FTP : NSObject{
    NSURLConnection *connection;
    NSString *filepath;
    NSOutputStream *fileStream;
    BOOL *anduvo;
}
@property(nonatomic, retain, readwrite) NSURLConnection *connection;
@property(nonatomic, copy,   readwrite) NSString *filePath;
@property(nonatomic, retain, readwrite) NSOutputStream *fileStream;
@property BOOL anduvo;
-(FTP*)initWithString:(NSString*)ruta yotroString:(NSString*)nombreDato ytipo:(NSString*)tipo yId:(NSString*)ide ytipo2:(NSString*)tipo2;
-(BOOL)getSiAnduvo;
@end
