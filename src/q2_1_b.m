%% Q2 Part 1 Section B
clear;
close all;
addpath('../res');
addpath('../res/boat');

%% Load manual
load('manualBoat.mat', 'xA', 'xB', 'yA', 'yB');
manualA = [xA; yA];
manualB = [xB; yB];

%% Load previous variables from q1_auto.m; loads imgA, imgB, coordA, coordB
load('auto_out.mat');

%% Estimate transformation matrices
transformMatAuto = estTransformMat2(coordA, coordB);
transformMatManual = estTransformMat2(manualA, manualB);

%% Warp Images!
transformAuto = projective2d(transformMatAuto);
imgABAuto = imwarp(imgB, transformAuto);
transformManual = projective2d(transformMatManual);
imgABManual = imwarp(imgB, transformManual);

%% Display
figure('position', [0 0 1280 800]);
subplot(2, 2, 1);
imshow(imgABAuto);
subplot(2, 2, 2);
imshow(imgABManual);
subplot(2, 2, 3);
imshow(imgA);
subplot(2, 2, 4);
imshow(imgB);




