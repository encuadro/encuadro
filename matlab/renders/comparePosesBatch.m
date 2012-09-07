clear all; close all; clc;

%colorado setup
setup = renderMarkerSetup(	'/home/roho/workspace/encuadro/',...
							'/home/roho/Dropbox/encuadro/renders/',...
							11,0);

% %mou setup
% setup = renderMarkerSetup(	'/Users/pablofloresguridi/repositorios/encuadro/',...
% 							'/Users/pablofloresguridi/Desktop/',...
% 							11,0);                        


%% configure camera
camera = pinholeCamera(44.5,480,360,zeros(5,1),0);

%% generate poses
poses = generatePoses(setup.pose_id);

%% read poses
poses_coplanar_06 = readPosesFile([setup.img_path 'poses_coplanar_scale0.6.txt']);
poses_coplanar_08 = readPosesFile([setup.img_path 'poses_coplanar_scale0.8.txt']);
poses_composit_06 = readPosesFile([setup.img_path 'poses_composit_scale0.6.txt']);
poses_composit_08 = readPosesFile([setup.img_path 'poses_composit_scale0.8.txt']);
%FIXME: eliminar este for cuando juani arregle el benchmark a grados.
for i=1:length(poses_coplanar_06)
	if (poses_coplanar_06(i).translation(3)~=-1)
		poses_coplanar_06(i).rotation = (180/pi)*poses_coplanar_06(i).rotation;
	end
	if (poses_coplanar_08(i).translation(3)~=-1)
		poses_coplanar_08(i).rotation = (180/pi)*poses_coplanar_08(i).rotation;
	end
	if (poses_composit_06(i).translation(3)~=-1)
		poses_composit_06(i).rotation = (180/pi)*poses_composit_06(i).rotation;
	end
	if (poses_composit_08(i).translation(3)~=-1)
		poses_composit_08(i).rotation = (180/pi)*poses_composit_08(i).rotation;
	end
end

%% compute errors
[media,varianza] = errorPosesBatch(poses,poses_coplanar_06)
% [media,varianza] = errorPosesBatch(poses,poses_composit_06)
% [media,varianza] = errorPosesBatch(poses,poses_coplanar_08)
% [media,varianza] = errorPosesBatch(poses,poses_composit_08)
