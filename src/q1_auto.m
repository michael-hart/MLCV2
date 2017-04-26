% File for detecting interest points in image

showImg = false;

% Load image
imgA = imread('img1.pgm');

% Perform Harris corner detection - 2500 works well from testing
harrisA = harris(imgA, 3000);

% Overlay interest points on image to evaluate
if showImg
    figure;
    imshow(imgA);
    hold on;
    scatter(harrisA(1, :), harrisA(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
end

% Take output interest point matrix and get the descriptors
describeA = describe2(imgA, harrisA);

% Get features and descriptors for image B
imgB = imread('img3.pgm');
harrisB = harris(imgB, 3000);

% Overlay interest points on image to evaluate
if showImg
    figure;
    imshow(imgB);
    hold on;
    scatter(harrisB(1, :), harrisB(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
    hold off;
end

describeB = describe2(imgB, harrisB);

% Match using Nearest Neighbour
matches = matchPatches(describeA, describeB);
% Got 77 matches between images!

% Estimate a transformation based on the matches between A and B
% Based on matched patches, build two matrices of co-ordinates
nMatch = size(matches, 2);
coordA = zeros(2, nMatch);
coordB = zeros(2, nMatch);

for i=1:nMatch
    n = matches(1, i);
    m = matches(2, i);
    coordA(:, i) = harrisA(:, n);
    coordB(:, i) = harrisB(:, m);
end

% Display the matched points on the photos, superimposed. Method is MATLAB
% Data is ours, obvs (well, boat stuff).
if showImg
    p1 = cornerPoints(coordA');
    p2 = cornerPoints(coordB');
    showMatchedFeatures(imgA, imgB, p1, p2);
end

if ismac
    save('../res/auto_out.mat', 'coordA', 'coordB', 'imgA', 'imgB');
else
    save('res/auto_out.mat', 'coordA', 'coordB', 'imgA', 'imgB');
end
