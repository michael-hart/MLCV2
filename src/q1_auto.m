% File for detecting interest points in image

showImg = false;

% Load image
imgA = imread('img1.pgm');

% Perform image detection - 3e7 works well from testing
% hess = hessian(imgA, 3e7);

% Perform Harris corner detection - 2500 works well from testing
harr = harris(imgA, 2500);

% Overlay interest points on image to evaluate
if showImg
    figure(1);
    imshow(imgA);
    hold on;
    scatter(hess(1, :), hess(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');

    figure(2);
    imshow(imgA);
    hold on;
    scatter(harr(1, :), harr(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
end

% Take output interest point matrix and get the descriptors
descriptors = describe(imgA, harr);
descriptors(end-2:end, :)
