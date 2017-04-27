%% Q2 Part 1 Section B
clear;
close all;
addpath('../res');
addpath('../res/boat');

%% Load previous variables from q1_auto.m; loads imgA, imgB, coordA, coordB
load('auto_out.mat');

%% Optimise
doRansac = true;
showImg1 = false;
showImg2 = true;
showImg3 = false;

if doRansac
    [coordOptA, coordOptB] = myRANSAC(coordA, coordB, 5e4, 20);
else
    coordOptA = coordA;
    coordOptB = coordB;
end

%% Graph two pics, with unoptimised and optimised points.
if showImg1
    figure('position', [0 0 1280 800]);
    subplot(2, 2, 1);
    imshow(imgA);
    hold on;
    scatter(coordA(1, :), coordA(2, :), 250, 'o', 'filled', 'blue');
    n = length(coordA(1, :));
    text(coordA(1, :), coordA(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'red' );
    hold off;

    subplot(2, 2, 2);
    imshow(imgB);
    hold on;
    scatter(coordB(1, :), coordB(2, :), 250, 'o', 'filled', 'blue');
    n = length(coordB(1, :));
    text(coordB(1, :), coordB(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'red' );
    hold off;

    subplot(2, 2, 3);
    imshow(imgA);
    hold on;
    scatter(coordOptA(1, :), coordOptA(2, :), 250, 'o', 'filled', 'blue');
    n = length(coordOptA(1, :));
    text(coordOptA(1, :), coordOptA(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'red' );
    hold off;

    subplot(2, 2, 4);
    imshow(imgB);
    hold on;
    scatter(coordOptB(1, :), coordOptB(2, :), 250, 'o', 'filled', 'blue');
    n = length(coordOptB(1, :));
    text(coordOptB(1, :), coordOptB(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'red' );
    hold off;
end

%% Estimate transformation matrices
transformMat = estTransformMat(coordOptA, coordOptB);

% Translated points
pointsAuto = zeros(size(coordOptA));
for index = 1:size(coordOptA, 2)
    temp = transformMat * [coordOptA(1, index); coordOptA(2, index); 1];
    pointsAuto(:, index) = temp(1:2);
end

%% Warp Images!
% Transpose required, MATLAB convention
transformA = projective2d(transformMat');
[imgAB1, ref1] = imwarp(imgA, transformA');

[imgAB2, ref2] = projection(imgA, transformMat);

% Display A, B, and B with A tranformed.
if showImg2
    figure('position', [0 0 1280 800]);

    subplot(2, 2, 1);
    imshow(imgA);
    title('Image A');

    subplot(2, 2, 2);
    imshow(imgB);
    title('Image B');

    subplot(2, 2, 3);
    imshowpair(imgB, imref2d(size(imgB)), imgAB2, ref2);
    title('Image A, Transformed, Auto Features, over B.');
    
    subplot(2, 2, 4);
    imshowpair(imgB, imref2d(size(imgB)), imgAB1, ref1);
    title('Image A, Transformed, Auto Features, over B.');
end

%% Display A and B is used points. Finally, B, with transformed A, both with their points. 
if showImg3
    figure('position', [0 0 1280 800]);

    subplot(2, 2, 1);
    imshow(imgA);
    hold on;
    scatter(coordOptA(1, :), coordOptA(2, :), 250, 'o', 'filled', 'blue');
    n = length(coordOptA(1, :));
    text(coordOptA(1, :), coordOptA(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'red' );
    hold off;

    subplot(2, 2, 2);
    imshow(imgB);
    hold on;
    scatter(coordOptB(1, :), coordOptB(2, :), 250, 'o', 'filled', 'blue');
    n = length(coordOptB(1, :));
    text(coordOptB(1, :), coordOptB(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'red' );
    hold off;

    subplot(2, 2, [3, 4]);
    imshowpair(imgB, imref2d(size(imgB)), imgAB, ref);
    hold on;
    
    scatter(coordOptB(1, :), coordOptB(2, :), 100, 'o', 'filled', 'blue');
    n = length(coordOptB(1, :));
    text(coordOptB(1, :), coordOptB(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'red' );
    
    scatter(pointsAuto(1, :), pointsAuto(2, :), 100, 'o', 'filled', 'yellow');
    n = length(pointsAuto(1, :));
    text(pointsAuto(1, :), pointsAuto(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'green' );
    hold off;
    title('Image A, Transformed, Auto Features, over B.');
end

%% Display errors
error = errorHA(coordOptA, coordOptB, transformMat);
errorBefore = errorHA(coordA, coordB, eye(3));
disp(errorBefore);
disp(error);

