function [rotPosit,TPosit]=test_posit(file,om,T)
% funcion para ver funcionamiento de posit.
% Se le ingersa una imagen y la pose de la camara de esa imagen 
% y devuleve la pose estimada por POSIT.


%% test poryección prisma

% parametros
M     = 480;               %tama?o de imagen
N     = 320;
I     = ones(M,N);		%creo imagen
fc    = 100; 				%focal length
fov   = 30;                 %field of view


%focal_distance = 100;
%fc = ((M+1)/2)/tan(fov/2*pi/180);
fc = 486.09;

c     = [(M+1)/2 (N+1)/2];   % Centro
k     = zeros(5,1);          % Distorsi??n
alpha = 0;                   % Sesgo

% dimensiones del prisma
%Lx = 44;
%Ly = 44;
%Lz = 0;

%Y     = [ 
%            Lx/2           Ly/2         -Lz/2 ;
%           -Lx/2           Ly/2         -Lz/2 ;
%           -Lx/2          -Ly/2         -Lz/2 ;
%            Lx/2          -Ly/2         -Lz/2 ;
                  
%            Lx/2           Ly/2          Lz/2 ;
%           -Lx/2           Ly/2          Lz/2 ;            
%           -Lx/2          -Ly/2          Lz/2 ;
%            Lx/2          -Ly/2          Lz/2 ;
%         ] ;

X=[0 0 0;
   44 0 0;
   88 0 0;
   132 0 0;
   132 44 0;
   132 88 0;
   132 132 0;
   88 132 0;
   44 132 0;
   0 132 0;
   0 88 0;
   0 44 0;
   44 44 0;
   88 44 0;
   88 88 0;
   44 88 0;];

rot   = rodrigues(om);     
x    = proj3dto2d(X', rot, T, fc,2, c')

I = imread(file);

cTool=[232.2 149.3];
c=[232.2 149.3];
subplot(1,2,1)
imshow(I)
hold on
for i=1:size(x,2)
    plot(x(1,i),x(2,i),'+','markersize',10)
    text(x(1,i),x(2,i),num2str(i),'color',[1;1;1])
end
plot(c(1),c(2),'+','markersize',10)
plot(cTool(1),cTool(2),'*','markersize',10)
hold off
title('Proyeccion con pose conocida')

%% Estimacion pose con POSIT

sigma = 10;					%noise level
dim=size(x);
x=x+sqrt(sigma)*randn(dim(1),dim(2));
x=ginput(16);
x=x'
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PROJ3DTO2D   Project a set of 3D points onto a 2D image.
%      PTS2D = proj3dto2d(PTS3D, ROT, TRANS, FLENGTH, OBJDIM, [CENTER])
%      returns a Nx2 (or 2xN, see below) matrix of the projections of the
%      3D object points PTS3D onto the image plane at focal length FLENGTH.
%      The 3D object points are mapped into the camera coordinate system
%      according to the transformation "Xcamera = ROT*Xobject + TRANS".
%      OBJDIM gives the dimension (1 or 2) in PTS3D along which object
%      points are indexed. Thus, the image matrix PTS2D will be Nx2
%      if OBJDIM == 1 and 2xN if OBJDIM == 2.  The optional argument
%      CENTER is a 2-vector which is principle point of the image plane;
%      if not specified, the center is assumed to be (0,0).
%
%    AUTHOR:
%        Philip David
%        Army Research Laboratory        University of Maryland
%        ATTN: AMSRL-CI-CB               Dept. of Computer Science
%        Adelphi, MD 20783               College Park, MD 20742
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pts2d = proj3dto2d(pts3d, rot, trans, flength, objdim, varargin)

% Check the inputs.
if objdim ~= 1 & objdim ~= 2
    error(['OBJDIM must be 1 or 2.  You gave ' num2str(OBJDIM)]);
elseif size(pts3d,bitcmp(objdim,2)) ~= 3
    error(['PTS3D does not have size 3 along dimension ' ...
          num2str(bitcmp(objdim,2))]);
end

% Get the principle point of the image.
if length(varargin) >= 1
    center = varargin{1};
    if size(center,2) ~= 1 
        center = center';              % Make sure center is a column vector.
    end
else
    center = [0;0];
end

% Make sure the 3D point matrix is 3xN.
if objdim == 1
    pts3d = pts3d';
end

numpts = size(pts3d,2);       % Number of 3D points.

% Map the world points into camera points.
campts = rot*pts3d + trans(:,ones(1,numpts));          % 3D camera points.
campts(3,find(campts(3,:) < 1e-20)) = 1e-20;           % Don't divide by zero!

% Project the camera points into the image.
pts2d = flength * campts(1:2,:) ./ campts([3;3],:);    % 2D image points.
pts2d = pts2d + center(:,ones(1,numpts));              % Shift principle point.

% Put the 2D point matrix into the same form as the 3D point matrix.
if objdim == 1
    pts2d = pts2d';
end

return

