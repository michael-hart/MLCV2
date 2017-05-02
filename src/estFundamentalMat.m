function [ fundamentalMat ] = estFundamentalMat( coordA, coordB )
%ESTFUNDAMENTALMAT Estimates fundamental matrix from A to B
%   Uses matched co-ordinate pairs in coordA, coordB
%   coordA and coordB are 2xN matrices, N the same for both
%   Returns fundamentalMat, a 3x3 transformation matrix

    A = zeros(size(coordA, 2), 9);
    n = 0;

    for i=1:size(coordA, 2)
        % Get points from patches
        xa = coordA(1, i);
        ya = coordA(2, i);
        xb = coordB(1, i);
        yb = coordB(2, i);

        n = n + 1;
        % Derived from x'Fx = 0 formula
        A(n, :) = [xa * xb, xb * ya, xb, ...
                   xa * yb, ya * yb, yb, ...
                   xa, ya, 1];
    end
    % Make square
    ATA = A' * A;
    % Perform SVD decomposition
    [~, ~, V] = svd(ATA);

    % Ideal f is : v(1, 9) ... v(9, 9), normalised
    f = V(:, 9);
    f = f/f(9);

    % Change vector into matrix.
    fundamentalMat = reshape(f, 3, 3)';

end
