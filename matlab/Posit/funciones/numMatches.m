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

