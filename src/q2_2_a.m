%% Question 2 Part 1 Section A
clear;
close all;
if ismac
    addpath('../res/kitchen');
    outputpath = ('../');
else
    addpath('res/kitchen');
    outputpath = ('');
end

newPoints = false;

if newPoints 
    [coordAB_A, coordAB_B] = q1_manual_9('FD1.pgm', 'FD2.pgm');
else
    load('q2_2_a.mat');
end
%%
imgA = imread('FD1.pgm');
imgB = imread('FD2.pgm');

% figure;
% p1 = cornerPoints(coordAB_A');
% p2 = cornerPoints(coordAB_B');
% showMatchedFeatures(imgA, imgB, p1, p2);
%% Acquire fundamental matrix. Acquire epipole. 
F = estFundamentalMat(coordAB_A, coordAB_B);

[~, ~, V1] = svd(F);
eA1 = V1(:, end);

F(abs(F) < 0.0001) = 0;
eA2 = null(F, 'r');

%% Calulate epipolar lines for each point. Plot line. 
figure;
imshow([imgA, imgB]);
hold on;
for index = 1:size(coordAB_A, 2)
    x1 = coordAB_A(1, index);
    y1 = coordAB_A(2, index);
    
    x2 = eA2(1);
    y2 = eA2(2);
    
    m = (y2 - y1)/(x2 - x1);
    b = y2 - m * x2;
    
    xplot = 1:size(imgA, 2);
    yplot = m * xplot + b;
    plot(xplot, yplot);
end
hold off;

