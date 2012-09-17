/*
 Program: ModernPosit.h
 Proyect: encuadro - Facultad de Ingeniería - UDELAR
 Author: Juan Ignacio Braun - juanibraun@gmail.com.
 
 Description:
 C implementation of modern posit, presented in the IJCV 2004 SoftPOSIT paper by Daniel DeMenthon.
 
 Hosted on:
 http://code.google.com/p/encuadro/
 *///


#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <stdbool.h>

void  ModernPosit(int NbPts,double** imgPts,double** worldPts, double focalLength,double center[2],double** R, double* T);
void  ModPosit(int NbPts,double** centeredImage,double** homogeneousWorldPts,double** objectMat, double focalLength,double center[2],double** R, double* T);

