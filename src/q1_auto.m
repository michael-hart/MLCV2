% File for detecting interest points in image

% Load image
imgA = imread('img1.pgm');

% Perform image detection - 3e7 works well from testing
hess = hessian(imgA, 3e7);

% Overlay interest points on image to evaluate
figure(1);
imshow(imgA);
hold on;
scatter(hess(1, :), hess(2, :), 50, 'x', 'MarkerEdgeColor', 'blue');
