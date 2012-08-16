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
   80.8754   37.4559;
  201.9913   36.2137;
  200.7491  163.5407;
   82.7388  161.0562;
  101.3720   58.5735;
  180.8737   58.5735;
  182.1159  144.2863;
  102.6142  142.4230;
  121.2474   78.4490;
  163.4827   78.4490;
  164.1038  123.7898;
  120.0052  123.1687;];

vector2 =[
   82.7388  174.7206;
  200.1280  177.2050;
  199.5069  297.6998;
   85.2232  291.4888;
  101.9931  193.9749;
  181.4948  197.0804;
  180.8737  276.5822;
  101.9931  274.0978;
  121.2474  213.8503;
  163.4827  213.8503;
  163.4827  257.3279;
  120.6263  256.7067;];

vector3 =[
  331.8028   36.2137;
  468.4464   35.5926;
  462.2353  170.3728;
  326.2128  168.5095;
  352.2993   58.5735;
  444.2232   58.5735;
  441.1176  149.8763;
  347.9516  146.7708;
  371.5536   79.6912;
  421.2422   78.4490;
  421.2422  127.5164;
  369.6903  128.1375;];

imagePts=[vector1; vector2;vector3];

fc = [ 448.04714   455.53400 ] ;
cc = [ 242.80734   212.87048 ] ;
kc = [ 0.38172   -1.79903   0.03287   -0.00243  0.00000 ];
alpha_c=0.0;
[omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)

% Ahora vamos a desplegar algunos puntos en la imagen a ver si la transformacion dio bien.

Img = imread('marcador.jpg'); % Se importa la imagen

% Se escribe la matriz de cambio de coordenadas o de "parámetros extrinsecos"
Ext = [Rckk Tckk; 0 0 0 1]

% Se escribe la matriz de parámetros intrínsecos:
Int = [  448.0000       0      242.8000         0;
          0          455.5000  212.9000         0;
          0             0         1             0] ;
% La cámara debe haber sido previamente calibrada.

% Se escribe la matriz proyeccion:
T = Int * Ext;

% Los siguientes, son los puntos en el modelo que se desean proyectar:
pto3D1 = [95/2,95/2 ,0, 1];
pto3D2 = [(95/2 + 105),95/2, 0, 1]
pto3D3 = [95/2,(95/2 +190) ,0, 1];

pto3D4 = [95,0 ,0, 1];
pto3D5 = [0,95 ,0, 1];

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












