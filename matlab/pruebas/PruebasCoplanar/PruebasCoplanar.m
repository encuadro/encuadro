close all
clear all
clc
% Este  script es para probar si los puntos que arroja el filtro para el
% LSD del programa LSD en Xcode; con la imagen "la foto.pgm" estan bien.

%Parametros de la camara
 fc = [ 448.04714   455.53400 ] ;
 cc = [ 242.80734   212.87048 ] ;
 kc = [ 0.38172   -1.79903   0.03287   -0.00243  0.00000 ] ; 
 alpha_c = 0.00000 ;
 MaxIter = 200 ;
 thresh_cond = 0.1 ;


%MODELO

% object=[0.0 0.0 0.0;
%     0.0 9.5 0.0;
%     9.5 9.5 0.0;
%     9.5 0.0 0.0;
%     1.5 1.5 0.0;
%     1.5 8.0 0.0;
%     8.0 8.0 0.0;
%     8.0 1.5 0.0;
%     3.0 3.0 0.0;
%     3.0 6.5 0.0;
%     6.5 6.5 0.0;
%     6.5 3.0 0.0;
%     10.5 0.0 0.0;
%     10.5 9.5 0.0;
%     20.0 9.5 0.0;
%     20.0 0.0 0.0;
%     12.0 1.5 0.0;
%     12.0 8.0 0.0;
%     18.5 8.0 0.0;
%     18.5 1.5 0.0;
%     13.5 3.0 0.0;
%     13.5 6.5 0.0;
%     17.0 6.5 0.0;
%     17.0 3.0 0.0;
%     0.0 19.0 0.0;
%     0.0 28.5 0.0;
%     9.5 28.5 0.0;
%     9.5 19.0 0.0;
%     1.5 20.5 0.0;
%     1.5 27.0 0.0;
%     8.0 27.0 0.0;
%     8.0 20.5 0.0;
%     3.0 22.0 0.0;
%     3.0 25.5 0.0;
%     6.5 25.5 0.0;
%     6.5 22.0 0.0];

% object=object*10;



%% render de frente, la foto 18
display('------------------------FOTO17------------------------');

Img = imread('la foto18.pgm');
imshow(Img)
nb=36;

object=[15 15 0;
    15 -15 0;
    -15 -15 0;
    -15 15 0;
    30 30 0;
    30 -30 0;
    -30 -30 0;
    -30 30 0;
    45 45 0;
    45 -45 0;
    -45 -45 0;
    -45 45 0;
    205 15 0;
    205 -15 0;
    175 -15 0;
    175 15 0;
    220 30 0;
    220 -30 0;
    160 -30 0;
    160 30 0;
    235 45 0;
    235 -45 0;
    145 -45 0;
    145 45 0;
    15 115 0;
    15 85 0;
    -15 85 0;
    -15 115 0;
    30 130 0;
    30 70 0;
    -30 70 0;
    -30 130 0;
    45 145 0;
    45 55 0;
    -45 55 0;
    -45 145 0];

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto16.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

imagePts=[282.44	154.255;
314.784	130.781;
288.225	112.149;
256.715	134.766;
278.929	177.981;
346.14	128.838;
291.151	91.0578;
227.006	137.722;
275.269	200.573;
375.448	126.504;
294.607	71.8986;
198.587	139.115;
494.194	310.895;
530.023	276.644;
489.648	249.634;
454.643	280.934;
496.796	345.346;
570.378	273.793;
487.697	221.771;
416.651	283.323;
498.941	379.932;
608.667	270.669;
485.832	196.226;
380.94	285.029;
165.068	241.628;
201.246	214.694;
176.986	192.609;
141.595	219.052;
158.33	269.363;
233.12	212.485;
182.574	168.921;
111.312	221.432;
151.849	297.139;
263.101	210.245;
186.943	147.475;
82.0259	222.614];


% hold on
% for i=1:nb
%     hold on
%     plot(imagePts(i,1),imagePts(i,2),'r+')
%     text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos detectados')

center=[292 217];

Rotacion=[0.796998	 -0.447087	 0.406088;
0.582281	 0.747376	 -0.319967;
-0.160447	 0.491470	 0.855987];

Traslacion=[-66.816280	 -70.764174	 405.306742];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 745.43429,2, center');

figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[0.421546	 -0.218693	 0.880041;
0.605893	 0.789983	 -0.093914;
-0.674679	 0.572800	 0.465519];


Traslacion=[
-41.521222	 -74.232965	 596.395517];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 745.43429,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sum(sqrt(ErrorModernCoplanarPosit)))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause
%% render de frente, la foto 16
display('------------------------FOTO16------------------------');

Img = imread('la foto16.png');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto16.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto16.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[240 179];

Rotacion=[
-0.013483	 0.998097	 0.060174;
0.964756	 -0.002832	 0.263132;
0.262802	 0.061601	 -0.962881];
Traslacion=[
   -44.065094	 -43.309499	 678.524157];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 449,2, center');

figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[0.003383	 0.911138	 -0.412088
0.999884	 -0.009196	 -0.012124
-0.014836	 -0.412000	 -0.911063];
Traslacion=[
-43.695186	 -44.059207	 755.811676];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 449,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sum(sqrt(ErrorModernCoplanarPosit)))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, foto inclinada la foto15.pgm
display('------------------------FOTO15------------------------');

Img = imread('la foto15.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto15.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto15.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];

Rotacion=[
-0.801210	 0.132852	 -0.583449;
-0.250565	 0.810957	 0.528740;
0.543396	 0.569824	 -0.616459];
Traslacion=[
    439.017151	 -498.842208	 1173.348616];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[-0.840144	 0.104994	 -0.532104;
-0.206865	 0.844885	 0.493332;
0.501364	 0.524544	 -0.688105];
Traslacion=[
447.279034	 -508.681144	 1186.031231];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause

%% Foto con cuadro de lejos, foto inclinada la foto14.pgm
display('------------------------FOTO14------------------------');

figure
Img = imread('la foto14.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto14.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto14.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
0.795107	 -0.089964	 0.599759;
0.159728	 -0.922957	 -0.350196;
0.585057	 0.374241	 -0.719480];
Traslacion=[
    -430.442512	 345.672750	 1230.031525];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[0.827100	 -0.054530	 0.559403;
0.121881	 -0.954199	 -0.273221;
0.548681	 0.294161	 -0.782572];
Traslacion=[
-437.902308	 353.851970	 1243.203464];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, foto inclinada la foto13.pgm
display('------------------------FOTO13------------------------');

figure
Img = imread('la foto13.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto13.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto13.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
0.703034	 -0.163231	 0.692170;
0.168053	 -0.907603	 -0.384727;
0.691015	 0.386797	 -0.610644];
Traslacion=[
   -501.163822	 304.663585	 1140.058092];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[0.740293	 -0.123464	 0.660851
0.126714	 -0.939748	 -0.317516
0.660235	 0.318794	 -0.680044];
Traslacion=[
-510.251363	 313.551201	 1152.826290];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')
 
disp('Presione cualquier tecla')
pause

%% Foto con cuadro de lejos, foto inclinada la foto12.pgm
display('------------------------FOTO12------------------------');

figure 
Img = imread('la foto12.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto12.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto12.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
    0.979661	 0.017408	 0.199901;
-0.000875	 -0.995850	 0.091009;
0.200655	 -0.089333	 -0.975580];
Traslacion=[-536.354549	 193.383464	 3153.483572];
% Rotacion=[
% 0.942851	 0.032475	 0.331628;
% 0.006630	 -0.996871	 0.078768;
% 0.333148	 -0.072067	 -0.940116];
% Traslacion=[
% -528.331530	 191.118025	 3096.123643];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[0.938825	 0.020479	 0.343786;
0.011864	 -0.999561	 0.027145;
0.344191	 -0.021406	 -0.938655];
Traslacion=[
-529.142725	 191.192449	 3108.378126];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, foto inclinada la foto11.pgm
display('------------------------FOTO11------------------------');

figure
Img = imread('la foto11.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto11.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto11.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
0.972296	 0.041667	 0.230009;
-0.009475	 -0.976151	 0.216884;
0.233560	 -0.213055	 -0.948713];
Traslacion=[
    -537.912330	 -189.549407	 3177.955195];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[0.961317	 0.029787	 0.273829;
-0.016433	 -0.986162	 0.164967;
0.274954	 -0.163085	 -0.947525];
Traslacion=[
-536.645559	 -188.658735	 3177.152873];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')
% 
disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, foto inclinada la foto10.pgm
display('------------------------FOTO10------------------------');

figure
Img = imread('la foto10.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto10.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto10.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
-0.709566	 0.254659	 -0.657012;
-0.233417	 0.794819	 0.560160;
0.664855	 0.550828	 -0.504535];
Traslacion=[
    980.333230	 -800.561164	 2101.164390];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[-0.742218	 0.235533	 -0.627405;
-0.205182	 0.811377	 0.547327;
0.637976	 0.534968	 -0.553891];
Traslacion=[
986.137033	 -805.588526	 2106.032589];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, foto inclinada la foto8.pgm
display('------------------------FOTO8------------------------');

figure
Img = imread('la foto8.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto8.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto8.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
0.881669	 -0.030507	 0.470882;
0.041319	 -0.989083	 -0.141445;
0.470057	 0.144164	 -0.870783];
Traslacion=[
    -630.873272	 122.112880	 2476.181852];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[0.916473	 0.001433	 0.400093;
0.022275	 -0.998625	 -0.047449;
0.399475	 0.052398	 -0.915245];
Traslacion=[
-637.884248	 125.511674	 2492.335377];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, foto inclinada la foto7.pgm
display('------------------------FOTO7------------------------');

figure
Img = imread('la foto7.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto7.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto7.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
-0.999151	 -0.030908	 0.027251;
-0.039222	 0.916108	 -0.399009;
-0.012632	 -0.399739	 -0.916542];
Traslacion=[
    489.346836	 107.789889	 1307.863331];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[-0.999177	 -0.040252	 -0.005052;
-0.034701	 0.912532	 -0.407531;
0.021014	 -0.407020	 -0.913177];
Traslacion=[
490.099768	 107.448225	 1304.405470];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, foto inclinada la foto6.pgm
display('------------------------FOTO6------------------------');

figure
Img = imread('la foto6.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto6.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto6.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
-0.997524	 -0.038873	 -0.058607;
0.027601	 0.550086	 -0.834652;
0.064684	 -0.834203	 -0.547651];
Traslacion=[
    553.884068	 150.302775	 1332.942949];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');

figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[-0.997129	 -0.052652	 -0.054415;
0.017872	 0.534686	 -0.844862;
0.073579	 -0.843409	 -0.532210];
Traslacion=[
551.111002	 150.960701	 1321.187906];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, foto inclinada la foto5.pgm
display('------------------------FOTO5------------------------');

figure
Img = imread('la foto5.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto5.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

%se carga el archivo de texto
fp = fopen('laFoto5.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')

center=[242.8 212.9];
Rotacion=[
-0.798329	 -0.042129	 -0.600747;
0.055489	 0.988161	 -0.143036;
0.599660	 -0.147524	 -0.786539
    ];
Traslacion=[
    568.722373	 42.044103	 1401.208088];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');

figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[-0.820926	 -0.066672	 -0.567129;
0.054747	 0.979396	 -0.194386;
0.568404	 -0.190625	 -0.800362];
Traslacion=[
571.811497	 42.182230	 1402.988894];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause



%% Foto con cuadro de lejos, foto inclinada la foto4.pgm
display('------------------------FOTO4------------------------');

figure
Img = imread('la foto4.pgm');
imshow(Img)
nb=36;
% % imagePts=ginput(nb)
% fp = fopen('laFoto4.txt','r');
% imagePts = fscanf(fp,'%lf',[2,36]);
% fclose(fp);
% imagePts=imagePts';

%se carga el archivo de texto
fp = fopen('laFoto4.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')


center=[242.8 212.9];
Rotacion=[
    -0.999880	 -0.013226	 0.008013;
-0.015447	 0.878356	 -0.477758;
-0.000720	 -0.477825	 -0.878455
    ];
Traslacion=[
    524.105840	 128.970291	 1400.762728];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');

figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[-0.999649	 -0.022616	 -0.013773
-0.013023	 0.872777	 -0.487946
0.023056	 -0.487595	 -0.872765];
Traslacion=[
524.195492	 128.742164	 1396.489075];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto con cuadro de lejos, la foto3.pgm
display('------------------------FOTO3------------------------');

figure
Img = imread('la foto3.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto3.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

fp = fopen('laFoto3.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')


center=[242.8 212.9];
Rotacion=[
0.691804	 0.084208	 -0.717158;
-0.123449	 -0.964762	 -0.232366;
-0.711454	 0.249285	 -0.657031
    ];
Traslacion=[
    244.591569	 221.535131	 1011.752939];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');

figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[0.694295	 0.077071	 -0.715552
-0.117359	 -0.968817	 -0.218222
-0.710057	 0.235487	 -0.663600];
Traslacion=[
247.596004	 222.205289	 1020.129778];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause


%% Foto de frente, de cerca. la foto2.pgm
display('------------------------FOTO2------------------------');

figure
Img = imread('la foto2.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto2.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

fp = fopen('laFoto2.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';


hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')


center=[242.8 212.9];
Rotacion=[
-0.241782	 0.866708	 0.436301;
0.701523	 -0.154512	 0.695695;
0.670379	 0.474282	 -0.570657];
Traslacion=[
    -73.724991	 -79.539346	 202.974748];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');

figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[-0.073197	 0.970751	 0.228657;
0.886948	 -0.041474	 0.460003;
0.456032	 0.236477	 -0.857970];
Traslacion=[
-108.603965	 -113.168009	 260.927748];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

disp('Presione cualquier tecla')
pause

%% Foto vista de costado a distancia media, la foto.pgm
display('------------------------FOTO1------------------------');

figure
Img = imread('la foto.pgm');
imshow(Img)
nb=36;

% % se guardan los puntos a un archivo de texto
% imagePts=ginput(nb);
% fp = fopen('laFoto.txt','w');
% for i=1:nb
%     fprintf(fp,'%f\t %f\n',imagePts(i,1),imagePts(i,2));
% end
% fclose(fp);

fp = fopen('laFoto.txt','r');
imagePts = fscanf(fp,'%lf',[2,36]);
fclose(fp);
imagePts=imagePts';



hold on
for i=1:nb
    hold on
    plot(imagePts(i,1),imagePts(i,2),'r+')
    text(imagePts(i,1),imagePts(i,2),num2str(i-1),'color',[0;0;0])
end
title('Puntos detectados')


center=[242.8 212.9];
Rotacion=[
-0.137410	 -0.512690	 -0.847506;
-0.947788	 0.316642	 -0.037880;
0.287777	 0.798052	 -0.529432];
Traslacion=[
    72.112876	 26.615695	 358.598980];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');

figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos positCoplanar')

ErrorCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorCoplanarPosit=sum(sqrt(ErrorCoplanarPosit))

Rotacion=[-0.137410	 -0.512690	 -0.847506
-0.947788	 0.316642	 -0.037880
0.287777	 0.798052	 -0.529432];
Traslacion=[
72.112876	 26.615695	 358.598980];
xPosit=proj3dto2d(object', Rotacion, Traslacion', 448,2, center');


figure
imshow(Img)
for i=1:nb
    hold on
    plot(xPosit(1,i),xPosit(2,i),'r+')
    text(xPosit(1,i),xPosit(2,i),num2str(i-1),'color',[0;0;0])
end
title('Puntos modernPositCoplanar')

ErrorModernCoplanarPosit=(imagePts(:,1)-xPosit(1,:)').^2+(imagePts(:,2)-xPosit(2,:)').^2;
ErrorModernCoplanarPosit=sum(sqrt(ErrorModernCoplanarPosit))

% [omckk,Tckk,Rckk,H,x,ex] = compute_extrinsic(imagePts',object',fc,cc,kc,alpha_c)
% xTool=proj3dto2d(object', Rckk, Tckk, 448,2, cc);
% figure
% imshow(Img) 
% for i=1:36
%     hold on
%     plot(xTool(1,i),xTool(2,i),'r+')
%     text(xTool(1,i),xTool(2,i),num2str(i-1),'color',[0;0;0])
% end
% title('Puntos toolbox')

