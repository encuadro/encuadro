clc 
close all
clear all

Ia = imread('chairs.pgm');
Ib = imread('chairs.pgm');
imshow(Ia);
imshow(Ib);

% Pasamos a presicion simple
Ia = single(Ia');
Ib = single(Ib');

[fa,da] = vl_sift(Ia,'verbose','verbose') ;
[fb,db] = vl_sift(Ib,'verbose','verbose') ;

[matches, scores] = vl_ubcmatch(da, db) ;