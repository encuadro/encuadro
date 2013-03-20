//
//  obtSalas.m
//  app0100
//
//  Created by encuadro on 3/8/13.
//
//

#import "obtSalas.h"
#import "conn.h"
#import "FTP.h"

@implementation obtSalas
@synthesize autorImagen = _autorImagen;
@synthesize autorDescripcion = _autorDescripcion;
@synthesize autorNombre = _autorNombre;
@synthesize datos2 = _datos2;

-(obtSalas*)init{
    finSal = NO;
    self.autorNombre = [[NSMutableArray alloc]init];
    self.autorDescripcion = [[NSMutableArray alloc]init];
    self.autorImagen = [[NSMutableArray alloc]init];
    conn *c = [[conn alloc] initconFunc:@"getSalas"];
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *n = [c getSoap];
    NSArray *datos = [n componentsSeparatedByString:@"=>"];
    self.datos2 = [[NSMutableArray alloc]init];
    int size1 = [datos count];
    int cont = 0;
    conn *c2;
    for(int i=0;i<size1-1;i=i+2){
        [self.datos2 addObject:[datos objectAtIndex:i]];
        c2 = [[conn alloc]initconFunc:@"getDataSalaId2" yNomParam:@"id_sala" yParam:[self.datos2 objectAtIndex:cont]];
        while(!finish) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSMutableString *n2 = [c2 getSoap];
        NSArray *d = [n2 componentsSeparatedByString:@"=>"];
        [self.autorNombre addObject:[d objectAtIndex:0]];
        [self.autorDescripcion addObject:[d objectAtIndex:1]];
        NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
        FTP *f = [[FTP alloc]initWithString:rutita yotroString:[d objectAtIndex:2] ytipo:@"salas" yId:[self.datos2 objectAtIndex:cont] ytipo2:@"imagen"];
        while(!finiteFTP) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        [self.autorImagen addObject:rutita];
        cont++;
        }
    finSal = YES;
    return self;
}

-(obtSalas*)initWithString:(NSString *)idSala{
    finSal = NO;
    self.autorNombre = [[NSMutableArray alloc]init];
    self.autorDescripcion = [[NSMutableArray alloc]init];
    self.autorImagen = [[NSMutableArray alloc]init];
    NSLog(@"%@",idSala);
    conn *c2 = [[conn alloc]initconFunc:@"getDataSalaId2" yNomParam:@"id_sala" yParam:idSala];
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    NSMutableString *n2 = [c2 getSoap];
    NSArray *d = [n2 componentsSeparatedByString:@"=>"];
    [self.autorNombre addObject:[d objectAtIndex:0]];
    [self.autorDescripcion addObject:[d objectAtIndex:1]];
    NSString *rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
    FTP *f = [[FTP alloc]initWithString:rutita yotroString:[d objectAtIndex:2] ytipo:@"salas" yId:idSala ytipo2:@"imagen"];
    while(!finiteFTP) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [self.autorImagen addObject:rutita];
    finSal = YES;
    return self;
}

-(NSMutableArray*)getNom{
    return self.autorNombre;
}

-(NSMutableArray*)getDesc{
    return self.autorDescripcion;
}

-(NSMutableArray*)getIma{
    return self.autorImagen;
}

-(NSMutableArray*)getSalas{
    return self.datos2;
}

@end
