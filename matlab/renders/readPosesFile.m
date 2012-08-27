function pose = readPosesFile(full_fname)

a = load(full_fname);
[n,m] = size(a);
for i=1:n
	pose(i).rotation =  a(i,1:3);
	pose(i).translation = a(i,4:6);
end

end