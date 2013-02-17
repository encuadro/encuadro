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

void  ModernPosit(int NbPts,float** imgPts,float** worldPts, float focalLength,float center[2],float** R, float* T);
void  ModPosit(int NbPts,float** centeredImage,float** homogeneousWorldPts,float** objectMat, float focalLength,float center[2],float** R, float* T);

