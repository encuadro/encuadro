function renderMarker(pose,camera,setup,pose_nb)

setup.img_fname = sprintf(setup.img_fname_template,pose_nb-1);

fix = jfc_system_call_fix();

cmd = sprintf('%s%s -b %s%s -P %s%s -- %4.3f %4.3f %4.3f %4.3f %4.3f %4.3f %4.3f %d %d %s%s',...	
				setup.blender_path, setup.blender_cmd,...
				setup.model_path, setup.model_fname,...
				setup.python_path, setup.python_fname,...
				pose.translation, pose.rotation,...
				camera.int.fov(1), camera.int.height, camera.int.width,...
				setup.img_path, setup.img_fname)

% system([fix ';' cmd])
system(cmd)
end
