function stats = errorPosesBatch(poses,poses_est)
%% vectorize poses
for i=1:length(poses)
		posesMat(i,1:3) = poses(i).rotation;
		posesMat(i,4:6) = poses(i).translation;
		posesMatEst(i,1:3) = poses_est(i).rotation;
		posesMatEst(i,4:6) = poses_est(i).translation;
end

%% compute stats

failIdx = find(posesMatEst(:,6)==-1);
failNb = length(failIdx);
successIdx = find(posesMatEst(:,6)~=-1);
successNb = length(successIdx);
score = successNb/length(poses);

%crop pose matrixes
m1 = posesMat(successIdx,:);
m2 = posesMatEst(successIdx,:);
err = m2-m1;

media = mean(err);
mediana = median(err);
varianza = var(err);
maximum = max(err);
minimum = min(err);

%% return stats struct
stats.meanErr = media;
stats.varErr = varianza;
stats.medianErr = mediana;
stats.maxErr = maximum;
stats.minErr = minimum;

stats.failNb = failNb;
stats.failIdx = failIdx;
stats.successNb = successNb;
stats.successIdx = successIdx;
stats.score = score;

%% plots
figure(1)
axis('tight');
subplot(321); plot(m1(:,1),'b'); hold on; plot(m2(:,1),'r'); ylabel('rx'); hold off;
subplot(323); plot(m1(:,2),'b'); hold on; plot(m2(:,2),'r'); ylabel('ry'); hold off;
subplot(325); plot(m1(:,3),'b'); hold on; plot(m2(:,3),'r'); ylabel('rz'); hold off;
subplot(322); plot(m1(:,4),'b'); hold on; plot(m2(:,4),'r'); ylabel('tx'); hold off;
subplot(324); plot(m1(:,5),'b'); hold on; plot(m2(:,5),'r'); ylabel('ty'); hold off;
subplot(326); plot(m1(:,6),'b'); hold on; plot(m2(:,6),'r'); ylabel('tz'); hold off; 
% xlabel('pose index'); title('Pose Estimation');

% figure(2)
% hist(err,500)

% figure(2)
% subplot(321); plot(err(:,1),'--o'); ylabel('rx');
% subplot(323); plot(err(:,2),'--o'); ylabel('ry');
% subplot(325); plot(err(:,3),'--o'); ylabel('rz');
% subplot(322); plot(err(:,4),'--o'); ylabel('tx');
% subplot(324); plot(err(:,5),'--o'); ylabel('ty');
% subplot(326); plot(err(:,6),'--o'); ylabel('tz'); 
% axis('tight');
% % xlabel('pose index'); title('Pose Error')

end