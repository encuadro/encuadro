//
//  Parser.h
//  app0100
//
//  Created by encuadro on 10/2/14.
//
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject
{
     NSMutableArray * dictionary;
}

- (id) init;
- (id) initWhitString:(NSString * )result;

- (NSString*) getParameter:(NSString *)parameter;
- (NSString*) getParameter:(NSString *) parameter:(int)row;
- (void) parsing: (NSString *) request;
- (void) parsingJson;
- (int) length;
@property(retain,nonatomic) NSString * soapResult;

@end





