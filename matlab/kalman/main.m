% poses=load('poses.txt');
poses=load('/Users/juanignaciobraun/Dropbox/encuadro/renders/pose_05/480x360/poses_coplanar_scale0.6.txt');
[LEN, DIM]=size(poses);
posesNoise=poses+randn(LEN,DIM);
y=zeros(LEN,DIM);
k=1;
goodPoses=zeros(LEN,DIM);
for i=2:LEN
    if poses(i,1)~=-1
        goodPoses(k,:)=  poses(i,:);
        k=k+1;
        %     else
        %         poses(i,:)=poses(i-1,:)*2;
    end
end
LEN=k;
A=eye(3);
H=eye(3);

% Caso1
R =1*[4.96249572803608,4.31450588099769,-0.0459669868120827;
    4.31450588099769,7.02354899298729,-0.0748919339531972;
    -0.0459669868120827,-0.0748919339531972,0.00106230567668207];

% % Caso3
% R = 0.8*[4.40787273901961,-0.743903387450980,-0.0112710759803922;
%     -0.743903387450980,0.142068035113122,0.00160756828054299;
%     -0.0112710759803922,0.00160756828054299,0.000118766557315234];

% % Caso4
% R = [3.24425906375000,-0.674983411577381,-0.00412114764880952;
%     -0.674983411577381,25.0604260173639,-0.241005422342687;
%     -0.00412114764880952,-0.241005422342687,0.00357257550170068];

% % Caso5
% R = [5.83145477746448,5.68260981650547,-0.0272625132431690;
%     5.68260981650547,7.35908416081967,-0.0314693884754095;
%     -0.0272625132431690,-0.0314693884754095,0.000205028989071034];

% % Caso6
% R = [0.0324648100000004,0.0242447500000001,-0.00182343000000001;
%     0.0242447500000001,0.0305585033333333,-0.00157719666666667;
%     -0.00182343000000001,-0.00157719666666667,0.000106143333333333];

% % Caso7
% R = [0.231609442777778,-0.353171842222222,0.000734761666666667;
%     -0.353171842222222,1.80637837155556,-0.00496504555555555;
%     0.000734761666666667,-0.00496504555555555,0.000555533888888889];

Q = eye(3);
x_est = [-60 0 0]' ;          % x_est=[x,y,Vx,Vy,Ax,Ay]'
p_est = 10*eye(3);
for n=1:LEN                     % Output in the loop
    
    
    x_prd = A * x_est;
    p_prd = A * p_est * A' + Q;
    S = H * p_prd' * H' + R;
    B = H * p_prd';
    klm_gain = (S \ B)';
    x_est = x_prd + klm_gain * (goodPoses(n,1:3)' - H * x_prd);
    p_est = p_prd - klm_gain * H * p_prd;
    y(n,1:3) = H * x_est;
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
plot(y(1:LEN,1))
plot(goodPoses(1:LEN,1),'-r')
ylabel('Rotacion en x')
legend('Filtered Data','Raw Data')
hold off
subplot(3,1,2)
hold on
plot(y(1:LEN,2))
plot(goodPoses(1:LEN,2),'-r')
ylabel('Rotacion en y')
legend('Filtered Data','Raw Data')
hold off
subplot(3,1,3)
hold on
plot(y(1:LEN,3))
plot(goodPoses(1:LEN,3),'-r')
ylabel('Rotacion en y')
legend('Filtered Data','Raw Data')
hold off

% figure
% subplot(3,1,1)
% title('Traslaciones')
% hold on
% plot(y(:,4))
% plot(poses(:,4),'-r')
% ylabel('Traslacion en x')
% legend('Filtered Data','Raw Data')
% hold off
% subplot(3,1,2)
% hold on
% plot(y(:,5))
% plot(poses(:,5),'-r')
% ylabel('Traslacion en y')
% legend('Filtered Data','Raw Data')
% hold off
% subplot(3,1,3)
% hold on
% plot(y(:,6))
% plot(poses(:,6),'-r')
% ylabel('Traslacion en z')
% legend('Filtered Data','Raw Data')
% hold off
