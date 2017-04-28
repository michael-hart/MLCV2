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

figure;
p1 = cornerPoints(coordAB_A');
p2 = cornerPoints(coordAB_B');
showMatchedFeatures(imgA, imgB, p1, p2);
%%
F = estFundamentalMat(coordAB_A, coordAB_B);
[~, ~, V] = svd(F' * F);
ea = V(:, end)
F(abs(F) < 0.0001) = 0;
eA = null(F, 'r')
F * ea
F * eA
