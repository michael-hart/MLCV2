%% Q2 Part 1 Section B
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

imgA = imread('HG1.pgm');
imgB = imread('HG2.pgm');
imgC = imread('HG3.pgm');

%% Load old or make new
again = false;

if again
    [coordAB_A, coordAB_B] = q1_manual('HG1.pgm', 'HG2.pgm');
    close all;
    [coordBC_A, coordBC_B] = q1_manual('HG2.pgm', 'HG3.pgm');
    close all;
    [coordCA_A, coordCA_B] = q1_manual('HG3.pgm', 'HG1.pgm');
    close all;
    save([outputpath, 'res/q2_1_b1_matches.mat'], ...
        'coordAB_A', 'coordAB_B', ...
        'coordBC_A', 'coordBC_B', ...
        'coordCA_A', 'coordCA_B');
else
    load('q2_1_b1_matches.mat');
end

%% Visualise matches.
figure;
p1 = cornerPoints(coordAB_A');
p2 = cornerPoints(coordAB_B');
showMatchedFeatures(imgA, imgB, p1, p2);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_matchedAB'],'-dpng','-r0');

figure;
p1 = cornerPoints(coordBC_A');
p2 = cornerPoints(coordBC_B');
showMatchedFeatures(imgB, imgC, p1, p2);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_matchedBC'],'-dpng','-r0');

figure;
p1 = cornerPoints(coordCA_A');
p2 = cornerPoints(coordCA_B');
showMatchedFeatures(imgC, imgA, p1, p2);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_matchedCA'],'-dpng','-r0');

%% Estimate transformation matrices
transformMatAB = estTransformMat(coordAB_A, coordAB_B);
transformMatBC = estTransformMat(coordBC_A, coordBC_B);
transformMatCA = estTransformMat(coordCA_A, coordCA_B);
save([outputpath, 'res/q2_1_b1_trans'], 'transformMatAB', 'transformMatBC', 'transformMatCA');

%% Warp Images!
[imgAB, refAB] = projection(imgA, transformMatAB);
[imgBC, refBC] = projection(imgB, transformMatBC);
[imgCA, refCA] = projection(imgC, transformMatCA);

%% Save pictures
figure;
imshow(imgAB);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_AB'],'-dpng','-r0');

figure;
imshow(imgBC);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_BC'],'-dpng','-r0');

figure;
imshow(imgCA);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_CA'],'-dpng','-r0');

figure;
imshowpair(imgB, imref2d(size(imgB)), imgAB, refAB);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_AB_pair'],'-dpng','-r0');

figure;
imshowpair(imgC, imref2d(size(imgC)), imgBC, refBC);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_BC_pair'],'-dpng','-r0');

figure;
imshowpair(imgA, imref2d(size(imgA)), imgCA, refCA);
fig = gcf;
fig.PaperPositionMode = 'auto';
print([outputpath, 'pic/q2_1_b1_CA_pair'],'-dpng','-r0');
