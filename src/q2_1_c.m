%% Q2 Part 1 Section B
clear;
close all;
addpath('../res');
addpath('../res/boat');

%% Question 2 Part 1 Section B - Editing Up
clear;
close all;

if ismac
    addpath('../res/kitchen');
    addpath('../res');
    addpath('../tes/test2');
    outputpath = ('../');
else
    addpath('res');
    addpath('res/kitchen');
    outputpath = ('');
end

imgA = imread('HG1.pgm');
imgB = imread('HG2.pgm');
imgC = imread('HG3.pgm');

load('20020020064ransaccoord.mat');

N = size(coordBC_AOpt,2);

errors = zeros(1, N-3);

for number = 4:N
    indices = datasample(1:N, number, 2);
    coordBC_AOpt_Selected = coordBC_AOpt(:, indices);
    coordBC_BOpt_Selected = coordBC_BOpt(:, indices);
    transformMat = estTransformMat(coordBC_AOpt_Selected, coordBC_BOpt_Selected);
    errors(number-3) = errorHA(coordBC_AOpt_Selected, coordBC_BOpt_Selected, transformMat);
end

plot(4:N, errors);

