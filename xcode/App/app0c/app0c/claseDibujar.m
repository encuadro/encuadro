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


CGFloat cgx1;
CGFloat cgy1;
CGFloat cgx2;
CGFloat cgy2;
CGPoint puntos2[2];
CGFloat cgesq1;
CGFloat cgesq2;
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
        
//    for(int i=0;i<self.cantidadSegmentos;i++){
//        
//        /*Para el iPhone habría que cambiar la linea que viene por la siguiente:*/
//        cgx1=self.segmentos[i*dim]*480/352;
//        cgy1=self.segmentos[i*dim+1]*320/288;
//        cgx2=self.segmentos[i*dim+2]*480/352;
//        cgy2=self.segmentos[i*dim+3]*320/288;
//        
//        
//        /*Para el iPad*/
////        
////        cgx1=self.segmentos[i*dim]*1024/352;
////        cgy1=self.segmentos[i*dim+1]*768/288;
////        cgx2=self.segmentos[i*dim+2]*1024/352;
////        cgy2=self.segmentos[i*dim+3]*768/288;
////        
//        
//        
//       
//        CGContextSetRGBStrokeColor(context, 255, 0, 0, 1);
//        puntos2[0]=CGPointMake(cgx1,cgy1);
//        puntos2[1]=CGPointMake(cgx2,cgy2);
//        CGContextStrokeLineSegments(context, puntos2, 2);
//        
//    }    
//  
//
//    
//        /*Dibujo esquinas*/
//     for(int i=0;i<self.cantidadEsquinas;i++){
//        
//         /*Para el iPhone habría que cambiar la linea que viene por la siguiente:*/
//    cgesq1=self.esquinas[i][0]*480/352;
//    cgesq2=self.esquinas[i][1]*320/288;
//         
//         /*Para el iPad*/
////    cgesq1=self.esquinas[i][0]*1024/352;
////    cgesq2=self.esquinas[i][1]*768/288;
//    CGContextSetRGBStrokeColor(context, 0, 0, 255, 1);
//    CGContextStrokeRect(context, CGRectMake(cgesq1, cgesq2, 5, 5));
//         
//     }    
//    
    
    ////////////////////////////////////////DIBUJOS DE TESTEO 
    ////////////////////////////////////////DIBUJOS DE TESTEO
    
    // Draw a circle (filled)
    CGContextFillEllipseInRect(context, CGRectMake(100, 100, 25, 25));
    
    // Draw a circle (border only)
    CGContextStrokeEllipseInRect(context, CGRectMake(100, 100, 25, 25));
    
    // Get the graphics context and clear it
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // Draw a green solid circle
    CGContextSetRGBFillColor(ctx, 0, 255, 0, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(100, 100, 25, 25));
    
    // Draw a yellow hollow rectangle
    CGContextSetRGBStrokeColor(ctx, 255, 255, 0, 1);
    CGContextStrokeRect(ctx, CGRectMake(195, 195, 60, 60));
    
    // Draw a purple triangle with using lines
    CGContextSetRGBStrokeColor(ctx, 255, 0, 255, 1);
    CGPoint points[6] = { CGPointMake(100, 200), CGPointMake(150, 250),
        CGPointMake(150, 250), CGPointMake(50, 250),
        CGPointMake(50, 250), CGPointMake(100, 200) };
    CGContextStrokeLineSegments(ctx, points, 6);
    
    ////////////////////////////////////////DIBUJOS DE TESTEO
    ////////////////////////////////////////DIBUJOS DE TESTEO
    
    
}



@end
