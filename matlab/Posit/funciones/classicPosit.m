function [rotation, translation] = classicPosit(imagePoints, objectPoints, focalLength, center)
%
% Usage:  [rotation, translation] = classicPosit(imagePoints, objectPoints, focalLength, center)
% Return rotation and translation of world object 
% given world points and image points
% Inputs:
% imagePoints is a matrix of size nbPts x 2
% objectPoints is a matrix of size nbPts x 3
% focalLength is the focal length of the camera in PIXELS
% center is a row vector with the two components of the image center
%
% If center is not given, assume the image coordinates 
% are w.r.t. image reference at image center
%
% Outputs:
% rot: a 3 x 3 rotation matrix of scene with respect to camera
% trans: 3 x 1 translation vector from projection center of camera to FIRST POINT in list of object points
%
% This version is a translation of the Mathematica code published in IJCV 15 (1995)
% Example of input: 
%
% cube = [ 0 0 0; 10 0 0; 10 10 0; 0 10 0; 0 0 10; 10 0 10; 10 10 10; 0 10 10]
% cubeImage = [0 0; 80 -93; 245 -77; 185 32; 32 135; 99 35; 247 62; 195 179]
% focalLength = 760
% [rot, trans] = classicPosit(cubeImage, cube, focalLength)
%
% Outputs: 
% rot = [ 0.4901  0.8506  0.1906; -0.5695  0.146  0.8088; 0.6600 -0.5049  0.5563];
% trans = [0.0; 0.0; 40.0392]; 
% when computation stops after 5 iterations

% Copyright (c) 1993-2003 Daniel DeMenthon and University of Maryland
% All rights reserved

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msg = nargchk(3, 4, nargin);
if (~isempty(msg))
	error(strcat('ERROR:', msg));
end

clear msg;

if nargin == 3 % image coordinates are already centered, center is not given
	center = [0, 0];
end

%=======================================================================================

imagePoints(:,1) = (imagePoints(:,1) - center(1));
imagePoints(:,2) = (imagePoints(:,2) - center(2));

converged = 0;
count = 0;
imageDifference = 99;

nbPoints = size(imagePoints, 1);

objectVectors = objectPoints - ones(nbPoints,1) * objectPoints(1,:);
objectMatrix = pinv(objectVectors) % pseudoinverse

oldSOPImagePoints = imagePoints;

while ~converged
	if count == 0
		imageVectors = imagePoints - ones(nbPoints,1) * imagePoints(1,:);
	else % count>0, we compute a SOP image first for POSIT
		correction = (1 + (objectVectors * row3')/translation(3));
		spreadCorrection = correction * ones(1, 2);
		SOPImagePoints = imagePoints .* spreadCorrection;
		diffImagePoints = abs(round(SOPImagePoints - oldSOPImagePoints))
		imageDifference = ones(1, nbPoints) * diffImagePoints * ones(2,1)  % add up all coordinates
		oldSOPImagePoints = SOPImagePoints;
		imageVectors = SOPImagePoints - ones(nbPoints,1) * SOPImagePoints(1,:)
	end % else

	IJ = (objectMatrix * imageVectors)'
	IVect = IJ(1,:); JVect = IJ(2,:);
	ISquare = IVect*IVect';
	JSquare = JVect*JVect';
	scale1 = sqrt(ISquare); scale2 = sqrt(JSquare);
	row1 = IVect/scale1; row2 = JVect/scale2;
	row3 = cross(row1, row2);
	rotation = [row1; row2; row3]
	scale = (scale1 + scale2)/2.0;
	translation = [imagePoints(1,:), focalLength]/scale
		
	converged = (count > 0 & imageDifference < 1)
	count = count + 1
	disp(' ');
	disp(' ======================================================= ');
	disp(' ');

end % while
