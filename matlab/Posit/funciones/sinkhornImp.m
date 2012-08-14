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


