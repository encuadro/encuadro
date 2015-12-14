    //
//  obtSalas.m
//  app0100
//
//  Created by encuadro on 3/8/13.
//
//

#import "obtSalas.h"


@implementation obtSalas
@synthesize autorImagen = _autorImagen;
@synthesize autorDescripcion = _autorDescripcion;
@synthesize autorNombre = _autorNombre;
@synthesize datos2 = _datos2;

-(obtSalas*)init{
    finSal = NO;
    Parser * parser;
    self.datos2 = [[NSMutableArray alloc] init];
    self.autorNombre = [[NSMutableArray alloc]init];
    self.autorDescripcion = [[NSMutableArray alloc]init];
    self.autorImagen = [[NSMutableArray alloc]init];
	//c = [[conn alloc] initconFunc:@"getAllDataSalas"];
	
	NSString *funcName = @"getAllDataSalas";
	NSString *arguments = [Configuracion soapMethodInvocationVariable: funcName, nil];
	c = [[conn alloc] initGenerico:arguments functionName:funcName];
	NSLog(@"PRUEBA_6");
	
    while(!finish){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if(worked == YES){
        NSMutableString *n = [c getSoap];
        if([n isEqualToString:@"-1"]){
            [self.datos2 addObject:@"-1"];
            [self.autorNombre addObject:@"-1"];
            [self.autorDescripcion addObject:@"-1"];
            [self.autorImagen addObject:@"-1"];
        }
        else{
            parser = [[Parser alloc]initWhitString:n];
            NSLog(@"parser soap %@",parser.soapResult);
            NSLog(@"parser length%d",parser.length);
            for(int x=0;x<[parser length];x++){
                [self.datos2 addObject:[parser getParameter:@"id_sala":x]];
                [self.autorNombre addObject:[parser getParameter:@"nombre_sala":x]];
                [self.autorDescripcion addObject:[parser getParameter:@"descripcion":x]];
                if(![[parser getParameter:@"imagen":x] isEqualToString:@"null"]){
                    rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *f = [[FTP alloc]initWithString:rutita yotroString:[parser getParameter:@"imagen":x]];
                    while(!finiteFTP) {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    }
                    if(anduvo == NO)
                        [self.autorImagen addObject:[[NSBundle mainBundle] pathForResource:@"enCuadroIcon" ofType:@"png"]];
                    else
                        [self.autorImagen addObject:rutita];
                }
                else
                    [self.autorImagen addObject:[[NSBundle mainBundle] pathForResource:@"enCuadroIcon" ofType:@"png"]];
            }
        }
    }
    else{
        [self.datos2 addObject:@"-1"];
        [self.autorNombre addObject:@"-1"];
        [self.autorDescripcion addObject:@"-1"];
        [self.autorImagen addObject:@"-1"];
    }
    finSal = YES;
    return self;
}

-(obtSalas*)initWithString:(NSString *)idSala{
    finSal = NO;
    self.autorNombre = [[NSMutableArray alloc]init];
    self.autorDescripcion = [[NSMutableArray alloc]init];
    self.autorImagen = [[NSMutableArray alloc]init];
	//c2 = [[conn alloc]initconFunc:@"getDataSalaId2" yNomParam:@"id_sala" yParam:idSala];
	
	NSString *funcName = @"getDataSalaId2";
	NSString *arguments = [Configuracion soapMethodInvocationVariable: funcName, @"id_sala", idSala, nil];
	c2 = [[conn alloc] initGenerico:arguments functionName:funcName];
	NSLog(@"PRUEBA_5");
	
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if(worked == YES){
        NSMutableString *n2 = [c2 getSoap];
        if(![n2 isEqualToString:@"-1"]){
            Parser * parser = [[Parser alloc]initWhitString:n2];
            [self.autorNombre addObject:[parser getParameter:@"nombre_sala"]];
            [self.autorDescripcion addObject:[parser getParameter:@"descripcion"]];
            rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
            FTP *f = [[FTP alloc]initWithString:rutita yotroString:[parser getParameter:@"imagen"]];
            while(!finiteFTP) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            if(anduvo == NO)
                [self.autorImagen addObject:[[NSBundle mainBundle] pathForResource:@"enCuadroIcon" ofType:@"png"]];
            else
                [self.autorImagen addObject:rutita];
        }
        else{
            [self.datos2 addObject:@"-1"];
            [self.autorNombre addObject:@"-1"];
            [self.autorDescripcion addObject:@"-1"];
            [self.autorImagen addObject:@"-1"];
        }
    }
    else{
        [self.datos2 addObject:@"-1"];
        [self.autorNombre addObject:@"-1"];
        [self.autorDescripcion addObject:@"-1"];
        [self.autorImagen addObject:@"-1"];
    }
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
