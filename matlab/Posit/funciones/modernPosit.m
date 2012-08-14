function [rot, trans] = modernPosit(imagePts, worldPts, focalLength, center)

% Usage: [rot, trans] = modernPosit(imagePts, worldPts, focalLength, center)
% Return rotation and translation of world object 
% given world points and image points
%
% Inputs
% imagePts is a matrix of size nbPts x 2
% worldPts is a matrix of size nbPts x 3
% focalLength is the focal length of the camera in PIXELS
% center is a row vector with the two components of the image center
%
% Outputs:
% rot: a 3 x 3 rotation matrix of scene with respect to camera
% trans: 3 x 1 translation vector from projection center of camera to ORIGIN of coordinate system of object/scene
%
% This version uses homogeneous coordinates
% Note that the translation obtained by this method can be different from that obtained by classicPosit.m
% In classicPosit.m the translation is w.r.t. the first point of the object point list,
% which may or may not be the origin of the object coordinate system
% Here the translation is from camera projection center to ORIGIN of object points
% This origin does not have to be in the point list and therefore does not have to be visible in the image
%
% If center is not given, assume the image coordinates 
% are w.r.t. centered image reference
%
% Example of input: 
%
% cube = [ 0 0 0; 10 0 0; 10 10 0; 0 10 0; 0 0 10; 10 0 10; 10 10 10; 0 10 10]
% cubeImage = [0 0; 80 -93; 245 -77; 185 32; 32 135; 99 35; 247 62; 195 179]
% focalLength = 760
% [rot, trans] = modernPosit(cubeImage, cube, focalLength)
%
% Outputs: 
% rot = [ 0.4910 0.8493 0.1911; -0.5699 0.1461 0.8093; 0.6594 -0.5063 0.5558];
% trans = [0.0033; 0.0046; 40.0728]; 
% when computation stops after 4 iterations


msg = nargchk(3, 4, nargin);
if (~isempty(msg))
	error(strcat('ERROR:', msg));
end

clear msg;

if nargin == 3 % image coordinates are already centered, center is not given
	center = [0, 0];
end

%=======================================================================================

nbPoints = size(imagePts, 1);

centeredImage(:,1) = (imagePts(:,1) - center(1))/focalLength;
centeredImage(:,2) = (imagePts(:,2) - center(2))/focalLength;

centeredImage

ui = centeredImage(:,1); 
vi = centeredImage(:,2); 
wi = ones(nbPoints, 1); % homogeneous image coordinates

homogeneousWorldPts = [worldPts, wi];

objectMat = pinv(homogeneousWorldPts) % pseudoinverse

converged = 0;
count = 0;

while ~converged

	r1T= objectMat * ui; % pose vectors

	r2T = objectMat * vi;

	Tz1 = 1/sqrt(r1T(1)*r1T(1) + r1T(2)*r1T(2)+ r1T(3)*r1T(3)); % 1/Tz1 is norm of r1T

	Tz2 = 1/sqrt(r2T(1)*r2T(1) + r2T(2)*r2T(2)+ r2T(3)*r2T(3)); % 1/Tz2 is norm of r2T

	Tz = sqrt(Tz1*Tz2); % geometric average instead of arythmetic average of classicPosit.m
% Tz = (Tz1+Tz2)/2; % same results

	r1N = r1T*Tz;
	r2N = r2T*Tz;

	r1 = r1N(1:3);

	r2 = r2N(1:3);

	r3 = cross(r1,r2);

	r3T= [r3; Tz];

	Tx = r1N(4);

	Ty = r2N(4);

	wi= homogeneousWorldPts * r3T /Tz;

	disp(' ');
	disp(' Scaled ortho projections ');
	disp(' ');
	oldUi = ui;
	oldVi = vi;
	ui = wi .* centeredImage(:,1)
	vi = wi .* centeredImage(:,2)
	deltaUi = ui - oldUi;
	deltaVi = vi - oldVi;
	disp(' ');
	disp(' Delta ');
	disp(' ');
	delta = focalLength * focalLength * (deltaUi' * deltaUi + deltaVi' * deltaVi)
	converged = (count>0 & delta < 1)
	count = count + 1
	disp(' ');
	disp(' ======================================================= ');
	disp(' ');
end % iteration loop


trans = [Tx; Ty; Tz];

rot = [r1'; r2'; r3'];
