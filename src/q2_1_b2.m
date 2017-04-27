%% Q2 Part 1 Section B
clear;
close all;
addpath('../res');

%% Load manual
% A to B, B to C, C to A. 

%% Load pictures
imgA = imread(one);
imgB = imread(two);
imgC = imread(three);

harrisA = harris(imgA, 2500);
harrisB = harris(imgB, 2500);
harrisC = harris(imgC, 2500);

 %% Display picture with points
showImg = true;

if showImg
    figure('position', [0 0 1280 800]);
    imshow(imgA);
    hold on;
    scatter(harrisA(1, :), harrisA(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
    
    figure('position', [0 0 1280 800]);
    imshow(imgB);
    hold on;
    scatter(harrisB(1, :), harrisB(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
    
    figure('position', [0 0 1280 800]);
    imshow(imgC);
    hold on;
    scatter(harrisC(1, :), harrisC(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
end


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