clear all;
close all;
clc;

%% setup

%colorado setup
setup = renderMarkerSetup(	'/home/roho/workspace/encuadro/',...
							'/home/roho/Dropbox/encuadro/renders/',...
							30);

%% configure camera
camera = pinholeCamera(46.4343,480,360,zeros(5,1),0);

%% generate poses
poses = generatePoses(setup.pose_id);

%% batch render images
for i=1:length(poses)
	renderMarker(poses(i),camera,setup,i);
end

%% write poses 
writePosesFile(poses,[setup.img_path 'poses.txt']);