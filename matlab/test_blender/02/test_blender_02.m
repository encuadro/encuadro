clear all; close all; clc;

%% setup

setup.repo_path = '/home/roho/workspace/encuadro/';
setup.script_path = 'matlab/test_blender/02/';

% setup.blender_path = [setup.repo_path '../../Descargas/Software/blender-2.61-linux-glibc27-x86_64/'];
setup.blender_path = '';					% path to blender excecutable
setup.blender_cmd = 'blender';

setup.model_path = 'renders/demo/';			% path to blender model (.blend)
setup.model_fname = 'demo.blend';

setup.python_path = 'renders/demo/';		% path to python script (.py)
setup.python_fname = 'moveObject.py';

setup.img_fname = 'tmp';	
setup.img_path = '.';						% output_path

%% camera

% camera.int.height = 358;
% camera.int.width = 480;
% camera.int.ar = camera.int.width/camera.int.height;
% camera.int.fov = 50*[1 1/camera.int.ar];
% camera.int.center = 0.5*[camera.int.width+1 camera.int.height+1];
% camera.int.fc = camera.int.center./tan(camera.int.fov./2*pi/180);
% camera.int.k     = zeros(5,1);          % Distorsion
% camera.int.alpha = 0;                   % Sesgo

camera = pinholeCamera(50,358,480,zeros(5,1),0);


%% object pose

pose.rotation = [0 30 0];
pose.translation = [0 0 8];

%% options


%% run

fix = jfc_system_call_fix();

cmd = sprintf('%s%s -b %s%s%s -P %s%s%s -- %d %d %d %d %d %d %d %d %d',...	
				setup.blender_path, setup.blender_cmd,...
				setup.repo_path, setup.model_path, setup.model_fname,...
				setup.repo_path, setup.python_path, setup.python_fname,...
				pose.translation, pose.rotation,...
				camera.int.fov(1), camera.int.height, camera.int.width)

system([fix ';' cmd])


%% object model
l=1;
cube = [
		+l	+l	+l;
		+l	-l	+l;
		-l	+l	+l;
		-l	-l	+l;
		+l	+l	-l;
		+l	-l	-l;
		-l	+l	-l;
		-l	-l	-l
		];

%% reproject proj3dto2d
T =  pose.translation';
om = pose.rotation*pi/180;
rot   = rodrigues(om);    
x    = proj3dto2d(cube', rot, T, camera.int.fc(1),2, camera.int.center');

im = imread('out.png');
figure(3)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'x')

%% reproject project_points2

x2 = project_points2(cube',	om',...
							pose.translation',...
							camera.int.fc,...
							camera.int.center,...
							camera.int.k,...
							camera.int.alpha);

hold on;
plot(x2(1,:),x2(2,:),'or')

hold off
legend('proj3dto2d', 'project\_points2')