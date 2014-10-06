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
    NSMutableDictionary * dictionary;
}

- (id) init;
- (id) initWhitString:(NSString * )result;

- (NSString*) getParameter:(NSString *)parameter;
- (void) parsing: (NSString *)request;

@property(retain,nonatomic) NSString * soapResult;

@end





