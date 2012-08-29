function writePosesFile(pose,full_fname)

fid = fopen(full_fname,'w');

n = length(pose);
% fprintf(fid,'%d\n',n);
for i=1:n
	fprintf(fid,'%4.4f %4.4f %4.4f %4.4f %4.4f %4.4f\n'	,...
										pose(i).rotation,...
										pose(i).translation);	
end
fclose(fid);

end

