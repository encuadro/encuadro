close all
clear all
clc
% Este  script es para comparar el SoftPosit de matlab, con la migracion a
% C del mismo. Se usan los parametros de la camara iphone de Juani y el
% modelo es un portalapices. Como poses iniciales se usaron las poses
% calculadas mediante modern posit. En las pruebas en Xcode se utilizo como
% pose inicial de Img4 la pose de Img3 y encontro bien la pose. 

%Parametros de la camara
 fc = [ 2469.28676   2475.62116 ] ;
 cc = [ 1349.92522   1005.36017 ] ;
 kc = [ 0.38172   -1.79903   0.03287   -0.00243  0.00000 ] ; 
 alpha_c = 0.00000 ;
 MaxIter = 400 ;
 thresh_cond = 0.01 ;
 
BETA0 = 2.0e-03
NOISESTD = 0

DISPLEVEL =0;
KICKOUT.numMatchable = 7;
KICKOUT.rthldfbeta = zeros(1,200);
IMAGEADJ=0;
WORLDADJ=0;


%MODELO

object=[0.0 0.0 0.0;
        0.0 7 0.0;
        7.0 7.0 0.0;
        7.0 0.0 0.0;
        0.0 0.0 10.5;
        0.0 7.0 10.5;
        7.0 7.0 10.5;
        7.0 0.0 10.5];

object=object*10;

%% Foto Img1.jpg
Img = imread('Img1.JPG');
figure
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('Img1.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('Img1.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[1;1;1])
end
title('Puntos detectados')


INITROT = [0.818480905882484,0.0283334326205691,-0.558526230873291;
           0.254439900150231,-0.901223207964561,0.375096695590682;
          -0.492729024569266,-0.449120841615272,-0.744843143424043];
INITTRANS =[13.1570764941129;-24.6660815665101;779.485117496804];


[rot, trans, assignMat, projWorldPts, foundPose, stats] = ...
    softPosit(imagePts, IMAGEADJ,  object,WORLDADJ, BETA0,NOISESTD, ...
    INITROT, INITTRANS,  fc(1) , DISPLEVEL,KICKOUT,cc);

figure
imshow(Img)
for i=1:8
    hold on
    plot(projWorldPts(i,1),projWorldPts(i,2),'r+')
    text(projWorldPts(i,1),projWorldPts(i,2),num2str(i-1),'color',[1;1;1])
end
title('Puntos softPosit')

Rotacion=[
0.822945	 0.034410	 -0.567078;
0.287474	 -0.886166	 0.363412;
-0.490021	 -0.462088	 -0.739158];
Traslacion=[
   13.336019	 -27.117659	 780.952812];
xPosit=proj3dto2d(object', Rotacion, Traslacion', fc(1),2, cc');



figure
imshow(Img)
for i=1:8
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[1;1;1])
end
title('Puntos softPositXCode')

display('Presione cualquier tecla')
pause


%% Foto Img2.jpg
Img = imread('Img2.JPG');
figure
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('Img2.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('Img2.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[1;1;1])
end
title('Puntos detectados')


INITROT = [0.588747091751459,0.0332702524753381,0.807612064669570;
           0.581690578964327,0.669776262924905,-0.461593472972425;
          -0.556276721954212,0.741542144260188,0.374975834496530];
INITTRANS =[-68.5302550702077;9.46684829380513;388.698837017614;];


[rot, trans, assignMat, projWorldPts, foundPose, stats] = ...
    softPosit(imagePts, IMAGEADJ,  object,WORLDADJ, BETA0,NOISESTD, ...
    INITROT, INITTRANS,  fc(1) , DISPLEVEL,KICKOUT,cc);

figure
imshow(Img)
for i=1:8
    hold on
    plot(projWorldPts(i,1),projWorldPts(i,2),'r+')
    text(projWorldPts(i,1),projWorldPts(i,2),num2str(i-1),'color',[1;1;1])
end
title('Puntos softPositMatlab')


Rotacion=[
0.595402	 0.021172	 0.803149;
0.583995	 0.675122	 -0.450733;
-0.551767	 0.737402	 0.389605];
Traslacion=[
    -68.216946	 9.302239	 390.488301];
xPosit=proj3dto2d(object', Rotacion, Traslacion', fc(1),2, cc');

figure
imshow(Img)
for i=1:8
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[1;1;1])
end
title('Puntos softPositXCode')

display('Presione cualquier tecla')
pause



%% Foto Img3.jpg
Img = imread('Img3.JPG');
figure
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('Img3.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('Img3.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[1;1;1])
end
title('Puntos detectados')


INITROT = [0.650744450063987,0.0160232842382338,0.770777457815296;
           0.429280804207171,0.800705171210948,-0.396331100812021;
          -0.623516022206298,0.588790231196882,0.514175957959229];
INITTRANS =[-81.6516452680535;-12.2491098372390;400.873679802791];


[rot, trans, assignMat, projWorldPts, foundPose, stats] = ...
    softPosit(imagePts, IMAGEADJ,  object,WORLDADJ, BETA0,NOISESTD, ...
    INITROT, INITTRANS,  fc(1) , DISPLEVEL,KICKOUT,cc);

figure
imshow(Img)
for i=1:8
    hold on
    plot(projWorldPts(i,1),projWorldPts(i,2),'r+')
    text(projWorldPts(i,1),projWorldPts(i,2),num2str(i-1),'color',[1;1;1])
end
title('Puntos softPositMatlab')

Rotacion=[
0.650141	 0.024436	 0.759421;
0.421390	 0.820093	 -0.387141;
-0.632256	 0.571709	 0.522879];
Traslacion=[
    -81.324097	 -11.665573	 400.388762];
xPosit=proj3dto2d(object', Rotacion, Traslacion', fc(1),2, cc');

figure
imshow(Img)
for i=1:8
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[1;1;1])
end
title('Puntos softPositXCode')

display('Presione cualquier tecla')
pause



%% Foto Img4.jpg
Img = imread('Img4.JPG');
figure
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('Img4.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('Img4.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[1;1;1])
end
title('Puntos detectados')


INITROT = [0.508111848583711,-0.0455723767854050,-0.862197717128813;
          -0.266489067377332,0.941911253767743,-0.195347302376109;
           0.821016173604382,0.329024544458688,0.466451728166017];
INITTRANS =[24.2296290303894;-36.1104799167114;154.322088410189;];


[rot, trans, assignMat, projWorldPts, foundPose, stats] = ...
    softPosit(imagePts, IMAGEADJ,  object,WORLDADJ, BETA0,NOISESTD, ...
    INITROT, INITTRANS,  fc(1) , DISPLEVEL,KICKOUT,cc);

figure
imshow(Img)
for i=1:8
    hold on
    plot(projWorldPts(i,1),projWorldPts(i,2),'r+')
    text(projWorldPts(i,1),projWorldPts(i,2),num2str(i-1),'color',[1;1;1])
end
title('Puntos softPosit')


Rotacion=[
0.502971	 -0.034164	 -0.863628;
-0.280417	 0.938716	 -0.200447;
0.817549	 0.342995	 0.462566];
Traslacion=[
   25.443374	 -36.998324	 160.038267];
xPosit=proj3dto2d(object', Rotacion, Traslacion', fc(1),2, cc');



figure
imshow(Img)
for i=1:8
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[1;1;1])
end
title('Puntos softPositXCode')

