% File for detecting interest points in image

showImg = true;

% Load image
imgA = imread('img1.pgm');

% Perform Harris corner detection - 2500 works well from testing
harrisA = harris(imgA, 2500);

% Overlay interest points on image to evaluate
if showImg
    figure(1);
    imshow(imgA);
    hold on;
    scatter(harrisA(1, :), harrisA(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
end

% Take output interest point matrix and get the descriptors
describeA = describe(imgA, harrisA);

% Get features and descriptors for image B
imgB = imread('img2.pgm');
harrisB = harris(imgB, 2500);
describeB = describe(imgB, harrisB);

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

save('res/auto_out.mat', 'coordA', 'coordB', 'imgA', 'imgB');
