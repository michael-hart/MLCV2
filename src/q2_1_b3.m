%% Question 2 Part 1 Section B - Using MATLAB's Harris
clear;
close all;

if ismac
    addpath('../res/kitchen');
    addpath('../res');
    outputpath = ('../');
else
    addpath('res');
    addpath('res/kitchen');
    outputpath = ('');
end

% Read images
imgA = imread('HG1.pgm');
imgB = imread('HG2.pgm');
imgC = imread('HG3.pgm');
% Acquire features
featuresImgA = detectHarrisFeatures(imgA, 'MinQuality', 0.000001, 'FilterSize', 7);
featuresImgB = detectHarrisFeatures(imgB, 'MinQuality', 0.000001, 'FilterSize', 7);
featuresImgC = detectHarrisFeatures(imgC, 'MinQuality', 0.000001, 'FilterSize', 7);
% Extract them
[featuresImgA, pointsA] = extractFeatures(imgA, featuresImgA);
[featuresImgB, pointsB] = extractFeatures(imgB, featuresImgB);
[featuresImgC, pointsC] = extractFeatures(imgC, featuresImgC);
% Match them
pairsAB = matchFeatures(featuresImgA, featuresImgB);
pairsBC = matchFeatures(featuresImgB, featuresImgC);
pairsCA = matchFeatures(featuresImgC, featuresImgA);

coordAB_A = pointsA(pairsAB(:,1));
coordAB_B = pointsB(pairsAB(:,2));

coordBC_A = pointsB(pairsBC(:,1));
coordBC_B = pointsC(pairsBC(:,2));

coordCA_A = pointsC(pairsCA(:,1));
coordCA_B = pointsA(pairsCA(:,2));

%% Visualise matches.
figure;
showMatchedFeatures(imgA, imgB, coordAB_A, coordAB_B);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_matchedAB'],'-dpng','-r0');

figure;
showMatchedFeatures(imgB, imgC, coordBC_A, coordBC_B);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_matchedBC'],'-dpng','-r0');

figure;
showMatchedFeatures(imgC, imgA, coordCA_A, coordCA_B);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_matchedCA'],'-dpng','-r0');

%% Estimate Transform
[tformAB, coordAB_BOpt,coordAB_AOpt] = ...
    estimateGeometricTransform(coordAB_A,...
    coordAB_B,'similarity');
[tformBC, coordBC_BOpt,coordBC_AOpt] = ...
    estimateGeometricTransform(coordBC_A,...
    coordBC_B,'similarity');
[tformCA, coordCA_BOpt,coordCA_AOpt] = ...
    estimateGeometricTransform(coordCA_A,...
    coordCA_B,'similarity');

%% Visualise
figure;
showMatchedFeatures(imgA, imgB, coordAB_AOpt, coordAB_BOpt);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_matchedAB_opt'],'-dpng','-r0');

figure;
showMatchedFeatures(imgB, imgC, coordBC_AOpt, coordBC_BOpt);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_matchedBC_opt'],'-dpng','-r0');

figure;
showMatchedFeatures(imgC, imgA, coordCA_AOpt, coordCA_BOpt);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_matchedCA_opt'],'-dpng','-r0');

%% Project images
[imgAB, refAB] = imwarp(imgA, tformAB);
[imgBC, refBC] = imwarp(imgB, tformBC);
[imgCA, refCA] = imwarp(imgC, tformCA);

% Save pictures
figure;
imshowpair(imgB, imref2d(size(imgB)), imgAB, refAB);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_AB'],'-dpng','-r0');

figure;
imshowpair(imgC, imref2d(size(imgC)), imgBC, refBC);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_BC'],'-dpng','-r0');

figure;
imshowpair(imgA, imref2d(size(imgA)), imgCA, refCA);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b3_CA'],'-dpng','-r0');
