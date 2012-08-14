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
@property(nonatomic, readwrite) double* segmentos;
@property(nonatomic, readwrite) bool bandera;

- (id)initWithFrame:(CGRect)frame;

-(void)drawRect:(CGRect)rect; //cantidadSeg:(int) cantidadSeg segmentos: (double*) segmentos;

@end
