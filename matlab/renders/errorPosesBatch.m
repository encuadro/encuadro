function [media,varianza] = errorPosesBatch(poses,poses_est)
	
count = 0;
for i=1:length(poses_est) %FIXME: juani arreglar escritura de poses.
		posesMat(i,1:3) = poses(i).rotation;
		posesMat(i,4:6) = poses(i).translation;
		posesMatEst(i,1:3) = poses_est(i).rotation;
		posesMatEst(i,4:6) = poses_est(i).translation;
end

m1 = posesMat(find(posesMatEst(:,6)>-1),:);
m2 = posesMatEst(find(posesMatEst(:,6)>-1),:);

err = m2-m1;

media = mean(err);
varianza = var(err);

figure(1)
axis('tight');
subplot(321); plot(m1(:,1),'--o'); hold on; plot(m2(:,1),'--xr'); ylabel('rx');
subplot(323); plot(m1(:,2),'--o'); hold on; plot(m2(:,2),'--xr'); ylabel('ry');
subplot(325); plot(m1(:,3),'--o'); hold on; plot(m2(:,3),'--xr'); ylabel('rz');
subplot(322); plot(m1(:,4),'--o'); hold on; plot(m2(:,4),'--xr'); ylabel('tx');
subplot(324); plot(m1(:,5),'--o'); hold on; plot(m2(:,5),'--xr'); ylabel('ty');
subplot(326); plot(m1(:,6),'--o'); hold on; plot(m2(:,6),'--xr'); ylabel('tz'); 
% xlabel('pose index'); title('Pose Estimation');

figure(2)
subplot(321); plot(err(:,1),'--o'); ylabel('rx');
subplot(323); plot(err(:,2),'--o'); ylabel('ry');
subplot(325); plot(err(:,3),'--o'); ylabel('rz');
subplot(322); plot(err(:,4),'--o'); ylabel('tx');
subplot(324); plot(err(:,5),'--o'); ylabel('ty');
subplot(326); plot(err(:,6),'--o'); ylabel('tz'); 
axis('tight');
% xlabel('pose index'); title('Pose Error')

end