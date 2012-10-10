//
//  claseDibujar.h
//  LSD
//
//  Created by juani on 12/29/11.
//  Copyright (c) 2011 pablofloresguridi@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface claseDibujar : UIView

@property(nonatomic, readwrite) int cantidadSegmentos;
@property(nonatomic, readwrite) float* segmentos;
@property(nonatomic, readwrite) float** esquinas;
@property(nonatomic, readwrite) float** esquinasReproyectadas;
@property(nonatomic, readwrite) int dealloc;
@property(nonatomic, readwrite) bool segments;
@property(nonatomic, readwrite) bool corners;
@property(nonatomic, readwrite) bool reproyected;

- (id)initWithFrame:(CGRect)frame;
-(void)drawRect:(CGRect)rect; //cantidadSeg:(int) cantidadSeg segmentos: (float*) segmentos;

@end
