clear all; close all; clc;

%% QlSet Model
l = 1.5;

Ql =[	+l		+l		0	;
		-l		+l		0	;
		-l		-l		0	;
		+l		-l		0	;
		+2*l	+2*l	0	;
		-2*l	+2*l	0	;
		-2*l	-2*l	0	;
		+2*l	-2*l	0	;
		+3*l	+3*l	0	;
		-3*l	+3*l	0	;
		-3*l	-3*l	0	;
		+3*l	-3*l	0	;
	];

centerQl(1,:) = [0		0		0];
centerQl(2,:) = [12*l	0		0] + centerQl(1,:);
centerQl(3,:) = [0		6*l+1	0] + centerQl(1,:);

QlSet = zeros(12,3,3);
for i=1:3
	for j=1:12
		QlSet(j,:,i)=Ql(j,:)+centerQl(i,:);
	end
	plot(QlSet(:,1,i),QlSet(:,2,i),'x'); hold on;
end
QlSet=QlSet*10
hold off;

%% test poryección prisma

% parametros
M     = 480;				%tama?o de imagen
N     = 359;
I     = ones(M,N);			%creo imagen
fc    = 100;				%focal length
% fov   = 56.145;             %field of view
fov   = 80;             %field of view


%focal_distance = 100;
fc = ((M+1)/2)/tan(fov/2*pi/180);
% fc = 486.09;

c     = [(M+1)/2 (N+1)/2];   % Centro
k     = zeros(5,1);          % Distorsi??n
alpha = 0;                   % Sesgo

X = [QlSet(:,:,1);
	 QlSet(:,:,2);
	 QlSet(:,:,3)];

T =  [0;0;800];
om = [0 0 0]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


% im = imread('pose_fov56145_480x359_tz80.png');
im = imread('out0001.jpg');
figure(3)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])

%%

fov = 56.145;
fc = ((M+1)/2)/tan(fov/2*pi/180);

T =  [-200;100;800];
om = [0 0 0]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


im = imread('out0004.png');
figure(4)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])

%%

fov = 80;
fc = ((M+1)/2)/tan(fov/2*pi/180);

T =  [0;0;500];
om = [-2 5 15]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


im = imread('out0002.png');
figure(5)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])

%%

fov = 56.145;
fc = ((M+1)/2)/tan(fov/2*pi/180);

T =  [0;70;800];
om = [5 0 0]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


im = imread('out0005.png');
figure(6)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])


%% tz= -800 rx=30

fov = 80;
fc = ((M+1)/2)/tan(fov/2*pi/180);

T =  [0;0;800];
om = [30 0 0]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


im = imread('out0006.png');
figure(7)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])

%% tz= -800 ry=30 ry=15 ry=45

fov = 80;
fc = ((M+1)/2)/tan(fov/2*pi/180);

T =  [0;0;800];
om = [30 -15 -45]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


im = imread('out0007.png');
figure(8)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])

%% tz= -800 ry=30 ry=30 ry=30

fov = 80;
fc = ((M+1)/2)/tan(fov/2*pi/180);

T =  [0;0;800];
om = [30 -30 -30]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


im = imread('out0010.png');
figure(11)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])

%% tz= -800 ry=30

fov = 80;
fc = ((M+1)/2)/tan(fov/2*pi/180);

T =  [0;0;800];
om = [0 -30 0]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


im = imread('out0008.png');
figure(9)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])

%% tz= -800 rz=30
fov = 80;
fc = ((M+1)/2)/tan(fov/2*pi/180);

T =  [0;0;800];
om = [0 0 -30]*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(X', rot, T, fc,2, c');


im = imread('out0009.png');
figure(10)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')
% axis([0 M 0 N])


