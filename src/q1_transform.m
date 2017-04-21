% File to estimate the transform between two images and show the first
% image transformed to look like the second

% Clear variables and figures
clear;
clf;

% Load previous variables from q1_auto.m; loads imgA, imgB, coordA, coordB
load('res/auto_out.mat');

% Call the matrix estimation function with coordA, coordB
transform = estTransformMat2(coordA, coordB);

% Transform A to B and display alongside B
% imgAB = imwarp(imgB, transform);

imgAB = uint8(zeros(size(imgB)));
for i=1:size(imgB, 1)
    for j=1:size(imgB, 2)
        x = j;
        y = i;
        homog = transform*[x; y; 1];
        out = homog ./ homog(3);
        x2 = round(out(1));
        y2 = round(out(2));
        if x2 <= size(imgAB, 2) && y2 <= size(imgAB, 1) && x2 > 0 && y2 > 0
            imgAB(y2, x2) = imgA(y, x);
        end
    end
end

figure;
subplot(2, 1, 1);
imshow(imgAB);
subplot(2, 1, 2);
imshow(imgA);
