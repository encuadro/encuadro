function writeCameraFile(camera,full_fname)

fid = fopen(full_fname,'w');

%dimensions
fprintf(fid,'%d %d\n',camera.int.width, camera.int.height); 
%aspect ratio
fprintf(fid,'%4.4f\n',camera.int.ar);
%fov
fprintf(fid,'%4.4f %4.4f\n',camera.int.fov,camera.int.fov*camera.int.ar);
%center
fprintf(fid,'%4.4f %4.4f\n',camera.int.center); 
%fc
fprintf(fid,'%4.4f %4.4f\n',camera.int.fc);
%distortion
fprintf(fid,'%4.4f %4.4f %4.4f %4.4f %4.4f\n',camera.int.k);
%skew
fprintf(fid,'%4.4f\n',camera.int.alpha);
%camera pose
fprintf(fid,'%4.4f %4.4f %4.4f %4.4f %4.4f %4.4f\n',camera.ext.rotation,...
													camera.ext.translation);	
fclose(fid);

end