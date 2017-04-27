%% Q2 Part 1 Section B
clear;
close all;
addpath('../res');

%% Load manual
% A to B, B to C, C to A. 

%% Load pictures
imgA = imread('HG1.pgm');
imgB = imread('HG2.pgm');
imgC = imread('HG3.pgm');

harrisA = harris(imgA, 1000);
harrisB = harris(imgB, 1000);
harrisC = harris(imgC, 1000);

 %% Display picture with points
showImg = true;

if showImg
    figure('position', [0 0 1280 800]);
    imshow(imgA);
    hold on;
    scatter(harrisA(1, :), harrisA(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
    
    figure('position', [0 0 1280 800]);
    imshow(imgB);
    hold on;
    scatter(harrisB(1, :), harrisB(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
    
    figure('position', [0 0 1280 800]);
    imshow(imgC);
    hold on;
    scatter(harrisC(1, :), harrisC(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
end

%%
describeA = describe2(imgA, harrisA);
describeB = describe2(imgB, harrisB);
describeC = describe2(imgC, harrisC);

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

%% Estimate transformation matrices
transformMatAB = estTransformMat(coordAB_A, coordAB_B);
transformMatBC = estTransformMat(coordBC_A, coordBC_B);
transformMatCA = estTransformMat(coordCA_A, coordCA_B);


%% Warp Images!
% Transpose required, MATLAB convention
[imgAB, refAB] = projection(imgA, transformMatAB);
[imgBC, refBC] = projection(imgB, transformMatBC);
[imgCA, refCA] = projection(imgC, transformMatCA);


%% Display
figure('position', [0 0 1280 800]);

subplot(2, 3, 1);
imshow(imgA);
title('Image A');

subplot(2, 3, 2);
imshow(imgB);
title('Image B');

subplot(2, 3, 3);
imshow(imgA);
title('Image C');

subplot(2, 3, 4);
imshowpair(imgB, imref2d(size(imgB)), imgAB, refAB);
title('Image A, Transformed over B. ');

subplot(2, 3, 5);
imshowpair(imgC, imref2d(size(imgC)), imgBC, refBC);
title('Image B, Transformed over C. ');

subplot(2, 3, 6);
imshowpair(imgA, imref2d(size(imgA)), imgCA, refCA);
title('Image C, Transformed over A. ');