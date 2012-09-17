clear all; close all; clc;

%% configure camera
camera = pinholeCamera(44.5,480,360,zeros(5,1),0);

%% setup

%colorado setup
setup = renderMarkerSetup(	camera,...
							'/home/roho/workspace/encuadro/',...
							'/home/roho/Dropbox/encuadro/renders/',...
							1,0);

% %mou setup
% setup = renderMarkerSetup(camera,...
% 							'/Users/pablofloresguridi/repositorios/encuadro/',...
% 							'/Users/pablofloresguridi/Desktop/',...
% 							11,0);                        
%% read poses
poses = readPosesFile([setup.img_path 'poses.txt']);

%% read poses

poses_est_fname = [	'poses_coplanar_scale0.6.txt';...
					'poses_composit_scale0.6.txt';...
					'poses_coplanar_scale0.8.txt';...
					'poses_composit_scale0.8.txt'];

for i=1:length(poses_est_fname(:,1))
	poses_est{i} = readPosesFile([setup.img_path poses_est_fname(i,:)]);
end

%% compute errors
for i=1:length(poses_est)
	fprintf('%s\n',poses_est_fname(i,:));
	stats{i} = errorPosesBatch(poses,poses_est{i});
	print(1,'-depsc2',[setup.img_path poses_est_fname(i,1:end-4) '.eps'])
	input('***Press enter to continue***');
end

%% write benchmark results

output_benchmark_fname = [setup.img_path 'benchmark.txt'];
writePosesBenchmarkFile(setup,camera,stats,output_benchmark_fname);


