function [ transformMat ] = estTransformMat( coordA, coordB )
%ESTTRANSFORMMAT Estimates transformation matrix from A to B
%   Uses matched co-ordinate pairs in coordA, coordB
%   coordA and coordB are 2xN matrices, N the same for both
%   Returns transformMat, an affine2d containing 3x3 transformation matrix

% Form a matrix O of 10xN, with O(1, :) as LSE value and O(2:10, :) as
% the flat matrix h
O = zeros(10, size(coordA, 2));

for i=1:size(coordA, 2)

    % Get points from patches
    xa = coordA(1, i);
    ya = coordA(2, i);
    xb = coordB(1, i);
    yb = coordB(2, i);

    % Construct a vector A; see notes (partially) for derivation)
    A = [-xb -yb -1 xb yb 1 ((xb*xa)-(xb*ya)) ((yb*xa)-(yb*ya)) (xa-ya)];

    % Find smallest eigenvalue of ATA and corresponding eigenvector
    ATA = A'*A;
    [V,D] = eig(ATA);
    D_vec = diag(D);

    [minVal, minCol] = min(D_vec);
    h_unscaled = V(:, minCol);

    % Need to rescale such that h33 = 1
    h_scaled = h_unscaled ./ h_unscaled(end);

    % Form into 3x3 matrix h such that Ah = 0
    h = reshape(h_scaled, 3, 3)';
    
    % Find error value
    err = 0;
    for j=1:size(coordA, 2)
        xa2 = coordA(1, j);
        ya2 = coordA(2, j);
        xb2 = coordB(1, j);
        yb2 = coordB(2, j);
        
        % Estimate xb2, yb2 from xa2, ya2
        homog = h*[xa2 ya2 1]';
        est = homog ./ homog(3);
        err =  err + abs(xb2 - est(1)) + abs(yb2 - est(2));
        
    end

    % Store matrix in O with error value
    O(1, i) = err;
    O(2:10, i) = h_scaled;
    
end

% Get the minimum error
[minErr, minIdx] = min(O(1, :));
h = reshape(O(2:10, minIdx), 3, 3)';

% Form into projective2d object and return
transformMat = projective2d(h);

end

