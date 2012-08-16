close all 
clear all 
clc

%Img = imread('marcador.jpg');
Img = imread('Calibrar1.jpg');
%Rot = [  -0.238584	 0.868239	 0.435016;
%        0.705950	 -0.152546	 0.691639;
%        0.666868	 0.472113	 -0.576538]
%Trans = [-75.190302	 -81.166803	 207.165755]

Rot = [ -0.160046 	 0.956317 	 0.244630;
          0.985030 	 0.170805 	 -0.023272;
         -0.064039 	 0.237243 	 -0.969337 ];
Trans = [ -27.800369 	 -137.888613 	 738.161083 ];




Proyeccion = [Rot Trans'; 0 0 0 1]
 Int = [  486.0921        0         232.21387         0;
          0              428.33488  149.33345        0;
          0         0         1    0.0000]





T = Int * Proyeccion

% pto3D1 = [95/2,95/2 ,0, 1];
% pto3D2 = [(95/2 + 105),95/2, 0, 1]
% pto3D3 = [95/2,(95/2 +190) ,0, 1];
% 
% pto3D4 = [95,0 ,0, 1];
% pto3D5 = [0,95 ,0, 1];
% 
pto3D1 = [0,0 ,0, 1];
pto3D2 = [88,0, 0, 1];
pto3D3 = [88,88 ,0, 1];
pto3D4 = [0,88 ,0, 1];
pto3D5 = [88*2,0,0, 1];

pto3D6 = [0,88*2 ,0, 1];
pto3D7 = [88*2,88*2, 0, 1];
pto3D8 = [88*3,88*3 ,0, 1];
pto3D9 = [0,88*3 ,0, 1];
pto3D10 = [88*3,0,0, 1];



pto2D1 = T * pto3D1'
pto2D1 = pto2D1 / pto2D1(3)

pto2D2 = T * pto3D2'
pto2D2 = pto2D2 / pto2D2(3)

pto2D3 = T * pto3D3'
pto2D3 = pto2D3 / pto2D3(3)

pto2D4 = T * pto3D4'
pto2D4 = pto2D4 / pto2D4(3)

pto2D5 = T * pto3D5'
pto2D5 = pto2D5 / pto2D5(3)

pto2D6 = T * pto3D6'
pto2D6 = pto2D6 / pto2D6(3)

pto2D6 = T * pto3D6'
pto2D6 = pto2D6 / pto2D6(3)

pto2D7 = T * pto3D7'
pto2D7 = pto2D7 / pto2D7(3)

pto2D8 = T * pto3D8'
pto2D8 = pto2D8 / pto2D8(3)

pto2D9 = T * pto3D9'
pto2D9 = pto2D9 / pto2D9(3)

pto2D10 = T * pto3D10'
pto2D10 = pto2D10 / pto2D10(3)



imshow(Img)
hold on
plot(pto2D1(1),pto2D1(2),'*r')
hold on
plot(pto2D2(1),pto2D2(2),'*r')
hold on
plot(pto2D3(1),pto2D3(2),'*r')

hold on
plot(pto2D4(1),pto2D4(2),'*r')
hold on
plot(pto2D5(1),pto2D5(2),'*r')

hold on
plot(pto2D6(1),pto2D6(2),'*r')
hold on
plot(pto2D7(1),pto2D7(2),'*r')

hold on
plot(pto2D8(1),pto2D8(2),'*r')
hold on
plot(pto2D9(1),pto2D9(2),'*r')

hold on
plot(pto2D10(1),pto2D10(2),'*r')



