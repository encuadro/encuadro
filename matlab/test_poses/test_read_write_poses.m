clear all;
close all;
clc;

%% test generate poses
pose = generatePoses(1);

%% test write poses
writePosesFile(pose,'poses.txt');

%% test read poses
poses_read = readPosesFile('poses.txt');

