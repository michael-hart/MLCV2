% File to estimate the transform between two images and show the first
% image transformed to look like the second

% Clear variables and figures
clear;
clf;
close all;

% Load previous variables from q1_auto.m; loads imgA, imgB, coordA, coordB
load('res/auto_out.mat');

% Call the matrix estimation function with coordA, coordB
transformMat = estTransformMat(coordA, coordB);

% Transform B to A and display alongside A
transform = projective2d(transformMat);
imgAB = imwarp(imgB, transform);

% Custom method to transform the image without matlab methods
% imgAB = uint8(zeros(size(imgB)));
% for i=1:size(imgB, 1)
%     for j=1:size(imgB, 2)
%         x = j;
%         y = i;
%         homog = transformMat'*[x; y; 1];
%         out = homog ./ homog(3);
%         x2 = round(out(1));
%         y2 = round(out(2));
%         if x2 <= size(imgAB, 2) && y2 <= size(imgAB, 1) && x2 > 0 && y2 > 0
%             imgAB(y2, x2) = imgB(y, x);
%         end
%     end
% end

figure;
subplot(2, 1, 1);
imshow(imgAB);
subplot(2, 1, 2);
imshow(imgA);
