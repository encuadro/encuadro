function setup = renderMarkerSetup(repo_path,output_path,pose_id,mode)

% % defaults
% if (varargin < 1)
% 	setup.repo_path = '/home/roho/workspace/encuadro/';
% 	if (varargin < 2)
% 		setup.img_path_template;
% 		if (varargin < 3)
% 		setup.blender_path = '';
% 		end
% 	end
% end

%% general setup

setup.pose_id = pose_id;
setup.mode = mode;

setup.img_fname_template = 'marker_%04d';
setup.img_fname = ''; % automatic template name;

setup.img_path_template = 'pose_%02d/';
setup.img_path = [output_path sprintf(setup.img_path_template,setup.pose_id)];  % automatic template name;

%make dir if doesn't exist
if (setup.mode == 1)
	if (~exist(setup.img_path,'dir'))
		mkdir(setup.img_path);
	else
		delete([setup.img_path '*.png']);
	end
end

setup.repo_path = repo_path;

%% blender setup
if (strcmp(computer,'GLNX86') || strcmp(computer,'GLNXA64'))
% 	setup.blender_path = '';
	setup.blender_path = [setup.repo_path '../../Descargas/Software/blender-2.61-linux-glibc27-x86_64/'];
elseif (strcmp(computer,'MACI') || strcmp(computer,'MACI64'))
	setup.blender_path = '/Applications/blender/Blender.app/Contents/MacOS/';
end
setup.blender_cmd = 'blender';

%% 3d model and python scripts setup
setup.model_path = [setup.repo_path 'matlab/renders/model/'];		% path to blender model (.blend)
setup.model_fname = 'Marker.blend';

setup.python_path = [setup.repo_path 'matlab/renders/model/'];		% path to python script (.py)
setup.python_fname = 'moveMarker.py';



end