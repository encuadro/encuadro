function pose = generatePoses(pose_nb,varargin)
%pose = generatePoses(poseNb)
%Generates poses in batch 
%
%Input:
%	pose_nb: int for pose choice
%	sigmaR, sigmaT: (optional) standard deviations for noise on each pose
%Output:
%	pose: 1xn vector of structs pose containing:
%		pose(i).rotation: 1x3 vector
%		pose(i).translation: 1x3 vector
%Usage:
%	pose = generatePoses(poseNb)
%	pose = generatePoses(poseNb,sigmaR,sigmaT)

%% NOISE

if (length(varargin)>5)
	sigmaR = varargin{1};
	sigmaT = varargin{2};
else
	sigmaR = 0;
	sigmaT = 0;
end

%% POSE OPTIONS
switch pose_nb
%=============================BASIC POSES=================================%
	case 1,		
		ax = 0;
		ay = 0;
		az = 0;

		tx = 0;
		ty = 0;
		tz = 500:100:3000;
	case 2,		
		ax = -60:5:60;
		ay = 0;
		az = 0;

		tx = 0;
		ty = 0;
		tz = 1000:500:2000;
	case 3, %esta es de juani		
		ax = -30:15:30;
		ay = -30:15:30;
		az = 0;

		tx = 0;
		ty = 0;
		tz = 1000:500:2000;		
    case 11, %esta es de mou		
		ax = -30;
		ay = -30;
		az = 0;

		tx = 0;
		ty = 0;
		tz = 500;
%=============================RANDOM POSES================================%
	case 50,		
		ax = randn(5);
		ay = randn(5);
		az = randn(5);

		tx = 0;
		ty = 0;
		tz = 1000;
	case 51,		
		ax = 0;
		ay = 0;
		az = 0;

		tx = 0;
		ty = 0;
		tz = 1000+20*randn(1,500);
%=========================DEFUALT SINGLE POSE=============================%		
	otherwise
		ax = 0;
		ay = 0;
		az = 0;

		tx = 0;
		ty = 0;
		tz = 1000;
end


%% COMBINE POSES
idx=1;
for i=tx
	for j=ty
		for k=tz
			for l=ax
				for m=ay
					for n=az
						pose(idx).rotation = [l m n] + sigmaR*randn;
						pose(idx).translation = [i j k] + sigmaT*randn;
						idx=idx+1;
					end
				end
			end
		end
	end
end