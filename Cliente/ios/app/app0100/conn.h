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
//-(conn *)initconFunc:(NSString*)string;
//-(conn *)initconFunc:(NSString*)string yNomParam:(NSString*)string2 yParam:(NSString*)inti;
//-(conn *)initConFuncion:(NSString*)nomFuncion NombreParametro:(NSString*)nombreParametro yNombreIma:(NSString*)nombreDato yNombreSegParam:(NSString*)nombreParam2 yIdSala:(NSString*)nombreDato2;
-(conn *)initGenerico:(NSString *)invocation functionName:(NSString *)funcName;
-(NSMutableString *)getSoap;
-(void) setParser;
@end
