clear all;
close all;
clc;

%% setup

%colorado setup
setup = renderMarkerSetup(	'/Users/juanignaciobraun/Desktop/encuadro/',...
							'/Users/juanignaciobraun/Dropbox/encuadro/renders/',...
							11);

% %mou setup
% setup = renderMarkerSetup(	'/Users/pablofloresguridi/repositorios/encuadro/',...
% 							'/Users/pablofloresguridi/Desktop/',...
% 							11);                        


%% configure camera
camera = pinholeCamera(44.5,480,360,zeros(5,1),0);

%% generate poses
poses = generatePoses(setup.pose_id);

%% batch render images
for i=1:length(poses)
	renderMarker(poses(i),camera,setup,i);
end

%% write parameters 
writePosesFile(poses,[setup.img_path 'poses.txt']);
writeCameraFile(camera,[setup.img_path 'camera.txt']);