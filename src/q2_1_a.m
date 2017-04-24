%% Question 2 Part 1 Section A
clear;
close all;

%% Generate data to use, normal image
imgNormal = imread('../res/boat/img1.pgm');

% Perform Harris corner detection - 2500 works well from testing
harrisNormal = harris(imgNormal, 2500);

%% Display picture with points
figure;
imshow(imgNormal);
hold on;
scatter(harrisNormal(1, :), harrisNormal(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
hold off;

%% Generate data to use, reduced image
reducedImg = imresize(imgNormal, 0.5);

% Perform Harris corner detection - 2500 works well from testing
harrisReduced = harris(reducedImg, 2500);

%% Display picture with points
figure;
imshow(reducedImg);
hold on;
scatter(harrisReduced(1, :), harrisReduced(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
hold off;

%% Compare
% Get into n x 2 style.
harrisNormal = harrisNormal';
harrisReduced = harrisReduced';

harrisCompare = nearestNeighbour(harrisNormal, harrisReduced);
error = errorHA(harrisNormal, harrisCompare);
disp(error);

