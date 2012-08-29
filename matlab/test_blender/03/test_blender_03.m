clear all; close all; clc;

%% setup

setup.repo_path = '/home/roho/workspace/encuadro/';
setup.script_path = 'matlab/test_blender/03/';

% setup.blender_path = [setup.repo_path '../../Descargas/Software/blender-2.61-linux-glibc27-x86_64/'];
setup.blender_path = '';					% path to blender excecutable
setup.blender_cmd = 'blender';

setup.model_path = 'renders/';			% path to blender model (.blend)
setup.model_fname = 'Marker.blend';

setup.python_path = 'renders/';		% path to python script (.py)
setup.python_fname = 'moveMarker.py';

setup.img_fname = 'marker_0007';	
setup.img_path = '';						% output_path

%% camera

camera = pinholeCamera(46.4343,640,480,zeros(5,1),0);

%% object pose

pose.rotation = [0 30 0];
pose.translation = [10 15 100];

% setup.img_fname = sprintf('out_%d_%d_%d_%d_%d_%d', 10*pose.translation,pose.rotation); 
													

%% options


%% run

fix = jfc_system_call_fix();

cmd = sprintf('%s%s -b %s%s%s -P %s%s%s -- %4.3f %4.3f %4.3f %4.3f %4.3f %4.3f %4.3f %d %d %s',...	
				setup.blender_path, setup.blender_cmd,...
				setup.repo_path, setup.model_path, setup.model_fname,...
				setup.repo_path, setup.python_path, setup.python_fname,...
				pose.translation, pose.rotation,...
				camera.int.fov(1), camera.int.height, camera.int.width,...
				setup.img_fname)

system([fix ';' cmd])


%% QlSet Model
l = 1.5;

Ql =[	+l		+l		0	;
		+l		-l		0	;
		-l		-l		0	;
		-l		+l		0	;
		+2*l	+2*l	0	;
		+2*l	-2*l	0	;
		-2*l	-2*l	0	;
		-2*l	+2*l	0	;
		+3*l	+3*l	0	;
		+3*l	-3*l	0	;
		-3*l	-3*l	0	;
		-3*l	+3*l	0	;
	];

centerQl(1,:) = [0			0		0];
centerQl(2,:) = [12*l+1		0	0] + centerQl(1,:);
centerQl(3,:) = [0			6*l+1	0] + centerQl(1,:);

QlSet = zeros(12,3,3);
for i=1:3
	for j=1:12
		QlSet(j,:,i)=Ql(j,:)+centerQl(i,:);
	end
	plot(QlSet(:,1,i),QlSet(:,2,i),'x'); hold on;
end
hold off;

%% reproject proj3dto2d

X = [QlSet(:,:,1);
	 QlSet(:,:,2);
	 QlSet(:,:,3)];

T =  pose.translation';
om = pose.rotation*pi/180;
rot_aux   = rodrigues(om)
% rot = SpinCalc('EA321toDCM',om,1e-3,0);
rot = euler2Matrix(om(1),om(2),om(3))

x    = proj3dto2d(X', rot, T, camera.int.fc(1),2, camera.int.center');

im = imread([setup.img_fname '.png']);
figure(3)
imshow(im)
hold on;
plot(x(1,:),x(2,:),'o')

%% reproject project_points2
% 
% if 1
% x2 = project_points2(X',	om',...
% 							pose.translation',...
% 							camera.int.fc,...
% 							camera.int.center,...
% 							camera.int.k,...
% 							camera.int.alpha);
% 
% hold on;
% plot(x2(1,:),x2(2,:),'xr')
% 
% hold off
% end
% legend('proj3dto2d', 'project\_points2')