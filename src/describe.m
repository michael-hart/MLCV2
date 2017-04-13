function [ desc ] = describe( img, points )
%DESCRIBE Describes patches given by 2xN matrix of points
%   Returns an MxN matrix of descriptors for the points

% Uses each point as the top left point of a 32x32 patch
% Takes a histogram of each patch and adds to the matrix

% Create output matrix
N = size(points, 2);
M = 256;
desc = zeros(M, N);

% Get patch represented by pixel
% Use min with image dimensions to ensure entire patch
[height, width] = size(img);
minHeight = height - 31
minWidth = width - 31

for i=1:N
    point = points(:, i);
    h = min(minHeight, point(2));
    w = min(minWidth, point(1));
    patch = img(h:h+31, w:w+31);

    % Get the histogram of the patch
    descriptor = imhist(patch);

    % Add the descriptor to the output matrix
    desc(:, i) = descriptor;

end

end

