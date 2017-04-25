function [ transformMat, V ] = estTransformMat( coordA, coordB )
%ESTTRANSFORMMAT Estimates transformation matrix from A to B
%   Uses matched co-ordinate pairs in coordA, coordB
%   coordA and coordB are 2xN matrices, N the same for both
%   Returns transformMat, a 3x3 transformation matrix

    A = zeros(2*size(coordA, 2), 9);

    % Indexing
    n = 0;
    for i=1:size(coordA, 2)
        % Get points from patches
        xa = coordA(1, i);
        ya = coordA(2, i);
        xb = coordB(1, i);
        yb = coordB(2, i);

        n = n + 1;
        A(n, :) = [xa ya 1 0 0 0 -xa*xb -ya*xb -xb];
        n = n + 1;
        A(n, :) = [0 0 0 xa ya 1 -xa*yb -ya*yb -yb];

    end

    ATA = A'*A;
    % Perform SVD decomposition
    [~, ~, V] = svd(ATA);

    % Select last column, normalise to last value.
    transformMat = reshape(V(:, 9) ./ V(9, 9), 3, 3)';
    % h31 and h32 are 0 for non-projections. 
    transformMat(3, 1:2) = [0, 0];
end

