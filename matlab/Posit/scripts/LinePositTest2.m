close all 
clear all
clc
% 
% initRot = [ -0.0567   -0.9692    0.2397;
%     -0.7991    0.1879    0.5710;
%     -0.5985   -0.1592   -0.7852];
% 
% initTrans = [0.5; -0.1; 7];
imagePts = [ 172.3829  -15.4229;
    174.9147 -183.8248;
    174.9147 -183.8248;
    -28.3942 -147.8052;
    -28.3942 -147.8052;
    243.2142  105.4463;
    243.2142  105.4463;
    252.6934  -72.3310;
    252.6934  -72.3310;
    25.7430  -28.9218;
    25.7430  -28.9218;
    35.9377  149.1948];

M = size(imagePts,1)/2;


worldPts = [ -0.5000   -0.5000   -0.5000;
    0.5000   -0.5000   -0.5000;
    0.5000   -0.5000   -0.5000;
    0.5000    0.5000   -0.5000;
    0.5000    0.5000   -0.5000;
    -0.5000    0.5000   -0.5000;
    -0.5000    0.5000   -0.5000;
    -0.5000   -0.5000    0.5000;
    -0.5000   -0.5000    0.5000;
    0.5000   -0.5000    0.5000;
    0.5000   -0.5000    0.5000;
    0.5000    0.5000    0.5000;
    0.5000    0.5000    0.5000;
    -0.5000    0.5000    0.5000];

M = size(imagePts,1)/2; % cantidad lineas en la imagen
N = size(worldPts,1)/2; % cantidad lineas en modelo

initRot = [ 0.9149    0.1910   -0.3558;
    -0.2254    0.9726   -0.0577;
    0.3350    0.1330    0.9328];
initTrans = [0; 0; 50];
fc = 1500;
center=[0 0];

beta0=2.0e-04;
noiseStd = 0.1;
alpha = 9.21*noiseStd^2;
maxDelta = sqrt(alpha)/2;          % Max allowed error per world point.
betaFinal = 0.5;                   % Terminate iteration when beta == betaFinal.
betaUpdate = 1.05;
M = size(imagePts,1)/2; % cantidad lineas en la imagen
N = size(worldPts,1)/2; % cantidad lineas en modelo
rot=initRot;
trans=initTrans;
assignConverged=0;
count=0;
betaCount=0;
maxCount = 2;
minBetaCount = 30;
r1T = zeros(4,4);
r2T = zeros(4,4);
w=ones(2*N,1);
beta=beta0;

% le corro el centro de la imagen
imgPts=(imagePts-center(ones(2*M,1),:))/fc;

n=zeros(M,3);
for i=1:M
    n(i,:)=cross([imgPts(2*i,:) 1],[imgPts(2*i-1,:) 1]);
    n(i,:)=n(i,:)./norm(n(i,:));
    ans1=dot([imgPts(2*i-1,1) imgPts(2*i-1,2) 1],n(i,:))
    ans2=dot([imgPts(2*i,1) imgPts(2*i,2) 1],n(i,:))
end

% aca arranca el loop de soft posit
while beta < betaFinal && ~assignConverged
    
    projWorldPts  = proj3dto2d(worldPts, rot, trans, fc,1, center'); % proyecto puntos de modelo sobre imagen
    
    %se calculan las distancias entre lineas
    [assignMat,distMat] = distanceMatrix(imagePts,projWorldPts,alpha,beta);
    assignMat(1:2*M*N+1,2*N+1) = 1/17;
    assignMat(2*M*N+1,1:2*N+1) = 1/17;
    assignMat = sinkhornImp(assignMat);
    
    % se grafica para ver que se esta proyectando bien
%     
%     figure
%     subplot(1,2,1)
%     I=imshow('cubo30.png');
%     hold on
%     subplot(1,2,2)
%     I=imshow('cubo30.png');
%     hold on
%     for i=1:size(projWorldPts,1)
%         subplot(1,2,1)
%         plot(projWorldPts(i,1),projWorldPts(i,2),'+','markersize',10)
%         text(projWorldPts(i,1),projWorldPts(i,2),num2str(i),'color',[1;1;1])
%         subplot(1,2,2)
%         plot(imagePts (i,1),imagePts (i,2),'*','markersize',10)
%         text(imagePts(i,1),imagePts(i,2),num2str(i),'color',[1;1;1])
%     end
%     hold off
%     title('Proyeccion con pose conocida')
%     
    
    
    
    %Calculo los vectores normales a los planos formados por las lineas en la
    %imagen
    
    
    
    k=1;
    Sij=zeros(2*M*N,3);
    maxCount = 2;
    pij=zeros(2*M*N,2);
    minBetaCount = 20;
    worldPtsCam=rot*worldPts'+trans(:,ones(1,2*N));
    worldPtsCam= worldPtsCam';
    
    
    
%     figure
%     
%     drawAxis3d
%     hold on
%     %      axis([-2000 2000 -2000 2000 -2000 2000]);
%     drawPoint3d([imgPts ones(2*M,1)]);
%     drawPoint3d(worldPtsCam,'*g');
%     
    %calculo las proyecciones de los puntos Pj y Pj' sobre el plano de la linea
    %i Sj y Sj'
    
        % dibujo plano de la camara
%         fillPolygon3d([-10 -10 1 ;10 -10 1; 10 10 1; -10 10 1],[0.8,0.6,0.4])
        for i=1:M
            for j=1:N
                plane = createPlane([imgPts(2*i-1,:) 1],n(i,:));
    %             drawPlane3d(plane);
                Sij(k,:) = projPointOnPlane(worldPtsCam(2*j-1,:), plane);
    %             drawPoint3d(Sij(k,:),'+b');
                pij(k,:)=[Sij(k,1)/Sij(k,3) Sij(k,2)/Sij(k,3)]; % calculo los imgPts que se van usar para meter en softPosit
%                 drawPoint3d([pij(k,:) 1],'+r');
                Sij(k+1,:) = projPointOnPlane(worldPtsCam(2*j,:), plane);
    %             drawPoint3d(Sij(k+1,:),'+b');
                pij(k+1,:)=[Sij(k+1,1)/Sij(k+1,3) Sij(k+1,2)/Sij(k+1,3)]; % calculo los imgPts que se van usar para meter en softPosit
%                 drawPoint3d([pij(k+1,:) 1],'+r');
                k=k+2;
            end
        end
    %
    % plane = createPlane([imgPts(1,:) 1],n(1,:));
    % Sij(1,:) = projPointOnPlane(worldPtsCam(1,:), plane);
    % pij(1,:)=[Sij(1,1)/Sij(1,3) Sij(1,2)/Sij(1,3)];
    %
    % Sij(2,:) = projPointOnPlane(worldPtsCam(2,:), plane);
    % pij(2,:)=[Sij(2,1)/Sij(2,3) Sij(2,2)/Sij(2,3)];
    %
    % plane = createPlane([imgPts(3,:) 1],n(2,:));
    % Sij(9,:) = projPointOnPlane(worldPtsCam(3,:), plane);
    % pij(9,:)=[Sij(9,1)/Sij(9,3) Sij(9,2)/Sij(9,3)];
    %
    % Sij(10,:) = projPointOnPlane(worldPtsCam(4,:), plane);
    % pij(10,:)=[Sij(10,1)/Sij(10,3) Sij(10,2)/Sij(10,3)];
    %
    % plane = createPlane([imgPts(5,:) 1],n(3,:));
    % Sij(17,:) = projPointOnPlane(worldPtsCam(5,:), plane);
    % pij(17,:)=[Sij(17,1)/Sij(17,3) Sij(17,2)/Sij(17,3)];
    %
    % Sij(18,:) = projPointOnPlane(worldPtsCam(6,:), plane);
    % pij(18,:)=[Sij(18,1)/Sij(18,3) Sij(18,2)/Sij(18,3)];
    %
    % pij(3:8,:)=0;
    % pij(11:16,:)=0;
    
    
    
    % se calculan Q1 y Q2 ecs (6) y (7) del paper de linePosit
    %     pij=pij*fc+center(ones(2*M*N,1),:);
    
    num = numMatches(assignMat);
    % assignMat=zeros(19,7);
    % assignMat(1:2,1:2)=ones(2,2);
    % assignMat(9:10,3:4)=ones(2,2);
    % assignMat(17:18,5:6)=ones(2,2);
    homogeneousWorldPts=[worldPts ones(2*N,1)];
%     pij(1:2,:)=imgPts(1:2,:);
%     pij(9:10,:)=imgPts(3:4,:);
%     pij(17:18,:)=imgPts(5:6,:);
    [r1T,r2T]=poseVectors(pij,homogeneousWorldPts,assignMat,w);
    
    % A partir de Q1 y Q2 se estima la pose
    
    r1TSquared = r1T(1)*r1T(1) + r1T(2)*r1T(2)+ r1T(3)*r1T(3);
    r2TSquared = r2T(1)*r2T(1) + r2T(2)*r2T(2)+ r2T(3)*r2T(3);
    s=sqrt(sqrt(r1TSquared)*sqrt(r2TSquared));
    R1=r1T(1:3)./s;
    R2=r2T(1:3)./s;
    R3=cross(R1,R2);
    TX=r1T(4)/s;
    TY=r2T(4)/s;
    TZ=fc/s;
    Tz = sqrt(2/(r1TSquared+r2TSquared));   % Chang & Tsai's suggestion.
    r1N = r1T*Tz;                   % Column 4-vectors: (R1,Tx).
    r2N = r2T*Tz;                   %                   (R2,Ty).
    r1 = r1N(1:3);                  % Three rows of the rotation matrix.
    r2 = r2N(1:3);
    r3 = cross(r1,r2);
    r3T= [r3; Tz];                  % Column 4-vector: (R3,Tz).
    Tx = r1N(4);
    Ty = r2N(4);
    
    rot2=[r1'; r2' ; r3'];
    T=[Tx Ty Tz];
%     ROT=[R1';R2';R3']
%     TRANS=[TX TY TZ]
    
    projWorldPts2  = proj3dto2d(worldPts, rot2, T', fc ,1, center');
    
    % se grafica para ver que se esta proyectando bien
%     figure
%     I=imshow('cubo30.png');
%     hold on
%     for i=1:size(projWorldPts,1)
%         plot(projWorldPts2(i,1),projWorldPts2(i,2),'+w','markersize',10)
        %     plot(imgPts (i,1),imgPts (i,2),'*w','markersize',10)
%         text(projWorldPts2(i,1),projWorldPts2(i,2),num2str(i),'color',[1;1;1])
%     end
%     hold off
%     title('Proyeccion con pose conocida')
    
    
    % se guarda la nueva pose estimada
    r1T = [r1; Tx]/Tz;
    r2T = [r2; Ty]/Tz;
    for j=1:2*N
        w(j)=rot(3,:)*worldPts(j,:)'/trans(3)+1;
    end
    
    delta = sqrt(sum(sum(assignMat(1:2*M*N,1:2*N) ...
        .* distMat))/(2*N))
    poseConverged = delta < maxDelta;
    count = count + 1;
    
    beta = betaUpdate * beta;
    betaCount = betaCount + 1;   % Number of deterministic annealing iterations.
    assignConverged = poseConverged & betaCount > minBetaCount;
    
    trans = [Tx; Ty; Tz];
    rot = [r1'; r2'; r3'];
    
    foundPose = (delta < maxDelta & betaCount > minBetaCount);
    
end