function camera = pinholeCamera(fov,width,height,k,alpha,varargin)

if (length(varargin)>5)
	rotation = varargin{1};
	translation = varargin{2};
else
	rotation = [0 0 0];
	translation = [0 0 0];
end

camera.ext.rotation=rotation;
camera.ext.translation=translation;
	
camera.int.height = height;
camera.int.width = width;
camera.int.ar = camera.int.height/camera.int.width;
camera.int.fov = fov;
camera.int.center = 0.5*[camera.int.width+1 camera.int.height+1];
camera.int.fc = [1 1/camera.int.ar].*camera.int.center./tan(camera.int.fov./2*pi/180);
camera.int.k = k;			% Distorsion
camera.int.alpha = alpha;		% Sesgo

end