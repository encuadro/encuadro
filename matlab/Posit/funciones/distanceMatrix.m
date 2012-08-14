function [m,distMat] = distanceMatrix(imgPoints,projPoints,Alpha,Beta)
%[m,d] = distanceMatrix(imgPoints,projPoints,Alpha,Beta)
%
% Genera assignment matrix para el posit de l??neas.


% lines li with i = 1,...,M
[M,di] = size(imgPoints);
M = M/2;

% lines lj with j=1,...,N
[N,dp] = size(projPoints);
N = N/2;

imgLines	=	[	imgPoints(1:2:end,:)	imgPoints(2:2:end,:)	];
projLines	=	[	projPoints(1:2:end,:)	projPoints(2:2:end,:)	];

% allocate memory
m = zeros(2*M*N+1,2*N+1);
distMat = zeros(2*M*N,2*N);
dSegm = zeros(M+1,N+1);

u =-1;
for i=1:M
for j=1:N
	
	% fill distance matrix
	dSegm(i,j) = distanceSegments(imgLines(i,:),projLines(j,:));
	dPointXX = distancePoints(imgLines(i,1:2), projLines(j,1:2));
    dPointXY = distancePoints(imgLines(i,3:4), projLines(j,1:2));
    dPointYX = distancePoints(imgLines(i,1:2), projLines(j,3:4));
    dPointYY = distancePoints(imgLines(i,3:4), projLines(j,3:4));
	
    
    % coord for assignment matrix m
	u = u+2;
	v = 2*j-1;
	
%     A=[(dSegm(i,j)^2-Alpha)/dPointXX^2 (dSegm(i,j)^2-Alpha)/dPointXY^2;...
%        (dSegm(i,j)^2-Alpha)/dPointXY^2 (dSegm(i,j)^2-Alpha)/dPointYY^2];

A=[dPointXX<dPointYX dPointXX>dPointYX;...
   dPointXX>dPointYX dPointXX<dPointYX];
    
	% fill assignment matrix m
	m(u:u+1,v:v+1) = exp(-Beta*(dSegm(i,j)^2-Alpha))*A;
    distMat(u:u+1,v:v+1)=dSegm(i,j);

end
end


