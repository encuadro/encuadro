clear all; close all; clc;

%colorado setup
setup = renderMarkerSetup(	'/home/roho/workspace/encuadro/',...
							'/home/roho/Dropbox/encuadro/renders/',...
							1,0);

% %mou setup
% setup = renderMarkerSetup(	'/Users/pablofloresguridi/repositorios/encuadro/',...
% 							'/Users/pablofloresguridi/Desktop/',...
% 							11,0);                        


%% configure camera
camera = pinholeCamera(44.5,480,360,zeros(5,1),0);

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
	print('-depsc2',[setup.img_path poses_est_fname(i,1:end-4) '.eps'])
	input('***Press enter to continue***');
end

%% write benchmark results

%writePosesBenchmarkFile(setup,stats,)

output_benchmark_fname = 'benchmark.txt';

fid=fopen([setup.img_path output_benchmark_fname],'w');

fprintf(fid,'BENCHMARK LOG\n');

fprintf(fid,'=SETUP=\n');
fprintf(fid,' pose id: %d\n', setup.pose_id);
fprintf(fid,' img fname template: %s\n', setup.img_fname_template);
fprintf(fid,' blender model: %s\n', setup.model_fname);
fprintf(fid,' python script: %s\n', setup.python_fname);

fprintf(fid,'=CAMERA=\n');
fprintf(fid,'==INTRINSIC==\n\n');
fprintf(fid,' dimensions: %d %d\n',camera.int.width, camera.int.height); 
fprintf(fid,' aspect ratio: %4.4f\n',camera.int.ar);
fprintf(fid,' fov: %4.4f %4.4f\n',camera.int.fov,camera.int.fov*camera.int.ar);
fprintf(fid,' center: %4.4f %4.4f\n',camera.int.center); 
fprintf(fid,' focal length: %4.4f %4.4f\n',camera.int.fc);
fprintf(fid,' distorsion: %4.4f %4.4f %4.4f %4.4f %4.4f\n',camera.int.k);
fprintf(fid,' skew: %4.4f\n',camera.int.alpha);
fprintf(fid,'==EXTRINSIC==\n\n');
fprintf(fid,' pose: %4.4f %4.4f %4.4f %4.4f %4.4f %4.4f\n',...
					camera.ext.rotation, camera.ext.translation);	

fprintf(fid,'=RESULTS=\n\n');
for i=1:length(stats)
	fprintf(fid,'==%s==\n\n',poses_est_fname(i,:));
	fprintf(fid,'===SCORES===\n\n');
	fprintf(fid,' score: %4.4f\n',stats{i}.score);
	fprintf(fid,' fails: %d\n',stats{i}.failNb);
	fprintf(fid,' fail indexes: \n ');
	for j=1:stats{i}.failNb
		fprintf(fid,'%d ',stats{i}.failIdx(j));
	end
	fprintf(fid,'\n\n');
	fprintf(fid,'===ERROR STATS===\n\n');
	fprintf(fid,'====ROTATIONS====\n\n');
	for j=1:3
		fprintf(fid,'=====R%d=====\n\n',j);
		fprintf(fid,' mean: %4.4f\n',stats{i}.meanErr(j));
		fprintf(fid,' variance: %4.4f\n',stats{i}.varErr(j));
		fprintf(fid,' median: %4.4f\n',stats{i}.medianErr(j));
		fprintf(fid,' max: %4.4f\n',stats{i}.maxErr(j));
		fprintf(fid,' min: %4.4f\n',stats{i}.minErr(j));
	end
	fprintf(fid,'====TRANSLATIONS====\n\n');
	for j=1:3
		fprintf(fid,'=====T%d=====\n\n',j);
		fprintf(fid,' mean: %4.4f\n',stats{i}.meanErr(j+3));
		fprintf(fid,' variance: %4.4f\n',stats{i}.varErr(j+3));
		fprintf(fid,' median: %4.4f\n',stats{i}.medianErr(j+3));
		fprintf(fid,' max: %4.4f\n',stats{i}.maxErr(j+3));
		fprintf(fid,' min: %4.4f\n',stats{i}.minErr(j+3));
	end
end
fclose(fid);


