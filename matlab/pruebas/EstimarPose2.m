close all
clear all
clc
 a=10;
 
    object(1,1)=0.0*a;
    object(1,2)=0.0*a;
    object(1,3)=0.0*a;
    object(2,1)=0.0*a;   
    object(2,2)=9.5*a;
    object(2,3)=0.0*a;
    object(3,1)=9.5*a;
    object(3,2)=9.5*a;
    object(3,3)=0.0*a;
    object(4,1)=9.5*a; 
    object(4,2)=0.0*a;   
    object(4,3)=0.0*a;
    object(5,1)=1.5*a;
    object(5,2)=1.5*a;
    object(5,3)=0.0*a;
    object(6,1)=1.5*a;
    object(6,2)=8.0*a;
    object(6,3)=0.0*a;
    object(7,1)=8.0*a;
    object(7,2)=8.0*a;
    object(7,3)=0.0*a;
    object(8,1)=8.0*a;
    object(8,2)=1.5*a;
    object(8,3)=0.0*a;
    object(9,1)=3.0*a;
    object(9,2)=3.0*a;
    object(9,3)=0.0*a;
    object(10,1)=3.0*a;   
    object(10,2)=6.5*a;
    object(10,3)=0.0*a;
    object(11,1)=6.5*a;
    object(11,2)=6.5*a;
    object(11,3)=0.0*a;
    object(12,1)=6.5*a; 
    object(12,2)=0.0*a;  
    object(12,3)=0.0*a;
   
    % Marcador 2 
    object(13,1)=10.5*a;
    object(13,2)=0.0*a;
    object(13,3)=0.0*a;
    object(14,1)=10.5*a;
    object(14,2)=9.5*a;
    object(14,3)=0.0*a;
    object(15,1)=20.0*a;
    object(15,2)=9.5*a;
    object(15,3)=0.0*a;
    object(16,1)=20.0*a;
    object(16,2)=0.0*a;
    object(16,3)=0.0*a;
    object(17,1)=12.0*a;
    object(17,2)=1.5*a;
    object(17,3)=0.0*a;
    object(18,1)=12.0*a;   
    object(18,2)=8.0*a;
    object(18,3)=0.0*a;
    object(19,1)=18.5*a;
    object(19,2)=8.0*a;
    object(19,3)=0.0*a;
    object(20,1)=18.5*a; 
    object(20,2)=1.5*a;   
    object(20,3)=0.0*a;
    object(21,1)=13.5*a;
    object(21,2)=3.0*a;
    object(21,3)=0.0*a;
    object(22,1)=13.5*a;
    object(22,2)=6.5*a;
    object(22,3)=0.0*a;
    object(23,1)=17.0*a;
    object(23,2)=6.5*a;
    object(23,3)=0.0*a;
    object(24,1)=17.0*a;
    object(24,2)=3.0*a;
    object(24,3)=0.0*a;
   
    object(25,1)=0.0*a;
    object(25,2)=19.0*a;
    object(25,3)=0.0*a;
    object(26,1)=0.0*a;   
    object(26,2)=28.5*a;
    object(26,3)=0.0*a;
    object(27,1)=9.5*a;
    object(27,2)=28.5*a;
    object(27,3)=0.0*a;
    object(28,1)=9.5*a;
    object(28,2)=19.0*a;   
    object(28,3)=0.0*a;
    object(29,1)=1.5*a;
    object(29,2)=20.5*a;
    object(29,3)=0.0*a;
    object(30,1)=1.5*a;
    object(30,2)=27.0*a;
    object(30,3)=0.0*a;
    object(31,1)=8.0*a;
    object(31,2)=27.0*a;
    object(32,3)=0.0*a;
    object(32,1)=8.0*a;
    object(32,2)=20.5*a;
    object(32,3)=0.0*a;
    object(33,1)=3.0*a;
    object(33,2)=22.0*a;
    object(33,3)=0.0*a;
    object(34,1)=3.0*a;
    object(34,2)=25.5*a;
    object(34,3)=0.0*a;
    object(35,1)=6.5*a;
    object(35,2)=25.5*a;
    object(35,3)=0.0*a;
    object(36,1)=6.5*a;
    object(36,2)=22.0*a;
    object(36,3)=0.0*a;
  
    
    % Puntos en la imagen
    
    xo=242.8;
    yo=212.9;
    % Marcador 1
    
   vector1 =[
   95.1996  137.6025;
  193.0088  141.5601;
  188.4859  191.3127;
   71.4541  191.8781;
   92.3728  182.8322;
  107.0724  147.2138;
  176.6131  147.2138;
  172.0901  183.3975;
  115.5530  173.7862;
  120.0760  155.6943;
  159.0866  155.1290;
  156.8251  173.2208;];

vector2 =[
   68.6272  199.2279;
  187.9205  198.0972;
  180.5707  277.8145;
   32.4435  281.2067;
   82.1961  209.9700;
  167.5671  209.4046;
  160.2173  265.9417;
   61.8428  264.2456;
   98.5919  221.2774;
  145.5177  220.7120;
  139.8640  250.6767;
   89.5459  249.5459;];

vector3 =[
  288.5565  139.8640;
  382.4081  139.8640;
  414.0689  189.6166;
  303.8216  190.7473;
  304.9523  147.2138;
  372.2314  146.0830;
  392.0194  180.5707;
  317.3905  182.2668;
  324.7403  154.5636;
  359.7933  154.5636;
  370.5353  172.0901;
  332.0901  172.6555;
  ];

imagePts=[vector1; vector2;vector3];

fc = [ 486.09219   428.33488 ] ;
cc = [ 232.21387   149.33345 ] ;
kc = [ 0.46769   -2.03268   -0.00089   -0.00570  0.00000];
alpha_c=0.0;
[omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)

% Ahora vamos a desplegar algunos puntos en la imagen a ver si la transformacion dio bien.

Img = imread('Marcador480x320.jpg'); % Se importa la imagen

% Se escribe la matriz de cambio de coordenadas o de "parámetros extrinsecos"
Ext = [Rckk Tckk; 0 0 0 1]

% Se escribe la matriz de parámetros intrínsecos:
Int = [  486.09219      0      232.21387         0;
          0          428.33488  149.33345        0;
          0             0         1              0];
% La cámara debe haber sido previamente calibrada.

% Se escribe la matriz proyeccion:
T = Int * Ext;

% Los siguientes, son los puntos en el modelo que se desean proyectar:
pto3D1 = [0,0 ,0, 1];
pto3D2 = [0,0, 20, 1]
pto3D3 = [0,0,40, 1];

pto3D4 = [0,0 ,60, 1];
pto3D5 = [0,0 ,80, 1];

% pto3D2 = [(95/2 + 105),95/2, 0, 1]
% pto3D3 = [95/2,(95/2 +190) ,0, 1];
% 
% pto3D4 = [95,0 ,0, 1];
% pto3D5 = [0,95 ,0, 1];


% Se realiza la proyeccion:
pto2D1 = T * pto3D1';
pto2D1 = pto2D1 / pto2D1(3);

pto2D2 = T * pto3D2';
pto2D2 = pto2D2 / pto2D2(3);

pto2D3 = T * pto3D3';
pto2D3 = pto2D3 / pto2D3(3);

pto2D4 = T * pto3D4';
pto2D4 = pto2D4 / pto2D4(3);

pto2D5 = T * pto3D5';
pto2D5 = pto2D5 / pto2D5(3);

% Se dibujan los resultados:
imshow(Img)
hold on
plot(pto2D1(1),pto2D1(2),'*r')
hold on
plot(pto2D2(1),pto2D2(2),'*r')
hold on
plot(pto2D3(1),pto2D3(2),'*r')

hold on
plot(pto2D4(1),pto2D4(2),'*b')
hold on
plot(pto2D5(1),pto2D5(2),'*b')












