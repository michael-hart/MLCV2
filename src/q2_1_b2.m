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

%% Harris pictures
harrisA = harris(imgA, 200);
harrisB = harris(imgB, 200);
harrisC = harris(imgC, 200);

 %% Display picture with points
showImg = true;

if showImg
    figure;
    imshow(imgA);
    hold on;
    scatter(harrisA(1, :), harrisA(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_harrisAB'],'-dpng','-r0');
    
    figure;
    imshow(imgB);
    hold on;
    scatter(harrisB(1, :), harrisB(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_harrisBC'],'-dpng','-r0');
    
    figure;
    imshow(imgC);
    hold on;
    scatter(harrisC(1, :), harrisC(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_harrisCA'],'-dpng','-r0');
end

%% Extract, quantise
describeA = describe2(imgA, harrisA);
describeB = describe2(imgB, harrisB);
describeC = describe2(imgC, harrisC);

%% Match
matchesAB = matchPatches(describeA, describeB);
matchesBC = matchPatches(describeB, describeC);
matchesCA = matchPatches(describeC, describeA);

nMatchAB = size(matchesAB, 2);
coordAB_A = zeros(2, nMatchAB);
coordAB_B = zeros(2, nMatchAB);

for index=1:nMatchAB
    n = matchesAB(1, index);
    m = matchesAB(2, index);
    coordAB_A(:, index) = harrisA(:, n);
    coordAB_B(:, index) = harrisB(:, m);
end

nMatchBC = size(matchesBC, 2);
coordBC_A = zeros(2, nMatchBC);
coordBC_B = zeros(2, nMatchBC);

for index=1:nMatchBC
    n = matchesBC(1, index);
    m = matchesBC(2, index);
    coordBC_A(:, index) = harrisB(:, n);
    coordBC_B(:, index) = harrisC(:, m);
end

nMatchCA = size(matchesCA, 2);
coordCA_A = zeros(2, nMatchCA);
coordCA_B = zeros(2, nMatchCA);

for index=1:nMatchCA
    n = matchesCA(1, index);
    m = matchesCA(2, index);
    coordCA_A(:, index) = harrisC(:, n);
    coordCA_B(:, index) = harrisA(:, m);
end

%% Save!
save([outputpath, 'res/q2_1_b2_matches.mat'], ...
    'coordAB_A', 'coordAB_B', ...
    'coordBC_A', 'coordBC_B', ...
    'coordCA_A', 'coordCA_B');

%% Visualise matches.
if showImg
    figure;
    p1 = cornerPoints(coordAB_A');
    p2 = cornerPoints(coordAB_B');
    showMatchedFeatures(imgA, imgB, p1, p2);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_matchedAB'],'-dpng','-r0');

    figure;
    p1 = cornerPoints(coordBC_A');
    p2 = cornerPoints(coordBC_B');
    showMatchedFeatures(imgB, imgC, p1, p2);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_matchedBC'],'-dpng','-r0');

    figure;
    p1 = cornerPoints(coordCA_A');
    p2 = cornerPoints(coordCA_B');
    showMatchedFeatures(imgC, imgA, p1, p2);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_matchedCA'],'-dpng','-r0');
end

%% Estimate transformation matrices
transformMatAB = estTransformMat(coordAB_A, coordAB_B);
transformMatBC = estTransformMat(coordBC_A, coordBC_B);
transformMatCA = estTransformMat(coordCA_A, coordCA_B);
save([outputpath, 'res/q2_1_b2_trans'], 'transformMatAB', 'transformMatBC', 'transformMatCA');

%% Ransac
[coordAB_AOpt, coordAB_BOpt] = myRANSAC(coordAB_A, coordAB_B, 1e6, 20);
[coordBC_AOpt, coordBC_BOpt] = myRANSAC(coordBC_A, coordBC_B, 1e6, 20);
[coordCA_AOpt, coordCA_BOpt] = myRANSAC(coordCA_A, coordCA_B, 1e6, 20);

%% Save!
save([outputpath, 'res/q2_1_b2_matchesRANSAC.mat'], ...
    'coordAB_AOpt', 'coordAB_BOpt', ...
    'coordBC_AOpt', 'coordBC_BOpt', ...
    'coordCA_AOpt', 'coordCA_BOpt');

%% Visualise matches.
if showImg
    figure;
    p1 = cornerPoints(coordAB_AOpt');
    p2 = cornerPoints(coordAB_BOpt');
    showMatchedFeatures(imgA, imgB, p1, p2);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_matchedABRANSAC'],'-dpng','-r0');

    figure;
    p1 = cornerPoints(coordBC_AOpt');
    p2 = cornerPoints(coordBC_BOpt');
    showMatchedFeatures(imgB, imgC, p1, p2);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_matchedBCRANSAC'],'-dpng','-r0');

    figure;
    p1 = cornerPoints(coordCA_AOpt');
    p2 = cornerPoints(coordCA_BOpt');
    showMatchedFeatures(imgC, imgA, p1, p2);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_matchedCARANSAC'],'-dpng','-r0');
end

%% Estimate transformation matrices
transformMatAB = estTransformMat(coordAB_AOpt, coordAB_BOpt);
transformMatBC = estTransformMat(coordBC_AOpt, coordBC_BOpt);
transformMatCA = estTransformMat(coordCA_AOpt, coordCA_BOpt);
save([outputpath, 'res/q2_1_b2_transRANSAC'], 'transformMatAB', 'transformMatBC', 'transformMatCA');

%% Warp Images!
% [imgAB, refAB] = projection(imgA, transformMatAB);
% [imgBC, refBC] = projection(imgB, transformMatBC);
% [imgCA, refCA] = projection(imgC, transformMatCA);
transformMatABObj = projective2d(transformMatAB');
transformMatBCObj = projective2d(transformMatBC');
transformMatCAObj = projective2d(transformMatCA');

[imgAB, refAB] = imwarp(imgA, transformMatABObj);
[imgBC, refBC] = imwarp(imgB, transformMatBCObj);
[imgCA, refCA] = imwarp(imgC, transformMatCAObj);


% Save pictures
if showImg
    figure;
    imshow(imgAB);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_AB'],'-dpng','-r0');

    figure;
    imshow(imgBC);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_BC'],'-dpng','-r0');

    figure;
    imshow(imgCA);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_CA'],'-dpng','-r0');

    figure;
    imshowpair(imgB, imref2d(size(imgB)), imgAB, refAB);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_AB_pair'],'-dpng','-r0');

    figure;
    imshowpair(imgC, imref2d(size(imgC)), imgBC, refBC);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_BC_pair'],'-dpng','-r0');

    figure;
    imshowpair(imgA, imref2d(size(imgA)), imgCA, refCA);
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print([outputpath, 'pic/q2_1_b2_CA_pair'],'-dpng','-r0');
end