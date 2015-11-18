//
//  conn.h
//  app0100
//
//  Created by encuadro on 2/25/13.
//
//

#import <Foundation/Foundation.h>
#import "Configuracion.h"
#import "Parser.h"

static NSString*  kPostURL=@"http://192.168.0.127/server_php/server_php.php";

BOOL finish,worked;
@interface conn : NSObject{
    NSString *funcion;
    NSMutableString *soapResults;
    NSMutableData *webData;
    NSXMLParser *xmlParser;
    BOOL *elementFound;
    BOOL *threadGoing;
    Parser *parser;
}
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
-(conn *)initconFunc:(NSString*)string;
-(conn *)initconFunc:(NSString*)string yNomParam:(NSString*)string2 yParam:(NSString*)inti;
-(conn*)initConFuncion:(NSString*)nomFuncion NombreParametro:(NSString*)nombreParametro yNombreIma:(NSString*)nombreDato yNombreSegParam:(NSString*)nombreParam2 yIdSala:(NSString*)nombreDato2;
-(NSMutableString *)getSoap;
-(void) setParser;
@end
