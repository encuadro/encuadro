% EXAMPLE USAGE:
%     This is an example of softPOSIT registering an image of a cube (in 
% which one cube vertex is not visible) to a 3D model of the cube.
% In this example, the internal paramter betaUpdate was set to 1.05.
% The pose of the cube that was used to generate the image points is:

            Rot = [ -0.0567   -0.9692    0.2397;
                         -0.7991    0.1879    0.5710;
                         -0.5985   -0.1592   -0.7852];
          Trans = [0.5; -0.1; 7];
% The rotation matrix computed by softPOSIT (see below) does not match the
% above rotation matrix because, for a cube, any of a number of different
% rotations register the image to the model equally well.
%        INPUTS:
            IMAGEPTS = [ 172.3829  -15.4229;
                        174.9147 -183.8248;
                        -28.3942 -147.8052;
                        243.2142  105.4463;
                        252.6934  -72.3310;
                         25.7430  -28.9218;
                         35.9377  149.1948];
           IMAGEADJ = [ 1     1     0     1     0     0     0;
                        1     1     1     0     1     0     0;
                        0     1     1     0     0     1     0;
                        1     0     0     1     1     0     1;
                        0     1     0     1     1     1     0;
                        0     0     1     0     1     1     1;
                        0     0     0     1     0     1     1];
           WORLDPTS = [ -0.5000   -0.5000   -0.5000;
                         0.5000   -0.5000   -0.5000;
                         0.5000    0.5000   -0.5000;
                        -0.5000    0.5000   -0.5000;
                        -0.5000   -0.5000    0.5000;
                         0.5000   -0.5000    0.5000;
                         0.5000    0.5000    0.5000;
                        -0.5000    0.5000    0.5000];
           WORLDADJ = [ 1     1     0     1     1     0     0     0;
                        1     1     1     0     0     1     0     0;
                        0     1     1     1     0     0     1     0;
                        1     0     1     1     0     0     0     1;
                        1     0     0     0     1     1     0     1;
                        0     1     0     0     1     1     1     0;
                        0     0     1     0     0     1     1     1;
                        0     0     0     1     1     0     1     1];
           BETA0 = 2.0e-04
           NOISESTD = 0
           INITROT = [ 0.9149    0.1910   -0.3558;
                      -0.2254    0.9726   -0.0577;
                       0.3350    0.1330    0.9328];
           INITTRANS = [0; 0; 50];
           FOCALLENGTH = 1500;
           DISPLEVEL = 5;
           KICKOUT.numMatchable = 7;
           KICKOUT.rthldfbeta = zeros(1,200);
           
           
           [rot, trans, assignMat, projWorldPts, foundPose, stats] = ...
    softPosit(IMAGEPTS, IMAGEADJ,  WORLDPTS,WORLDADJ, BETA0,NOISESTD, ...
              INITROT, INITTRANS,  FOCALLENGTH , DISPLEVEL,KICKOUT)

% 
%        EXECUTION:
%            SoftPOSIT runs for 42 iterations.  The message displayed on the 
%            final iteration is the following:
%                betaCount = 42, beta = 0.0015523, delta = 0.86674, 
%                poseConverged = 1, numMatchPts = 7, sumNonslack = 5.0256
%            On the final iteration, the projected world points exactly overlay
%            the image points.
% 
%        OUTPUTS:
%            ROT = [   0.9692    0.0567   -0.2395;
%                     -0.1879    0.7990   -0.5712;
%                      0.1589    0.5987    0.7851];
%            TRANS = [ 0.5002; -0.1001; 7.0011];
%            ASSIGNMAT = [   0     0     0     0     0     0  0.72    0  0.28;
%                            0     0     0     0     0  0.72     0    0  0.28;
%                            0     0     0     0  0.72     0     0    0  0.28;
%                            0     0  0.72     0     0     0     0    0  0.28;
%                            0  0.72     0     0     0     0     0    0  0.28;
%                         0.72     0     0     0     0     0     0    0  0.28;
%                            0     0     0  0.72     0     0     0    0  0.28;
%                         0.28  0.28  0.28  0.28  0.28  0.28  0.28  1.0  0.11];
%            PROJWORLDPTS = [  25.7389  -28.9020;
%                             252.6681  -72.2992;
%                             243.1986  105.4171;
%                              35.9445  149.1457;
%                             -28.3467 -147.8163;
%                             174.9461 -183.8300;
%                             172.4196  -15.4739;
%                             -14.9407   21.2222];
%            FOUNDPOSE = 1;
%            STATS = [0.00020  53.3      0   0.24   0.00108;
%                     0.00021  55.1      0   0.30   0.00112;
%                     0.00022  55.3      0   0.36   0.00105;
%                     0.00023  55.1   0.12   0.44   0.00106;
%                     0.00024  51.2   0.37   0.50   0.00128;
%                     ...];
