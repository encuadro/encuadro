function [rotPosit,TPosit]=test_posit(file,om,T)
% funcion para ver funcionamiento de posit.
% Se le ingersa una imagen y la pose de la camara de esa imagen 
% y devuleve la pose estimada por POSIT.


%% test poryección prisma

% parametros
M     = 1024;               %tama?o de imagen
I     = ones(M,M);		%creo imagen
fc    = 100; 				%focal length
fov   = 30;                 %field of view


focal_distance = 100;
fc = ((M+1)/2)/tan(fov/2*pi/180);


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
                  
            Lx/2           Ly/2          Lz/2 ;
           -Lx/2           Ly/2          Lz/2 ;            
           -Lx/2          -Ly/2          Lz/2 ;
            Lx/2          -Ly/2          Lz/2 ;
         ] ;


rot   = rodrigues(om);     
x    = proj3dto2d(X', rot, T, fc,2, c')

I = imread(file);


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

sigma = 10;					%noise level
dim=size(x);
x=x+sqrt(sigma)*randn(dim(1),dim(2));

[rotPosit, TPosit] = modernPosit(x', X, fc, c);

xPosit=proj3dto2d(X', rotPosit, TPosit, fc,2, c')


subplot(1,2,2)
imshow(I)
hold on
for i=1:size(xPosit,2)
    plot(xPosit(1,i),xPosit(2,i),'+','markersize',10)
    text(xPosit(1,i),xPosit(2,i),num2str(i),'color',[1;1;1])
end
hold off
title('Pose estimada con POSIT')

