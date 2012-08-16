%% test poryección prisma

clear all; close all; clc;

% parametros
M     = 1024;               %tama?o de imagen
I     = ones(M,M);		%creo imagen
fc    = 100; 				%focal length
fov   = 30;                 %field of view


focal_distance = 100;
fc = (M/2)/tan(fov/2*pi/180);


om    = [pi/6;0;0];           % Rotaci??n
T     = [0;0;160];           % Traslaci??n
c     = [(M+1)/2 (M+1)/2];   % Centro
k     = zeros(5,1);          % Distorsi??n
alpha = 0;                   % Sesgo

% dimensiones del prisma
Lx = 10;
Ly = 20;
Lz = 30;

X     = [ 
            Lx/2           Ly/2         -Lz/2 ;
           -Lx/2           Ly/2         -Lz/2 ;
           -Lx/2          -Ly/2         -Lz/2 ;
            Lx/2          -Ly/2         -Lz/2 ;
                  
%             Lx/2           Ly/2          Lz/2 ;
%            -Lx/2           Ly/2          Lz/2 ;            
%            -Lx/2          -Ly/2          Lz/2 ;
%             Lx/2          -Ly/2          Lz/2 ;
         ] ;

x=project_points2(X',om,T,[fc;fc],c,k,alpha);

I = imread('prisma-30-160.png');

figure(1)
subplot(1,2,1)
imshow(I)
hold on
for i=1:size(x,2)
    plot(x(1,i),x(2,i),'+','markersize',10)
    text(x(1,i),x(2,i),num2str(i),'color',[1;1;1])
end
hold off
title('Proyeccion con pose conocida')

%% Estimacion pose con POSIT

sigma = 500;					%noise level
dim=size(x);
x=x+sqrt(sigma)*randn(dim(1),dim(2));

[rot, TPosit] = modernPosit(x', X, fc, c);
omPosit=rodrigues(rot);

xPosit=project_points2(X',omPosit,TPosit,[fc;fc],c,k,alpha);


subplot(1,2,2)
imshow(I)
hold on
for i=1:size(xPosit,2)
    plot(xPosit(1,i),xPosit(2,i),'+','markersize',10)
    text(xPosit(1,i),xPosit(2,i),num2str(i),'color',[1;1;1])
end
hold off
title('Pose estimada con POSIT')

