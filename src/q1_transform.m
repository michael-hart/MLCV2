% File to estimate the transform between two images and show the first
% image transformed to look like the second

% Clear variables and figures
clear;
clf;
close all;

% Load previous variables from q1_auto.m; loads imgA, imgB, coordA, coordB
load('res/auto_out.mat');

% Call the matrix estimation function with coordA, coordB
transformMat = estTransformMat(coordA, coordB);

% Transform B to A and display alongside A
% transform = projective2d(transformMat);
% imgAB = imwarp(imgB, transform);
[imgAB, ~] = project(imgB, transformMat);

figure;
subplot(2, 1, 1);
imshow(imgAB);
subplot(2, 1, 2);
imshow(imgA);
