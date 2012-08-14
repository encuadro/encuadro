rot = [ -0.0567   -0.9692    0.2397;
    -0.7991    0.1879    0.5710;
    -0.5985   -0.1592   -0.7852];

trans = [0.5; -0.1; 7];
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
beta0 = 2.0e-04
noiseStd = 0
INITROT = [ 0.9149    0.1910   -0.3558;
    -0.2254    0.9726   -0.0577;
    0.3350    0.1330    0.9328];
INITTRANS = [0; 0; 50];
focalLength= 1500;
center=[0 0];



alpha = 9.21*noiseStd^2 + 1;

maxDelta = sqrt(alpha)/2;          % Max allowed error per world point.

betaFinal = 0.5;                   % Terminate iteration when beta == betaFinal.
betaUpdate = 1.05;                 % Update rate on beta.
epsilon0 = 0.01;                   % Used to initialize assignement matrix.

maxCount = 2;
minBetaCount = 20;



minNbPts = min([2*M;2*N]);
maxNbPts = max([2*M;2*N]);
scale = 1/(maxNbPts + 1);

% Convert to normalized image coordinates. With normalized coordinates, (0,0)
% is the point where the optic axis penetrates the image, and the focal length
% is 1.
centeredImage(:,1) = (imagePts(:,1) - center(1))/focalLength;
centeredImage(:,2) = (imagePts(:,2) - center(2))/focalLength;

imageOnes = ones(2*M, 1);   % Column M-vector.

% The homogeneous world points -- append a 1 to each 3-vector. An Nx4 matrix.
worldOnes = ones(2*N, 1);   % Column N-vector.
homogeneousWorldPts = [worldPts, worldOnes];

% Initial rotation and translation as passed into this function.
% rot = initRot;
% trans = initTrans;


% Initialize the depths of all world points based on initial pose.
wk = homogeneousWorldPts * [rot(3,:)/trans(3), 1]';

% Draw a picture of the model on the original image plane.
projWorldPts = proj3dto2d(worldPts, rot, trans, focalLength, 1, center);

%     % plotImages(imagePts, imageAdj, projWorldPts, worldAdj);
%     plot2dPts(imagePts, 'r.-', 'FigNum', 1, 'AdjMat', imageAdj, ...
%               'Name', 'Original image', 'Axis', 300);
%     plot2dPts(projWorldPts, 'b.-', 'Overlay', 'AdjMat', worldAdj, ...
%               'Name', 'Projected model', 'Axis', 'Freeze');


% First two rows of the camera matrices (for both perspective and SOP).  Note:
% the scale factor is s = f/Tz = 1/Tz since f = 1.  These are column 4-vectors.
r1T = [rot(1,:)/trans(3), trans(1)/trans(3)]';
r2T = [rot(2,:)/trans(3), trans(2)/trans(3)]';

betaCount = 0;
poseConverged = 0;
assignConverged = 0;
foundPose = 0;
beta = beta0;

% The assignment matrix includes a slack row and slack column.
 [assignMat2,distMat] = distanceMatrix(imagePts,projWorldPts,alpha,beta0);
    assignMat2(1:2*M*N+1,2*N+1) = 1/17;
    assignMat2(2*M*N+1,1:2*N+1) = 1/17;
    assignMat = sinkhornImp(assignMat2);
    
     %Calculo los vectores normales a los planos formados por las lineas en la
    %imagenR
    n=zeros(M,3);
    for i=1:M
        n(i,:)=cross([centeredImage(2*i,:) 1],[centeredImage(2*i-1,:) 1]);
        n(i,:)=n(i,:)./norm(n(i,:));
        ans1=dot([centeredImage(2*i-1,1) centeredImage(2*i-1,2) 1],n(i,:))
        ans2=dot([centeredImage(2*i,1) centeredImage(2*i,2) 1],n(i,:))
    end
    %calculo las proyecciones de los puntos Pj y Pj' sobre el plano de la linea
    %i Sj y Sj'
    k=1;
    Sij=zeros(2*M*N,3);maxCount = 2;
    pij=zeros(2*M*N,2);
    minBetaCount = 20;
    worldPtsCam=rot*worldPts'+trans(:,ones(1,2*N));
    worldPtsCam= worldPtsCam';
    
     figure
    
    drawAxis3d
    hold on
%      axis([-2000 2000 -2000 2000 -2000 2000]);
    drawPoint3d([centeredImage ones(2*M,1)]);
    drawPoint3d(worldPtsCam,'*g');
% %     drawPoint3d(worldPts,'*b');
    

% dibujo plano de la camara
fillPolygon3d([-5 -5 1 ;5 -5 1; 5 5 1; -5 5 1],[0.8,0.6,0.4])
    for i=1:M
        for j=1:N
            plane = createPlane([centeredImage(2*i-1,:) 1],n(i,:));
%             drawPlane3d(plane);
            Sij(k,:) = projPointOnPlane(worldPtsCam(2*j-1,:), plane);
            drawPoint3d(Sij(k,:),'+b');
            pij(k,:)=[Sij(k,1)/Sij(k,3) Sij(k,2)/Sij(k,3)];
            drawPoint3d([pij(k,:) 1],'+r');
            Sij(k+1,:) = projPointOnPlane(worldPtsCam(2*j,:), plane);
            pij(k+1,:)=[Sij(k+1,1)/Sij(k+1,3) Sij(k+1,2)/Sij(k+1,3)];
            drawPoint3d([pij(k+1,:) 1],'+r');
            k=k+2;
        end
    end
    
    
    % calculo los imgPts que se van usar para meter en softPosit
%     pij=[Sij(:,1)./Sij(:,3) Sij(:,2)./Sij(:,3)];
    
    % se calculan Q1 y Q2 ecs (6) y (7) del paper de linePosit
    
    
    % Puntos modelo en coordenadas homogeneas
    summedByColAssign = sum(assignMat(1:2*N*M, 1:2*N), 1); % assignment matrix sumada en la dimension de las columnas
    
    % este termino es comun a Q1 y Q2
    sumSkSkT = zeros(4, 4);
    for k = 1:2*N
        sumSkSkT = sumSkSkT + summedByColAssign(k) * ...
            homogeneousWorldPts(k,:)' * homogeneousWorldPts(k,:);
    end
    
    objectMat = inv(sumSkSkT);
    
    % Save the previouse pose vectors for convergence checks.
    r1Tprev = r1T;
    r2Tprev = r2T;
    
    w=ones(2*N,1);
    
    
    weightedUi = zeros(4,1);                    % Segundo termino de Q1
    weightedVi = zeros(4,1);                    % Segundo termino de Q2
    for j = 1:2*M*N
        for k = 1:2*N
            weightedUi = weightedUi + assignMat(j,k) *  wk(k) *  ...
                pij(j,1) * homogeneousWorldPts(k,:)';
            weightedVi = weightedVi + assignMat(j,k) * wk(k) * ...
                pij(j,2) * homogeneousWorldPts(k,:)';
        end % for k
    end % for j
    
    r1T = objectMat * weightedUi;               % M
    r2T = objectMat * weightedVi;              % N
    
    % A partir de Q1 y Q2 se estima la pose
    
    [U, S, V] = svd([r1T(1:3)'; r2T(1:3)']');
    A = U * [1 0; 0 1; 0 0] * V';
    r1 = A(:,1);
    r2 = A(:,2);
    r3 = cross(r1,r2);
    Tz = 2 / (S(1,1) + S(2,2));
    Tx = r1T(4) * Tz;
    Ty = r2T(4) * Tz;
    r3T= [r3; Tz];
    
    rot2=[r1'; r2' ; r3']
    T=[Tx Ty Tz];
    
    projWorldPts2  = proj3dto2d(worldPts, rot2, T', focalLength ,1, center);
    
    % se grafica para ver que se esta proyectando bien
    figure
    I=imshow('cubo30.png');
    hold on
    for i=1:size(projWorldPts,1)
        plot(projWorldPts2(i,1),projWorldPts2(i,2),'+w','markersize',10)
        %     plot(imgPts (i,1),imgPts (i,2),'*w','markersize',10)
        text(projWorldPts2(i,1),projWorldPts2(i,2),num2str(i),'color',[1;1;1])
    end
    hold off
    title('Proyeccion con pose conocida')
    
    
    % se guarda la nueva pose estimada
    r1T = [r1; Tx]/Tz;
    r2T = [r2; Ty]/Tz;
    
  