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
transformMatAuto = estTransformMat(coordA, coordB);
transformMatManual = estTransformMat(manualA, manualB);

%% Warp Images!
% Transpose required, MATLAB convention
transformAuto = affine2d(transformMatAuto');
[imgABAuto, refAuto] = imwarp(imgA, transformAuto);

transformManual = affine2d(transformMatManual');
[imgABManual, refManual] = imwarp(imgA, transformManual);

%% Display
figure('position', [0 0 1280 800]);

subplot(2, 2, 1);
imshow(imgA);
title('Image A');

subplot(2, 2, 2);
imshow(imgB);
title('Image B');

subplot(2, 2, 3);
imshowpair(imgB, imref2d(size(imgB)), imgABAuto, refAuto);
title('Image A, Transformed, Auto Features, over B. ');

subplot(2, 2, 4);
imshowpair(imgB, imref2d(size(imgB)), imgABManual, refManual);
title('Image A, Transformed, Manual Features, over B. ');

%% Display errors
errorMan = errorHA(manualA, manualB, transformMatManual);
errorAuto = errorHA(coordA, coordB, transformMatAuto);
disp(errorMan);
disp(errorAuto);