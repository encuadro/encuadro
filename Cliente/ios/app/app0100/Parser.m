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
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id) initWhitString:(NSString *)result{
    self = [super init];
    if(self)
        self.soapResult = result;
    return self;
}

- (NSString *)getParameter:(NSString *)parameter{
    return dictionary[parameter];
}

- (void) parsing:(NSString *) request{
    NSArray * array = [self.soapResult componentsSeparatedByString:@"=>"];
    if([request isEqualToString:@"ns1:getDataObraResponse"]){
        [dictionary setObject:array[0] forKey:@"idObra"];
        [dictionary setObject:array[1] forKey:@"nombreObra"];
        [dictionary setObject:array[2] forKey:@"descripcion"];
        [dictionary setObject:array[3] forKey:@"descriptor"];
        [dictionary setObject:array[4] forKey:@"imagen"];
        [dictionary setObject:array[5] forKey:@"idSala"];
        [dictionary setObject:array[6] forKey:@"nombreSala"];
    }
    if([request isEqualToString:@"ns1:ObraPerteneceAJuegoResponse"]){
        [dictionary setObject:array[0] forKey:@"idJuego"];
    }
    if([request isEqualToString:@"ns1:BusquedaPistaResponse"]){
        [dictionary setObject:array[0] forKey:@"idObraSiguiente"];
        [dictionary setObject:array[1] forKey:@"pista"];
    }


}

@end
                        
                        
                        
                        
                        
                        
                        
                        
