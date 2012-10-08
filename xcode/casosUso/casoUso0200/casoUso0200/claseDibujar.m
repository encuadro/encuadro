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
@synthesize cantidadEsquinas = _cantidadEsquinas;
@synthesize esquinas = _esquinas;
@synthesize esquinasRep = _esquinasRep;
@synthesize bandera = _bandera;
@synthesize dealloc=_dealloc;

CGFloat cgx1;
CGFloat cgy1;
CGFloat cgx2;
CGFloat cgy2;
CGPoint puntos2[2];
CGFloat cgesq1;
CGFloat cgesq2;
CGFloat cgesqRep1;
CGFloat cgesqRep2;
int dim=7;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.transform =CGAffineTransformMake(0, 1, -1, 0, 0, 0);
        
        
        
        
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
//        cgy1=self.segmentos[i*dim]*480/480;             //480/352
//        cgx1=480 - self.segmentos[i*dim+1]*320/360;     //320/288
//        
//        cgy2=self.segmentos[i*dim+2]*480/480;
//        cgx2=480 - self.segmentos[i*dim+3]*320/360;
        
        /*a lo mou*/
        cgx1=self.segmentos[i*dim]*wSize/480;             //480/352
        cgy1=self.segmentos[i*dim+1]*hSize/360;     //320/288
        
        cgx2=self.segmentos[i*dim+2]*wSize/480;
        cgy2=self.segmentos[i*dim+3]*hSize/360;
        
        /*Para el iPad*/
        
//        cgx1=self.segmentos[i*dim]*1024/352;
//        cgy1=self.segmentos[i*dim+1]*768/288;
//        cgx2=self.segmentos[i*dim+2]*1024/352;
//        cgy2=self.segmentos[i*dim+3]*768/288;
        
        
        
       
        CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
        puntos2[0]=CGPointMake(cgx1,cgy1);
        puntos2[1]=CGPointMake(cgx2,cgy2);
        CGContextStrokeLineSegments(context, puntos2, 2);
        
    }    
  

    
        /*Dibujo esquinas*/
 

     for(int i=0;i<self.cantidadEsquinas;i++){
       
    /*Para el iPhone habría que cambiar la linea que viene por la siguiente:*/
    cgesq1=self.esquinas[i][0]*wSize/480;
    cgesq2=self.esquinas[i][1]*hSize/360;
         
         /*Para el iPad*/
//    cgesq1=self.esquinas[i][0]*1024/352;
//    cgesq2=self.esquinas[i][1]*768/288;
         
    CGContextSetRGBStrokeColor(context, 0, 0, 255, 1);
    CGContextStrokeRect(context, CGRectMake(cgesq1, cgesq2, 5, 5));
         
     }   
   
//    if (_bandera)
//    {
//    /*Dibujo esquinas REPROYECTADAS*/
//    for(int i=0;i<self.cantidadEsquinas;i++){
//        
//        /*Para el iPhone habría que cambiar la linea que viene por la siguiente:*/
//        cgesqRep1=self.esquinasRep[i][0]*480/352;
//        cgesqRep2=self.esquinasRep[i][1]*320/288;
//    
//        
//        /*Para el iPad*/
////        cgesqRep1=self.esquinasRep[i][0]*1024/352;
////        cgesqRep2=self.esquinasRep[i][1]*768/288;
//        
//        CGContextSetRGBStrokeColor(context, 0, 255, 0, 1);
//        CGContextStrokeRect(context, CGRectMake(cgesqRep1, cgesqRep2, 5, 5));
//
//
//        
//    }    
//
//    }
    
    
    
//    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
//    CGContextStrokeRect(context, CGRectMake(100, 0, 5, 5));
//    
//    CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
//    CGContextStrokeRect(context, CGRectMake(100, 50, 5, 5));
//    
//    CGContextSetRGBStrokeColor(context, 0, 255, 0, 1);
//    CGContextStrokeRect(context, CGRectMake(200, 100, 5, 5));
//    
//    CGContextSetRGBStrokeColor(context, 0, 0, 255, 1);
//    CGContextStrokeRect(context, CGRectMake(300, 150, 5, 5));
//    
//    CGContextSetRGBStrokeColor(context, 0, 255, 255, 1);
//    CGContextStrokeRect(context, CGRectMake(400, 200, 5, 5));
//    
//    CGContextSetRGBStrokeColor(context, 0, 255, 255, 1);
//    CGContextStrokeRect(context, CGRectMake(480, 250, 5, 5));
//    
//    CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
//    CGContextStrokeRect(context, CGRectMake(100, 320, 5, 5));
    
    
    
    
    
   
    
    
    
}



@end
