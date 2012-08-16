% agarrar imágenes de cámara
close all; clear all; clc;

n = 5; % numero de impagenes

vid = videoinput('linuxvideo',1); % aprontar cámara
set(vid, 'ReturnedColorSpace', 'RGB');



% activar cámara
preview(vid);

% tomar n snapshots
i = 1;
while i<=n

   ch = getkeywait(1/20);
   if ch~=-1
       img(:,:,:,i) = getsnapshot(vid);
       i = i+1;
   end
end
delete(vid);

% guardar snapshots en carpeta
for i=1:n
    nombre = strcat(strcat('imgs/Image',num2str(i)),'.jpg');
    imwrite(rgb2gray(img(:,:,:,i)),nombre); 
end


%% Correr toolbox
cd imgs

calib_gui

