%% Q2 Part 1 Section B
clear;
close all;
addpath('../res');
addpath('../res/boat');

%% Load manual
load('manualBoat.mat', 'xA', 'xB', 'yA', 'yB');
load('man2.mat');
manualA = [xA; yA];
manualB = [xB; yB];

%% Load previous variables from q1_auto.m; loads imgA, imgB, coordA, coordB
load('auto_out.mat');

%% Optimise
optimise = 1;
showImg1 = false;
showImg2 = false;
showImg3 = true;

if optimise == 1
    [coordOptA, coordOptB] = myRANSAC(coordA, coordB, 1e5, 20);

elseif optimise == 2
    yes = [1, 2, 6, 7, 9, 10, 12, 14, 15, 16, 17];
    coordOptA = coordA(:, yes);
    coordOptB = coordB(:, yes);

else
    coordOptA = coordA;
    coordOptB = coordB;
end

%% Graph 
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
transformMatAuto = estTransformMat(coordOptA, coordOptB);
transformMatManual = estTransformMat(manualA, manualB);

% Translated points
pointsAuto = zeros(size(coordOptA));
for index = 1:size(coordOptA, 2)
    temp = transformMatAuto * [coordOptA(1, index); coordOptA(2, index); 1];
    pointsAuto(:, index) = temp(1:2);
end

%% Warp Images!
% Transpose required, MATLAB convention
transformAuto = affine2d(transformMatAuto');
[imgABAuto, refAuto] = imwarp(imgA, transformAuto');

transformManual = affine2d(transformMatManual');
[imgABManual, refManual] = imwarp(imgA, transformManual);

%% Display
if showImg2
    figure('position', [0 0 1280 800]);

    subplot(2, 2, 1);
    imshow(imgA);
    title('Image A');

    subplot(2, 2, 2);
    imshow(imgB);
    title('Image B');

    subplot(2, 2, 3);
    imshowpair(imgB, imref2d(size(imgB)), imgABAuto, refAuto);
    title('Image A, Transformed, Auto Features, over B.');

    subplot(2, 2, 4);
    imshowpair(imgB, imref2d(size(imgB)), imgABManual, refManual);
    title('Image A, Transformed, Manual Features, over B.');
end

%% Display
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

    subplot(2, 2, 3);
    imshowpair(imgB, imref2d(size(imgB)), imgABAuto, refAuto);
    hold on;
    
    scatter(coordOptB(1, :), coordOptB(2, :), 100, 'o', 'filled', 'blue');
    n = length(coordOptB(1, :));
    text(coordOptB(1, :), coordOptB(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'red' );
    
    scatter(pointsAuto(1, :), pointsAuto(2, :), 100, 'o', 'filled', 'yellow');
    n = length(pointsAuto(1, :));
    text(pointsAuto(1, :), pointsAuto(2, :), cellstr(num2str([1:n]')), 'FontSize', 20, 'color', 'green' );
    hold off;
    title('Image A, Transformed, Auto Features, over B.');

    subplot(2, 2, 4);
    imshowpair(imgB, imref2d(size(imgB)), imgABManual, refManual);
    title('Image A, Transformed, Manual Features, over B.');
end

%% Display errors
errorMan = errorHA(manualA, manualB, transformMatManual);
errorAuto = errorHA(coordOptA, coordOptB, transformMatAuto);
errorManBefore = errorHA(manualA, manualB, eye(3));
errorAutoBefore = errorHA(coordA, coordB, eye(3));
disp(errorManBefore);
disp(errorMan);
disp(errorAutoBefore);
disp(errorAuto);

