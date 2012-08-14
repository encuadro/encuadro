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
