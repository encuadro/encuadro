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
    self.datos2 = [[NSMutableArray alloc] init];
    self.autorNombre = [[NSMutableArray alloc]init];
    self.autorDescripcion = [[NSMutableArray alloc]init];
    self.autorImagen = [[NSMutableArray alloc]init];
    c = [[conn alloc] initconFunc:@"getAllDataSalas"];
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
            NSArray *datos = [n componentsSeparatedByString:@"=>"];
            int size1 = [datos count];
            for(int i=0; i<size1-1; i = i+4){
                [self.datos2 addObject:[datos objectAtIndex:i]];
            }
            for(int i=1;i<size1;i=i+4){
                [self.autorNombre addObject:[datos objectAtIndex:i]];
            }
            for(int i=2;i<size1;i=i+4){
                [self.autorDescripcion addObject:[datos objectAtIndex:i]];
            }
            for(int i=3;i<size1;i=i+4){
                if(![[datos objectAtIndex:i] isEqualToString:@"null"]){
                    rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
                    FTP *f = [[FTP alloc]initWithString:rutita yotroString:[datos objectAtIndex:i]];
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
    c2 = [[conn alloc]initconFunc:@"getDataSalaId2" yNomParam:@"id_sala" yParam:idSala];
    while(!finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if(worked == YES){
        NSMutableString *n2 = [c2 getSoap];
        if(![n2 isEqualToString:@"-1"]){
            NSArray *d = [n2 componentsSeparatedByString:@"=>"];
            [self.autorNombre addObject:[d objectAtIndex:0]];
            [self.autorDescripcion addObject:[d objectAtIndex:1]];
            rutita = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
            FTP *f = [[FTP alloc]initWithString:rutita yotroString:[d objectAtIndex:2]];
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
