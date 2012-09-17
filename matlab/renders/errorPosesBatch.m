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
stddev = std(err);
maximum = max(err);
minimum = min(err);

trimmedia = trimmean(err,20)

%% return stats struct
stats.meanErr = media;
stats.varErr = varianza;
stats.stdErr = stddev;
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
subplot(321); plot(successIdx,m1(:,1),'b'); hold on; plot(successIdx,m2(:,1),'r'); ylabel('rx'); hold off;
subplot(323); plot(successIdx,m1(:,2),'b'); hold on; plot(successIdx,m2(:,2),'r'); ylabel('ry'); hold off;
subplot(325); plot(successIdx,m1(:,3),'b'); hold on; plot(successIdx,m2(:,3),'r'); ylabel('rz'); hold off;
subplot(322); plot(successIdx,m1(:,4),'b'); hold on; plot(successIdx,m2(:,4),'r'); ylabel('tx'); hold off;
subplot(324); plot(successIdx,m1(:,5),'b'); hold on; plot(successIdx,m2(:,5),'r'); ylabel('ty'); hold off;
subplot(326); plot(successIdx,m1(:,6),'b'); hold on; plot(successIdx,m2(:,6),'r'); ylabel('tz'); hold off; 
% xlabel('pose index'); title('Pose Estimation');

% figure(2)
% hist(err,500)

figure(2)
subplot(321); plot(successIdx,err(:,1),'b'); ylabel('rx');
subplot(323); plot(successIdx,err(:,2),'b'); ylabel('ry');
subplot(325); plot(successIdx,err(:,3),'b'); ylabel('rz');
subplot(322); plot(successIdx,err(:,4),'b'); ylabel('tx');
subplot(324); plot(successIdx,err(:,5),'b'); ylabel('ty');
subplot(326); plot(successIdx,err(:,6),'b'); ylabel('tz'); 
% axis('tight');
% % xlabel('pose index'); title('Pose Error')

end