% poses=load('poses.txt');
poses=load('poses_coplanar_scale0.8.txt');
[LEN, DIM]=size(poses);
posesNoise=poses+randn(LEN,DIM);
y=zeros(LEN,DIM);
k=1;
goodPoses=zeros(LEN,DIM);
for i=2:LEN
    if poses(i,1)>0
        goodPoses(k,:)=  poses(i,:);
        k=k+1;
        %     else
        %         poses(i,:)=poses(i-1,:)*2;
    end
end

A=eye(6);
H=eye(6);
% R = [0.35 0 0 0 0 0; 0 0.14 0 0 0 0; 0 0 0.04 0 0 0; 0 0 0 0.18 0 0; 0 0 0 0 0.18 0; 0 0 0 0 0 18];
Q = 2*eye(6);
R = eye(6);
x_est = [-60 0 0 0 0 1500]' ;          % x_est=[x,y,Vx,Vy,Ax,Ay]'
p_est = 10*eye(6);
for n=1:LEN                     % Output in the loop
    
    
    x_prd = A * x_est;
    p_prd = A * p_est * A' + Q;
    S = H * p_prd' * H' + R;
    B = H * p_prd';
    klm_gain = (S \ B)';
    x_est = x_prd + klm_gain * (posesNoise(n,:)' - H * x_prd);
    p_est = p_prd - klm_gain * H * p_prd;
    y(n,:) = H * x_est;
end


% % w=randn(301,3);
% % v=randn(301,3);
% % W=mean(w*w');
% % V=mean(v*v');
% % P=mean(w*v');
%    Copyright 2010 The MathWorks, Inc.
% function y=kalman_loop(z)
% % Call Kalman estimator in the loop for large data set testing
% %#codegen
% [DIM, LEN]=size(z);
% y=zeros(DIM,LEN);           % Initialize output
% for n=1:LEN                     % Output in the loop
%     y(:,n)=kalmanfilter(z(:,n));
% end;
close all
subplot(3,1,1)
title('Rotaciones')
hold on
plot(y(:,1))
plot(posesNoise(:,1),'-r')
ylabel('Rotacion en x')
legend('Filtered Data','Raw Data')
hold off
subplot(3,1,2)
hold on
plot(y(:,2))
plot(posesNoise(:,2),'-r')
ylabel('Rotacion en y')
legend('Filtered Data','Raw Data')
hold off
subplot(3,1,3)
hold on
plot(y(:,3))
plot(posesNoise(:,3),'-r')
ylabel('Rotacion en y')
legend('Filtered Data','Raw Data')
hold off

figure
subplot(3,1,1)
title('Traslaciones')
hold on
plot(y(:,4))
plot(posesNoise(:,4),'-r')
ylabel('Traslacion en x')
legend('Filtered Data','Raw Data')
hold off
subplot(3,1,2)
hold on
plot(y(:,5))
plot(posesNoise(:,5),'-r')
ylabel('Traslacion en y')
legend('Filtered Data','Raw Data')
hold off
subplot(3,1,3)
hold on
plot(y(:,6))
plot(posesNoise(:,6),'-r')
ylabel('Traslacion en z')
legend('Filtered Data','Raw Data')
hold off
