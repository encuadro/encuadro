//
//  claseDibujar.m
//  LSD
//
//  Created by juani on 12/29/11.
//  Copyright (c) 2011 pablofloresguridi@gmail.com. All rights reserved.
//

#import "claseDibujar.h"
//#include "lsd_cmd.h"
//#include "segments.h"

@implementation claseDibujar

@synthesize cantidadSegmentos = _cantidadSegmentos;
@synthesize segmentos = _segmenos;
@synthesize bandera = _bandera;

CGFloat cgx1;
CGFloat cgy1;
CGFloat cgx2;
CGFloat cgy2;
CGPoint puntos2[2];

int dim=7;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
 
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    
        /*Dibujo lineas*/
        
    for(int i=0;i<self.cantidadSegmentos;i++){
        
        /*Para el iPhone habría que cambiar la linea que viene por la siguiente:*/
        cgx1=self.segmentos[i*dim]*480/352;
        cgy1=self.segmentos[i*dim+1]*320/288;
        cgx2=self.segmentos[i*dim+2]*480/352;
        cgy2=self.segmentos[i*dim+3]*320/288;
        
        
        /*Para el iPad*/
        
//        cgx1=self.segmentos[i*dim]*1024/352;
//        cgy1=self.segmentos[i*dim+1]*768/288;
//        cgx2=self.segmentos[i*dim+2]*1024/352;
//        cgy2=self.segmentos[i*dim+3]*768/288;
        
        
        
       
        CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
        puntos2[0]=CGPointMake(cgx1,cgy1);
        puntos2[1]=CGPointMake(cgx2,cgy2);
        CGContextStrokeLineSegments(context, puntos2, 2);
        
    }    

    
}



@end
