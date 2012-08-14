% script para test de funciones implementadas para posit de líneas

clear all; close all; clc;

%% test distanceSegments

% para probar función

%	[ x1	y1	x2	y2 ]
li =[ 0		0	10	10] ;
lj =[ 4		0	0	4 ];

vi = [li(3)-li(1); li(4)-li(2)];	
vj = [lj(3)-lj(1); lj(4)-lj(2)];
pi1 = li(1:2);
pi2 = li(3:4);
pj1 = lj(1:2);
pj2 = lj(3:4);

dij = distanceSegments(li,lj)

figure(1)
plot(li(1:2:3),li(2:2:4),'-x'); hold on;
plot(lj(1:2:3),lj(2:2:4),'-o');
legend('li','lj')

% quiver(0,0,pi1(1),pi1(2),0);
% quiver(0,0,pi2(1),pi2(2),0);
% quiver(0,0,pj1(1),pj1(2),0);
% quiver(0,0,pj2(1),pj2(2),0);

axis square
hold off

%% test distanceMatrix

imgPoints = [0 0; 2 2; 0 0; 2 2; 0 0; 2 2; 0 0; 2 2]; 

projPoints = [0 0; 1 1; 0 0; 1 1; 0 0; 1 1]; 

[m,d] = distanceMatrix(imgPoints,projPoints,1,1)

spy(m)
