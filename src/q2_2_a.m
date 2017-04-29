%% Question 2 Part 1 Section A
clear;
close all;
if ismac
    addpath('../res/kitchen');
    addpath('../res');
    outputpath = ('../');
else
    addpath('res/kitchen');
    addpath('../res');
    outputpath = ('');
end

newPoints = false;

if newPoints 
    [coordAB_A, coordAB_B] = q1_manual_9('FD1.pgm', 'FD2.pgm');
else
    load('q2_2_a.mat');
end

imgA = imread('FD1.pgm');
imgB = imread('FD2.pgm');
%%
figure;
p1 = cornerPoints(coordAB_A');
p2 = cornerPoints(coordAB_B');
showMatchedFeatures(imgA, imgB, p1, p2);
%% Acquire fundamental matrix. Acquire epipole. 

F1 = estFundamentalMat(coordAB_A, coordAB_B);
[~, ~, V1] = svd(F1);
eA1 = V1(:, end);


offset = size(imgA)/2+.5;
offset = fliplr(offset);

N = size(coordAB_A, 2);

coordAB_AFixed = coordAB_A - offset(ones(N, 1), :)';
coordAB_BFixed = coordAB_B - offset(ones(N, 1), :)';

F2 = estFundamentalMat(coordAB_AFixed, coordAB_BFixed);

[~, ~, V2] = svd(F2);
eA2 = V2(:, end);

%% Calulate epipolar lines for each point. Plot line. 
figure;
imshow([imgA, imgB]);
hold on;
scatter(coordAB_A(1, :), coordAB_A(2, :), 50, 'o', 'filled', 'blue');

for index = 1:size(coordAB_A, 2)
    x1 = coordAB_AFixed(1, index);
    y1 = coordAB_AFixed(2, index);
    
    x2 = eA2(1);
    y2 = eA2(2);
    
    m = (y2 - y1)/(x2 - x1);
    b = y2 - m * x2;
    
    M = size(imgA, 2);
    xplot = 1:M;
    yplot = m * xplot + b;
    points = round([xplot; yplot] + offset(ones(M, 1), :)');
    plot(points');
end
hold off;

