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
imshow(imgNormal);
hold on;
scatter(2*harrisReduced(1, :), 2*harrisReduced(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
hold off;

%% Compare
% Nearest reduced point to actual point
[ harrisCompare1, distances1 ] = nearestNeighbour(harrisNormal, 2 * harrisReduced);
% Nearest actual point to reduced point
[ harrisCompare2, distances2 ] = nearestNeighbour(2 * harrisReduced, harrisNormal);

% The two errors
error1 = errorHA(harrisNormal, harrisCompare1, eye(3));
error2 = errorHA( 2*harrisReduced, harrisCompare2, eye(3));

% The average
disp(mean([error1 error2]));
