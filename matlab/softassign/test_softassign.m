clear all; close all; clc;


imagePts = [0 0;
			1 1;
			1.05 0.99;
			5 0];

worldPts = [0 0;
			1 1;
			0 5;
			5 0];

assignMat = softassign(imagePts, worldPts, 0.05, 0);

[pos,ratios] = maxPosRatio(assignMat)