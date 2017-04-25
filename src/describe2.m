function [ desc ] = describe2( img, points )
%DESCRIBE Describes patches given by 2xN matrix of points
%   Returns an MxN matrix of descriptors for the points

% Uses each point as the top (16, 16) point of a 32x32 patch
% Takes a histogram of each patch and adds to the matrix

    % Create output matrix
    N = size(points, 2);
    M = 256;
    desc = zeros(M, N);

    % Pad image
    img = padarray(img, [16, 16], 'replicate');
    % Offset points (1, 1) should become (17, 17);
    points = points + 16;
    
    % Get patch represented by pixel
    for index=1:N
        h = points(2, index);
        w = points(1, index);
        patch = img(h-15:h+16, w-15:w+16);

        % Get the histogram of the patch
        descriptor = imhist(patch);

        % Add the descriptor to the output matrix
        desc(:, index) = descriptor;

    end

end

