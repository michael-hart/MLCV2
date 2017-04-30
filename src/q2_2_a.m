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
%% Display matching.
figure;
p1 = cornerPoints(coordAB_A');
p2 = cornerPoints(coordAB_B');
showMatchedFeatures(imgA, imgB, p1, p2);
%% Acquire fundamental matrix. Acquire epipole and lines.

F = estFundamentalMat(coordAB_A, coordAB_B);
[epiLines, epiPole] = epiPolesLines(coordAB_A, F, [NaN NaN]);

%% Plot lines. 
imgWidth = size(imgA, 2);
N = size(epiLines, 1);

xpoints = repmat(1:imgWidth, N, 1)';

ypoints = zeros(imgWidth, N);
for index = 1:N
    ypoints(:, index) = [1:imgWidth]' .* epiLines(index, 1) + epiLines(index, 2);
end

figure;
imshow([imgA]);
hold on;
plot(xpoints, ypoints);
scatter(coordAB_A(1, :), coordAB_A(2, :), 50, 'o', 'filled', 'blue');
hold off;

