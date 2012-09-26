function assignMat = softassign(imagePts, worldPts, beta0, noiseStd)

							
alpha = 9.21*noiseStd^2 + 1;

maxDelta = sqrt(alpha)/2;          % Max allowed error per world point.

betaFinal = 0.5;                   % Terminate iteration when beta == betaFinal.
betaUpdate = 1.05;                 % Update rate on beta.
epsilon0 = 0.01;                   % Used to initialize assignement matrix.

maxCount = 2;
minBetaCount = 20;

nbImagePts = size(imagePts, 1);    % Number of image points (M below).
nbWorldPts = size(worldPts, 1);    % Number of world points (N below).

maxNbPts = max([nbImagePts;nbWorldPts]);
scale = 1/(maxNbPts + 1);

betaCount = 0;
beta = beta0;

% The assignment matrix includes a slack row and slack column.
assignMat = ones(nbImagePts+1,nbWorldPts+1) + epsilon0;
							
while beta < betaFinal
    
	% For all possible pairings of image to world points, map the
    % perspective image point into the corrected SOP image point using
    % the world point's current estimate of w[i].  Here, j is the index of
    % an image point and k is the index of a world point.  wkxj is an
    % MxN  matrix where the j-th,k-th entry is w[k]*x[j]/f.  wkyj is an
    % MxN matrix where the j-th,k-th entry is w[k]*y[j]/f.
    imgPtsx = repmat(imagePts(:,1),1,nbWorldPts);
	imgPtsy = repmat(imagePts(:,2),1,nbWorldPts);
	
	wrldPtsx = repmat(worldPts(:,1),1,nbImagePts)';
	wrldPtsy = repmat(worldPts(:,2),1,nbImagePts)';

    % distMat[j,k] = d[j,k]^2
    distMat = (imgPtsx - wrldPtsx).^2 + (imgPtsy - wrldPtsy).^2;
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Use the softAssign algorithm to compute the best assignment of image to
    % world points based on the computed distances.  The use of alpha 
    % determines when to favor assignments instead of use of slack.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    assignMat(1:nbImagePts, 1:nbWorldPts) = scale*exp(-beta*(distMat - alpha));
    assignMat(1:nbImagePts+1,nbWorldPts+1) = scale;
    assignMat(nbImagePts+1,1:nbWorldPts+1) = scale;
%     assignMat = sinkhornSlack(assignMat); % Don't normalize slack row and col.
    assignMat = sinkhornImp(assignMat);   % My "improved" Sinkhorn.

    % About how many matching model points do we currently have?
    numMatchPts = numMatches(assignMat);
    sumNonslack = sum(sum(assignMat(1:nbImagePts,1:nbWorldPts)));
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Updates for deterministic annealing and checks for convergence.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Update the "annealing temperature" and determine if the assignments
    % have converged.
    beta = betaUpdate * beta;
    betaCount = betaCount + 1;   % Number of deterministic annealing iterations.	

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Normalize across rows and columns to find an assignment matrix (a 
% doubly stochastic matrix).
%
% This version treats the slack row and column differently from other rows
% and columns: the slack values are not normalized with respect to other
% slack values, only with respect to the nonslack values.  This may work
% better than the original Sinkhorn algorithm which treats all rows and
% columns identically.  This is true primarily when there needs to be more
% than one assignment to a slack row or column.  I.e., when there are two
% or more missing image points or model points.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function normalizedMat = sinkhornSlack(M)

iMaxIterSinkhorn=60;  % In PAMI paper
fEpsilon2 = 0.001; % Used in termination of Sinkhorn Loop.

iNumSinkIter = 0;
[nbRows, nbCols] = size(M);

fMdiffSum = fEpsilon2 + 1;  % Set "difference" from last M matrix above 
                            % the loop termination threshold.

while(abs(fMdiffSum) > fEpsilon2 & iNumSinkIter < iMaxIterSinkhorn)
    Mprev = M;  % Save M from previous iteration to test for loop termination

    % Col normalization (except outlier row - do not normalize col slacks 
    % against each other)
    McolSums = sum(M, 1); % Row vector.
    McolSums(nbCols) = 1; % Don't normalize slack col terms against each other.
    McolSumsRep = ones(nbRows,1) * McolSums ;
    M = M ./ McolSumsRep;

    % Row normalization (except outlier row - do not normalize col slacks 
    % against each other)
    MrowSums = sum(M, 2); % Column vector.
    MrowSums(nbRows) = 1; % Don't normalize slack row terms against each other.
    MrowSumsRep = MrowSums * ones(1, nbCols);   
    M = M ./ MrowSumsRep;

    iNumSinkIter=iNumSinkIter+1;
    fMdiffSum=sum(abs(M(:)-Mprev(:)));
end

normalizedMat = M;

return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% normalizedMat = sinkhornImp(M)
%
% Apply an improved Sinkhorn algorithm to map matrix M to a doubly 
% stochastic matrix.
% 
% The Sinkhorn algorithm modified for slack rows and columns treats the
% slack row and column differently from other rows and columns: the slack
% values are not normalized with respect to other slack values, only with
% respect to the nonslack values.  This may work better than the original
% Sinkhorn algorithm which treats all rows and columns identically.
% This is true primarily when there needs to be more than one assignment
% to a slack row or column.  I.e., when there are two or more missing
% image points or model points.
% 
% A problem with this modified Sinkhorn algorithm is the following.
% Suppose all rows except the slack row are normalized.  It is possible that
% a nonslack value which was previously maximum in its row and column to now
% have a value that is less than the slack value for that column. (This
% nonslack value will still be greater than the slack value for that
% row.)  The same sort of thing can happen when columns are normalized.
% Intuitivitly, this seems like a bad thing: nonslack values that start
% off as maximum in their row and column should remain maximum in their
% row and column throughout this iteration.  The current algorithm
% attempts to prevent this from happening as follows.  After performing
% row normalizations, the values in the slack row are set so that their
% ratio to the nonslack value in that column which was previously maximum
% is the same as this ratio was prior to row normalization.  A similar
% thing is done after column normalizations.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function normalizedMat = sinkhornImp(M)

iMaxIterSinkhorn=60;          % In PAMI paper
fEpsilon2 = 0.001;            % Used in termination of Sinkhorn Loop.

iNumSinkIter = 0;
[nbRows, nbCols] = size(M);

fMdiffSum = fEpsilon2 + 1;    % Set "difference" from last M matrix above 
                              % the loop termination threshold

% Get the positions and ratios to slack of the nonslack elements that
% are maximal in their row and column.
[posmax, ratios] = maxPosRatio(M);

while(abs(fMdiffSum) > fEpsilon2 & iNumSinkIter < iMaxIterSinkhorn)
    Mprev = M;  % Save M from previous iteration to test for loop termination

    % Col normalization (except outlier row - do not normalize col slacks 
    % against each other)
    McolSums = sum(M, 1);  % Row vector.
    McolSums(nbCols) = 1;  % Don't normalize slack col terms against each other.
    McolSumsRep = ones(nbRows,1) * McolSums ;
    M = M ./ McolSumsRep;

    % Fix values in the slack column.
    for i = 1:size(posmax,1)
      M(posmax(i,1),nbCols) = ratios(i,1)*M(posmax(i,1),posmax(i,2));
    end

    % Row normalization (except outlier row - do not normalize col slacks 
    % against each other)
    MrowSums = sum(M, 2);  % Column vector.
    MrowSums(nbRows) = 1;  % Don't normalize slack row terms against each other.
    MrowSumsRep = MrowSums * ones(1, nbCols);   
    M = M ./ MrowSumsRep;

    % Fix values in the slack row.
    for i = 1:size(posmax,1)
      M(nbRows,posmax(i,2)) = ratios(i,2)*M(posmax(i,1),posmax(i,2));
    end

    iNumSinkIter=iNumSinkIter+1;
    fMdiffSum=sum(abs(M(:)-Mprev(:)));
end

normalizedMat = M;

return;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% maxPosRatio    Get the positions and ratios of the maximum nonslack values.
%     [POS, RATIOS] = maxPosRatio(ASSIGNMAT)
%         ASSIGNMAT is an image to model assignment matrix.  The last
%         row and column of ASSIGNMAT are slack, and are used to indicate
%         no match for that row or column. POS returns an Mx2 matrix of the
%         positions in ASSIGNMAT that are maximal within the respective
%         row and column. M is the number of elements in ASSIGNMAT that are
%         maximum in a row and column, and may equal zero.  The Kth row
%         of POS gives [ROWPOS COLPOS], the row and column position of the
%         Kth maximal element.  RATIOS returns an Mx2 matrix of the ratios
%         of these maximal values to the slack values in those rows and
%         columns.  The Kth row of RATIOS is [RRATIO, CRATIO] where RRATIO
%         (CRATIO) is the respective row (column) slack value for the Kth
%         maximal element divided by the value of the Kth maximal element.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pos, ratios] = maxPosRatio(assignMat)

pos = [];
ratios = [];

nrows = size(assignMat,1);
ncols = size(assignMat,2);
nimgpnts  = nrows - 1;
nmodpnts = ncols - 1;

% Iterate over all columns of assignMat.
for k = 1 : nmodpnts
    [vmax imax] = max(assignMat(:,k));                  % Max value in column k.

    if imax == nrows
        continue;                       % Slack value is maximum in this column.
    end;

    % Check if the max value in the column is maximum within its row.
    if all(vmax > assignMat(imax,[1:k-1,k+1:ncols]))
        pos = [pos; [imax, k]];     % This value is maximal in its row & column.

        % Compute the ratios to row and column slack values.
        rr = assignMat(imax,ncols)/assignMat(imax,k);
        cr = assignMat(nrows,k)/assignMat(imax,k);
        ratios = [ratios; [rr cr]];
    end
end

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% NUMMATCHES    How many image points have found a model point match?
%     NUM = numMatches(ASSIGNMAT)
%         ASSIGNMAT is an image to model assignment matrix.  The last
%         row and column of ASSIGNMAT are slack, and are used to indicate
%         no match for that row or column. Image point number I matches
%         model point number M if ASSIGNMAT(I,M) is strictly greater
%         than all other entries in row I and column M of ASSIGNMAT.
%         NUM returns the number of matching points.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function num = numMatches(assignMat)

num = 0;

nrows = size(assignMat,1);
ncols = size(assignMat,2);
nimgpnts  = nrows - 1;
nmodpnts = ncols - 1;

for k = 1 : nmodpnts
    [vmax imax] = max(assignMat(:,k));                  % Max value in column k.

    if imax == nrows
        continue;                       % Slack value is maximum in this column.
    end;

    if all(vmax > assignMat(imax,[1:k-1,k+1:ncols]))
        num = num + 1;              % This value is maximal in its row & column.
    end
end

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

