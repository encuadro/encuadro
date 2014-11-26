//
//  Parser.m
//  app0100
//
//  Created by encuadro on 10/2/14.
//
//

#import "Parser.h"

@implementation Parser
@synthesize soapResult;

-(id) init{
    self = [super init];
    if(self){
        dictionary = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id) initWhitString:(NSString *)result{
    self = [super init];
    if(self){
        dictionary = [[NSMutableArray alloc] init];
        self.soapResult = result;
        [self parsing:soapResult];
    }
    return self;
}

- (NSString *)getParameter:(NSString *)parameter{
        return dictionary[0][parameter];
}
- (NSString *) getParameter:(NSString *)parameter :(int)row{
    return dictionary[row][parameter];
}
- (void) parsing:(NSString *)request{
    if(soapResult==nil)
        soapResult = request;
    NSString * comp = [soapResult substringWithRange:NSMakeRange(0,1)];
    if([comp isEqualToString:@"["] || [comp isEqualToString:@"{"])
        [self parsingJson];
       
}

- (void) parsingJson{
    NSData *jsonData = [soapResult dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSMutableArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    [dictionary addObjectsFromArray:(dic)];
}

- (int) length{
    return [dictionary count];
}

@end

                        
                        
                        
                        
                        
                        
                        
