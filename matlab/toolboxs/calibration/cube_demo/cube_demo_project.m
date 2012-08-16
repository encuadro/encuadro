%% test poryección cubo

clear all; close all; clc;

% parametros
M     = 1024;               %tama?o de imagen
I     = 100*ones(M,M);		%creo imagen
fc    = 100; 				%focal length
fov   = 30;                 %field of view


focal_distance = 100;
fc = (M/2)/tan(fov/2*pi/180);


sigma = 1;					%noise level

om    = [pi/3;0;0];           % Rotaci??n
rot   = rodrigues(om);
T     = [0;0;160];           % Traslaci??n
c     = [(M+1)/2 (M+1)/2];   % Centro
k     = zeros(5,1);          % Distorsi??n
alpha = 0;                   % Sesgo

L = 30; % lado del cilindro


X     = [ 
            0             0            0   ;   
            L/2           L/2         -L/2 ;
           -L/2           L/2         -L/2 ;
           -L/2          -L/2         -L/2 ;
            L/2          -L/2         -L/2 ;
                  
            L/2           L/2          L/2 ;
           -L/2           L/2          L/2 ;            
           -L/2          -L/2          L/2 ;
            L/2          -L/2          L/2 ;
         ] ;


% x=project_points2(X',om,T,[fc;fc],c,k,alpha);
x=proj3dto2d(X', rot, T, fc,2, c')
I = imread('view_0002.png');

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


[rotPosit, TPosit] = classicPosit(x', X, fc, c)


xPosit=proj3dto2d(X', rotPosit, TPosit', fc,2, c')


subplot(1,2,2)
imshow(I)
hold on
for i=1:size(xPosit,2)
    plot(xPosit(1,i),xPosit(2,i),'+','markersize',10)
    text(xPosit(1,i),xPosit(2,i),num2str(i),'color',[1;1;1])
end
hold off
title('Pose estimada con POSIT')
